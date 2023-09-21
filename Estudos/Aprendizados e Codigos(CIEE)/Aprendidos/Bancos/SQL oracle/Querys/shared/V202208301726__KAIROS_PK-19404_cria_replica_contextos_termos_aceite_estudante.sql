DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'REP_CONTEXTO_TERMOS_ACEITE_CORE'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'create table service_vagas_dev.rep_contexto_termos_aceite_core
(	
    id number(19,0) not null enable, 
    id_modelo_termo_aceite number(19,0) not null enable, 
    termo_contexto varchar2(255 char) not null enable, 
    termo_item varchar2(255 char) not null enable, 
    criado_por varchar2(255 char) not null enable, 
    data_criacao timestamp (6) not null enable, 
    modificado_por varchar2(255 char), 
    data_alteracao timestamp (6), 
    deletado number(1,0) not null enable, 
    constraint krs_indice_11670 primary key (id))';
  end if;
END;

/

comment on table service_vagas_dev.rep_contexto_termos_aceite_core is 'CORE_DEV:SERVICE_CORE_DEV:CONTEXTO_TERMOS_ACEITE:id';