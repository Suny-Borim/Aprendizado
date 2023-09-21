DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'CAMPOS' and column_name = 'TIPO_CONTRATO'; 

  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.CAMPOS ADD (TIPO_CONTRATO NUMBER(1) DEFAULT 0 )';
     EXECUTE IMMEDIATE 'COMMENT ON COLUMN CAMPOS.TIPO_CONTRATO IS ''Enum: 0-ESTAGIO; 1-APRENDIZ;''';    
  end if;   
END;
