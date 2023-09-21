begin execute immediate 'drop table fila_triagem_estudante'; exception when others then null; end;
/
create table fila_triagem_estudante (id_estudante int not null);
alter table fila_triagem_estudante
    add constraint pk_fila_triagem_estudante primary key (id_estudante);
alter table fila_triagem_estudante
    enable row movement;

begin
    execute immediate 'drop table {{user}}.fila_triagem_estudante_log';
    exception when others then null;
end;
/

CREATE TABLE {{user}}.fila_triagem_estudante_log
(
    "IDS_ESTUDANTES" {{user}}.IDS_TYP,
     dt_ocorrencia date not null,
     ds_ocorrencia varchar(1000) not null
)
    nested table IDS_ESTUDANTES store as N_IDS_FILA_TRIAGEM_LOG;
