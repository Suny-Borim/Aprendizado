CREATE TABLE AVALIACOES_COMPORTAMENTAIS_STATUS (
    id               NUMBER(20) NOT NULL,
    id_estudante     NUMBER(20) NOT NULL,
    status           NUMBER(1) NOT NULL,
    criado_por       VARCHAR2(255 BYTE) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP,
    modificado_por   VARCHAR2(255 BYTE),
    deletado         NUMBER
);

COMMENT ON COLUMN AVALIACOES_COMPORTAMENTAIS_STATUS.status IS
    'ENUM

0-PENDENTE
1-RECUPERADO
2-INVALIDO';

ALTER TABLE AVALIACOES_COMPORTAMENTAIS_STATUS ADD CONSTRAINT krs_indice_03694 PRIMARY KEY ( id );

ALTER TABLE AVALIACOES_COMPORTAMENTAIS_STATUS
    ADD CONSTRAINT krs_indice_03695 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );


-- Cria flag de aceite para tabela de replica
ALTER TABLE REP_ESTUDANTES ADD  ACEITE_ANALISE NUMERIC;
COMMENT ON COLUMN rep_estudantes.aceite_analise IS
    'Aceita o CIEE armazenar as informações referente a análise comportamental.';
