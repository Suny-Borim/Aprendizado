-- CRIANDO A TABELA CONFIG CONTRATOS ESTAGIO

CREATE TABLE rep_config_contratos_estagio_company (
    id                  NUMBER NOT NULL,
    atende_autonomo     NUMBER(1) DEFAULT 0,
    possui_aditivo_pe   NUMBER(1) DEFAULT 0
);

ALTER TABLE rep_config_contratos_estagio_company ADD CONSTRAINT krs_indice_04940 PRIMARY KEY ( id );

ALTER TABLE rep_config_contratos_estagio_company
    ADD CONSTRAINT krs_indice_04941 FOREIGN KEY ( id )
        REFERENCES rep_configuracao_contratos ( id );