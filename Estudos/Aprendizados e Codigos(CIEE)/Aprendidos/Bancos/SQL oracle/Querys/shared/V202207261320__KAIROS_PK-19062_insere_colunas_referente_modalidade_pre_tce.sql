DECLARE
    coluna_existente1                              NUMBER := 0;
    coluna_existente2                              NUMBER := 0;
    coluna_existente3                              NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente1
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'MODALIDADE'
        AND upper(table_name) = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA';
        
    SELECT
        COUNT(*)
    INTO coluna_existente2
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'DIAS_HIBRIDO_PRESENCIAL'
        AND upper(table_name) = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA';
        
    SELECT
        COUNT(*)
    INTO coluna_existente3
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = upper('DIAS_HIBRIDO_REMOTO')
        AND upper(table_name) = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA';


    IF ( coluna_existente1 = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (MODALIDADE NUMBER(1,0) NULL)';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN PRE_CONTRATOS_ESTUDANTES_EMPRESA.MODALIDADE IS ''0-Presencial; 1-Remoto; 2-Híbrido;''';
    END IF;
    
    IF ( coluna_existente2 = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (DIAS_HIBRIDO_PRESENCIAL NUMBER(1,0) NULL)';
    END IF;
    
    IF ( coluna_existente3 = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (DIAS_HIBRIDO_REMOTO NUMBER(1,0) NULL)';
    END IF;
END;
