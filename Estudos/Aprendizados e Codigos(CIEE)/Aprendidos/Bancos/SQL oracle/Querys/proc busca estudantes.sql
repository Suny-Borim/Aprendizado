CREATE OR REPLACE PROCEDURE {{user}}.proc_busca_estudantes(EST_NOME VARCHAR2 DEFAULT NULL,
                                                                    EST_CPF VARCHAR2 DEFAULT NULL,
                                                                    EST_DATA_NASCIMENTO TIMESTAMP DEFAULT NULL,
                                                                    EST_CODIGO_ESTUDANTE VARCHAR2 DEFAULT NULL,
                                                                    EST_PCD NUMBER DEFAULT NULL,
                                                                    EST_SITUACAO VARCHAR2 DEFAULT NULL,
                                                                    ENDERECO VARCHAR2 DEFAULT NULL,
                                                                    NUMERO VARCHAR2 DEFAULT NULL,
                                                                    UF VARCHAR2 DEFAULT NULL,
                                                                    CIDADE VARCHAR2 DEFAULT NULL,
                                                                    COMPLEMENTO VARCHAR2 DEFAULT NULL,
                                                                    CEP VARCHAR2 DEFAULT NULL,
                                                                    TELEFONE VARCHAR2 DEFAULT NULL,
                                                                    EMAIL VARCHAR2 DEFAULT NULL,
                                                                    SORT VARCHAR2 DEFAULT NULL,
                                                                    DIRECTION VARCHAR2 DEFAULT NULL,
                                                                    OFFSET NUMBER DEFAULT 0,
                                                                    NEXT NUMBER DEFAULT 50,
                                                                    RESULTSET OUT SYS_REFCURSOR)
AS
    l_query CLOB; DIRECAO VARCHAR2(40);
BEGIN
    NLS_CS(1);

    l_query := l_query || '
    SELECT T_EST.ID_ESTUDANTE,
           T_EST.NOME,
           T_EST.CODIGO_ESTUDANTE,
           T_EST.SITUACAO,
           T_EST.CPF,
           T_EST.DATA_NASCIMENTO,
           CASE WHEN T_EST.PCDS IS NULL OR T_EST.PCDS IS EMPTY THEN 0 ELSE 1 END PCD,
           T_EST.SITUACAO_ANALISE_PCD,
           T_EST_END.ENDERECO ENDERECO,
           T_EST_END.CIDADE CIDADE,
           T_EST_END.UF UF,
           T_EST.NOME_MAE,
           (SELECT * FROM TABLE(T_EST.EMAILS) e FETCH FIRST 1 ROWS ONLY) EMAIL,
            CASE WHEN T_EST.PCDS IS NULL OR T_EST.PCDS IS EMPTY THEN 0 ELSE 1 END PCD
    from TRIAGENS_ESTUDANTES T_EST
    OUTER APPLY TABLE(T_EST.ENDERECOS) T_EST_END
    WHERE T_EST_END.PRINCIPAL = 1
    AND (1=1 OR :EST_NOME is null
             OR :EST_CPF is null
             OR :EST_DATA_NASCIMENTO is null
             OR :EST_CODIGO_ESTUDANTE is null
             OR :EST_PCD is null
             OR :EST_SITUACAO is null
             OR :ENDERECO is null
             OR :NUMERO is null
             OR :UF is null
             OR :CIDADE is null
             OR :COMPLEMENTO is null
             OR :CEP is null
             OR :TELEFONE is null
             OR :EMAIl is null
    )
               ';

    IF (EST_NOME IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST.NOME LIKE  ''%''||:EST_NOME||''%'' ';
    END IF;

    IF (EST_CPF IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST.CPF = :EST_CPF ';
    END IF;

    IF (EST_DATA_NASCIMENTO IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST.DATA_NASCIMENTO = :EST_DATA_NASCIMENTO ';
    END IF;

    IF (EST_CODIGO_ESTUDANTE IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST.CODIGO_ESTUDANTE = :EST_CODIGO_ESTUDANTE ';
    END IF;

    IF (EST_PCD IS NOT NULL)
    THEN
        l_query := l_query ||
                   ' AND CASE WHEN T_EST.PCDS IS NULL OR T_EST.PCDS IS EMPTY THEN 0 ELSE 1 END  = :EST_PCD ';
    END IF;

    IF (EST_SITUACAO IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST.SITUACAO = :EST_SITUACAO ';
    END IF;

    IF (ENDERECO IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.ENDERECO LIKE ''%''||:ENDERECO||''%'' ';
    END IF;

    IF (NUMERO IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.NUMERO = :NUMERO ';
    END IF;

    IF (UF IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.UF = :UF ';
    END IF;

    IF (CIDADE IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.CIDADE LIKE ''%''||:CIDADE||''%'' ';
    END IF;

    IF (COMPLEMENTO IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.COMPLEMENTO LIKE ''%''||:COMPLEMENTO||''%'' ';
    END IF;

    IF (CEP IS NOT NULL)
    THEN
        l_query := l_query || ' AND T_EST_END.CEP = :CEP ' ;
    END IF;

    IF (TELEFONE IS NOT NULL)
    THEN
        l_query := l_query || ' AND :TELEFONE MEMBER OF T_EST.TELEFONES ' ;
    END IF;

    IF (EMAIL IS NOT NULL)
    THEN
        l_query := l_query || ' AND :EMAIl MEMBER OF T_EST.EMAIlS ' ;
    END IF;

    IF (SORT IS NOT NULL)
    THEN
        IF (DIRECTION IS NULL OR (DIRECTION <> 'ASC' AND DIRECTION <> 'DESC'))
        THEN
            DIRECAO := 'ASC';
        ELSE
            DIRECAO := DIRECTION;
        END IF;

        l_query := l_query || ' ORDER BY ( ';
        CASE SORT
            WHEN 'CODIGO'
                THEN l_query := l_query || ' T_EST.CODIGO_ESTUDANTE ';
            WHEN 'NOME'
                THEN l_query := l_query || ' T_EST.NOME ';
            WHEN 'CPF'
                THEN l_query := l_query || ' T_EST.CPF ';
            WHEN 'DATA_NASCIMENTO'
                THEN l_query := l_query || ' T_EST.DATA_NASCIMENTO ';
            WHEN 'NOME_MAE'
                THEN l_query := l_query || ' T_EST.NOME_MAE ';
            WHEN 'CIDADE'
                THEN l_query := l_query || ' T_EST_END.CIDADE ';
            WHEN 'ENDERECO'
                THEN l_query := l_query || ' T_EST_END.ENDERECO ';
            WHEN 'UF'
                THEN l_query := l_query || ' T_EST_END.UF ';

            ELSE l_query := l_query || ' T_EST.ID_ESTUDANTE ';
            END CASE;

        l_query := l_query || ' ) ' || DIRECAO;
    END IF;

    l_query := l_query || '
                OFFSET :OFFSET ROWS FETCH NEXT :NEXT ROWS ONLY ';

    OPEN RESULTSET FOR l_query
        USING EST_NOME,EST_CPF,EST_DATA_NASCIMENTO,EST_CODIGO_ESTUDANTE,EST_PCD,EST_SITUACAO,ENDERECO,NUMERO,UF,CIDADE,COMPLEMENTO,CEP,TELEFONE,EMAIL,OFFSET,NEXT;
    NLS_CS(0);
END;
/