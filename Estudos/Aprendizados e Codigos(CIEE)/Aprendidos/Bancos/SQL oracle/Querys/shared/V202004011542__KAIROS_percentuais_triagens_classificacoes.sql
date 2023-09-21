CREATE TABLE percentuais_triagens_classificacoes (
    id                  NUMBER(20) NOT NULL,
    percentual_faixa_1  NUMBER(3),
    sigla_faixa_1       VARCHAR2(15 CHAR),
    percentual_faixa_2  NUMBER(3),
    sigla_faixa_2       VARCHAR2(15 CHAR),
    percentual_faixa_3  NUMBER(3),
    sigla_faixa_3       VARCHAR2(15 CHAR),
    data_criacao        TIMESTAMP NOT NULL,
    data_alteracao      TIMESTAMP NOT NULL,
    criado_por          VARCHAR2(255 CHAR),
    modificado_por      VARCHAR2(255 CHAR),
    deletado            NUMBER(1) DEFAULT 0
);

ALTER TABLE percentuais_triagens_classificacoes ADD CONSTRAINT krs_indice_07460 PRIMARY KEY ( id );



