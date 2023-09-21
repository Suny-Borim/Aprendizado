--Réplica de telefones do schema do company

CREATE TABLE REP_TELEFONES_COMPANY (
    id               NUMBER NOT NULL,
    ddd              VARCHAR2(2 CHAR) NOT NULL,
    numero           VARCHAR2(9 CHAR) NOT NULL,
    descricao        VARCHAR2(100 CHAR),
    ramal            VARCHAR2(9 CHAR),
    tipo_telefone    VARCHAR2(50 CHAR) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1)
);

COMMENT ON TABLE REP_TELEFONES_COMPANY IS
    'COMPANY';

ALTER TABLE REP_TELEFONES_COMPANY ADD CONSTRAINT krs_indice_03945 PRIMARY KEY ( id );


--Réplica de Representante telefones do schema do company

CREATE TABLE rep_representantes_telefones (
    id_representante   NUMBER NOT NULL,
    id_telefone        NUMBER NOT NULL
);

COMMENT ON TABLE rep_representantes_telefones IS
    'COMPANY';

ALTER TABLE rep_representantes_telefones ADD CONSTRAINT krs_indice_03944 PRIMARY KEY ( id_representante,
                                                                                       id_telefone );
