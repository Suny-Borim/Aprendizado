DECLARE
    v_column_exists number := 0;
BEGIN
    Select count(*) into v_column_exists
    from USER_TAB_COLS
    where upper(COLUMN_NAME) = 'GENERO'
      and upper(table_name) = 'TRIAGENS_ESTUDANTES';

    if (v_column_exists = 0) then
        execute immediate 'alter table TRIAGENS_ESTUDANTES add GENERO NUMBER(20)';
    end if;

    v_column_exists := 0;

    Select count(*) into v_column_exists
    from USER_TAB_COLS
    where upper(COLUMN_NAME) = 'ETNIA'
      and upper(table_name) = 'TRIAGENS_ESTUDANTES';

    if (v_column_exists = 0) then
        execute immediate 'alter table TRIAGENS_ESTUDANTES add ETNIA NUMBER(20)';
    end if;

end;
