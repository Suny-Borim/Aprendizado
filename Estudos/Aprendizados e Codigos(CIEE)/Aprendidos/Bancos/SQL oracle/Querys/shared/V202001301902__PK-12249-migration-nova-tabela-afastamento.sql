--PK-9311 - Implementar Gerar TA Aprendiz CIEE
CREATE TABLE afastamentos (
    id                   NUMBER(20) NOT NULL,
    id_contr_emp_est     NUMBER(20) NOT NULL,
    motivo_afastamento   VARCHAR2(30 CHAR) NOT NULL,
    tipo_afastamento     NUMBER(1) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255 CHAR),
    modificado_por       VARCHAR2(255 CHAR),
    deletado             NUMBER(1) DEFAULT 0
);

COMMENT ON COLUMN afastamentos.tipo_afastamento IS
    'ENUM:
0-Acidente
1-Gestante
2-Serviço militar';

ALTER TABLE afastamentos ADD CONSTRAINT krs_indice_07061 PRIMARY KEY ( id );

CREATE TABLE hist_afastamentos (
    id                   NUMBER(20) NOT NULL,
    id_contr_emp_est     NUMBER(20) NOT NULL,
    motivo_afastamento   VARCHAR2(30 CHAR) NOT NULL,
    tipo_afastamento     NUMBER(1) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255 CHAR),
    modificado_por       VARCHAR2(255 CHAR),
    deletado             NUMBER(1) DEFAULT 0
);

COMMENT ON COLUMN hist_afastamentos.tipo_afastamento IS
    'ENUM:
0-Acidente
1-Gestante
2-Serviço militar';

ALTER TABLE hist_afastamentos ADD CONSTRAINT krs_indice_07062 PRIMARY KEY ( id );

ALTER TABLE afastamentos
    ADD CONSTRAINT krs_indice_07063 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );
		
ALTER TABLE hist_afastamentos
    ADD CONSTRAINT krs_indice_07064 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );