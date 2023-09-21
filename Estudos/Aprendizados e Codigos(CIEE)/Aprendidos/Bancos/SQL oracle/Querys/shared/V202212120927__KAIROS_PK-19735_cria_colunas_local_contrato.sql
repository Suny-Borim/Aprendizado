DECLARE
    coluna_existente_1 int:=0;
    coluna_existente_2 int:=0;
BEGIN
  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'ACOMPANHAMENTOS_GMC' and column_name = 'ID_LOCAL_CONTRATO'; 

  if coluna_existente_1<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE ACOMPANHAMENTOS_GMC ADD ID_LOCAL_CONTRATO NUMBER(20,0)';
  end if;
  
  SELECT count(*) into coluna_existente_2 from all_tab_columns where table_name = 'ACOMPANHAMENTOS_GMC' and column_name = 'NOME_LOCAL_CONTRATO'; 

  if coluna_existente_2<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE ACOMPANHAMENTOS_GMC ADD NOME_LOCAL_CONTRATO VARCHAR2(255 CHAR)';
  end if;
END;

