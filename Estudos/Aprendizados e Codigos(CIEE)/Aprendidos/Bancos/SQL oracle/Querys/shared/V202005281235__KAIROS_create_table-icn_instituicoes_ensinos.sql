--PK-14051 - Integrar Kairós com ICN - Instituição de Ensino
--Service Vagas
CREATE TABLE icn_instituicoes_ensinos (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0,
    uf_envio         VARCHAR2(2 CHAR),
    data_envio       TIMESTAMP,
    cnpj             VARCHAR2(14 CHAR),
    codigo_convenio  NUMBER(20),
    razao_social     VARCHAR2(150 CHAR),
    unid_ciee_ie     NUMBER(20),
    log_erro         CLOB
);
ALTER TABLE icn_instituicoes_ensinos ADD CONSTRAINT krs_indice_07621 PRIMARY KEY ( id );
CREATE SEQUENCE SEQ_ICN_INSTITUICOES_ENSINOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;