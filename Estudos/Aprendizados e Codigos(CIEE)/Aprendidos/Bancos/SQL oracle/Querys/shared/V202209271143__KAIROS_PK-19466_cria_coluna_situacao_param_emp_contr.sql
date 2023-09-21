DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'PARAMETROS_EMPRESA_CONTRATO' and column_name = 'SITUACAO'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE PARAMETROS_EMPRESA_CONTRATO ADD SITUACAO NUMBER(1,0) DEFAULT 1';
  end if;
END;