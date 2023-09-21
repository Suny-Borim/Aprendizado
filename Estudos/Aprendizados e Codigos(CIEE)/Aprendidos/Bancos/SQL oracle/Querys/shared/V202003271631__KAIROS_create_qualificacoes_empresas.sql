--Service Vagas
--PK-12929 - Qualificar Empresas, Locais de Contratos
CREATE TABLE qualificacoes_empresas_analiticos (
    id                                 NUMBER(20) NOT NULL,
    data_criacao                       TIMESTAMP NOT NULL,
    data_alteracao                     TIMESTAMP NOT NULL,
    criado_por                         VARCHAR2(255 CHAR),
    modificado_por                     VARCHAR2(255 CHAR),
    deletado                           NUMBER(1) DEFAULT 0,
	id_qualificacao_empresa_consolidado  NUMBER(20) NOT NULL,
    id_qualificacao_parametro_empresa  NUMBER(20) NOT NULL,
    pontuacao_atual                    NUMBER(4),
    total_pontuacao_obtida             NUMBER(10),
	data_vencimento    				   TIMESTAMP
	
);
ALTER TABLE qualificacoes_empresas_analiticos ADD CONSTRAINT krs_indice_07295 PRIMARY KEY ( id );
CREATE TABLE qualificacoes_empresas_consolidado (
    id                      NUMBER(20) NOT NULL,
    data_criacao            TIMESTAMP NOT NULL,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255 CHAR),
    modificado_por          VARCHAR2(255 CHAR),
    deletado                NUMBER(1) DEFAULT 0,
    id_empresa              NUMBER(20) NOT NULL,
    id_local_contrato       NUMBER(20),
    pontuacao_obtida        NUMBER(4),
    classificacao_obtida    VARCHAR2(15 CHAR),
    data_calculo_pontuacao  TIMESTAMP
);
COMMENT ON COLUMN qualificacoes_empresas_consolidado.classificacao_obtida IS
    'A
B
C';
ALTER TABLE qualificacoes_empresas_consolidado ADD CONSTRAINT krs_indice_07294 PRIMARY KEY ( id );
CREATE TABLE qualificacoes_parametros_empresas (
    id                 NUMBER(20) NOT NULL,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255 CHAR),
    modificado_por     VARCHAR2(255 CHAR),
    deletado           NUMBER(1) DEFAULT 0,
    indicador          VARCHAR2(255 CHAR),
    periodo            NUMBER(10),
    faixa_confirmacao  NUMBER(1),
    ponto              NUMBER(3)
);
COMMENT ON COLUMN qualificacoes_parametros_empresas.faixa_confirmacao IS
    '0-Não
1-Sim';
ALTER TABLE qualificacoes_parametros_empresas ADD CONSTRAINT krs_indice_07292 PRIMARY KEY ( id );
CREATE TABLE qualificacoes_parametros_pontos (
    id              NUMBER(20) NOT NULL,
    data_criacao    TIMESTAMP NOT NULL,
    data_alteracao  TIMESTAMP NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    modificado_por  VARCHAR2(255 CHAR),
    deletado        NUMBER(1) DEFAULT 0,
    sigla           VARCHAR2(15 CHAR),
    ponto_de        NUMBER(3),
    ponto_ate       NUMBER(3)
);
COMMENT ON COLUMN qualificacoes_parametros_pontos.sigla IS
    'A
B
C';
ALTER TABLE qualificacoes_parametros_pontos ADD CONSTRAINT krs_indice_07293 PRIMARY KEY ( id );
ALTER TABLE qualificacoes_empresas_consolidado
    ADD CONSTRAINT krs_indice_07409 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE qualificacoes_empresas_analiticos
    ADD CONSTRAINT krs_indice_07410 FOREIGN KEY ( id_qualificacao_empresa_consolidado )
        REFERENCES qualificacoes_empresas_consolidado ( id )
    NOT DEFERRABLE;
ALTER TABLE qualificacoes_empresas_analiticos
    ADD CONSTRAINT krs_indice_07411 FOREIGN KEY ( id_qualificacao_parametro_empresa )
        REFERENCES qualificacoes_parametros_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE qualificacoes_empresas_consolidado
    ADD CONSTRAINT krs_indice_07412 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id )
    NOT DEFERRABLE;
    
CREATE SEQUENCE SEQ_qualificacoes_empresas_analiticos MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_qualificacoes_empresas_consolidado MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_qualificacoes_parametros_empresas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_qualificacoes_parametros_pontos MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;