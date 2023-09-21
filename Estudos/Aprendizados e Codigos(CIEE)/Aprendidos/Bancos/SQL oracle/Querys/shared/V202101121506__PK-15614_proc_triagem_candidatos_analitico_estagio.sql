/*
 ##### PK-15614: Implementar - Jovem Talento em Triagem
 ########## PK-16065: Atualizar motivos da analise da triagem

 Corrigindo atribuição nas linhas 39 e 40, estava causando problema pois a variável é um NUMBER(3) e estava
 recebendo um NUMBER(4).
 Troquei para receber o valor "-999" ao invés de receber "-1000"

 */

create or replace PROCEDURE                   proc_triagem_candidatos_analitico_estagio (
    V_CODIGO_DA_VAGA     NUMBER DEFAULT NULL,
    V_QUEM_TRIOU         NUMBER,
    V_CRIADO_POR         VARCHAR2,
    V_IDS_EST_VINC       VARCHAR2,
    V_OFFSET             NUMBER DEFAULT 0,
    V_NEXT               NUMBER DEFAULT 50
)
AS
    V_CLASSIFICACAO_SCORE   SERVICE_VAGAS_DEV.CLASSIFICACAO_SCORE_TYP;
    V_PONTO_DE              NUMBER(3) := 0;
    V_PONTO_ATE             NUMBER(3) := 0;
    V_ATENDE_PRECONDICAO    NUMBER(1) := 0;
BEGIN

    --### CASO SEJA FILTRO POR VAGA, APLICA AS REGRAS DE SCORE  ###
    IF V_CODIGO_DA_VAGA IS NOT NULL THEN
        BEGIN
            --Busca a classificação da vaga para a pesquisa de aluno
            V_CLASSIFICACAO_SCORE := SERVICE_VAGAS_DEV.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);

            --Busca os dados para filtro
            V_PONTO_DE           := V_CLASSIFICACAO_SCORE.PONTO_DE;
            V_PONTO_ATE          := V_CLASSIFICACAO_SCORE.PONTO_ATE;
            V_ATENDE_PRECONDICAO := V_CLASSIFICACAO_SCORE.ATENDE_PRECONDICAO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                --Busca os dados para filtro
                V_PONTO_DE     := -999;
                V_PONTO_ATE    := -999;
        END;
    END IF;

