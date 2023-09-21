DECLARE
    coluna_existente_1 int:=0;
    coluna_existente_4 int:=0;
BEGIN

  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'CONTRATACAO_EMPRESA'; 
  if coluna_existente_1<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (CONTRATACAO_EMPRESA NUMBER(1,0) DEFAULT 0)';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_4 from all_tab_columns where table_name = 'CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'CONTRATACAO_EMPRESA'; 
  if coluna_existente_4<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA ADD (CONTRATACAO_EMPRESA NUMBER(1,0) DEFAULT 0)';
  end if;   
  -----------------------------------------------

END;
