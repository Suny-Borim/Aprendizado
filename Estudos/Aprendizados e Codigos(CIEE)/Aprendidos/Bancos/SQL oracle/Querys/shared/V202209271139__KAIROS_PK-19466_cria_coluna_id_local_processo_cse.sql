DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'PROCESSOS_CSE' and column_name = 'ID_LOCAL_CONTRATO'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE PROCESSOS_CSE ADD ID_LOCAL_CONTRATO NUMBER(20,0)';
  end if;
END;