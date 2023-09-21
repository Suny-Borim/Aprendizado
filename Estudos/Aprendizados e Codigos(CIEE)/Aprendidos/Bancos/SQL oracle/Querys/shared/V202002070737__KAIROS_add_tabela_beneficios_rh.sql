--PK-10084 - Solicitar Desconto de benefícios - Aprendiz

CREATE TABLE BENEFICIOS_RH (
    ID               NUMBER(20) NOT NULL,
    DESCRICAO        VARCHAR2(300 CHAR) NOT NULL,
    DATA_CRIACAO     TIMESTAMP NOT NULL,
    DATA_ALTERACAO   TIMESTAMP NOT NULL,
    CRIADO_POR       VARCHAR2(255 CHAR),
    MODIFICADO_POR   VARCHAR2(255 CHAR),
    DELETADO         NUMBER(1) DEFAULT 0
);

--PK-11263 - Solicitar Reembolso Despesas Médicas e Medicamentos (FAE)
--Service Vagas
CREATE TABLE documentos_solicitacoes_servicenow (
    id                          NUMBER(20) NOT NULL,
    id_solicitacao_servicenow   NUMBER(20) NOT NULL,
    codigo_documento            NUMBER(20),
    descricao                   VARCHAR2(255),
    data_criacao                TIMESTAMP NOT NULL,
    data_alteracao              TIMESTAMP NOT NULL,
    criado_por                  VARCHAR2(255 CHAR),
    modificado_por              VARCHAR2(255 CHAR),
    deletado                    NUMBER(1) DEFAULT 0
);

ALTER TABLE documentos_solicitacoes_servicenow ADD CONSTRAINT krs_indice_07104 PRIMARY KEY ( id );
ALTER TABLE documentos_solicitacoes_servicenow
    ADD CONSTRAINT krs_indice_07105 FOREIGN KEY ( id_solicitacao_servicenow )
        REFERENCES solicitacoes_servicenow ( id );
--


ALTER TABLE BENEFICIOS_RH ADD CONSTRAINT krs_indice_07237 PRIMARY KEY ( ID );
CREATE SEQUENCE SEQ_BENEFICIOS_RH MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_documentos_solicitacoes_servicenow MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;


INSERT INTO BENEFICIOS_RH VALUES(SEQ_BENEFICIOS_RH.nextval, 'Vale Transporte', CURRENT_DATE, CURRENT_DATE, 'flyway', 'flyway', 0);
INSERT INTO BENEFICIOS_RH VALUES(SEQ_BENEFICIOS_RH.nextval, 'Vale Refeição/Vale Alimentação', CURRENT_DATE, CURRENT_DATE, 'flyway', 'flyway', 0);
INSERT INTO BENEFICIOS_RH VALUES(SEQ_BENEFICIOS_RH.nextval, 'Cesta Básica', CURRENT_DATE, CURRENT_DATE, 'flyway', 'flyway', 0);
INSERT INTO BENEFICIOS_RH VALUES(SEQ_BENEFICIOS_RH.nextval, '2ª via de crachá', CURRENT_DATE, CURRENT_DATE, 'flyway', '', 0);
