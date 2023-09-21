create or replace FUNCTION {{user}}.BUSCAR_SCORE_VAGA_TRIAGEM
(
    V_CODIGO_DA_VAGA  NUMBER := NULL,
    V_MODO_DEBUG      NUMBER := 0
)
    RETURN {{user}}.CLASSIFICACAO_SCORE_TYP
AS
    V_PONTUACAO             NUMBER := NULL;
    V_DESCRICAO             VARCHAR2(15 CHAR);
    V_PONTO_DE              NUMBER(3);
    V_PONTO_ATE             NUMBER(3);
    V_SIGLA_FAIXA           VARCHAR2(15 CHAR);
    V_PERCENTUAL_FAIXA      NUMBER(19,4);
    V_MODO_ORDENAR          VARCHAR2(20 CHAR);
    V_PRECONDICAO           NUMBER(1);
BEGIN

    SELECT
        PONTUACAO_EMPRESA,
        -- ### Regras para atender o filtro por score ###
        CASE WHEN
                         PRIORIZA_VULNERAVEL = 0 AND      -- Não deve ser indicada como "priorizar vulneravel"
                         ESCOLARIDADE > 0                 -- Ser uma vaga de Estágio de área de atuação 2- "Superior" ou 1- "Técnico"
                 THEN 1 ELSE 0 END as PRECONDICAO
    INTO
        V_PONTUACAO,  V_PRECONDICAO
    FROM
        {{user}}."TRIAGENS_VAGAS"
    WHERE
            CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;

    IF V_PRECONDICAO = 0 THEN
        RETURN {{user}}.CLASSIFICACAO_SCORE_TYP('N', 0, 0, '', 0);
    END IF;

    IF V_PONTUACAO IS NULL THEN
        V_PONTUACAO := 0;
    END IF;

    IF (V_MODO_DEBUG = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Pontuação vaga: ' || V_PONTUACAO);
    END IF;

    --Busca a classificação da empresa
    BEGIN
        SELECT
            SIGLA
        INTO
            V_DESCRICAO
        FROM
            {{user}}.qualificacoes_parametros_pontos
        WHERE
                DELETADO = '0'
          AND V_PONTUACAO BETWEEN ponto_de AND ponto_ate
          AND ROWNUM = 1
        ORDER BY
            ID DESC;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --Busca os dados para filtro
            V_DESCRICAO := 'C';
    END;

    --Busca o range atual de pontuação do estudante
    BEGIN
        SELECT
            PONTO_DE, PONTO_ATE
        INTO
            V_PONTO_DE, V_PONTO_ATE
        FROM
            {{user}}.classificacoes_parametros_pontos
        WHERE
                DELETADO = '0'
          AND DESCRICAO = V_DESCRICAO
          AND ROWNUM = 1
        ORDER BY
            ID DESC;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --Busca os dados para filtro
            V_PONTO_DE  := -999;
            V_PONTO_ATE := -999;
    END;

    IF (V_MODO_DEBUG = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Pontuação da faixa da vaga: ' || V_DESCRICAO || ' - ' || v_ponto_de || ' - ' || v_ponto_ate);
    END IF;

    --Busca o percentual de desconto que deve ser aplicado de acordo com a faixa descrita
    SELECT
        SIGLA_FAIXA, PERCENTUAL_FAIXA / 100.00
    INTO
        V_SIGLA_FAIXA, V_PERCENTUAL_FAIXA
    FROM
        {{user}}.percentuais_triagens_classificacoes
            UNPIVOT(
            (SIGLA_FAIXA, PERCENTUAL_FAIXA)  -- unpivot_clause
            FOR SIGLA --  unpivot_for_clause
            IN ( -- unpivot_in_clause
                (SIGLA_FAIXA_1, PERCENTUAL_FAIXA_1) AS 'A',
                (SIGLA_FAIXA_2, PERCENTUAL_FAIXA_2) AS 'B',
                (SIGLA_FAIXA_3, PERCENTUAL_FAIXA_3) AS 'C'
                )
            )
    WHERE
            SIGLA_FAIXA = V_DESCRICAO
      AND DELETADO = '0';

    IF (V_MODO_DEBUG = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Faixa de desconto: ' || V_SIGLA_FAIXA || ' - ' || V_PERCENTUAL_FAIXA);
    END IF;

    IF V_DESCRICAO IN ('A', 'B') THEN
        -- Ajusta para permitir buscar um percentual da faixa anterior
        -- Utiliza a função Trunc para permitir arredondar para baixo, sendo inclusiva
        V_PONTO_DE := TRUNC(V_PONTO_DE - (V_PONTO_DE * V_PERCENTUAL_FAIXA));

        --Modeo de ordenação que deve ser aplicada no campo de sigla
        V_MODO_ORDENAR := 'ASC';
    ELSE
        -- Ajusta a faixa C para permitir buscar um percentual da faixa B
        V_PONTO_ATE := V_PONTO_ATE * (1 + V_PERCENTUAL_FAIXA);

        --Modeo de ordenação que deve ser aplicada no campo de sigla
        V_MODO_ORDENAR := 'DESC';
    END IF;

    IF (V_MODO_DEBUG = 1) THEN
        DBMS_OUTPUT.PUT_LINE('Faixa de busca: ' || V_DESCRICAO || ' - ' || V_PONTO_DE || ' - ' || V_PONTO_ATE
            || ' - ' || V_MODO_ORDENAR || ' - PRE CONDICAO:' || V_PRECONDICAO);
    END IF;

    --Define os dados de classificação
    RETURN {{user}}.CLASSIFICACAO_SCORE_TYP(V_DESCRICAO, V_PONTO_DE, V_PONTO_ATE, V_MODO_ORDENAR, V_PRECONDICAO);
END;