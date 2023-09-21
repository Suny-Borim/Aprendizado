DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'REP_MODELOS_TERMO_ACEITE_CORE'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'create table service_vagas_dev.rep_modelos_termo_aceite_core
(	
    id number(19,0) not null enable, 
    nome_modelo varchar2(255 char) not null enable, 
    descricao_modelo varchar2(255 char), 
    situacao number(1,0) not null enable, 
    validade_dias number(19,0), 
    permite_revogacao number(1,0) not null enable, 
    obrigatorio number(1,0) not null enable, 
    mensagem_nao_aceite varchar2(255 char), 
    criado_por varchar2(255 char) not null enable, 
    data_criacao timestamp (6) not null enable, 
    modificado_por varchar2(255 char), 
    data_alteracao timestamp (6), 
    deletado number(1,0) not null enable, 
    constraint krs_indice_11669 primary key (id))';
  end if;
END;

/

comment on table service_vagas_dev.rep_modelos_termo_aceite_core is 'CORE_DEV:SERVICE_CORE_DEV:MODELOS_TERMO_ACEITE:id';