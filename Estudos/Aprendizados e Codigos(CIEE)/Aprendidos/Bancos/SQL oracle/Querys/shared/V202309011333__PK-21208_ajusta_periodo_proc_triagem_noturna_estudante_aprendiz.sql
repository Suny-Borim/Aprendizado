create or replace PROCEDURE PROC_TRIAGEM_NOTURNA_ESTUDANTE_APRENDIZ -- 1500 segundos para toda a base de vagas
AS

    V_CODIGO_DA_VAGA      INT;
    v_stage_objetivo_vaga INT;
    V_IDADE_MINIMA              DATE := NULL;
    V_IDADE_MAXIMA              DATE := NULL;
    V_STATUS_ESCOLARIDADE       NUMBER(1,0);
    V_ESCOLARIDADE              NUMBER(1,0);
    V_PCD                       NUMBER(1,0);
    V_MODALIDADE_CAPACITACAO    NUMBER(1,0);
    V_GEOHASHS                  SERVICE_VAGAS_DEV.GEOHASHS_TYP;
    V_CAPACITACAO_GEOHASHS      SERVICE_VAGAS_DEV.GEOHASHS_TYP;
    v_data_triagem              DATE;

    V_HORA DATE;

BEGIN
    V_HORA := SYSDATE;
    FOR c_vaga IN (SELECT codigo_da_vaga, id_unidade_ciee
                   FROM SERVICE_VAGAS_DEV."TRIAGENS_VAGAS"
                   WHERE TIPO_VAGA = 'A'
                     and (ID_SITUACAO_VAGA = 1 or (ID_SITUACAO_VAGA = 2 and POSSUI_OCORRENCIAS = 0)))

        LOOP

            V_CODIGO_DA_VAGA := c_vaga.codigo_da_vaga;
            v_stage_objetivo_vaga := NVL(stage_objetivo_vaga(V_CODIGO_DA_VAGA, 'A', c_vaga.id_unidade_ciee), 0);

            IF (v_stage_objetivo_vaga <= 0) THEN
                update VAGAS_APRENDIZ set ID_SITUACAO_VAGA = 2
                where CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;
                update TRIAGENS_VAGAS SET DATA_TRIAGEM = SYSDATE WHERE CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;
                COMMIT;
                CONTINUE;
            END IF;

            dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' tempo em sgundos: ' || EXTRACT(SECOND FROM(SYSDATE - V_HORA) DAY TO SECOND));

            V_HORA:=SYSDATE;


            --### BUSCA OS DADOS DA VAGA PARA PROCESSAR MAIS RÁPIDO ###
            SELECT
                add_months(sysdate, (12 * (-1) *  V.IDADE_MINIMA)) as IDADE_MINIMA,
                add_months(sysdate, (12 * (-1) *  V.IDADE_MAXIMA)) as IDADE_MAXIMA,
                CASE COALESCE(SITUACAO_ESCOLARIDADE,0)
                    WHEN 0 THEN -1
                    WHEN 1 THEN 1
                    WHEN 2 THEN 0
                    ELSE -1
                    END as STATUS_ESCOLARIDADE,
                ESCOLARIDADE,
                COALESCE(V.POSSUI_PCD, 0),
                COALESCE(V.MODALIDADE_CAPACITACAO, 0),
                COALESCE(V.ENDERECO_GEOHASHS, SERVICE_VAGAS_DEV.GEOHASHS_TYP()),
                COALESCE(V.CAPACITACAO_GEOHASHS, SERVICE_VAGAS_DEV.GEOHASHS_TYP()),
                COALESCE(V.DATA_TRIAGEM, TO_DATE('1900-01-01','YYYY-MM-DD'))
            INTO
                V_IDADE_MINIMA, V_IDADE_MAXIMA, V_STATUS_ESCOLARIDADE, V_ESCOLARIDADE,
                V_PCD, V_MODALIDADE_CAPACITACAO, V_GEOHASHS, V_CAPACITACAO_GEOHASHS, v_data_triagem
            FROM
                SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
            WHERE
                    V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;

            IF (V_MODALIDADE_CAPACITACAO = 1 AND V_CAPACITACAO_GEOHASHS is not null) THEN
                V_GEOHASHS := V_GEOHASHS MULTISET UNION DISTINCT V_CAPACITACAO_GEOHASHS;
            END IF;


            INSERT INTO vinculos_vaga
            ( id
            , codigo_vaga
            , id_estudante
            , tipo_selecao
            , resp_selecao_convocacao
            , resp_selecao_encaminhamento
            , resp_selecao_contrato
            , situacao_vinculo
            , data_convocacao
            , data_encaminhamento
            , data_solicitacao_contratacao
            , data_contratacao
            , numero_contrato
            , deletado
            , data_criacao
            , data_alteracao
            , criado_por
            , modificado_por
            , enviado_ura
            , data_enviado_ura
            , data_comunicacao_convocacao
            , tipo_comunicacao_convocacao
            , acontratar)
            SELECT SEQ_VINCULOS_VAGA.NEXTVAL AS id
                 , codigo_da_vaga
                 , ID_ESTUDANTE
                 , tipo_selecao
                 , resp_selecao_convocacao
                 , resp_selecao_encaminhamento
                 , resp_selecao_contrato
                 , situacao_vinculo
                 , data_convocacao
                 , data_encaminhamento
                 , data_solicitacao_contratacao
                 , data_contratacao
                 , numero_contrato
                 , deletado
                 , data_criacao
                 , data_alteracao
                 , criado_por
                 , modificado_por
                 , enviado_ura
                 , data_enviado_ura
                 , data_comunicacao_convocacao
                 , tipo_comunicacao_convocacao
                 , acontratar
            FROM (

                     WITH TEMP_ESTUDANTES AS (
                         SELECT
                             DISTINCT
                             F.ID_ESTUDANTE
                         from
                             TRIAGENS_ESTUDANTES_FILTRO F
                         WHERE
                           -- REGRAS DE ENDERECO - DISTANCIA ONDE MORA OU ESTUDA (CAMPUS)
                             EXISTS (SELECT 1 from TABLE (V_GEOHASHS) CC WHERE CC.COLUMN_VALUE = F.ENDERECO_GEOHASH)
                           AND F.PCD = V_PCD
                           AND v_data_triagem < f.data_alteracao
                           AND (V_STATUS_ESCOLARIDADE = -1 OR F.STATUS_ESCOLARIDADE = V_STATUS_ESCOLARIDADE)
                           AND (
                                 (V_ESCOLARIDADE = 0 AND F.NIVEL_ENSINO NOT IN ('SU', 'TE')) OR
                                 (V_ESCOLARIDADE = 1 AND F.NIVEL_ENSINO = 'EF') OR
                                 (V_ESCOLARIDADE = 2 AND F.NIVEL_ENSINO = 'EM')
                             )
                     )
                     SELECT
                         V.codigo_da_vaga
                          , E.ID_ESTUDANTE
                          , 0       AS tipo_selecao
                          , 0       AS resp_selecao_convocacao
                          , NULL    AS resp_selecao_encaminhamento
                          , NULL    AS resp_selecao_contrato
                          , 0       AS situacao_vinculo
                          , SYSDATE AS data_convocacao
                          , NULL    AS data_encaminhamento
                          , NULL    AS data_solicitacao_contratacao
                          , NULL    AS data_contratacao
                          , NULL    AS numero_contrato
                          , 0       AS deletado
                          , SYSDATE AS data_criacao
                          , SYSDATE AS data_alteracao
                          , 'triagem_noturna' AS criado_por
                          , 'triagem_noturna' AS modificado_por
                          , 0 AS enviado_ura
                          , NULL AS    data_enviado_ura
                          , NULL AS    data_comunicacao_convocacao
                          , NULL AS    tipo_comunicacao_convocacao
                          , 0 AS       acontratar
                     FROM
                         SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
                         SERVICE_VAGAS_DEV.TEMP_ESTUDANTES TE,
                         SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
                     WHERE
                             1=1
                       AND E.ID_ESTUDANTE = TE.ID_ESTUDANTE
                       AND V.CODIGO_DA_VAGA = c_vaga.CODIGO_DA_VAGA
                       AND V.TIPO_VAGA = 'A'
                       AND E.TIPO_PROGRAMA IN (1, 2)
                       AND E.APTO_TRIAGEM = 1
                       AND V.ID_SITUACAO_VAGA = 1

                       -- [I] VALIDA A IDADE DO ESTUDANTE
                       AND (V.POSSUI_PCD = 1 OR
                            V.IDADE_MINIMA IS NULL OR
                            V.IDADE_MAXIMA IS NULL OR
                            E.DATA_NASCIMENTO BETWEEN V_IDADE_MAXIMA AND V_IDADE_MINIMA)

                       -- [I] Validar Regra de cota PCD valida
                       AND (V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD)

                       AND (E.CONTRATOS_EMPRESA IS EMPTY
                         OR E.CONTRATOS_EMPRESA IS NULL
                         OR NOT EXISTS
                             (
                                 SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP
                                 WHERE
                                         EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR
                                         EC_EMP.SITUACAO in (0,3,4,5) OR
                                     exists (
                                             select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) ECC, TABLE(V.CURSOS_CAPACITACAO) VCC
                                             where
                                                     ECC.COLUMN_VALUE = VCC.COLUMN_VALUE
                                         )
                             )
                         )

                       AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)

                       -- validacoes de pontuacao de aderencia
                       -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
                       AND (V.SEXO IS NULL OR V.SEXO = 'I' OR V.SEXO = E.SEXO)

                       -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
                       AND (
                             (
                                         V.EMPRESA_COM_ACESSIBILIDADE = 0
                                     AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)
                                 )
                             OR
                             V.EMPRESA_COM_ACESSIBILIDADE = 1
                         )

                       -- [I] Validar regra de validade do laudo
                       -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                       -- TODO remover duplicatas de PCD em vagas
                         /*
                         AND (
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
                           )
                         */
                       -- [I] Validar regra de tipos de deficiencia
                       AND (
                                 V.PCDS IS NULL OR
                                 V.PCDS IS EMPTY OR
                                 EXISTS(
                                         SELECT 1
                                         FROM
                                             TABLE(E.PCDS) PE,
                                             TABLE(V.PCDS) PV
                                         WHERE
                                                 PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                     )
                         )

                       -- [I] Validar regra de qualificação restritiva
                       AND (
                                 V.QUALIFICACOES IS NULL OR
                                 V.QUALIFICACOES IS EMPTY OR
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
                       AND (V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA)

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

                        AND (
                             (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR
                              (extract(hour from V.HORARIO_ENTRADA) < 22 AND extract(hour from V.HORARIO_SAIDA) <= 22 AND extract(hour from V.HORARIO_ENTRADA) >= 5))
                             AND (
                                         E.MODALIDADE = 'E' OR E.STATUS_ESCOLARIDADE = 1
                                     OR (
                                                     E.MODALIDADE = 'P'
                                                 AND
                                                     (
                                                                 E.TIPO_PERIODO_CURSO = 'Variável'
                                                             OR E.TIPO_PERIODO_CURSO IN ('Manhã', 'Integral') AND
                                                                V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                                                             OR E.TIPO_PERIODO_CURSO = 'Tarde' AND
                                                                (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR
                                                                 V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                                                             OR E.TIPO_PERIODO_CURSO IN ('Noite', 'Vespertino') AND
                                                                (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                                                         )
                                             )
                                 )
                         )
                    -- Filtro por Aprendiz Paulista
                     AND (
	                    (v.tipo_documento is null or v.tipo_documento != 'Aprendiz Paulista')
	                    OR
	                    (
	                        v.tipo_documento = 'Aprendiz Paulista'
	                        AND
	                        (
	                            (
	                                (
	                                	e.NIVEL_ENSINO in ('EM') and 
	                                	(
	                                		e.TIPO_ESCOLA in (SELECT RTE.ID FROM REP_TIPOS_ESCOLAS_UNIT RTE WHERE RTE.SIGLA IN('M','E','F')	)
	                                	)
	                            	) OR 
	                            		(	e.NIVEL_ENSINO in ('EF')	)
	                        	)
	                    	)
	                	)
                	)

                       -- [I] Validar regra de vinculo
                       AND NOT EXISTS(SELECT 1
                                      FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA t
                                      WHERE t.codigo_vaga = V.codigo_da_vaga
                                        AND t.id_estudante = E.ID_ESTUDANTE
                                        AND t.deletado = 0
                                        AND t.SITUACAO_VINCULO <> 3)
                       AND NOT EXISTS(SELECT 1
                                      FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA t
                                               INNER JOIN SERVICE_VAGAS_DEV.vinculos_convocacao vc ON t.id = vc.id_vinculo
                                      WHERE t.codigo_vaga = V.codigo_da_vaga
                                        AND t.id_estudante = E.ID_ESTUDANTE
                                        AND t.deletado = 0
                                        AND vc.ID_Recusa is not null)
                       AND NOT EXISTS(SELECT 1
                                      FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA t
                                               INNER JOIN SERVICE_VAGAS_DEV.vinculos_encaminhamento venc ON t.id = venc.id_vinculo
                                      WHERE t.codigo_vaga = V.codigo_da_vaga
                                        AND t.id_estudante = E.ID_ESTUDANTE
                                        AND t.deletado = 0
                                        AND venc.ID_Recusa is not null)

                       AND ROWNUM <= v_stage_objetivo_vaga --stage_objetivo_vaga (codigo_da_vaga)


                     ORDER BY E.QUALIFICACAO_VULNERAVEL DESC,
                              E.QTD_CONVOCACOES) t3;

            COMMIT;
        END LOOP;
END;