create or replace PROCEDURE proc_triagem_candidatos_analitico_estagio_carteira (
    V_CODIGO_DA_VAGA    NUMBER DEFAULT NULL,
    V_RESULTSET         OUT SYS_REFCURSOR
)
AS
    V_CLASSIFICACAO_SCORE SERVICE_VAGAS_DEV.CLASSIFICACAO_SCORE_TYP;
BEGIN

    BEGIN
        --Busca a classificação da vaga para a pesquisa de aluno
        V_CLASSIFICACAO_SCORE := SERVICE_VAGAS_DEV.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            OPEN V_RESULTSET FOR
                SELECT 0 as QTD_CARTEIRA FROM dual;
            RETURN;
    END;

    OPEN V_RESULTSET FOR
        SELECT
            COUNT(1) as QTD_CARTEIRA
        FROM
            SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
            SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
        WHERE
                V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA
          AND V.TIPO_VAGA = 'E'
          AND E.ESCOLA IS NOT NULL
          AND E.TIPO_PROGRAMA IN (0, 2)
          AND E.APTO_TRIAGEM = 1
          AND E.STATUS_ESCOLARIDADE = 0

          --### CASO SEJA UMA VAGA QUE ATENDE AOS CRITÉRIOS DE SCORE, APLICA A REGRA DE SCORE
          -- CRITERIOS:
          -- Não deve ser indicada como "priorizar vulneravel"
          -- Ser uma vaga de Estágio de área de atuação 2- "Superior" ou 1- "Técnico"
          AND
            (
                        V_CLASSIFICACAO_SCORE.ATENDE_PRECONDICAO = 0
                    OR
                        E.PONTUACAO_OBTIDA BETWEEN V_CLASSIFICACAO_SCORE.PONTO_DE AND V_CLASSIFICACAO_SCORE.PONTO_ATE
                )

          AND EXISTS (SELECT 1 from TABLE (V.CURSOS) CC WHERE CC.COLUMN_VALUE = E.CODIGO_CURSO_PRINCIPAL)
          AND NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA AND EC_EMP.SITUACAO <> 0)
          AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)

          -- TODO considerar trazer o flag de PCD da tabela ESTUDANTES
          -- Regra antiga
          AND (
                (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
                (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
            )
          --AND (V.POSSUI_PCD = 0 OR (V.POSSUI_PCD = 1 AND EXISTS(SELECT 1 FROM TABLE(E.PCDS))))

          -- REGRAS DE ENDERECO
          AND E.ENDERECO IS NOT NULL

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
                );
END;