create or replace PROCEDURE proc_triagem_estagio (
    V_CODIGO_DA_VAGA     NUMBER DEFAULT NULL,
    V_ID_ESTUDANTE       NUMBER DEFAULT NULL,
    V_OFFSET             NUMBER DEFAULT 0,
    V_NEXT               NUMBER DEFAULT 50,
    V_RESULTSET          OUT SYS_REFCURSOR
)
AS
    l_query                 CLOB;
    V_CLASSIFICACAO_SCORE   SERVICE_VAGAS_DEV.CLASSIFICACAO_SCORE_TYP;
    V_PONTO_DE              NUMBER(3) := 0;
    V_PONTO_ATE             NUMBER(3) := 0;
    V_MODO_ORDENAR          VARCHAR2(20 CHAR) := 'ASC';
    V_SCORE_ORDER_BY        VARCHAR2(4000) := '';
    V_ATENDE_PRECONDICAO    NUMBER(1) := 0;
    V_IDADE_MINIMA          DATE := NULL;
    V_IDADE_MAXIMA          DATE := NULL;
BEGIN

    --### CASO SEJA FILTRO POR VAGA, APLICA AS REGRAS DE SCORE  ###
    IF V_CODIGO_DA_VAGA IS NOT NULL THEN
        BEGIN
            --Busca a classificação da vaga para a pesquisa de aluno
            V_CLASSIFICACAO_SCORE := SERVICE_VAGAS_DEV.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);

            --Busca os dados para filtro
            V_PONTO_DE           := V_CLASSIFICACAO_SCORE.PONTO_DE;
            V_PONTO_ATE          := V_CLASSIFICACAO_SCORE.PONTO_ATE;
            V_MODO_ORDENAR       := V_CLASSIFICACAO_SCORE.MODO_ORDENAR;
            V_ATENDE_PRECONDICAO := V_CLASSIFICACAO_SCORE.ATENDE_PRECONDICAO;

            --Busca a idade
            SELECT
                add_months(sysdate, (12 * (-1) *  V.IDADE_MINIMA)) as IDADE_MINIMA,
                add_months(sysdate, (12 * (-1) *  V.IDADE_MAXIMA)) as IDADE_MAXIMA
            INTO
                V_IDADE_MINIMA, V_IDADE_MAXIMA
            FROM
                SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
            WHERE
                    V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Busca os dados para filtro
                V_PONTO_DE     := -999;
                V_PONTO_ATE    := -999;
                V_MODO_ORDENAR := 'ASC';
        END;
    END IF;

    l_query := l_query || '
    SELECT
        V.CODIGO_DA_VAGA,
        E.ID_ESTUDANTE,

        -- [E] CASO A VAGA PERMITA ESTUDANTE, NAO PRECISA CHECAR NO ALUNO. CASO NAO PERMITE, DEVE SER FEITA A CHECAGEM.
        CASE WHEN V.FUMANTE = 1 OR V.FUMANTE = E.FUMANTE THEN 1 ELSE 0 END FUMANTE,

        -- [E] SE A VAGA EXIGE CNH, O ESTUDANTE DEVE POSSUIR
        CASE WHEN V.POSSUI_CNH = 0 OR V.POSSUI_CNH = E.CNH THEN 1 ELSE 0 END CNH,

        -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
        CASE WHEN V.SEXO IS NULL OR V.SEXO = ''I'' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO,

        -- [E] SE A VAGA ESPECIFICOU UM ESTADO CIVIL, O ESTUDANTE DEVE CONSTAR NELE
        CASE WHEN
             V.ESTADO_CIVIL IS NULL OR
             V.ESTADO_CIVIL IS EMPTY OR
             --Se o estado civil do estudante contem na lista de vagas
             EXISTS (SELECT 1 from TABLE (V.ESTADO_CIVIL) EC WHERE EC.COLUMN_VALUE = E.ESTADO_CIVIL)
         THEN 1 ELSE 0 END ESTADO_CIVIL,

        -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
        --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
        --  SE O ALUNO Já FOI CADASTRADO COM ENSINO SUPERIOR, N�O PODE PARTICIPAR PARA VAGA DE APRENDIZ
        CASE WHEN
             V.ESCOLAS IS NULL OR
             V.ESCOLAS IS EMPTY OR
             EXISTS (SELECT 1 from TABLE (V.ESCOLAS) EC WHERE EC.COLUMN_VALUE = E.ESCOLA)
            THEN 1 ELSE 0 END ESCOLA,

        -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
        CASE WHEN (V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL) THEN 1 ELSE 0 END SEMESTRE,

        -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERACAO O N�VEL
        CASE WHEN
             V.CONHECIMENTOS IS NULL OR
             V.CONHECIMENTOS IS EMPTY OR
             (
                 SELECT COUNT(1)
                 FROM
                     TABLE(V.CONHECIMENTOS) CV,
                     TABLE(E.CONHECIMENTOS) CE
                 WHERE
                    CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                ) = CARDINALITY(V.CONHECIMENTOS)
             THEN 1 ELSE 0 END CONHECIMENTO,

        -- [E] REALIZA A COMPARACAO POR IDIOMA
        CASE WHEN
             V.IDIOMAS IS NULL OR
             V.IDIOMAS IS EMPTY OR
             (
                E.IDIOMAS IS NOT NULL AND E.IDIOMAS IS NOT EMPTY AND
                (
                     SELECT COUNT(1)
                     FROM
                         TABLE(V.IDIOMAS) IDV,
                         TABLE(E.IDIOMAS) IDE
                     WHERE
                        IDE.NOME = IDV.NOME AND IDE.NIVEL >= IDV.NIVEL
                 ) = CARDINALITY(V.IDIOMAS)
            )
            THEN 1 ELSE 0 END IDIOMA,

        -- TODO para os calculos de distancia, considerar o tipo de localizacao pedido pela vaga
        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 1) = 2 OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3)
                AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CASA,

        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO CAMPUS DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 1) = 1 OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 2, 3) AND
                (
                    E.CURSO_EAD = 1 OR
                    (
                        E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                        AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
                        --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                    )
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        -- [I] VALIDA A IDADE DO ESTUDANTE
        1 RANGE_IDADE,

        -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
        CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0 AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)) THEN 1
            WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 1) THEN 1
            ELSE 0
        END "ACESSIBILIDADE",

        -- [I] Validar regra de validade do laudo
        -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
        -- TODO remover duplicatas de PCD em vagas
        CASE WHEN
             V.PCDS IS NULL OR
             V.PCDS IS EMPTY OR
             (
                SELECT COUNT(1)
                FROM
                     TABLE(E.PCDS) PE,
                     TABLE(V.PCDS) PV
                 WHERE
                    PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                    AND
                    (
                        PV.VALIDADE_MINIMA_LAUDO is null
                        OR (PE.VALIDADE_MINIMA_LAUDO is null and PV.VALIDADE_MINIMA_LAUDO is null)
                        OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                    )
             ) > 0
            THEN 1 ELSE 0 END AS VALIDADE_LAUDO,

        -- [I] Validar regra de tipos de deficiencia
        CASE WHEN
                 V.PCDS IS NULL OR
                 V.PCDS IS EMPTY OR
                 (
                    SELECT COUNT(1)
                    FROM
                         TABLE(E.PCDS) PE,
                         TABLE(V.PCDS) PV
                     WHERE
                        PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                    ) > 0
                THEN 1 ELSE 0
            END AS TIPO_DEFICIENCIA,

        -- [I] Validar regra de qualificacao restritiva
        CASE WHEN
            V.QUALIFICACOES IS NULL OR
            V.QUALIFICACOES IS EMPTY OR
            (
                SELECT COUNT(1)
                FROM
                     TABLE(V.QUALIFICACOES) VQ,
                     TABLE(E.QUALIFICACOES) EQ
                 WHERE
                    VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                    AND EQ.RESULTADO = 0
                    AND EQ.DATA_VALIDADE >= SYSDATE
                ) = CARDINALITY(V.QUALIFICACOES)
            THEN 1 ELSE 0 END QUALIFICACAO,

        -- [I] Validar regra de Reservista
        CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END RESERVISTA,

        -- [I] Validar regra de recurso de acessibilidade
        CASE WHEN
                V.RECURSOS_ACESSIBILIDADE IS NULL OR
                V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                EXISTS
                (
                    SELECT 1
                    FROM
                        TABLE(E.RECURSOS_ACESSIBILIDADE) ERA, TABLE(V.RECURSOS_ACESSIBILIDADE) VRA
                    WHERE
                        ERA.COLUMN_VALUE = VRA.COLUMN_VALUE
                )
            THEN 1 ELSE 0 END RECURSO_ACESSIBILIDADE,

        -- [I] Validar Regra de cota PCD válida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA <= E.ELEGIVEL_PCD
        THEN 1 ELSE 0 END VALIDO_COTA,

        -- [E] Validar data de conclusão
        CASE WHEN V.DATA_CONCLUSAO IS NULL OR E.DATA_CONCLUSAO_CURSO = V.DATA_CONCLUSAO THEN 1 ELSE 0 END DATA_CONCLUSAO,

        -- [I] Validar Horário
        CASE WHEN
            V.TIPO_HORARIO_ESTAGIO = 0 OR
            (
                E.MODALIDADE = ''E''
                OR (
                    E.MODALIDADE = ''P''
                    AND
                    (
                        E.TIPO_PERIODO_CURSO = ''Variável''
                        OR E.TIPO_PERIODO_CURSO IN (''Manhã'', ''Integral'') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                        OR E.TIPO_PERIODO_CURSO = ''Tarde'' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                        OR E.TIPO_PERIODO_CURSO IN (''Noite'', ''Vespertino'') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                    )
                )
            )
        THEN 1 ELSE 0 END HORARIO,

        -- Parametro de ordenacao de vulneravel para vagas com priorizacao de atendimento a vulneraveis
        CASE WHEN V.PRIORIZA_VULNERAVEL = 1 THEN E.QUALIFICACAO_VULNERAVEL ELSE 0 END VULNERAVEL_PRIORIZADO,

        -- ## Parâmetros escolares: Somente para vaga estágio e somente dos tipos "areaAtuacao", "permiteEstagio" e "cargaHorariaDiaria"
        /* CASE WHEN
         ---------------------------
         -- EXISTE_PAR_ESCOLA = 1 --
         ---------------------------
            EXISTE_PAR_ESCOLA = 0 or
            (
                -- Parametro Area atuação: Caso alguma área de atuação da vaga estiver contida nas áreas de atuação do parâmetro, estudante deverá estar cursando semestre dentro do intervalo especificado no parâmetro
                 NVL(case when v.areas_atuacao_estagio multiset intersect e.par_areas_atuacao is empty or e.semestre between e.par_semestre_inicio
                 and e.par_semestre_fim then 1 else 0 end, 1)

                 -- Parâmetro permissão estágio. Caso houver, semestre atual do estudante não deve ultrapassar semestre indicado no parâmetro
                 + NVL(case when e.par_semestre_maximo >= e.semestre then 1 else 0 end, 1)

                 -- Parâmetro Carga horária diária: Caso vaga for a combinar ou nível da vaga for igual ao indicado no parâmetro, jornada diária da vaga não deve exceder o indicado no parâmetro
                 + NVL(case when v.tipo_horario_estagio = 0 OR e.nivel_ensino <> e.par_nivel_nao_permitido
                 OR v.jornada_minutos <= e.par_carga_horaria_diaria * 60 then 1 else 0 end, 1)
             ) = 3
        THEN 1 ELSE 0 END */ 1  parametro_escolar,

        -- Parametro de ordenação de convocacoes
        E.QTD_CONVOCACOES,

        E.CLASSIFICACAO_OBTIDA,
        E.PONTUACAO_OBTIDA
    FROM
        SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
        SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
    WHERE
        V.TIPO_VAGA = ''E''
        --AND E.ENDERECO IS NOT NULL
        AND E.TIPO_PROGRAMA IN (0, 2)
        AND E.APTO_TRIAGEM = 1
        AND E.STATUS_ESCOLARIDADE = 0
        AND E.ESCOLA IS NOT NULL

        --VERSÃO ANTIGA
        AND (
            (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
            (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
        )
        --AND (V.POSSUI_PCD = 0 OR (V.POSSUI_PCD = 1 AND EXISTS(SELECT 1 FROM TABLE(E.PCDS))))

        AND EXISTS (SELECT 1 from TABLE (V.CURSOS) CC WHERE CC.COLUMN_VALUE = E.CODIGO_CURSO_PRINCIPAL)
        AND NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE (EC_EMP.ID_EMPRESA = V.ID_EMPRESA AND EC_EMP.SITUACAO <> 0 ) or EC_EMP.SITUACAO in (0,3,4,5))
        AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)

        -- REGRAS DE ENDERECO
        AND
        (
            -- Distancia onde mora
            EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_GEOHASH)
            OR
            (
                -- Distancia onde estuda
                E.CURSO_EAD = 0 AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
            )
        )
