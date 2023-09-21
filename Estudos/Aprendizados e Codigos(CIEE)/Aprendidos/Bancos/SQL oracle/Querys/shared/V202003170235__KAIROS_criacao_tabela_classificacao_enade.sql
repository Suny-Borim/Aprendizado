--Service Vagas
--PK-12926 - Processar Enade para Escolas
CREATE TABLE classificacoes_ies_enad (
    id                   NUMBER(20) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255 CHAR),
    modificado_por       VARCHAR2(255 CHAR),
    deletado             NUMBER(1) DEFAULT 0,
    ano                  NUMBER(4),
    codigo_ie_enad       NUMBER(20),
    igc                  NUMBER(3),
    convenio_ie_kairos   NUMBER(20),
    classificacao        VARCHAR2(15 CHAR)
);

ALTER TABLE classificacoes_ies_enad ADD CONSTRAINT krs_indice_07290 PRIMARY KEY ( id );

CREATE TABLE classificacoes_ies_igc (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0,
    descricao        VARCHAR2(15 CHAR),
    ponto_de         NUMBER(3),
    ponto_ate        NUMBER(3)
);

ALTER TABLE classificacoes_ies_igc ADD CONSTRAINT krs_indice_07291 PRIMARY KEY ( id );

CREATE SEQUENCE SEQ_CLASSIFICACOES_IES_ENAD MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

CREATE SEQUENCE SEQ_CLASSIFICACOES_IES_IGC MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
