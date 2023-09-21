DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'REP_CIEE_PERSONALIZADO_CORE'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE TABLE REP_CIEE_PERSONALIZADO_CORE
   (	
        id number(20,0) not null enable, 
        descricao varchar2(255 char) not null enable, 
        tipo number(10,0) not null enable, 
        idade_minima number(10,0),
        idade_maxima number(10,0), 
        data_criacao timestamp (6), 
        data_alteracao timestamp (6), 
        criado_por varchar2(255 char), 
        modificado_por varchar2(255 char), 
        deletado number(1,0))';
     EXECUTE IMMEDIATE 'ALTER TABLE REP_CIEE_PERSONALIZADO_CORE ADD (CONSTRAINT KRS_INDICE_12333 PRIMARY KEY (ID))';
     EXECUTE IMMEDIATE 'COMMENT ON TABLE SERVICE_VAGAS_DEV.REP_CIEE_PERSONALIZADO_CORE IS ''CORE_DEV:SERVICE_CORE_DEV:CIEE_PERSONALIZADO:ID''';
  end if;
END;