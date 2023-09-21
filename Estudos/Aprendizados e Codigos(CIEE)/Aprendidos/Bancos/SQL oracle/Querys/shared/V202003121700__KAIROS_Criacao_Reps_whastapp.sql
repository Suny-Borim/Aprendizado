CREATE TABLE rep_parametros_ciee_company (
    id                               NUMBER NOT NULL,
    ciee_id                          NUMBER,
    qtd_dia_apos_inicio_contrato     NUMBER(2),
    qtd_dia_max_assinar_contrato     NUMBER(2),
    qtd_dia_max_validacao            NUMBER(3),
    qtd_mes_max_validacao_local      NUMBER(3),
    qtd_mes_max_validacao_nacional   NUMBER(3),
    qtd_mes_visualizar_concessao     NUMBER(3),
    qtd_mes_visualizar_cobranca      NUMBER(3),
    data_criacao                     TIMESTAMP,
    data_alteracao                   TIMESTAMP,
    criado_por                       VARCHAR2(255 CHAR),
    modificado_por                   VARCHAR2(255 CHAR),
    deletado                         NUMBER(1),
    central_atendimento              VARCHAR2(60 CHAR),
    whatsapp                         VARCHAR2(60 CHAR)
);
COMMENT ON TABLE rep_parametros_ciee_company IS
    'COMPANY_DEV:SERVICE_COMPANY_DEV:PARAMETROS_CIEE';
ALTER TABLE rep_parametros_ciee_company ADD CONSTRAINT krs_indice_07304 PRIMARY KEY ( id );
CREATE TABLE rep_superintendencias_unit (
    id                   NUMBER(19) NOT NULL,
    criado_por           VARCHAR2(255 CHAR),
    data_criacao         TIMESTAMP,
    deletado             NUMBER(1),
    modificado_por       VARCHAR2(255 CHAR),
    data_alteracao       TIMESTAMP,
    ativo                NUMBER(1),
    descricao            VARCHAR2(100 CHAR),
    sigla                VARCHAR2(10 CHAR),
    descricao_reduzida   VARCHAR2(50 CHAR),
    id_responsavel       NUMBER(19),
    id_dominio           NUMBER(19),
    id_ciee              NUMBER(19)
);
COMMENT ON TABLE rep_superintendencias_unit IS
    'UNIT_DEV:SERVICE_UNIT_DEV:SUPERINTENDENCIAS';
ALTER TABLE rep_superintendencias_unit ADD CONSTRAINT krs_indice_07305 PRIMARY KEY ( id );