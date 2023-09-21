-- CRIANDO REPLICA CORRETORAS APOLICES CIEE DO COMPANY

CREATE TABLE rep_corretoras_apolices_ciee_company (
    id                  NUMBER NOT NULL,
    nome                VARCHAR2(100 CHAR) NOT NULL,
    cnpj                VARCHAR2(14 CHAR) NOT NULL,
    id_endereco         NUMBER,
    susep               VARCHAR2(20 CHAR) NOT NULL,
    nome_corretor       VARCHAR2(100 CHAR) NOT NULL,
    endereco_email      VARCHAR2(100 CHAR) NOT NULL,
    cobertura_apolice   VARCHAR2(50 BYTE) NOT NULL,
    data_criacao        TIMESTAMP NOT NULL,
    data_alteracao      TIMESTAMP NOT NULL,
    criado_por          VARCHAR2(255 CHAR),
    modificado_por      VARCHAR2(255 CHAR),
    deletado            NUMBER(1)
);

ALTER TABLE rep_corretoras_apolices_ciee_company ADD CONSTRAINT krs_indice_04960 PRIMARY KEY ( id );


-- CRIANDO REPLICA CORRETORAS TELFONES DO COMPANY

CREATE TABLE rep_corretoras_telefones_company (
    id_corretora   NUMBER NOT NULL,
    id_telefone    NUMBER NOT NULL
);

ALTER TABLE rep_corretoras_telefones_company ADD CONSTRAINT krs_indice_04961 PRIMARY KEY ( id_corretora,
                                                                                           id_telefone );

ALTER TABLE rep_corretoras_telefones_company
    ADD CONSTRAINT krs_indice_04964 FOREIGN KEY ( id_corretora )
        REFERENCES rep_corretoras_apolices_ciee_company ( id );

ALTER TABLE rep_corretoras_telefones_company
    ADD CONSTRAINT krs_indice_04965 FOREIGN KEY ( id_telefone )
        REFERENCES rep_telefones_company ( id );

-- ADICIONANDO CAMPO NA REPLICA APOLICES CIEE

ALTER TABLE rep_apolices_ciee ADD id_corretora NUMBER;

ALTER TABLE rep_apolices_ciee
    ADD CONSTRAINT krs_indice_04966 FOREIGN KEY ( id_corretora )
        REFERENCES rep_corretoras_apolices_ciee_company ( id );


-- CRIANDO REPLICA TELFONES DO UNIT

CREATE TABLE rep_telefones_unit (
    id               NUMBER(19) NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    data_criacao     TIMESTAMP NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    modificado_por   VARCHAR2(255 CHAR),
    data_alteracao   TIMESTAMP NOT NULL,
    ddd              VARCHAR2(2 CHAR) NOT NULL,
    descricao        VARCHAR2(100 CHAR),
    ramal            VARCHAR2(9 CHAR),
    numero           VARCHAR2(9 CHAR) NOT NULL,
    tipo_telefone    VARCHAR2(255 CHAR)
);

ALTER TABLE rep_telefones_unit ADD CONSTRAINT krs_indice_04963 PRIMARY KEY ( id );

-- CRIANDO REPLICA UNIDADES CIEE TELEFONES CONTATO DO UNIT

CREATE TABLE rep_unids_ciee_tels_contato_unit (
    id_unidade_ciee   NUMBER(19) NOT NULL,
    id_telefone       NUMBER NOT NULL
);

ALTER TABLE rep_unids_ciee_tels_contato_unit ADD CONSTRAINT krs_indice_04962 PRIMARY KEY ( id_unidade_ciee,
                                                                                           id_telefone );

ALTER TABLE rep_unids_ciee_tels_contato_unit
    ADD CONSTRAINT krs_indice_04980 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES rep_unidades_ciee ( id );

ALTER TABLE rep_unids_ciee_tels_contato_unit
    ADD CONSTRAINT krs_indice_04981 FOREIGN KEY ( id_telefone )
        REFERENCES rep_telefones_unit ( id );
