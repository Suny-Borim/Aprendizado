DECLARE
    coluna_existente NUMBER := 0;
BEGIN
    SELECT COUNT(*)
    INTO coluna_existente
    FROM all_tab_columns
    WHERE UPPER(column_name) = 'DATA_RESCISAO'
          AND UPPER(table_name) = 'RECESSOS';

    IF coluna_existente > 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE RECESSOS DROP COLUMN DATA_RESCISAO';
    END IF;
END;