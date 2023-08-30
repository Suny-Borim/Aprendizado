DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'REP_CAMPUS' and column_name = 'NOME'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE REP_CAMPUS ADD NOME VARCHAR2(200 CHAR)';
  end if;
END;