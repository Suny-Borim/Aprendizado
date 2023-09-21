DECLARE
  COLUNA_EXISTESNTE number := 0;  
BEGIN
  Select count(*) into COLUNA_EXISTESNTE
    from ALL_TAB_COLUMNS
    where upper(column_name) = 'SEXO'
      and upper(table_name) = 'REP_DEPENDENTES_STUDENT';
  if (COLUNA_EXISTESNTE = 0) then
      execute immediate 'alter table REP_DEPENDENTES_STUDENT add (SEXO VARCHAR2 (30 CHAR))';
  end if;
end;