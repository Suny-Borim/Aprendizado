DECLARE
coluna_existente1                             NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente1
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'ID_ESCOLARIDADE_ESTUDANTES'
        AND upper(table_name) = 'CONTRATOS_ESTUDANTES_EMPRESA';
        
        IF ( coluna_existente1 = 0 ) THEN
       EXECUTE IMMEDIATE 'ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD (ID_ESCOLARIDADE_ESTUDANTES NUMBER(19,0) NULL)';
    END IF;
END;