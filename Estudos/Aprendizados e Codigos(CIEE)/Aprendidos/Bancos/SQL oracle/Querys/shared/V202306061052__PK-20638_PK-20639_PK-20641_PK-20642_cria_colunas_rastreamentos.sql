DECLARE
    coluna_existente_1 int:=0;
    coluna_existente_2 int:=0;
    coluna_existente_3 int:=0;
    coluna_existente_4 int:=0;
    coluna_existente_5 int:=0;
    coluna_existente_6 int:=0;
BEGIN

  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO_AUTOMATICO'; 
  if coluna_existente_1<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO_AUTOMATICO NUMBER(1,0) DEFAULT 1 NOT NULL )';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_2 from all_tab_columns where table_name = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO'; 
  if coluna_existente_2<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO NUMBER(1,0) DEFAULT 0 NOT NULL)';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_3 from all_tab_columns where table_name = 'PRE_CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO_MESES'; 
  if coluna_existente_3<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO_MESES NUMBER(20,0))';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_4 from all_tab_columns where table_name = 'CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO_AUTOMATICO'; 
  if coluna_existente_4<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO_AUTOMATICO NUMBER(1,0) DEFAULT 1 NOT NULL )';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_5 from all_tab_columns where table_name = 'CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO'; 
  if coluna_existente_5<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO NUMBER(1,0) DEFAULT 0 NOT NULL )';
  end if;   
  -----------------------------------------------
  
    SELECT count(*) into coluna_existente_6 from all_tab_columns where table_name = 'CONTRATOS_ESTUDANTES_EMPRESA' and column_name = 'RASTREAMENTO_MESES'; 
  if coluna_existente_6<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA ADD (RASTREAMENTO_MESES NUMBER(20,0))';
  end if;   
  -----------------------------------------------
END;
