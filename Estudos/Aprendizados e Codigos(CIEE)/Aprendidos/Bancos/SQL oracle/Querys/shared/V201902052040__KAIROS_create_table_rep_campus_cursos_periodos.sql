CREATE TABLE {{user}}.rep_campus_cursos_periodos (
  id                           NUMBER(20) NOT NULL,
  estagio_apos_tempo           NUMBER(10),
  deletado                     NUMBER,
  data_criacao                 TIMESTAMP NOT NULL,
  data_alteracao               TIMESTAMP NOT NULL,
  criado_por                   VARCHAR2(255),
  modificado_por               VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_campus_cursos_periodos
ADD CONSTRAINT krs_indice_01700 PRIMARY KEY ( id );

alter table REP_ESTUDANTES
  add id_informacoes_adicionais number(19,0);

alter table REP_ESTUDANTES
  add data_nascimento TIMESTAMP;

alter table REP_ESTUDANTES
  add pcd number(1);

alter table REP_ESTUDANTES
  add situacao varchar2(20);

alter table REP_ESTUDANTES
  add elegivel_pcd number(1);

alter table REP_ESTUDANTES
  add usa_recursos_acessibilidade number(1);
