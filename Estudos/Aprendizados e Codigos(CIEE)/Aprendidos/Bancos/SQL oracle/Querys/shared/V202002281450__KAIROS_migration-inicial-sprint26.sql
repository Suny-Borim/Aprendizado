--Service_Vagas
--PK-12683 - Baixar pendência de vias do TCE e TA de estágio - Manual
--PK-12684 - Gerenciar irregularidades de Retorno Simpress
alter table contratos_estudantes_empresa add data_baixa timestamp;
alter table hist_contratos_estudantes_empresa add data_baixa timestamp;
COMMENT ON COLUMN contratos_estudantes_empresa.situacao IS
    'Eum:
0-Efetivado
1-Encerrado
2-Cancelado
3-Preenchido
4-Manual
5-Emitido';
COMMENT ON COLUMN hist_contratos_estudantes_empresa.situacao IS
    'Eum:
0-Efetivado
1-Encerrado
2-Cancelado
3-Preenchido
4-Manual
5-Emitido';
--
CREATE TABLE retornos_simpress (
                                   id                    NUMBER(20) NOT NULL,
                                   movimento             VARCHAR2(60 CHAR),
                                   movimento_ddmmaaaa    TIMESTAMP,
                                   motivo                VARCHAR2(100 CHAR),
                                   tipo                  NUMBER(1),
                                   numero_tce_ta         NUMBER(20),
                                   seq_ta                NUMBER(20),
                                   numero_tce_ta_atual   NUMBER(20),
                                   seq_ta_atual          NUMBER(20),
                                   situacao              NUMBER(1),
                                   data_criacao          TIMESTAMP NOT NULL,
                                   data_alteracao        TIMESTAMP NOT NULL,
                                   criado_por            VARCHAR2(255 CHAR),
                                   modificado_por        VARCHAR2(255 CHAR),
                                   deletado              NUMBER(1) DEFAULT 0
);
COMMENT ON COLUMN retornos_simpress.movimento IS
    'conforme o nome do Arquivo';
COMMENT ON COLUMN retornos_simpress.movimento_ddmmaaaa IS
    'conforme o nome do Arquivo';
COMMENT ON COLUMN retornos_simpress.tipo IS
    'ENUM:
0-TCE
1-TA';
COMMENT ON COLUMN retornos_simpress.seq_ta IS
    'Se tipo TA ou TA_ALTERACAO';
COMMENT ON COLUMN retornos_simpress.situacao IS
    'ENUM:
0-Pendente
1-Liberado sem baixa
2-Liberado
3-Alterado';
ALTER TABLE retornos_simpress ADD CONSTRAINT krs_indice_07220 PRIMARY KEY ( id );
CREATE SEQUENCE SEQ_retornos_impress MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;