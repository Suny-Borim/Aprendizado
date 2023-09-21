DECLARE
    coluna_existente NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente
    FROM
        all_tab_columns
    WHERE
            upper(column_name) = 'EMAIL_ALERTA_4VIA'
        AND upper(table_name) = 'PARAMETROS_COMUNICACOES_EMPRESAS';

    IF ( coluna_existente = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PARAMETROS_COMUNICACOES_EMPRESAS ADD EMAIL_ALERTA_4VIA NUMBER(1,0) DEFAULT 0';
    END IF;
END;