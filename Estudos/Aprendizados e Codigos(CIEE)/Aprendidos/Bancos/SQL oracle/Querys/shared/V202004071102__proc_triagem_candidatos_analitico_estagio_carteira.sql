create or replace PROCEDURE {{user}}.proc_triagem_candidatos_analitico_estagio_carteira (
    V_CODIGO_DA_VAGA    NUMBER DEFAULT NULL,
    V_RESULTSET         OUT SYS_REFCURSOR
)
AS
    V_CLASSIFICACAO_SCORE {{user}}.CLASSIFICACAO_SCORE_TYP;
BEGIN

    BEGIN
        --Busca a classificação da vaga para a pesquisa de aluno
        V_CLASSIFICACAO_SCORE := {{user}}.BUSCAR_SCORE_VAGA_TRIAGEM(V_CODIGO_DA_VAGA, 0);
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
            {{user}}."TRIAGENS_VAGAS" V
                CROSS JOIN {{user}}."TRIAGENS_ESTUDANTES" E
        WHERE
                V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA
          AND V.TIPO_VAGA = 'E'
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
          AND E.CODIGO_CURSO_PRINCIPAL MEMBER OF V.CURSOS
          AND (E.ESCOLAS IS NOT NULL AND E.ESCOLAS IS NOT EMPTY)
          AND E.STATUS_ESCOLARIDADE = 0
          AND (
                    E.CONTRATOS_EMPRESA IS EMPTY OR
                    E.CONTRATOS_EMPRESA IS NULL OR
                    NOT EXISTS(SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA AND EC_EMP.SITUACAO <> 0)
            )
          AND (E.VINCULOS IS EMPTY OR E.VINCULOS IS NULL OR NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID))
          -- TODO considerar trazer o flag de PCD da tabela ESTUDANTES
          AND (
                (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
                (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
            )
          -- REGRAS DE ENDERECO
          AND E.ENDERECO IS NOT NULL
          -- Distancia onde mora
          AND (
                    E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                OR -- Distancia estuda
                    (
                                E.CURSO_EAD = 0 AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                            AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                        )
            )
          AND E.TIPO_PROGRAMA IN (0, 2)
          AND E.APTO_TRIAGEM = 1;
END;