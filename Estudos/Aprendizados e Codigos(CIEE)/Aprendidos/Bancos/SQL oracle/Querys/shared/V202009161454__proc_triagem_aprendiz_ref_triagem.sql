create or replace PROCEDURE proc_triagem_aprendiz(V_CODIGO_DA_VAGA NUMBER DEFAULT NULL,
                                                  V_ID_ESTUDANTE NUMBER DEFAULT NULL,
                                                  V_OFFSET NUMBER DEFAULT 0,
                                                  V_NEXT NUMBER DEFAULT 50,
                                                  V_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query CLOB;
BEGIN

    l_query := l_query || '
    SELECT /*+ PARALLEL(8) */
        V.CODIGO_DA_VAGA,
        E.ID_ESTUDANTE,

        -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
        CASE WHEN V.SEXO IS NULL OR V.SEXO = ''I'' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO,

        -- TODO para os calculos de distancia, considerar o tipo de localização pedido pela vaga
        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4) AND
                E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CASA,

        -- [I] CIRCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO CAMPUS DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6) AND
                (
                    E.CURSO_EAD = 1 OR E.status_escolaridade = 1 OR NOT EXISTS(select 1 from table(e.escolas)) OR (
                        (
                            E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                            AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                        )
                        AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                    )
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        -- [A] CIRCULO DE DISTANCIA ENTRE O LOCAL DE CAPACITACAO (SOMENTE APRENDIZ) E O ENDERECO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6) AND
                E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CAPACITACAO,

        -- [I] VALIDA A IDADE DO ESTUDANTE
        CASE WHEN
             V.POSSUI_PCD = 1 OR
             ((V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
             AND
             (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA))
         THEN 1 ELSE 0 END AS RANGE_IDADE,

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
                E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                 (
                    SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                      ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                      WHERE PV.VALIDADE_MINIMA_LAUDO is null or (PE.VALIDADE_MINIMA_LAUDO is null and PV.VALIDADE_MINIMA_LAUDO is null) or TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                 ) > 0
            )
            THEN 1 ELSE 0 END AS VALIDADE_LAUDO,

        -- [I] Validar regra de tipos de deficiencia
        CASE WHEN
                 V.PCDS IS NULL OR
                 V.PCDS IS EMPTY OR
                 (
                    E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                     (
                        SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                          ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                     ) > 0
                  )
                THEN 1 ELSE 0
            END AS TIPO_DEFICIENCIA,

        -- [I] Validar regra de qualificação restritiva
        CASE WHEN
                V.QUALIFICACOES IS NULL OR
                V.QUALIFICACOES IS EMPTY OR
                (
                    E.QUALIFICACOES IS NOT NULL AND E.QUALIFICACOES IS NOT EMPTY AND
                    EXISTS (
                        SELECT 1 FROM TABLE(V.QUALIFICACOES) VQ
                            INNER JOIN TABLE(E.QUALIFICACOES) EQ ON VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                            WHERE EQ.RESULTADO = 0 AND EQ.DATA_VALIDADE >= SYSDATE
                )
            ) THEN 1 ELSE 0 END QUALIFICACAO,

        -- [I] Validar regra de Reservista
        CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END RESERVISTA,

        -- [I] Validar regra de recurso de acessibilidade
        CASE WHEN
             V.RECURSOS_ACESSIBILIDADE IS NULL OR
             V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
             (
                E.RECURSOS_ACESSIBILIDADE IS NOT NULL AND E.RECURSOS_ACESSIBILIDADE IS NOT EMPTY AND
                --E.RECURSOS_ACESSIBILIDADE multiset intersect V.RECURSOS_ACESSIBILIDADE IS NOT EMPTY
                EXISTS(SELECT 1 FROM TABLE(E.RECURSOS_ACESSIBILIDADE) WHERE COLUMN_VALUE MEMBER OF (V.RECURSOS_ACESSIBILIDADE)
             )
         ) THEN 1 ELSE 0 END RECURSO_ACESSIBILIDADE,

        -- [I] Validar Regra de cota PCD valida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA <= E.ELEGIVEL_PCD
        THEN 1 ELSE 0 END VALIDO_COTA,
        -- [I] Validar Horario
        CASE WHEN
           (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR (extract(hour from V.HORARIO_ENTRADA) < 18 AND extract(hour from V.HORARIO_SAIDA) < 18))
           AND (
             E.MODALIDADE = ''E'' OR E.STATUS_ESCOLARIDADE = 1
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

        e.QUALIFICACAO_VULNERAVEL,

        E.QTD_CONVOCACOES
    FROM
        SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
        CROSS JOIN SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
    WHERE
      V.TIPO_VAGA = ''A''
      AND E.ENDERECO IS NOT NULL
      AND ((V.SITUACAO_ESCOLARIDADE = 0) OR (V.SITUACAO_ESCOLARIDADE = 1 and E.STATUS_ESCOLARIDADE = 1) OR (V.SITUACAO_ESCOLARIDADE = 2 and E.STATUS_ESCOLARIDADE = 0))
      AND (E.NIVEL_ENSINO <> ''SU'' AND E.NIVEL_ENSINO <> ''TE'' )
      AND ((V.ESCOLARIDADE = 0) OR (V.ESCOLARIDADE = 1 AND E.NIVEL_ENSINO = ''EF'') OR (V.ESCOLARIDADE = 2 AND E.NIVEL_ENSINO = ''EM''))
      AND (V.POSSUI_PCD = 1 OR trunc(months_between(SYSDATE, E.DATA_NASCIMENTO)/12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA)
      AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR ((EC_EMP.SITUACAO in (0,3,4,5) OR exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO)) )))
      AND (E.VINCULOS IS EMPTY OR E.VINCULOS IS NULL OR NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID))
      AND ((V.POSSUI_PCD = 0 AND CARDINALITY(E.PCDS) = 0) OR (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0))
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
        OR -- Distancia capacitação
        (
            E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS
        )
      )
      AND E.TIPO_PROGRAMA IN (1, 2)
      AND E.APTO_TRIAGEM = 1
';

    IF (V_CODIGO_DA_VAGA IS NOT NULL)
    THEN
        l_query := l_query || ' AND V.CODIGO_DA_VAGA = :V_CODIGO_DA_VAGA ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_CODIGO_DA_VAGA is null) ';
    END IF;

    IF (V_ID_ESTUDANTE IS NOT NULL)
    THEN
        l_query := l_query || ' AND E.ID_ESTUDANTE = :V_ID_ESTUDANTE ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_ID_ESTUDANTE is null) ';
    END IF;


    l_query := l_query || '
ORDER BY
    (
        SEXO + RANGE_IDADE + ACESSIBILIDADE +
        DISTANCIA_CASA + DISTANCIA_CAMPUS + DISTANCIA_CAPACITACAO +
        VALIDADE_LAUDO + TIPO_DEFICIENCIA + QUALIFICACAO + RESERVISTA +
        RECURSO_ACESSIBILIDADE + VALIDO_COTA + HORARIO
    ) DESC,
    E.QUALIFICACAO_VULNERAVEL DESC,
    E.QTD_CONVOCACOES
   -- DISTANCIA
OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY
';

-- dbms_output.put_line(l_query);

    OPEN V_RESULTSET FOR l_query
        USING V_CODIGO_DA_VAGA, V_ID_ESTUDANTE, V_OFFSET, V_NEXT;

END;