DECLARE
    coluna_existente1                              NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente1
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'SITUACO_ANT_CANC'
        AND upper(table_name) = 'CONTRATOS_ESTUDANTES_EMPRESA';


    IF ( coluna_existente1 = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD (SITUACO_ANT_CANC NUMBER(1,0) NULL)';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN CONTRATOS_ESTUDANTES_EMPRESA.SITUACO_ANT_CANC IS ''Enum: 0-Efetivado; 1-Encerrado; 2-Cancelado; 3-Preenchido; 4-Manual; 5-Emitido''';
    END IF;
END;