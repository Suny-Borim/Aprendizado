DECLARE
    coluna_existente_email4via NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente_email4via
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'EMAIL_4VIA'
        AND upper(table_name) = 'REP_PARAMETROS_CIEE_COMPANY';

    

    IF ( coluna_existente_email4via = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE REP_PARAMETROS_CIEE_COMPANY ADD (EMAIL_4VIA VARCHAR2(255 CHAR))';       
    END IF;
END;