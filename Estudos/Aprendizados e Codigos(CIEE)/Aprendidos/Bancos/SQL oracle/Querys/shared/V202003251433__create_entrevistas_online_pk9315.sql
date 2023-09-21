CREATE TABLE checklists_entrevistas (
    id              NUMBER(20) NOT NULL,
    id_checklist    NUMBER(20) NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    data_criacao    TIMESTAMP,
    modificado_por  VARCHAR2(255 CHAR),
    data_alteracao  TIMESTAMP,
    deletado        NUMBER(1) NOT NULL
);
COMMENT ON COLUMN checklists_entrevistas.id_checklist IS
    'ID do checklist na Recrutei';
ALTER TABLE checklists_entrevistas ADD CONSTRAINT krs_indice_07400 PRIMARY KEY ( id );
CREATE TABLE entrevistas_online (
    id                           NUMBER(20) NOT NULL,
    id_estudante                 NUMBER NOT NULL,
    link_estudante               VARCHAR2(255 CHAR) NOT NULL,
    codigo_da_vaga               NUMBER(20) NOT NULL,
    id_vinculo_vaga              NUMBER(20) NOT NULL,
    id_agenda_processo_seletivo  NUMBER(20) NOT NULL,
    id_usuario                   NUMBER(19) NOT NULL,
    link_usuario_responsavel     VARCHAR2(255 CHAR) NOT NULL,
    id_scorecard_entrevista      NUMBER(20) NOT NULL,
    id_checklist_entrevista      NUMBER(20) NOT NULL,
    id_entrevista                NUMBER(20) NOT NULL,
    data_agendada                TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255 CHAR),
    data_criacao                 TIMESTAMP,
    modificado_por               VARCHAR2(255 CHAR),
    data_alteracao               TIMESTAMP,
    deletado                     NUMBER(1) NOT NULL
);
COMMENT ON COLUMN entrevistas_online.id_entrevista IS
    'ID da entrevista na Recrutei';
ALTER TABLE entrevistas_online ADD CONSTRAINT krs_indice_07401 PRIMARY KEY ( id );
CREATE TABLE scorecards_entrevistas (
    id              NUMBER(20) NOT NULL,
    id_scorecard    NUMBER(20) NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    data_criacao    TIMESTAMP,
    modificado_por  VARCHAR2(255 CHAR),
    data_alteracao  TIMESTAMP,
    deletado        NUMBER(1) NOT NULL
);
COMMENT ON COLUMN scorecards_entrevistas.id_scorecard IS
    'ID do scorecard na Recrutei';
ALTER TABLE scorecards_entrevistas ADD CONSTRAINT krs_indice_07402 PRIMARY KEY ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07403 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07404 FOREIGN KEY ( id_vinculo_vaga )
        REFERENCES vinculos_vaga ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07405 FOREIGN KEY ( id_agenda_processo_seletivo )
        REFERENCES agenda_processo_seletivo ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07406 FOREIGN KEY ( id_usuario )
        REFERENCES rep_usuarios ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07407 FOREIGN KEY ( id_scorecard_entrevista )
        REFERENCES scorecards_entrevistas ( id );
ALTER TABLE entrevistas_online
    ADD CONSTRAINT krs_indice_07408 FOREIGN KEY ( id_checklist_entrevista )
        REFERENCES checklists_entrevistas ( id );
CREATE SEQUENCE SEQ_checklists_entrevistas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_entrevistas_online MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_scorecards_entrevistas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

INSERT INTO CHECKLISTS_ENTREVISTAS (ID, ID_CHECKLIST, CRIADO_POR, DATA_CRIACAO, DELETADO) VALUES ('1', '9', 'vitor.oyama@ciee.org.br', TO_TIMESTAMP('2020-03-25 14:43:10.180000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '0');
INSERT INTO SCORECARDS_ENTREVISTAS (ID, ID_SCORECARD, CRIADO_POR, DATA_CRIACAO, DELETADO) VALUES ('1', '8', 'vitor.oyama@ciee.org.br', TO_TIMESTAMP('2020-03-25 14:43:10.180000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '0');
