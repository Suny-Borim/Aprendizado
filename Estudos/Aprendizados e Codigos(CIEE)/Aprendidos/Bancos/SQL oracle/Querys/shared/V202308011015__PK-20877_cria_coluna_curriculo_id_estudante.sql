DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'REP_ESTUDANTES' and column_name = 'CURRICULO_ID'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE REP_ESTUDANTES ADD CURRICULO_ID NUMBER(20,0)';
  end if;
END;