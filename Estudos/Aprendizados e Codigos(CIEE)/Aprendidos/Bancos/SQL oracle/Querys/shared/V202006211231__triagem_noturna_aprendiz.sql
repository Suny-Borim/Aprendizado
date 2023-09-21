create or replace PROCEDURE PROC_TRIAGEM_NOTURNA_ESTUDANTE_APRENDIZ -- 1500 segundos para toda a base de vagas
AS
    V_CODIGO_DA_VAGA      INT;
    v_stage_objetivo_vaga INT;

BEGIN

    FOR c_vaga IN (SELECT codigo_da_vaga
                   FROM SERVICE_VAGAS_DEV."TRIAGENS_VAGAS"
                   WHERE TIPO_VAGA = 'A'
                     and (ID_SITUACAO_VAGA = 1 or (ID_SITUACAO_VAGA = 2 and POSSUI_OCORRENCIAS = 0))
                     and stage_objetivo_vaga(codigo_da_vaga) > 0 )

        LOOP

            V_CODIGO_DA_VAGA      := c_vaga.codigo_da_vaga;
            v_stage_objetivo_vaga := stage_objetivo_vaga (V_CODIGO_DA_VAGA);
            -- dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' - Ponto de:' || V_PONTO_DE || ' - Ate:' || V_PONTO_ATE);

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
            FROM (SELECT /*+ PARALLEL(8) */
                      V.codigo_da_vaga
                       , E.ID_ESTUDANTE
                       , 0                 AS tipo_selecao
                       , 0                 AS resp_selecao_convocacao
                       , NULL              AS resp_selecao_encaminhamento
                       , NULL              AS resp_selecao_contrato
                       , 0                 AS situacao_vinculo
                       , SYSDATE           AS data_convocacao
                       , NULL              AS data_encaminhamento
                       , NULL              AS data_solicitacao_contratacao
                       , NULL              AS data_contratacao
                       , NULL              AS numero_contrato
                       , 0                 AS deletado
                       , SYSDATE           AS data_criacao
                       , SYSDATE           AS data_alteracao
                       , 'triagem_noturna' AS criado_por
                       , 'triagem_noturna' AS modificado_por
                       , 0                 AS enviado_ura
                       , NULL              AS data_enviado_ura
                       , NULL              AS data_comunicacao_convocacao
                       , NULL              AS tipo_comunicacao_convocacao
                       , 0                 AS acontratar
                  FROM SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
                           CROSS JOIN SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
                  WHERE V.TIPO_VAGA = 'A'
                    AND E.ENDERECO IS NOT NULL
                    AND ((V.SITUACAO_ESCOLARIDADE = 0) OR (V.SITUACAO_ESCOLARIDADE = 1 and E.STATUS_ESCOLARIDADE = 1) OR
                         (V.SITUACAO_ESCOLARIDADE = 2 and E.STATUS_ESCOLARIDADE = 0))
                    AND E.NIVEL_ENSINO <> 'SU'
                    AND ((V.ESCOLARIDADE = 0) OR (V.ESCOLARIDADE = 1 AND E.NIVEL_ENSINO = 'EF') OR
                         (V.ESCOLARIDADE = 2 AND E.NIVEL_ENSINO = 'EM'))
                    AND (V.POSSUI_PCD = 1 OR
                         trunc(months_between(SYSDATE, E.DATA_NASCIMENTO) / 12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA)
                    AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS(SELECT 1
                                                                                                   from TABLE (E.CONTRATOS_EMPRESA) EC_EMP
                                                                                                   WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA
                                                                                                      OR (EC_EMP.TIPO_CONTRATO = 'A' AND
                                                                                                          (EC_EMP.SITUACAO = 1 OR
                                                                                                           exists(
                                                                                                                   select 1
                                                                                                                   from table (E.CONTRATOS_CURSOS_CAPACITACAO)
                                                                                                                   where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO)))))
                    AND (E.VINCULOS IS EMPTY OR E.VINCULOS IS NULL OR
                         NOT EXISTS(SELECT 1 from TABLE (E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID))
                    AND ((V.POSSUI_PCD = 0 AND CARDINALITY(E.PCDS) = 0) OR
                         (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0))
                    -- REGRAS DE ENDERECO
                    AND (
                      -- Distancia onde mora
                          E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                          OR -- Distancia estuda
                          (
                                  E.CURSO_EAD = 0 AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND
                                  V.ENDERECO_GEOHASHS IS NOT NULL
                                  AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                              )
                          OR -- Distancia capacitação
                          (
                              E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS
                              )
                      )
                    AND E.TIPO_PROGRAMA IN (1, 2)
                    AND E.APTO_TRIAGEM = 1
                    AND V.CODIGO_DA_VAGA = c_vaga.CODIGO_DA_VAGA
                    -- validacoes de pontuacao de aderencia
                    -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
                    AND (V.SEXO IS NULL OR V.SEXO = 'I' OR V.SEXO = E.SEXO)

                    -- TODO para os calculos de distancia, considerar o tipo de localização pedido pela vaga
                    -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO ALUNO
                    AND (
                          NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
                          (
                                  NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4) AND
                                  E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
                                  SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, 'unit=km') <
                                  NVL(V.VALOR_RAIO, 20)
                              )
                      )

                    -- [I] CIRCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO CAMPUS DO ALUNO
                    AND (
                          NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
                          (
                                  NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6) AND
                                  (
                                          E.CURSO_EAD = 1 OR E.status_escolaridade = 1 OR
                                          NOT EXISTS(select 1 from table (e.escolas)) OR (
                                                  (
                                                          E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND
                                                          V.ENDERECO_GEOHASHS IS NOT NULL
                                                          AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                                                      )
                                                  AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005,
                                                                            'unit=km') < NVL(V.VALOR_RAIO, 20)
                                              )
                                      )
                              )
                      )

                    -- [A] CIRCULO DE DISTANCIA ENTRE O LOCAL DE CAPACITACAO (SOMENTE APRENDIZ) E O ENDERECO DO ALUNO
                    AND (
                          NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
                          (
                                  NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6) AND
                                  E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS AND
                                  SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, 'unit=km') <
                                  NVL(V.VALOR_RAIO, 20)
                              )
                      )

                    -- [I] VALIDA A IDADE DO ESTUDANTE
                    AND (
                          V.POSSUI_PCD = 1 OR
                          ((V.IDADE_MINIMA IS NULL OR
                            TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
                              AND
                           (V.IDADE_MAXIMA IS NULL OR
                            TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA))
                      )

                    -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
                    AND (
                          (V.EMPRESA_COM_ACESSIBILIDADE = 0
                              AND
                           (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)
                              )
                          OR
                          V.EMPRESA_COM_ACESSIBILIDADE = 1
                      )

                    -- [I] Validar regra de validade do laudo
                    -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                    -- TODO remover duplicatas de PCD em vagas
                    AND (
                          V.PCDS IS NULL OR
                          V.PCDS IS EMPTY OR
                          (
                                  E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                                  (
                                      SELECT COUNT(1)
                                      FROM TABLE (E.PCDS) PE
                                               INNER JOIN TABLE (V.PCDS) PV
                                                          ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                      WHERE PV.VALIDADE_MINIMA_LAUDO IS NULL
                                         OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                                  ) = CARDINALITY(V.PCDS)
                              )
                      )

                    -- [I] Validar regra de tipos de deficiencia
                    AND (
                          V.PCDS IS NULL OR
                          V.PCDS IS EMPTY OR
                          (
                                  E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                                  (
                                      SELECT COUNT(1)
                                      FROM TABLE (E.PCDS) PE
                                               INNER JOIN TABLE (V.PCDS) PV
                                                          ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                  ) = CARDINALITY(V.PCDS)
                              )
                      )

                    -- [I] Validar regra de qualificação restritiva
                    AND (
                          V.QUALIFICACOES IS NULL OR
                          V.QUALIFICACOES IS EMPTY OR
                          (
                                  E.QUALIFICACOES IS NOT NULL AND E.QUALIFICACOES IS NOT EMPTY AND
                                  EXISTS(
                                          SELECT 1
                                          FROM TABLE (V.QUALIFICACOES) VQ
                                                   INNER JOIN TABLE (E.QUALIFICACOES) EQ ON VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                                          WHERE EQ.RESULTADO = 0
                                            AND EQ.DATA_VALIDADE >= SYSDATE
                                      )
                              )
                      )

                    -- [I] Validar regra de Reservista
                    AND (
                      V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA
                      )

                    -- [I] Validar regra de recurso de acessibilidade
                    AND (
                          V.RECURSOS_ACESSIBILIDADE IS NULL OR
                          V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                          (
                                  E.RECURSOS_ACESSIBILIDADE IS NOT NULL AND E.RECURSOS_ACESSIBILIDADE IS NOT EMPTY AND
                                  --E.RECURSOS_ACESSIBILIDADE multiset intersect V.RECURSOS_ACESSIBILIDADE IS NOT EMPTY
                                  EXISTS(SELECT 1
                                         FROM TABLE (E.RECURSOS_ACESSIBILIDADE)
                                         WHERE COLUMN_VALUE MEMBER OF (V.RECURSOS_ACESSIBILIDADE)
                                      )
                              )
                      )

                    -- [I] Validar Regra de cota PCD valida
                    AND (
                      V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD
                      )

                    AND (
                          (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR
                           (extract(hour from V.HORARIO_ENTRADA) < 18 AND extract(hour from V.HORARIO_SAIDA) < 18))
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
                    AND ROWNUM <= v_stage_objetivo_vaga --stage_objetivo_vaga (codigo_da_vaga)
                  ORDER BY E.QUALIFICACAO_VULNERAVEL DESC,
                           E.QTD_CONVOCACOES) t3;

            COMMIT;


        END LOOP;

END;