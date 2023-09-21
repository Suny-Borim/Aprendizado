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

    IF ( coluna_existente_permite_escolha = 1 ) THEN
        EXECUTE IMMEDIATE 'UPDATE BANCOS SET PERMITE_ESCOLHA=1 WHERE ID_BANCO IN(1,33,237,341)';   
        EXECUTE IMMEDIATE 'UPDATE BANCOS SET PERMITE_ESCOLHA=0 WHERE ID_BANCO NOT IN(1,33,237,341)';     
    END IF;
END;