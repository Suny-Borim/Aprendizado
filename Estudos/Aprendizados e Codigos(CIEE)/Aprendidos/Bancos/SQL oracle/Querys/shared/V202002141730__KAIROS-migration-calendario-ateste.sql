--Service Vagas
CREATE TABLE contratos_calendarios
(
    id               NUMBER(20),
    id_calendario    NUMBER(20) NOT NULL,
    id_contr_emp_est NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP  NOT NULL,
    data_alteracao   TIMESTAMP  NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0
);
--
CREATE TABLE rep_calendarios_core
(
    id             NUMBER(20) NOT NULL,
    descricao      VARCHAR2(150 CHAR),
    data_criacao   TIMESTAMP,
    data_alteracao TIMESTAMP,
    criado_por     VARCHAR2(255 CHAR),
    modificado_por VARCHAR2(255 CHAR),
    deletado       NUMBER(1)
);

COMMENT ON TABLE rep_calendarios_core IS 'CORE_DEV:SERVICE_CORE_DEV:CALENDARIOS';

CREATE TABLE rep_feriados_core
(
    id             NUMBER(20) NOT NULL,
    data_criacao   TIMESTAMP,
    data_alteracao TIMESTAMP,
    criado_por     VARCHAR2(255 CHAR),
    modificado_por VARCHAR2(255 CHAR),
    deletado       NUMBER(1),
    descricao      VARCHAR2(255 CHAR),
    data           TIMESTAMP,
    tipo_feriado   NUMBER(3),
    id_calendario  NUMBER(20) NOT NULL
);

COMMENT ON TABLE rep_feriados_core IS 'CORE_DEV:SERVICE_CORE_DEV:FERIADOS';
COMMENT ON COLUMN rep_feriados_core.tipo_feriado IS '0-NACIONAL 1-ESTADUAL 2-MUNICIPAL';

ALTER TABLE rep_calendarios_core ADD CONSTRAINT krs_indice_07163 PRIMARY KEY (id);
ALTER TABLE contratos_calendarios ADD CONSTRAINT krs_indice_07165 FOREIGN KEY (id_calendario) REFERENCES rep_calendarios_core (id);
ALTER TABLE contratos_calendarios ADD CONSTRAINT krs_indice_07166 FOREIGN KEY (id_contr_emp_est) REFERENCES contratos_estudantes_empresa (id);

ALTER TABLE rep_feriados_core ADD CONSTRAINT krs_indice_07162 PRIMARY KEY (id);
ALTER TABLE rep_feriados_core ADD CONSTRAINT krs_indice_07164 FOREIGN KEY (id_calendario) REFERENCES rep_calendarios_core (id);

CREATE SEQUENCE SEQ_contratos_calendarios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP  NOSCALE  GLOBAL;
