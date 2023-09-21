DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'TURMAS' and column_name = 'ID_INSTRUTOR'; 

  if coluna_existente <= 0 then
     EXECUTE IMMEDIATE 'ALTER TABLE TURMAS ADD (ID_INSTRUTOR NUMBER(20,0))';
     
     EXECUTE IMMEDIATE 'ALTER TABLE TURMAS ADD CONSTRAINT KRS_INDICE_12035 FOREIGN KEY ( ID_INSTRUTOR ) REFERENCES INSTRUTOR( ID ) NOT DEFERRABLE';
  end if;
  	
END;