';

    IF (V_CODIGO_DA_VAGA IS NOT NULL )
    THEN
        l_query := l_query || ' AND V.CODIGO_DA_VAGA = :V_CODIGO_DA_VAGA ';

        --### CASO SEJA UMA PESQUISA POR VAGA E TENHA AS PRE-CONDICOES, DEVE SER IMPLEMENTADA AS REGRAS DE SCORE ###
        IF (V_ATENDE_PRECONDICAO = 1) THEN
            l_query := l_query || ' AND E.PONTUACAO_OBTIDA BETWEEN :V_PONTO_DE AND :V_PONTO_ATE';

            -- Ajuste para ordenar de acordo com a classificação
            V_SCORE_ORDER_BY := ', E.CLASSIFICACAO_OBTIDA ' || V_MODO_ORDENAR || ', E.PONTUACAO_OBTIDA DESC ';
        ELSE
            l_query := l_query || ' AND (:V_PONTO_DE = 0 AND :V_PONTO_ATE = 0)';
        END IF;

        l_query := l_query || ' AND E.DATA_NASCIMENTO BETWEEN :V_IDADE_MAXIMA AND :V_IDADE_MINIMA ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_CODIGO_DA_VAGA is null) ';
        l_query := l_query || ' AND (:V_PONTO_DE = 0 AND :V_PONTO_ATE = 0)';
        l_query := l_query || ' AND trunc(months_between(SYSDATE, E.DATA_NASCIMENTO)/12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA';

        l_query := l_query || ' AND (1=1 or :V_IDADE_MAXIMA is null) ';
        l_query := l_query || ' AND (1=1 or :V_IDADE_MINIMA is null) ';
    END IF;

    IF (V_ID_ESTUDANTE IS NOT NULL )
    THEN
        l_query := l_query || ' AND E.ID_ESTUDANTE = :V_ID_ESTUDANTE ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_ID_ESTUDANTE is null) ';
    END IF;


    l_query := l_query || '
    ORDER BY
        (
            FUMANTE + CNH + SEXO + ESTADO_CIVIL + ESCOLA + SEMESTRE + CONHECIMENTO + IDIOMA +
            DISTANCIA_CASA + DISTANCIA_CAMPUS +
            RANGE_IDADE + ACESSIBILIDADE + VALIDADE_LAUDO + TIPO_DEFICIENCIA + QUALIFICACAO + RESERVISTA +
            RECURSO_ACESSIBILIDADE + VALIDO_COTA + DATA_CONCLUSAO + HORARIO
        ) DESC,
        VULNERAVEL_PRIORIZADO DESC,
        QTD_CONVOCACOES,
    --     DISTANCIA,
        E.QUALIFICACAO_VULNERAVEL DESC
        ' || V_SCORE_ORDER_BY || '
    OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY
    ';

    dbms_output.put_line(l_query);
    dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' - Ponto de:' || V_PONTO_DE || ' - Ate:' || V_PONTO_ATE || ' - Estudante:' || V_ID_ESTUDANTE);

    OPEN V_RESULTSET FOR l_query
        USING V_CODIGO_DA_VAGA, V_PONTO_DE, V_PONTO_ATE, V_IDADE_MAXIMA, V_IDADE_MINIMA, V_ID_ESTUDANTE, V_OFFSET, V_NEXT;

END;