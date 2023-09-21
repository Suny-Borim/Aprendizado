DECLARE
    coluna_existente_permite_escolha NUMBER := 0;    
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente_permite_escolha
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'PERMITE_ESCOLHA'
        AND upper(table_name) = 'BANCOS';

    IF ( coluna_existente_permite_escolha = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE BANCOS ADD (PERMITE_ESCOLHA NUMBER(1,0) NULL)';       
    END IF;
END;