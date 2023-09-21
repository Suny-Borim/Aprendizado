DECLARE
    coluna_existente_1 int:=0;
    coluna_existente_2 int:=0;
    coluna_existente_3 int:=0;
BEGIN
  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_INICIAL'; 

  if coluna_existente_1<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_TEORICA_INICIAL TIMESTAMP(6)';
  end if;
  
  SELECT count(*) into coluna_existente_2 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_BASICA'; 

  if coluna_existente_2<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_TEORICA_BASICA TIMESTAMP(6)';
  end if;
  
  SELECT count(*) into coluna_existente_3 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_ESPECIFICA'; 

  if coluna_existente_3<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_TEORICA_ESPECIFICA TIMESTAMP(6)';
  end if;
END;

