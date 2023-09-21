DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'REP_ATIVIDADES' and column_name = 'ATIVO'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE REP_ATIVIDADES ADD ATIVO NUMBER(1,0)';
  end if;
END;