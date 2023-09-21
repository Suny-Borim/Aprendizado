CREATE TABLE checklists_entrevistas_resultados (
    id                              NUMBER(20) NOT NULL,
    id_entrevista_online_resultado  NUMBER(20) NOT NULL,
    id_checklist_entrevista         NUMBER(20) NOT NULL,
    id_checklist_skill              NUMBER(20) NOT NULL,
    assinalado                      NUMBER(1) NOT NULL,
    criado_por                      VARCHAR2(255 CHAR),
    data_criacao                    TIMESTAMP,
    modificado_por                  VARCHAR2(255 CHAR),
    data_alteracao                  TIMESTAMP,
    deletado                        NUMBER(1) NOT NULL
);
COMMENT ON COLUMN checklists_entrevistas_resultados.id_checklist_skill IS
    'ID do skill na Recrutei';
COMMENT ON COLUMN checklists_entrevistas_resultados.assinalado IS
    'ENUM: 0 - Não; 1 - Sim';
ALTER TABLE checklists_entrevistas_resultados ADD CONSTRAINT krs_indice_07440 PRIMARY KEY ( id );
CREATE TABLE entrevistas_online_resultados (
    id                    NUMBER(20) NOT NULL,
    id_entrevista_online  NUMBER(20) NOT NULL,
    inicio_entrevista     TIMESTAMP NOT NULL,
    fim_entrevista        TIMESTAMP NOT NULL,
    anotacoes             VARCHAR2(255 CHAR),
    criado_por            VARCHAR2(255 CHAR),
    data_criacao          TIMESTAMP,
    modificado_por        VARCHAR2(255 CHAR),
    data_alteracao        TIMESTAMP,
    deletado              NUMBER(1) NOT NULL
);
ALTER TABLE entrevistas_online_resultados ADD CONSTRAINT krs_indice_07441 PRIMARY KEY ( id );
CREATE TABLE scorecards_entrevistas_resultados (
    id                              NUMBER(20) NOT NULL,
    id_entrevista_online_resultado  NUMBER(20) NOT NULL,
    id_scorecard_entrevista         NUMBER(20) NOT NULL,
    id_scorecard_item               NUMBER(20) NOT NULL,
    avaliacao                       NUMBER(1) NOT NULL,
    anotacoes                       VARCHAR2(255 CHAR),
    criado_por                      VARCHAR2(255 CHAR),
    data_criacao                    TIMESTAMP,
    modificado_por                  VARCHAR2(255 CHAR),
    data_alteracao                  TIMESTAMP,
    deletado                        NUMBER(1) NOT NULL
);
COMMENT ON COLUMN scorecards_entrevistas_resultados.id_scorecard_item IS
    'ID do item na Recrutei';
COMMENT ON COLUMN scorecards_entrevistas_resultados.avaliacao IS
    'ENUM: 0 - ruim; 1 - fraco; 2 - regular; 3 - bom; 4 - muito bom';
ALTER TABLE scorecards_entrevistas_resultados ADD CONSTRAINT krs_indice_07442 PRIMARY KEY ( id );
ALTER TABLE entrevistas_online_resultados
    ADD CONSTRAINT krs_indice_07443 FOREIGN KEY ( id_entrevista_online )
        REFERENCES entrevistas_online ( id )
    NOT DEFERRABLE;
ALTER TABLE checklists_entrevistas_resultados
    ADD CONSTRAINT krs_indice_07444 FOREIGN KEY ( id_entrevista_online_resultado )
        REFERENCES entrevistas_online_resultados ( id )
    NOT DEFERRABLE;
ALTER TABLE checklists_entrevistas_resultados
    ADD CONSTRAINT krs_indice_07445 FOREIGN KEY ( id_checklist_entrevista )
        REFERENCES checklists_entrevistas ( id )
    NOT DEFERRABLE;
ALTER TABLE scorecards_entrevistas_resultados
    ADD CONSTRAINT krs_indice_07446 FOREIGN KEY ( id_entrevista_online_resultado )
        REFERENCES entrevistas_online_resultados ( id )
    NOT DEFERRABLE;
ALTER TABLE scorecards_entrevistas_resultados
    ADD CONSTRAINT krs_indice_07447 FOREIGN KEY ( id_scorecard_entrevista )
        REFERENCES scorecards_entrevistas ( id )
    NOT DEFERRABLE;
CREATE SEQUENCE SEQ_checklists_entrevistas_resultados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_entrevistas_online_resultados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_scorecards_entrevistas_resultados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;