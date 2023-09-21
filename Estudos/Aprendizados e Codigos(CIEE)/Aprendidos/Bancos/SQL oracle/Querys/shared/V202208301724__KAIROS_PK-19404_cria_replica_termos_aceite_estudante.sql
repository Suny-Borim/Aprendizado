DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'REP_TERMOS_ACEITE_ESTUDANTE_STUDENT'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'create table service_vagas_dev.rep_termos_aceite_estudante_student
(	
    id number(19,0) not null enable, 
    id_usuario number(19,0) not null enable, 
    id_modelo_termo_aceite number(19,0) not null enable, 
    versao number(19,0) not null enable, 
    data_validade timestamp (6), 
    situacao number(1,0) not null enable, 
    data_aceite_recusa timestamp (6), 
    data_revogacao timestamp (6), 
    criado_por varchar2(255 char) not null enable, 
    data_criacao timestamp (6) not null enable, 
    modificado_por varchar2(255 char), 
    data_alteracao timestamp (6), 
    deletado number(1,0) not null enable, 
    constraint krs_indice_11668 primary key (id))';
  end if;
END;

/

comment on table service_vagas_dev.rep_termos_aceite_estudante_student is 'STUDENT_DEV:SERVICE_STUDENT_DEV:TERMOS_ACEITE_ESTUDANTE:id';