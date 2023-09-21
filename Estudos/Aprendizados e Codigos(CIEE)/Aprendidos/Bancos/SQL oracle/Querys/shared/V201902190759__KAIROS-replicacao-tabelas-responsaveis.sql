CREATE TABLE rep_responsaveis (
   id                       NUMBER(20) NOT NULL,
   nome_mae                 VARCHAR2(150 CHAR),
   nome_pai                 VARCHAR2(150 CHAR),
   nome_responsavel_legal   VARCHAR2(150 CHAR),
   data_criacao             TIMESTAMP NOT NULL,
   data_alteracao           TIMESTAMP NOT NULL,
   criado_por               VARCHAR2(255),
   modificado_por           VARCHAR2(255),
   deletado                 NUMBER(1)
);

ALTER TABLE rep_responsaveis ADD CONSTRAINT krs_indice_01807 PRIMARY KEY (id);
