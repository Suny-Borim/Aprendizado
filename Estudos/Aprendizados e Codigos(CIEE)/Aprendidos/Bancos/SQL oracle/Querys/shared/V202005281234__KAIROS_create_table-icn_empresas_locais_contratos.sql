--PK-13999 - Integrar Kairós com ICN - Empresas e Locais de Contratos
--Service Vagas
CREATE TABLE icn_empresas_locais_contratos (
    id                 NUMBER(20) NOT NULL,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255 CHAR),
    modificado_por     VARCHAR2(255 CHAR),
    deletado           NUMBER(1) DEFAULT 0,
    uf_envio           VARCHAR2(2 CHAR),
    data_envio         TIMESTAMP,
    cnpj               VARCHAR2(14 CHAR),
    codigo_contrato    NUMBER(20),
    razao_social       VARCHAR2(150 CHAR),
    unid_adm_contrato  NUMBER(20),
    tipo               NUMBER(1),
    log_erro           CLOB
);
COMMENT ON COLUMN icn_empresas_locais_contratos.tipo IS
    '0-CONTRATO
1-LOCAL DE CONTRATO';
ALTER TABLE icn_empresas_locais_contratos ADD CONSTRAINT krs_indice_07620 PRIMARY KEY ( id );
CREATE SEQUENCE SEQ_ICN_EMPRESAS_LOCAIS_CONTRATOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;