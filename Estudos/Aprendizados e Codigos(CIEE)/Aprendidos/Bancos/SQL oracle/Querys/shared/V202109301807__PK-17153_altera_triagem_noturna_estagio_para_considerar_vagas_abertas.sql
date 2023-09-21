create or replace PROCEDURE PROC_TRIAGEM_NOTURNA_ESTUDANTE -- 1500 segundos para toda a base de vagas
AS
    quantidade              INT;
    V_CODIGO_DA_VAGA        INT;
    V_CLASSIFICACAO_SCORE   SERVICE_VAGAS_DEV.CLASSIFICACAO_SCORE_TYP;
    V_PONTO_DE              NUMBER(3) := 0;
    V_PONTO_ATE             NUMBER(3) := 0;
    V_MODO_ORDENAR          VARCHAR2(20 CHAR) := 'ASC';
    V_SCORE_ORDER_BY        VARCHAR2(4000) := '';
    V_ATENDE_PRECONDICAO    NUMBER(1) := 0;
    v_stage_objetivo_vaga   INT;

    V_IDADE_MINIMA          DATE := NULL;
    V_IDADE_MAXIMA          DATE := NULL;
    V_GEOHASHS              SERVICE_VAGAS_DEV.GEOHASHS_TYP;
    V_CURSOS                SERVICE_VAGAS_DEV.IDS_TYP;
    V_PCD                   NUMBER(1,0);
    V_DATA_TRIAGEM          DATE;

    V_HORA DATE;

