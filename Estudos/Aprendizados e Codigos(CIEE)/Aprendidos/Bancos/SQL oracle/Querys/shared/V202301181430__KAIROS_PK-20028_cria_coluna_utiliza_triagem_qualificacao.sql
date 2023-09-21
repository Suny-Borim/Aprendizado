DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'QUALIFICACAO' and column_name = 'UTILIZA_TRIAGEM'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.QUALIFICACAO ADD (UTILIZA_TRIAGEM NUMBER(1) DEFAULT 0 )';
  end if;
END;