-- Migration de alteracao ferias

DROP TABLE CONTRATOS_EMPRESAS_FERIAS;
DROP TABLE PRE_CONTRATOS_EMPRESAS_FERIAS;

--Criacao de table

CREATE TABLE ferias (
    id               NUMBER(20) NOT NULL,
    id_contr_emp     NUMBER(20) NOT NULL,
    tipo_ferias      NUMBER(1) NOT NULL,
    data_inicio      TIMESTAMP NOT NULL,
    data_fim         TIMESTAMP NOT NULL,
    deletado         NUMBER,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.tipo_ferias IS
    'Enum:

0 - FAIXA1 (PERIODO DE 30 DIAS)

1 - FAIXA2 (PERIODO DE 10 A 20 DIAS)

2 - FAIXA3 (3 PERIODOS DE 10 DIAS)

Este campo e utilizado na matricula do Aprendiz'
    ;

COMMENT ON COLUMN ferias.data_inicio IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.data_fim IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

ALTER TABLE ferias ADD CONSTRAINT krs_indice_02383 PRIMARY KEY ( id );

ALTER TABLE ferias
    ADD CONSTRAINT "KRS_INDICE_02385 " FOREIGN KEY ( id_contr_emp )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;


--Criacao de table

CREATE TABLE periodos (
    id               NUMBER(20) NOT NULL,
    id_ferias        NUMBER(20) NOT NULL,
    data_inicio      TIMESTAMP NOT NULL,
    data_fim         TIMESTAMP NOT NULL,
    deletado         NUMBER,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN periodos.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.data_inicio IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.data_fim IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN periodos.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';



--Criacao table

CREATE TABLE pre_ferias (
    id                 NUMBER(20) NOT NULL,
    id_pre_contr_emp   NUMBER(20) NOT NULL,
    tipo_ferias        NUMBER(1) NOT NULL,
    deletado           NUMBER,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP,
    criado_por         VARCHAR2(255) NOT NULL,
    modificado_por     VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN pre_ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_ferias.tipo_ferias IS
    'Enum:

0 - FAIXA1 (PERIODO DE 30 DIAS)

1 - FAIXA2 (PERIODO DE 10 A 20 DIAS)

2-FAIXA3 (3 PERIODOS DE 10 DIAS)

Este campo e utilizado na matricula do Aprendiz'
    ;

COMMENT ON COLUMN pre_ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';


--Criacao table

CREATE TABLE pre_periodos_ferias (
    id               NUMBER(20) NOT NULL,
    id_pre_ferias    NUMBER(20) NOT NULL,
    data_inicio      TIMESTAMP NOT NULL,
    data_fim         TIMESTAMP NOT NULL,
    deletado         NUMBER,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN pre_periodos_ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.data_inicio IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.data_fim IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_periodos_ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';



--Add indices

ALTER TABLE periodos ADD CONSTRAINT krs_indice_02384 PRIMARY KEY ( id );

ALTER TABLE periodos
    ADD CONSTRAINT krs_indice_02386 FOREIGN KEY ( id_ferias )
        REFERENCES ferias ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_ferias ADD CONSTRAINT krs_indice_02387 PRIMARY KEY ( id );

ALTER TABLE pre_ferias
    ADD CONSTRAINT "KRS_INDICE_02388 " FOREIGN KEY ( id_pre_contr_emp )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_periodos_ferias ADD CONSTRAINT krs_indice_02390 PRIMARY KEY ( id );

ALTER TABLE pre_periodos_ferias
    ADD CONSTRAINT krs_indice_02389 FOREIGN KEY ( id_pre_ferias )
        REFERENCES pre_ferias ( id )
    NOT DEFERRABLE;


--Alteracao de nome da tabela
ALTER TABLE pre_beneficios_contr_emp_est RENAME TO pre_beneficios_contr_emp;


--Apagar sequences tabaleas excluidas
DROP SEQUENCE SEQ_PRE_CONTRATOS_EMPRESAS_FERIAS;

--Sequences das tabelas criadas

CREATE SEQUENCE SEQ_FERIAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PERIODOS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

CREATE SEQUENCE SEQ_PRE_FERIAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PRE_PERIODOS_FERIAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;