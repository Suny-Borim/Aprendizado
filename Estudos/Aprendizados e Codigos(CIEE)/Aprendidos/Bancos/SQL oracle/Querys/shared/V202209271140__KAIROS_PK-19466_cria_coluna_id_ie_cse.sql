DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'CSE' and column_name = 'ID_IE'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE CSE ADD ID_IE NUMBER(20,0)';
  end if;
END;