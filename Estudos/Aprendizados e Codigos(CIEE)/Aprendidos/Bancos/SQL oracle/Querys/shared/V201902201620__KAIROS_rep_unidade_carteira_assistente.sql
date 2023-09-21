
CREATE TABLE {{user}}.rep_carteiras
(
  id               NUMBER NOT NULL,
  ativo            NUMBER(1),
  descricao        VARCHAR2(150 CHAR),
  id_assistente    NUMBER,
  id_unidade_ciee  NUMBER NOT NULL,
  data_criacao     TIMESTAMP NOT NULL,
  data_alteracao   TIMESTAMP NOT NULL,
  criado_por       VARCHAR2(255 CHAR),
  modificado_por   VARCHAR2(255 CHAR),
  deletado         NUMBER(1)
);

ALTER TABLE {{user}}.rep_carteiras ADD CONSTRAINT krs_indice_01825 PRIMARY KEY ( id );


CREATE TABLE {{user}}.rep_map_carteiras_territorios
(
  id                NUMBER NOT NULL,
  codigo_municipio  NUMBER NOT NULL,
  corrente          NUMBER(1),
  cep               VARCHAR2(8 CHAR),
  id_unidade_ciee   NUMBER NOT NULL,
  id_carteira       NUMBER,
  data_criacao      TIMESTAMP NOT NULL,
  data_alteracao    TIMESTAMP NOT NULL,
  criado_por        VARCHAR2(255 CHAR),
  modificado_por    VARCHAR2(255 CHAR),
  deletado          NUMBER(1)
);

ALTER TABLE {{user}}.rep_map_carteiras_territorios ADD CONSTRAINT krs_indice_01826 PRIMARY KEY ( id );


CREATE TABLE {{user}}.rep_assistentes
(
  id              NUMBER NOT NULL,
  ativo           NUMBER(1),
  id_pessoa       NUMBER NOT NULL,
  data_criacao    TIMESTAMP NOT NULL,
  data_alteracao  TIMESTAMP NOT NULL,
  criado_por      VARCHAR2(255 CHAR),
  modificado_por  VARCHAR2(255 CHAR),
  deletado        NUMBER(1)
);

ALTER TABLE {{user}}.rep_assistentes ADD CONSTRAINT krs_indice_01827 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_pessoas
(
  id              NUMBER NOT NULL,
  nome            VARCHAR2(255 CHAR),
  data_criacao    TIMESTAMP NOT NULL,
  data_alteracao  TIMESTAMP NOT NULL,
  criado_por      VARCHAR2(255 CHAR),
  modificado_por  VARCHAR2(255 CHAR),
  deletado        NUMBER(1)
);

ALTER TABLE {{user}}.rep_pessoas ADD CONSTRAINT krs_indice_01832 PRIMARY KEY ( id );


ALTER TABLE {{user}}.rep_carteiras
    ADD CONSTRAINT krs_indice_01828 FOREIGN KEY ( id_assistente )
        REFERENCES {{user}}.rep_assistentes ( id );

ALTER TABLE {{user}}.rep_carteiras
    ADD CONSTRAINT krs_indice_01829 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES {{user}}.rep_unidades_ciee ( id );


ALTER TABLE {{user}}.rep_map_carteiras_territorios
    ADD CONSTRAINT krs_indice_01830 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES {{user}}.rep_unidades_ciee ( id );

ALTER TABLE {{user}}.rep_map_carteiras_territorios
    ADD CONSTRAINT krs_indice_01831 FOREIGN KEY ( id_carteira )
        REFERENCES {{user}}.rep_carteiras ( id );

ALTER TABLE {{user}}.rep_assistentes
    ADD CONSTRAINT krs_indice_01833 FOREIGN KEY ( id_pessoa )
        REFERENCES {{user}}.rep_pessoas ( id );
