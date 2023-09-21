begin execute immediate 'drop table fila_triagem_estudante'; exception when others then null; end;
/
create table fila_triagem_estudante (id_estudante int not null, dt_ocorrencia date default sysdate);
alter table fila_triagem_estudante add constraint pk_fila_triagem_estudante primary key (id_estudante);
alter table fila_triagem_estudante enable row movement;