BEGIN

    FOR c_vaga IN (SELECT codigo_da_vaga, id_unidade_ciee
                   FROM SERVICE_VAGAS_DEV."TRIAGENS_VAGAS"
                   WHERE TIPO_VAGA = 'E'
                     and  (ID_SITUACAO_VAGA = 1 or (ID_SITUACAO_VAGA = 2 and POSSUI_OCORRENCIAS =0))
        )

        LOOP

            V_CODIGO_DA_VAGA      := c_vaga.codigo_da_vaga;
            v_stage_objetivo_vaga := NVL(stage_objetivo_vaga (V_CODIGO_DA_VAGA, 'E', c_vaga.id_unidade_ciee), 0);

            dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' tempo em segundos: ' || EXTRACT(SECOND FROM(SYSDATE - V_HORA) DAY TO SECOND));

            V_HORA:=SYSDATE;

            IF v_stage_objetivo_vaga <= 0 THEN
                update VAGAS_ESTAGIO set ID_SITUACAO_VAGA = 2
                where CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;
                COMMIT;
                CONTINUE;
            END IF;


            BEGIN
                --Busca a classificação da vaga para a pesquisa de aluno
                V_CLASSIFICACAO_SCORE := SERVICE_VAGAS_DEV.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);

                --Busca os dados para filtro
                V_PONTO_DE           := V_CLASSIFICACAO_SCORE.PONTO_DE;
                V_PONTO_ATE          := V_CLASSIFICACAO_SCORE.PONTO_ATE;
                V_MODO_ORDENAR       := V_CLASSIFICACAO_SCORE.MODO_ORDENAR;
                V_ATENDE_PRECONDICAO := V_CLASSIFICACAO_SCORE.ATENDE_PRECONDICAO;

                /*-----------nova implementação 1-----------*/
                --Busca o geohash e PCD
                SELECT
                    add_months(sysdate, (12 * (-1) *  V.IDADE_MINIMA)) as IDADE_MINIMA,
                    add_months(sysdate, (12 * (-1) *  V.IDADE_MAXIMA)) as IDADE_MAXIMA,
                    V.ENDERECO_GEOHASHS,
                    V.CURSOS,
                    V.POSSUI_PCD,
                    --V.DATA_TRIAGEM
                    COALESCE(V.DATA_TRIAGEM, TO_DATE('1900-01-01','YYYY-MM-DD'))
                INTO
                    V_IDADE_MINIMA, V_IDADE_MAXIMA, V_GEOHASHS, V_CURSOS, V_PCD, V_DATA_TRIAGEM
                FROM
                    SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
                WHERE
                        V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;
                /*-----------fim nova implementação 1-----------*/

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    --Busca os dados para filtro
                    V_PONTO_DE     := -999;
                    V_PONTO_ATE    := -999;
                    V_MODO_ORDENAR := 'ASC';
            END;


            INSERT INTO vinculos_vaga
            (id
            ,codigo_vaga
            ,id_estudante
            ,tipo_selecao
            ,resp_selecao_convocacao
            ,resp_selecao_encaminhamento
            ,resp_selecao_contrato
            ,situacao_vinculo
            ,data_convocacao
            ,data_encaminhamento
            ,data_solicitacao_contratacao
            ,data_contratacao
            ,numero_contrato
            ,deletado
            ,data_criacao
            ,data_alteracao
            ,criado_por
            ,modificado_por
            ,enviado_ura
            ,data_enviado_ura
            ,data_comunicacao_convocacao
            ,tipo_comunicacao_convocacao
            ,acontratar)

            SELECT
                SEQ_VINCULOS_VAGA.NEXTVAL AS id
                 ,codigo_da_vaga
                 ,ID_ESTUDANTE
                 ,tipo_selecao
                 ,resp_selecao_convocacao
                 ,resp_selecao_encaminhamento
                 ,resp_selecao_contrato
                 ,situacao_vinculo
                 ,data_convocacao
                 ,data_encaminhamento
                 ,data_solicitacao_contratacao
                 ,data_contratacao
                 ,numero_contrato
                 ,deletado
                 ,data_criacao
                 ,data_alteracao
                 ,criado_por
                 ,modificado_por
                 ,enviado_ura
                 ,data_enviado_ura
                 ,data_comunicacao_convocacao
                 ,tipo_comunicacao_convocacao
                 ,acontratar
            FROM
                (

                    /*-----------nova implementação 3-----------*/
                    WITH TEMP_ESTUDANTES AS (
                        SELECT
                            DISTINCT
                            F.ID_ESTUDANTE
                        from
                            TRIAGENS_ESTUDANTES_FILTRO F
                        WHERE
                          -- REGRAS DE ENDERECO - DISTANCIA ONDE MORA OU ESTUDA (CAMPUS)
                            EXISTS (SELECT 1 from TABLE (V_GEOHASHS) CC WHERE CC.COLUMN_VALUE = F.ENDERECO_GEOHASH)
                          -- CURSO
                          AND EXISTS (SELECT 1 from TABLE (V_CURSOS) CC WHERE CC.COLUMN_VALUE = F.CODIGO_CURSO_PRINCIPAL)
                          AND F.STATUS_ESCOLARIDADE = 0
                          AND F.PONTUACAO_OBTIDA BETWEEN V_PONTO_DE AND V_PONTO_ATE
                          AND F.PCD = V_PCD
                          AND V_DATA_TRIAGEM < F.data_alteracao
                        --AND (V_DATA_TRIAGEM < F.data_alteracao OR V_DATA_TRIAGEM IS NULL)
                    )
                        /*-----------fim nova implementação 3-----------*/
                    SELECT
                        V.codigo_da_vaga
                         ,E.ID_ESTUDANTE
                         ,0 AS tipo_selecao
                         ,0 AS resp_selecao_convocacao
                         ,NULL AS resp_selecao_encaminhamento
                         ,NULL AS resp_selecao_contrato
                         ,0 AS situacao_vinculo
                         ,SYSDATE AS data_convocacao
                         ,NULL AS data_encaminhamento
                         ,NULL AS data_solicitacao_contratacao
                         ,NULL AS data_contratacao
                         ,NULL AS numero_contrato
                         ,0 AS deletado
                         ,SYSDATE AS data_criacao
                         ,SYSDATE AS data_alteracao
                         ,'TRIAGEM_NOTURNA' AS criado_por
                         ,'TRIAGEM_NOTURNA' AS modificado_por
                         ,0 AS enviado_ura
                         ,NULL AS data_enviado_ura
                         ,NULL AS data_comunicacao_convocacao
                         ,NULL AS tipo_comunicacao_convocacao
                         ,0 AS acontratar
                         ,E.SEXO
                    FROM
                        SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
                        TEMP_ESTUDANTES TE, /*-----------nova implementação 4-----------*/
                        SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
                    WHERE
                            1=1
                      AND V.TIPO_VAGA = 'E'
                      AND E.ID_ESTUDANTE = TE.ID_ESTUDANTE /*-----------nova implementação 5-----------*/
                      AND V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA
                      AND V.ID_SITUACAO_VAGA = 1

                      -- [I] VALIDA A IDADE DO ESTUDANTE
                      AND (
                                V.IDADE_MINIMA IS NULL OR
                                V.IDADE_MAXIMA IS NULL OR
                                E.DATA_NASCIMENTO BETWEEN V_IDADE_MAXIMA AND V_IDADE_MINIMA
                        )

                      AND E.ESCOLA IS NOT NULL

                      AND NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE (EC_EMP.ID_EMPRESA = V.ID_EMPRESA AND EC_EMP.SITUACAO <> 0 ) or EC_EMP.SITUACAO in (0,3,4,5))

                      AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)

                      -- TODO considerar trazer o flag de PCD da tabela ESTUDANTES
                      --AND (V.POSSUI_PCD = 0 OR (V.POSSUI_PCD = 1 AND EXISTS(SELECT 1 FROM TABLE(E.PCDS))))
                      AND E.TIPO_PROGRAMA IN (0, 2)
                      AND E.APTO_TRIAGEM = 1

                      -- [E] CASO A VAGA PERMITA ESTUDANTE, NAO PRECISA CHECAR NO ALUNO. CASO NAO PERMITE, DEVE SER FEITA A CHECAGEM.
                      AND ( V.FUMANTE = 1 OR V.FUMANTE = E.FUMANTE )

                      -- [E] SE A VAGA EXIGE CNH, O ESTUDANTE DEVE POSSUIR
                      AND ( V.POSSUI_CNH = 0 OR V.POSSUI_CNH = E.CNH )

                      -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE

                      AND ( V.SEXO IS NULL OR V.SEXO = 'I' OR V.SEXO = E.SEXO )

                      -- [E] SE A VAGA ESPECIFICOU UM ESTADO CIVIL, O ESTUDANTE DEVE CONSTAR NELE
                      AND (
                                V.ESTADO_CIVIL IS NULL OR
                                V.ESTADO_CIVIL IS EMPTY OR
                            --Se o estado civil do estudante contem na lista de vagas
                                EXISTS (SELECT 1 from TABLE (V.ESTADO_CIVIL) EC WHERE EC.COLUMN_VALUE = E.ESTADO_CIVIL)

                        )

                      -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
                      --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
                      --  SE O ALUNO Já FOI CADASTRADO COM ENSINO SUPERIOR, N?O PODE PARTICIPAR PARA VAGA DE APRENDIZ
                      AND (
                                V.ESCOLAS IS NULL OR
                                V.ESCOLAS IS EMPTY OR
                                (
                                    --E.ESCOLAS IS NOT NULL AND E.ESCOLAS IS NOT EMPTY AND
                                    EXISTS(SELECT 1 FROM TABLE(V.ESCOLAS) V WHERE V.COLUMN_VALUE = E.ESCOLA)
                                    --E.ESCOLAS multiset intersect V.ESCOLAS IS NOT EMPTY
                                    )
                        )

                      -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
                      AND ( (V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL) )

                      -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERACAO O N?VEL
                      AND (
                                V.CONHECIMENTOS IS NULL OR
                                NOT EXISTS(SELECT 1 FROM TABLE(V.CONHECIMENTOS)) OR
                                (
                                    SELECT COUNT(1)
                                    FROM
                                        TABLE(V.CONHECIMENTOS) CV,
                                        TABLE(E.CONHECIMENTOS) CE
                                    WHERE
                                            CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                                ) = CARDINALITY(V.CONHECIMENTOS)
                        )

                      -- [E] REALIZA A COMPARACAO POR IDIOMA
                      AND (
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
                        )


                      -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
                      AND ( ((V.EMPRESA_COM_ACESSIBILIDADE IS NULL OR V.EMPRESA_COM_ACESSIBILIDADE = 0)
                        AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE <> 1)) )

                      -- [I] Validar regra de validade do laudo
                      -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                      -- TODO remover duplicatas de PCD em vagas
                      AND (
                                V.PCDS IS NULL OR
                                NOT EXISTS(SELECT 1 FROM TABLE(V.PCDS)) OR
                                (
                                    SELECT COUNT(1)
                                    FROM
                                        TABLE(E.PCDS) PE,
                                        TABLE(V.PCDS) PV
                                    WHERE
                                            PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                      AND TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                                ) = CARDINALITY(V.PCDS)
                        )

                      -- [I] Validar regra de qualificacao restritiva
                      AND (
                                V.QUALIFICACOES IS NULL OR
                                NOT EXISTS(SELECT 1 FROM TABLE(V.QUALIFICACOES)) OR
                                (
                                    SELECT COUNT(1)
                                    FROM
                                        TABLE(V.QUALIFICACOES) VQ,
                                        TABLE(E.QUALIFICACOES) EQ
                                    WHERE
                                            VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                    						AND EQ.SITUACAO = 1
                    						AND (
                    							EQ.TIPO = 0
                    							OR
                    							(
                    								EQ.RESULTADO = 0
                    								AND EQ.DATA_VALIDADE >= SYSDATE
                   									AND EQ.TIPO = 1
                   								)
                   							)
                    			) = CARDINALITY(V.QUALIFICACOES)
                        )

                      -- [I] Validar regra de Reservista
                      AND ( V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA )

                      -- [I] Validar regra de recurso de acessibilidade
                      AND (
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
                        )

                      -- [I] Validar Regra de cota PCD válida
                      AND (V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD)

                      -- [E] Validar data de conclusão
                      AND ( V.DATA_CONCLUSAO IS NULL OR E.DATA_CONCLUSAO_CURSO <= V.DATA_CONCLUSAO )

                      -- [I] Validar Horário
                      AND (
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
                        )

                      AND (

                        ---------------------------
                        -- EXISTE_PAR_ESCOLA = 1 --
                        ---------------------------
                                EXISTE_PAR_ESCOLA = 0 or
                                (
                                    -- Parametro Area atuação: Caso alguma área de atuação da vaga estiver contida nas áreas de atuação do parâmetro, estudante deverá estar cursando semestre dentro do intervalo especificado no parâmetro
                                        NVL(case when v.areas_atuacao_estagio multiset intersect e.par_areas_atuacao is empty or v.areas_atuacao_estagio multiset intersect e.par_areas_atuacao is null or e.semestre between e.par_semestre_inicio
                                            and e.par_semestre_fim then 1 else 0 end, 1)

                                        -- Parâmetro permissão estágio. Caso houver, semestre atual do estudante não deve ultrapassar semestre indicado no parâmetro
                                        + NVL(case when e.par_semestre_maximo >= e.semestre or e.par_semestre_maximo is null then 1 else 0 end, 1)

                                        -- Parâmetro Carga horária diária: Caso vaga for a combinar ou nível da vaga for igual ao indicado no parâmetro, jornada diária da vaga não deve exceder o indicado no parâmetro
                                        + NVL(case when v.tipo_horario_estagio = 0 OR e.nivel_ensino <> e.par_nivel_nao_permitido
                                        OR v.jornada_minutos <= e.par_carga_horaria_diaria * 60 or e.par_carga_horaria_diaria is null then 1 else 0 end, 1)
                                    ) = 3
                        )

                      AND NOT EXISTS (SELECT 1 FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA t
                                      WHERE t.codigo_vaga = V.codigo_da_vaga AND t.id_estudante = E.ID_ESTUDANTE AND t.deletado = 0 AND
                                          (t.SITUACAO_VINCULO <> 3 
                                          OR exists(select 1 from SERVICE_VAGAS_DEV.vinculos_convocacao vc WHERE t.id = vc.id_vinculo AND vc.id_recusa is not null)
                                          OR exists(select 1 from SERVICE_VAGAS_DEV.vinculos_encaminhamento venc WHERE t.id = venc.id_vinculo AND venc.id_recusa is not null)))

                      AND (
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
                        )

                      AND ROWNUM <= v_stage_objetivo_vaga
                    ORDER BY E.PONTUACAO_OBTIDA DESC) t3;



            UPDATE TRIAGENS_VAGAS SET DATA_TRIAGEM = SYSDATE WHERE CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;
            COMMIT;

        END LOOP;
END;