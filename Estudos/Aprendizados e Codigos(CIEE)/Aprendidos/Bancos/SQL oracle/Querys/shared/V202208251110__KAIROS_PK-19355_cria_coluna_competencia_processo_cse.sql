DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'PROCESSOS_CSE' and column_name = 'COMPETENCIA'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.PROCESSOS_CSE ADD (COMPETENCIA timestamp(6))';
  end if;
END;