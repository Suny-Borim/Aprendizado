DECLARE
coluna_existente1 int := 0;
BEGIN
    SELECT COUNT(*) INTO coluna_existente1 FROM all_tab_columns WHERE upper(column_name) = 'TIPO_ESCOLA' AND upper(table_name) = 'TRIAGENS_ESTUDANTES';
    IF( coluna_existente1 = 0 ) THEN
       EXECUTE IMMEDIATE 'ALTER TABLE TRIAGENS_ESTUDANTES ADD TIPO_ESCOLA NUMBER(20,0)';
    END IF;
END;
/
DECLARE
coluna_existente1                            int := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente1
    FROM
        all_tab_columns
    WHERE
        upper(column_name) = 'TIPO_DOCUMENTO'
        AND upper(table_name) = 'TRIAGENS_VAGAS';
    IF ( coluna_existente1 = 0 ) THEN
       EXECUTE IMMEDIATE 'ALTER TABLE TRIAGENS_VAGAS ADD TIPO_DOCUMENTO VARCHAR2(50 CHAR)';
    END IF;
END;