/*INSERT NA TABELA PARA ANÁLISE DA TRIAGEM */
    INSERT INTO SERVICE_VAGAS_DEV.TRIAGEM_CANDIDATOS_ANALITICO (
                                                                ID
                                                               ,ID_EMPRESA
                                                               ,ID_ESTUDANTE
                                                               ,CODIGO_VAGA
                                                               ,TIPO_VAGA
                                                               ,MORA
                                                               ,ESTUDA
                                                               ,SEMESTRE_VAGA
                                                               ,DATA_CONCLUSAO
                                                               ,HORARIO
                                                               ,SEXO
                                                               ,FAIXA_ETARIA
                                                               ,ESTADO_CIVIL
                                                               ,IDIOMAS
                                                               ,CONHECIMENTOS
                                                               ,RESERVISTA
                                                               ,FUMANTE
                                                               ,CNH
                                                               ,ESCOLA
                                                               ,TIPO_DEFICIENCIA
                                                               ,RECURSO
                                                               ,VALIDADE_LAUDO
                                                               ,OFERECE_ACESSIBILIDADE
                                                               ,VALIDO_COTA
                                                               ,CAPACITACAO_MORA
                                                               ,QUEM_TRIOU
                                                               ,DELETADO
                                                               ,DATA_CRIACAO
                                                               ,DATA_ALTERACAO
                                                               ,CRIADO_POR
                                                               ,MODIFICADO_POR
                                                               ,PARAMETRO_ESCOLAR
                                                               ,PRIORIZA_VULNERAVEL
                                                               ,QUALIFICACAO_RESTRITIVA
                                                               ,JOVEM_TALENTO_CONTRATADO
                                                               ,SITUACAO
    )
    SELECT
        -- GERAÇÃO DO IDENTITY DA TABELA
        SERVICE_VAGAS_DEV.SEQ_TRIAGEM_CAND_ANALITICO.nextval as ID,
        T.*,
        CASE WHEN (T.DISTANCIA_CASA+T.DISTANCIA_CAMPUS+T.SEMESTRE_VAGA+T.DATA_CONCLUSAO+T.HORARIO+T.SEXO+T.FAIXA_ETARIA+T.ESTADO_CIVIL+T.IDIOMAS+T.CONHECIMENTOS+T.RESERVISTA+T.FUMANTE+T.CNH+T.ESCOLA+T.TIPO_DEFICIENCIA+T.RECURSO_ACESSIBILIDADE+T.VALIDADE_LAUDO+T.OFERECE_ACESSIBILIDADE+T.VALIDO_COTA+T.JOVEM_TALENTO_CONTRATADO) = 20 THEN
                 1
             ELSE
                 0
            END as SITUACAO
    FROM (
             SELECT

                 V.ID_EMPRESA AS ID_EMPRESA

                  ,E.ID_ESTUDANTE AS ID_ESTUDANTE

                  ,V.CODIGO_DA_VAGA AS CODIGO_VAGA

                  --Enum: 0- Estagio, 1- Aprendiz
                  , 0 AS TIPO_VAGA

                  -- [I] CÁLCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTÁGIO E O ENDEREÇO DO ALUNO
                  ,CASE WHEN
                                    NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
                                    (
                                                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4)
                                            AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_GEOHASH)
                                        --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                        ) THEN 1 ELSE 0
                 END
                 AS DISTANCIA_CASA

                  -- [I] CÁLCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTÁGIO E O ENDEREÇO DO CAMPUS DO ALUNO
                  , CASE WHEN
                                     NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
                                     (
                                                 NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6)
                                             AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
                                         --   AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                         ) THEN 1 ELSE 0
                 END
                 AS DISTANCIA_CAMPUS

                  -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
                  , CASE WHEN (V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL)
                             THEN 1
                         ELSE 0 END AS SEMESTRE_VAGA

                  -- [E] Validar data de conclusão
                  , CASE WHEN V.DATA_CONCLUSAO IS NULL OR E.DATA_CONCLUSAO_CURSO = V.DATA_CONCLUSAO THEN 1 ELSE 0 END AS DATA_CONCLUSAO

                  -- [I] Validar Horário
                  ,CASE WHEN
                                    V.TIPO_HORARIO_ESTAGIO = 0 OR
                                    (
                                                E.MODALIDADE = 'E'
                                            OR (
                                                            E.MODALIDADE = 'P'
                                                        AND
                                                            (
                                                                        E.TIPO_PERIODO_CURSO = 'Variável'
                                                                    OR E.TIPO_PERIODO_CURSO IN ('Manhã', 'Integral') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                                                                    OR E.TIPO_PERIODO_CURSO = 'Tarde' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                                                                    OR E.TIPO_PERIODO_CURSO IN ('Noite', 'Vespertino') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                                                                )
                                                    )
                                        )
                            THEN 1 ELSE 0 END AS HORARIO

                  -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECÌFICO, VALIDAR O PERFIL DO ESTUDANTE
                  ,CASE WHEN V.SEXO IS NULL OR V.SEXO = 'I' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO

                  -- [I] VALIDA A IDADE DO ESTUDANTE
                  ,CASE WHEN
                                (V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
                                AND
                                (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA)
                            THEN 1
                        ELSE 0
                 END AS FAIXA_ETARIA

                  -- [E] SE A VAGA ESPECIFICOU UM ESTADO CÍVIL, O ESTUDANTE DEVE CONSTAR NELE
                  , CASE WHEN
                                     V.ESTADO_CIVIL IS NULL OR
                                     V.ESTADO_CIVIL IS EMPTY OR
                                 --Se o estado cívil do estudante contém na lista de vagas
                                     EXISTS (SELECT 1 from TABLE (V.ESTADO_CIVIL) EC WHERE EC.COLUMN_VALUE = E.ESTADO_CIVIL)
                             THEN 1 ELSE 0 END AS ESTADO_CIVIL

                  -- [E] REALIZA A COMPARAÇÃO POR IDIOMA
                  , CASE WHEN
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
                             THEN 1 ELSE 0 END AS IDIOMAS

                  -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERAÇÃO O NÍVEL
                  , CASE WHEN
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
                             THEN 1 ELSE 0 END AS CONHECIMENTOS

                  -- [I] Validar regra de Reservista
                  ,CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END AS RESERVISTA

                  -- [E] CASO A VAGA PERMITA ESTUDANTE, NÃO PRECISA CHECAR NO ALUNO. CASO NÃO PERMITE, DEVE SER FEITA A CHECAGEM.
                  ,CASE WHEN V.FUMANTE = 1 OR V.FUMANTE = E.FUMANTE THEN 1 ELSE 0 END AS FUMANTE

                  -- [E] SE A VAGA EXIGE CNH, O ESTUDANTE DEVE POSSUIR
                  ,CASE WHEN V.POSSUI_CNH = 0 OR V.POSSUI_CNH = E.CNH THEN 1 ELSE 0 END AS CNH

                  -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
                  --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
                  --  SE O ALUNO JÁ FOI CADASTRADO COM ENSINO SUPERIOR, NÃO PODE PARTICIPAR PARA VAGA DE APRENDIZ
                  ,CASE WHEN
                                    V.ESCOLAS IS NULL OR
                                    V.ESCOLAS IS EMPTY OR
                                    EXISTS (SELECT 1 from TABLE (V.ESCOLAS) EC WHERE EC.COLUMN_VALUE = E.ESCOLA)
                            THEN 1 ELSE 0 END
                 AS ESCOLA

                  -- [I] Validar regra de tipos de deficiência
                  ,CASE WHEN
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
                            THEN 1 ELSE 0 END AS TIPO_DEFICIENCIA

                  -- [I] Validar regra de recurso de acessibilidade (Se a vaga possui, o usuário deve possuir)
                  ,CASE WHEN
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
                            THEN 1 ELSE 0 END AS RECURSO_ACESSIBILIDADE

                  -- [I] Validar regra de validade do laudo
                  -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                  -- TODO remover duplicatas de PCD em vagas
                  ,CASE WHEN
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
                            THEN 1 ELSE 0 END AS VALIDADE_LAUDO

                  -- [I] Validar regra de recurso de acessibilidade
                  ,CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0 AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)) THEN 1
                        WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 1) THEN 1
                        ELSE 0
                 END AS OFERECE_ACESSIBILIDADE

                  -- [I] Validar Regra de cota PCD válida
                  ,CASE WHEN
                                    V.POSSUI_PCD = 0 OR V.VALIDO_COTA <= E.ELEGIVEL_PCD THEN 1 ELSE 0
                 END AS VALIDO_COTA

                  , 1 AS DISTANCIA_CAPACITACAO
                  , V_QUEM_TRIOU AS QUEM_TRIOU
                  , 0 AS DELETADO
                  , sysdate AS DATA_CRIACAO
                  , sysdate AS DATA_ALTERACAO
                  , V_CRIADO_POR AS CRIADO_POR
                  , V_CRIADO_POR AS MODIFICADO_POR

                  , -- ## Parâmetros escolares: Somente para vaga estágio e somente dos tipos 'areaAtuacao', 'permiteEstagio' e 'cargaHorariaDiaria'
                 case when v.tipo_vaga = 'E' THEN
                          CASE WHEN
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
                                   THEN 1 ELSE 0 END
                      else 1
                     end PARAMETRO_ESCOLAR

                  -- Parâmetro de ordenação de vulnerável para vagas com priorização de atendimento a vulneráveis
                  , CASE WHEN V.PRIORIZA_VULNERAVEL = 1 THEN E.QUALIFICACAO_VULNERAVEL ELSE 0 END AS PRIORIZA_VULNERAVEL

                  -- [I] Validar regra de qualificação restritiva
                  ,CASE WHEN
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
                            THEN 1 ELSE 0 END AS QUALIFICACAO_RESTRITIVA

                  , CASE WHEN
                                    V.CONTRATACAO_JOVEM_TALENTO = 0
                                    OR
                                    (
                                        V.CONTRATACAO_JOVEM_TALENTO = 1
                                        AND
                                        (
                                            E.CONTRATOS_EMPRESA IS EMPTY
                                            OR E.CONTRATOS_EMPRESA IS NULL
                                            OR NOT (V.CODIGO_AREA_PROFISSIONAL member of E.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO)
                                        )
                                    )
                      THEN 1 ELSE 0 END AS JOVEM_TALENTO_CONTRATADO

             FROM
                 SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
                 SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
             WHERE
                     V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA
               AND V.TIPO_VAGA = 'E'
               AND E.ESCOLA IS NOT NULL
               AND E.STATUS_ESCOLARIDADE = 0
               --Regra antiga
               AND (
                     (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
                     (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
                 )
               --AND (V.POSSUI_PCD = 0 OR (V.POSSUI_PCD = 1 AND EXISTS(SELECT 1 FROM TABLE(E.PCDS))))

               AND EXISTS (SELECT 1 from TABLE (V.CURSOS) CC WHERE CC.COLUMN_VALUE = E.CODIGO_CURSO_PRINCIPAL)
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

               AND NOT EXISTS (
                     select 1 from (SELECT trim(regexp_substr(V_IDS_EST_VINC, '[^,]+', 1, LEVEL)) id_est_vinculado
                                    FROM dual
                                    CONNECT BY regexp_substr(V_IDS_EST_VINC, '[^,]+', 1, LEVEL) IS NOT NULL)
                     where id_est_vinculado = e.id_estudante
                 )

               AND E.TIPO_PROGRAMA IN (0, 2)
               AND E.APTO_TRIAGEM = 1
               --### CASO SEJA UMA VAGA QUE ATENDE AOS CRITÉRIOS DE SCORE, APLICA A REGRA DE SCORE
               -- CRITERIOS:
               -- Não deve ser indicada como "priorizar vulneravel"
               -- Ser uma vaga de Estágio de área de atuação 2- "Superior" ou 1- "Técnico"
               AND
                 (
                             V_CODIGO_DA_VAGA IS NULL
                         OR V_ATENDE_PRECONDICAO = 0
                         OR E.PONTUACAO_OBTIDA BETWEEN V_PONTO_DE AND V_PONTO_ATE
                     )
             ORDER BY
                 -- ### SCORE ###
                 -- EFETUA O CÁLCULO DO SCORE PARA REALIZAR O ORDENAMENTO DA QUERY
                 (
                         FUMANTE + CNH + SEXO + ESTADO_CIVIL + ESCOLA + SEMESTRE + CONHECIMENTOS + IDIOMAS +
                         --TODO: Removida a validação de endereço por questões de desempenho da aplicação
                         -- este item deve ser reavalidado
                         --DISTANCIA_CASA + DISTANCIA_CAMPUS +
                         FAIXA_ETARIA + OFERECE_ACESSIBILIDADE + VALIDADE_LAUDO + TIPO_DEFICIENCIA + QUALIFICACAO_RESTRITIVA + RESERVISTA + RECURSO_ACESSIBILIDADE +
                         VALIDO_COTA + DATA_CONCLUSAO + HORARIO + JOVEM_TALENTO_CONTRATADO
                     )
                 DESC,

                 -- APLICA AS REGRAS DE ORDENAÇÃO DE ACORDO COM O TIPO DE VAGA
                 PRIORIZA_VULNERAVEL DESC,

                 -- QUANTIDADE DE CONCOCAÇÕES
                 E.QTD_CONVOCACOES,

                 -- PRIORIZA VULNERÁVEL CASO SEJA ESTAGIÁRIO
                 E.QUALIFICACAO_VULNERAVEL DESC,

                 -- ORDENA DE ACORDO COM AS REGRAS DE SCORE
                 CASE WHEN V_ATENDE_PRECONDICAO = 1 THEN
                          -- CASO SEJA C, AJUSTA O VALOR DA PONTUACAO PARA SER RETORNADA
                          -- ANTES DA CLASSIFICACAO B
                          CASE WHEN V.CLASSIFICACAO_EMPRESA = 'C' AND E.CLASSIFICACAO_OBTIDA = 'C' THEN
                                       E.PONTUACAO_OBTIDA + 1000
                               ELSE
                                   E.PONTUACAO_OBTIDA
                              END
                      ELSE
                          V_ATENDE_PRECONDICAO
                     END DESC

                 --Efetua a limitação na quantidade de linhas retornadas
             OFFSET V_OFFSET ROWS FETCH NEXT V_NEXT ROWS ONLY
         ) T
    where T.DISTANCIA_CASA+T.DISTANCIA_CAMPUS+T.SEMESTRE_VAGA+T.DATA_CONCLUSAO+T.HORARIO+T.SEXO+T.FAIXA_ETARIA+T.ESTADO_CIVIL+T.IDIOMAS+T.CONHECIMENTOS+T.RESERVISTA+T.FUMANTE+T.CNH+T.ESCOLA+T.TIPO_DEFICIENCIA+T.RECURSO_ACESSIBILIDADE+T.VALIDADE_LAUDO+T.OFERECE_ACESSIBILIDADE+T.VALIDO_COTA+T.JOVEM_TALENTO_CONTRATADO < 20;
END;
/

