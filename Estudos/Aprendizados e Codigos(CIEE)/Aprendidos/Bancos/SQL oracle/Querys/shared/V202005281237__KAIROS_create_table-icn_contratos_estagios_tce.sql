--PK-14071 - Integrar Kairós com ICN - Contratos de Estagio (TCE)
--Service Vagas
CREATE TABLE icn_contratos_estagios_tce (
    id                          NUMBER(20) NOT NULL,
    data_criacao                TIMESTAMP NOT NULL,
    data_alteracao              TIMESTAMP NOT NULL,
    criado_por                  VARCHAR2(255 CHAR),
    modificado_por              VARCHAR2(255 CHAR),
    deletado                    NUMBER(1) DEFAULT 0,
    uf_envio                    VARCHAR2(2 CHAR),
    data_envio                  TIMESTAMP,
    cpf_estagiario              VARCHAR2(11 CHAR),
    nome_estagiario             VARCHAR2(150 CHAR),
    cnpj_empresa                VARCHAR2(14 CHAR),
    razao_social                VARCHAR2(150 CHAR),
    numero_contrato_estagio     NUMBER(20),
    data_inicio                 TIMESTAMP,
    data_termino                TIMESTAMP,
    data_rescisao               TIMESTAMP,
    unid_ciee_contrato_estagio  NUMBER(20),
    log_erro                    CLOB
);
ALTER TABLE icn_contratos_estagios_tce ADD CONSTRAINT krs_indice_07643 PRIMARY KEY ( id );
CREATE SEQUENCE SEQ_CONTRATOS_ESTAGIOS_TCE MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;