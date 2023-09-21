create table estagiarios_mepe(
id                NUMBER(20) NOT NULL,
cpf_estudante     VARCHAR2(11 BYTE),
link_pesquisa     VARCHAR2(500 char),
respondido		  NUMBER(1),
data_criacao      TIMESTAMP NOT NULL,
data_alteracao    TIMESTAMP,
criado_por        VARCHAR2(255 char),
modificado_por    VARCHAR2(255 char),
deletado          NUMBER(1)
);

ALTER TABLE estagiarios_mepe ADD CONSTRAINT KRS_INDICE_10870 PRIMARY KEY ( ID );

CREATE SEQUENCE SEQ_ESTAGIARIOS_MEPE INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;