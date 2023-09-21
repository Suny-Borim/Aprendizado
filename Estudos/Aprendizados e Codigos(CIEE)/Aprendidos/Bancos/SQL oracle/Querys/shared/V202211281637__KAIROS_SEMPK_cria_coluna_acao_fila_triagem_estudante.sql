DECLARE
    coluna_existente_acao NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente_acao
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'ACAO'
        AND upper(table_name) = 'FILA_TRIAGEM_ESTUDANTE';
        
    IF ( coluna_existente_acao = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.FILA_TRIAGEM_ESTUDANTE ADD (ACAO VARCHAR2(20) DEFAULT ''A'' )';       
    END IF;
END;