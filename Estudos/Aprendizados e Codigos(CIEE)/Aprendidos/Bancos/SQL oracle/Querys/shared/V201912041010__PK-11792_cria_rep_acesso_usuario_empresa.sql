CREATE TABLE rep_acessos_usuario_empresa_company (
    id                       NUMBER NOT NULL,
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP,
    criado_por               VARCHAR2(255 CHAR),
    modificado_por           VARCHAR2(255 CHAR),
    deletado                 NUMBER(1),
    nome                     VARCHAR2(300 CHAR),
    email                    VARCHAR2(150 CHAR),
    departamento             VARCHAR2(50 CHAR),
    codigo                   VARCHAR2(100 CHAR),
    id_usuario               NUMBER,
    ativo                    NUMBER(1) DEFAULT 1,
    administrador_contrato   NUMBER(1),
    id_contrato              NUMBER NOT NULL
);

COMMENT ON TABLE rep_acessos_usuario_empresa_company IS
    'COMPANY_DEV:SERVICE_COMPANY_DEV:ACESSOS_USUARIO_EMPRESA';

ALTER TABLE rep_acessos_usuario_empresa_company ADD CONSTRAINT krs_indice_06700 PRIMARY KEY ( id );

ALTER TABLE rep_acessos_usuario_empresa_company ADD CONSTRAINT acessos_usuario_empresa_id_usuario_un UNIQUE ( id_usuario );

CREATE TABLE rep_usuarios_dominios_company (
    id                   NUMBER NOT NULL,
    id_usuario           NUMBER NOT NULL,
    composicao_dominio   VARCHAR2(255 CHAR),
    id_grupo_acesso      NUMBER NOT NULL,
    data_criacao         TIMESTAMP,
    data_alteracao       TIMESTAMP,
    criado_por           VARCHAR2(255 CHAR),
    modificado_por       VARCHAR2(255 CHAR),
    deletado             NUMBER(1)
);

COMMENT ON TABLE rep_usuarios_dominios_company IS
    'COMPANY_DEV:SERVICE_COMPANY_DEV:USUARIOS_DOMINIOS';

ALTER TABLE rep_usuarios_dominios_company ADD CONSTRAINT krs_indice_06701 PRIMARY KEY ( id );