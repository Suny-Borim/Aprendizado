DECLARE
    coluna_existente_1 int:=0;

BEGIN

  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'RECESSOS' and column_name = 'DATA_RESCISAO'; 
  	if coluna_existente_1<=0 then
  			EXECUTE IMMEDIATE 'ALTER TABLE RECESSOS ADD (DATA_RESCISAO TIMESTAMP (6))';
  	end if;   
  
END;
