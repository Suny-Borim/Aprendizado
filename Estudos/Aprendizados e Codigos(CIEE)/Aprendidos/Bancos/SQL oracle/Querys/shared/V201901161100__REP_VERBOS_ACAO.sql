CREATE TABLE rep_verbos_acao (
  id                     NUMBER(20) NOT NULL,
  descricao_verbo_acao   VARCHAR2(25),
  deletado               NUMBER,
  data_criacao           TIMESTAMP,
  data_alteracao         TIMESTAMP NOT NULL,
  criado_por             VARCHAR2(255),
  modificado_por         VARCHAR2(255)
);

ALTER TABLE rep_verbos_acao ADD CONSTRAINT krs_indice_01220 PRIMARY KEY ( id );