CREATE TABLE agrupamentos (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(150) NOT NULL,
    deletado         NUMBER,
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

ALTER TABLE agrupamentos ADD CONSTRAINT krs_indice_01780 PRIMARY KEY ( id );

CREATE TABLE agrupamentos_contratos (
    id_agrupamento   NUMBER(20) NOT NULL,
    id_contrato      NUMBER(20) NOT NULL
);

ALTER TABLE agrupamentos_contratos
    ADD CONSTRAINT krs_indice_01781 FOREIGN KEY ( id_agrupamento )
        REFERENCES agrupamentos ( id )
    NOT DEFERRABLE;

ALTER TABLE agrupamentos_contratos
    ADD CONSTRAINT krs_indice_01782 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id )
    NOT DEFERRABLE;


--- CAMPO NOVO NA REPLICA ESTUDANTE

ALTER TABLE REP_ESTUDANTES ADD(
    ID_INFORMACOES_BRASILEIROS NUMBER(30)
);