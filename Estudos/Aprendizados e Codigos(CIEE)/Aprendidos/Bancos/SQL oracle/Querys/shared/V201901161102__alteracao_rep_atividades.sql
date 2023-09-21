alter table {{user}}.rep_atividades
add id_verbos_acao number(20) not null;

alter table {{user}}.rep_atividades
MODIFY  descricao_atividade VARCHAR2(200);

alter table {{user}}.rep_atividades
  ADD CONSTRAINT krs_indice_01221 FOREIGN KEY ( id_verbos_acao )
REFERENCES rep_verbos_acao ( id );