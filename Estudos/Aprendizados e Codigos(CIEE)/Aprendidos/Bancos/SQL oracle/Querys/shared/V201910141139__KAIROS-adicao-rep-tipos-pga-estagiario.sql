CREATE TABLE rep_tipos_sis_pga_estagiario_company (
    id               NUMBER NOT NULL,
    descricao        VARCHAR2(150 CHAR) NOT NULL,
    sigla            VARCHAR2(2 CHAR) NOT NULL,
    ativo            NUMBER(1),
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1),
    tipo_pessoa      VARCHAR2(100 CHAR),
    categoria        VARCHAR2(50 BYTE) NOT NULL
);

ALTER TABLE rep_tipos_sis_pga_estagiario_company
    ADD CHECK ( categoria IN (
        'CENTRALIZADO',
        'DIRETO'
    ) );

ALTER TABLE rep_tipos_sis_pga_estagiario_company ADD CONSTRAINT krs_indice_04771 PRIMARY KEY ( id );

ALTER TABLE rep_contratos
    ADD CONSTRAINT krs_indice_04772 FOREIGN KEY ( id_tipo_sis_pga_estagiario )
        REFERENCES rep_tipos_sis_pga_estagiario_company ( id );