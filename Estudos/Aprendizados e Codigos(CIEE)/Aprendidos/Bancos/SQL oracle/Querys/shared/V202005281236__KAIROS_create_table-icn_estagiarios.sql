--PK-14003 - Integrar Kairós com ICN - Estagiário
--Service Vagas
CREATE TABLE icn_estagiarios (
    id              NUMBER(20) NOT NULL,
    data_criacao    TIMESTAMP NOT NULL,
    data_alteracao  TIMESTAMP NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    modificado_por  VARCHAR2(255 CHAR),
    deletado        NUMBER(1) DEFAULT 0,
    uf_envio        VARCHAR2(2 CHAR),
    data_envio      TIMESTAMP,
    cpf             VARCHAR2(11 CHAR),
    nome            VARCHAR2(150 CHAR),
    unid_ciee_ie    NUMBER(20),
    log_erro        CLOB
);
ALTER TABLE icn_estagiarios ADD CONSTRAINT krs_indice_07642 PRIMARY KEY ( id );
CREATE SEQUENCE SEQ_ICN_ESTAGIARIOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;