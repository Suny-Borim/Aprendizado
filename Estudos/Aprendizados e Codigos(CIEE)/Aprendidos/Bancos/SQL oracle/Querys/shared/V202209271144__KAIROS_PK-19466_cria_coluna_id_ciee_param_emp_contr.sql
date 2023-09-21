DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'PARAMETROS_EMPRESA_CONTRATO' and column_name = 'ID_CIEE'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE PARAMETROS_EMPRESA_CONTRATO ADD ID_CIEE NUMBER(20,0)';
  end if;
END;