create or replace PROCEDURE {{user}}.PROC_TRIAGEM_NOTURNA_ESTUDANTE -- 1500 segundos para toda a base de vagas
AS
    quantidade INT;
    V_CODIGO_DA_VAGA INT;
    V_CLASSIFICACAO_SCORE   SERVICE_VAGAS_DEV.CLASSIFICACAO_SCORE_TYP;
    V_PONTO_DE              NUMBER(3) := 0;
    V_PONTO_ATE             NUMBER(3) := 0;
    V_MODO_ORDENAR          VARCHAR2(20 CHAR) := 'ASC';
    V_SCORE_ORDER_BY        VARCHAR2(4000) := '';
    V_ATENDE_PRECONDICAO    NUMBER(1) := 0;

BEGIN

    FOR c_vaga IN (SELECT codigo_da_vaga FROM {{user}}."TRIAGENS_VAGAS" WHERE stage_objetivo_vaga (codigo_da_vaga) > 0)
        LOOP

            V_CODIGO_DA_VAGA := c_vaga.codigo_da_vaga;

            IF V_CODIGO_DA_VAGA IS NOT NULL THEN
                BEGIN
                    --Busca a classificação da vaga para a pesquisa de aluno
                    V_CLASSIFICACAO_SCORE := {{user}}.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);

                    --Busca os dados para filtro
                    V_PONTO_DE           := V_CLASSIFICACAO_SCORE.PONTO_DE;
                    V_PONTO_ATE          := V_CLASSIFICACAO_SCORE.PONTO_ATE;
                    V_MODO_ORDENAR       := V_CLASSIFICACAO_SCORE.MODO_ORDENAR;
                    V_ATENDE_PRECONDICAO := V_CLASSIFICACAO_SCORE.ATENDE_PRECONDICAO;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        --Busca os dados para filtro
                        V_PONTO_DE     := -999;
                        V_PONTO_ATE    := -999;
                        V_MODO_ORDENAR := 'ASC';
                END;
            END IF;

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
                (SELECT /*+ PARALLEL(8) */
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
                      ,'triagem_noturna' AS criado_por
                      ,'triagem_noturna' AS modificado_por
                      ,0 AS enviado_ura
                      ,NULL AS data_enviado_ura
                      ,NULL AS data_comunicacao_convocacao
                      ,NULL AS tipo_comunicacao_convocacao
                      ,0 AS acontratar
                 FROM
                     {{user}}."TRIAGENS_VAGAS" V
                         CROSS JOIN {{user}}."TRIAGENS_ESTUDANTES" E
                 WHERE
                         V.TIPO_VAGA = 'E'
                   AND E.ENDERECO IS NOT NULL
                   --AND ROWNUM <= 50
                   AND V.DATA_ALTERACAO <= E.DATA_ALTERACAO -- seleciona estudantes que não foram triados ainda para a vaga
                   AND V.CODIGO_DA_VAGA = c_vaga.CODIGO_DA_VAGA
                   AND (V.CURSOS IS EMPTY OR V.CURSOS IS NULL OR (E.CURSOS IS NOT NULL AND E.CURSOS IS NOT EMPTY AND E.CURSOS MULTISET INTERSECT V.CURSOS IS NOT EMPTY))
                   AND trunc(months_between(SYSDATE, E.DATA_NASCIMENTO)/12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA
                   AND (E.ESCOLAS IS NOT NULL AND E.ESCOLAS IS NOT EMPTY)
                   AND E.STATUS_ESCOLARIDADE = 0
                   AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR (EC_EMP.TIPO_CONTRATO = 'A' AND (EC_EMP.SITUACAO = 1 OR exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO)) )))
                   AND (E.VINCULOS IS EMPTY OR E.VINCULOS IS NULL OR NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID))
                   -- TODO considerar trazer o flag de PCD da tabela ESTUDANTES
                   AND (
                         (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
                         (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
                     )
                   -- REGRAS DE ENDERECO
                   AND
                     (
                         -- Distancia onde mora
                                 E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                             OR -- Distancia estuda
                                 (
                                             E.CURSO_EAD = 0 AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                                         AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                                     )
                         )
                   AND E.TIPO_PROGRAMA IN (0, 2)

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
                             E.ESTADO_CIVIL MEMBER OF V.ESTADO_CIVIL
                     )

                   -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
                   --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
                   --  SE O ALUNO Já FOI CADASTRADO COM ENSINO SUPERIOR, N?O PODE PARTICIPAR PARA VAGA DE APRENDIZ
                   AND (
                             V.ESCOLAS IS NULL OR
                             V.ESCOLAS IS EMPTY OR
                             (
                                         E.ESCOLAS IS NOT NULL AND E.ESCOLAS IS NOT EMPTY AND
                                         EXISTS(SELECT 1 FROM TABLE(E.ESCOLAS) WHERE COLUMN_VALUE MEMBER OF (V.ESCOLAS))
                                 --E.ESCOLAS multiset intersect V.ESCOLAS IS NOT EMPTY
                                 )
                     )

                   -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
                   AND ( (V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL) )

                   -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERACAO O N?VEL
                   AND (
                             V.CONHECIMENTOS IS NULL OR
                             V.CONHECIMENTOS IS EMPTY OR
                             (
                                         E.CONHECIMENTOS IS NOT NULL AND E.CONHECIMENTOS IS NOT EMPTY AND
                                         EXISTS(
                                                 SELECT 1 FROM
                                                     TABLE(E.CONHECIMENTOS) CE
                                                         INNER JOIN TABLE(V.CONHECIMENTOS) CV ON CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                                             )
                                 )
                     )

                   -- [E] REALIZA A COMPARACAO POR IDIOMA
                   AND (
                             V.IDIOMAS IS NULL OR
                             V.IDIOMAS IS EMPTY OR
                             (
                                         E.IDIOMAS IS NOT NULL AND E.IDIOMAS IS NOT EMPTY AND
                                         EXISTS(
                                                 SELECT 1 FROM
                                                     TABLE(E.IDIOMAS) IDE
                                                         INNER JOIN TABLE(V.IDIOMAS) IDV ON IDE.NOME = IDV.NOME AND IDE.NIVEL >= IDV.NIVEL
                                             )
                                 )
                     )

                   -- TODO para os calculos de distancia, considerar o tipo de localizacao pedido pela vaga
                   -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO ALUNO
                   AND (
                             NVL(V.LOCALIZACAO, 1) = 2 OR
                             (
                                         NVL(V.LOCALIZACAO, 1) IN (0, 1, 3) AND
                                         E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
                                         SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                 ) )

                   -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO CAMPUS DO ALUNO
                   AND (
                             NVL(V.LOCALIZACAO, 1) = 1 OR
                             (
                                         NVL(V.LOCALIZACAO, 1) IN (0, 2, 3) AND
                                         (
                                                     E.CURSO_EAD = 1 OR
                                                     (
                                                             (
                                                                         E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                                                                     AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                                                                 ) AND
                                                             SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, 'unit=km') < NVL(V.VALOR_RAIO, 20)
                                                         )
                                             )
                                 ) )

                   -- [I] VALIDA A IDADE DO ESTUDANTE
                   AND (
                         (V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
                         AND
                         (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA)
                     )

                   -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
                   AND ( ((V.EMPRESA_COM_ACESSIBILIDADE IS NULL OR V.EMPRESA_COM_ACESSIBILIDADE = 0)
                     AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE <> 1)) )

                   -- [I] Validar regra de validade do laudo
                   -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
                   -- TODO remover duplicatas de PCD em vagas
                   AND (
                             V.PCDS IS NULL OR
                             V.PCDS IS EMPTY OR
                             (
                                         E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                                         (
                                             SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                                                                                               ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                             WHERE PE.VALIDADE_MINIMA_LAUDO >= PV.VALIDADE_MINIMA_LAUDO
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
                                             SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                                                                                               ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                                         ) = CARDINALITY(V.PCDS)
                                 ))

                   -- [I] Validar regra de qualificacao restritiva
                   AND (
                             V.QUALIFICACOES IS NULL OR
                             V.QUALIFICACOES IS EMPTY OR
                             (
                                         E.QUALIFICACOES IS NOT NULL AND E.QUALIFICACOES IS NOT EMPTY AND
                                         EXISTS (
                                                 SELECT 1 FROM TABLE(V.QUALIFICACOES) VQ
                                                                   INNER JOIN TABLE(E.QUALIFICACOES) EQ ON VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                                                 WHERE EQ.RESULTADO = 0 AND EQ.DATA_VALIDADE >= SYSDATE
                                             )
                                 )
                     )

                   -- [I] Validar regra de Reservista
                   AND ( V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA )

                   -- [I] Validar regra de recurso de acessibilidade
                   AND (
                             V.RECURSOS_ACESSIBILIDADE IS NULL OR
                             V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                             (
                                         E.RECURSOS_ACESSIBILIDADE IS NOT NULL AND E.RECURSOS_ACESSIBILIDADE IS NOT EMPTY AND
                                         E.RECURSOS_ACESSIBILIDADE multiset intersect V.RECURSOS_ACESSIBILIDADE IS NOT EMPTY
                                 --EXISTS(SELECT 1 FROM TABLE(E.RECURSOS_ACESSIBILIDADE) WHERE COLUMN_VALUE MEMBER OF (V.RECURSOS_ACESSIBILIDADE))
                                 )
                     )

                   -- [I] Validar Regra de cota PCD válida
                   AND (
                             V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD
                     )

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
                   AND NOT EXISTS (SELECT 1 FROM {{user}}.STG_VINCULOS_VAGA t WHERE t.codigo_vaga = V.codigo_da_vaga AND t.id_estudante = E.ID_ESTUDANTE AND t.deletado = 0 AND t.SITUACAO_VINCULO <> 3)
                   AND NOT EXISTS (SELECT 1 FROM
                     {{user}}.VINCULOS_VAGA t
                         INNER JOIN {{user}}.vinculos_convocacao vc  ON t.id = vc.id_vinculo
                                   WHERE t.codigo_vaga = V.codigo_da_vaga AND t.id_estudante = E.ID_ESTUDANTE AND t.deletado = 0 AND vc.ID_Recusa is not null)
                   AND (E.PONTUACAO_OBTIDA BETWEEN V_PONTO_DE AND V_PONTO_ATE OR V_ATENDE_PRECONDICAO = 0)
                   AND ROWNUM <= stage_objetivo_vaga (codigo_da_vaga)
                 ORDER BY PONTUACAO_OBTIDA DESC) t3;

            COMMIT;

        END LOOP;

END;
/
