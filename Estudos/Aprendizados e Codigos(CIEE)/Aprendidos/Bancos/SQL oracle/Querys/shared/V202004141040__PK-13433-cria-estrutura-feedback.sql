CREATE TABLE tipos_feedbacks (
    id              NUMBER(20) NOT NULL,
    descricao       VARCHAR2(255 CHAR) NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    data_criacao    TIMESTAMP,
    modificado_por  VARCHAR2(255 CHAR),
    data_alteracao  TIMESTAMP,
    deletado        NUMBER(1) NOT NULL
);
ALTER TABLE tipos_feedbacks ADD CONSTRAINT krs_indice_07562 PRIMARY KEY ( id );
CREATE TABLE feedbacks_comentarios (
    id               NUMBER(20) NOT NULL,
    id_vinculo       NUMBER(20) NOT NULL,
    id_usuario       NUMBER(19) NOT NULL,
    data_comentario  TIMESTAMP NOT NULL,
    comentario       VARCHAR2(255 CHAR) NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    data_criacao     TIMESTAMP,
    modificado_por   VARCHAR2(255 CHAR),
    data_alteracao   TIMESTAMP,
    deletado         NUMBER(1) NOT NULL
);
ALTER TABLE feedbacks_comentarios ADD CONSTRAINT krs_indice_07560 PRIMARY KEY ( id );
CREATE TABLE feedbacks_vagas (
    id                NUMBER(20) NOT NULL,
    id_vinculo        NUMBER(20) NOT NULL,
    id_tipo_feedback  NUMBER(20) NOT NULL,
    pontuacao         NUMBER(20) NOT NULL,
    criado_por        VARCHAR2(255 CHAR),
    data_criacao      TIMESTAMP,
    modificado_por    VARCHAR2(255 CHAR),
    data_alteracao    TIMESTAMP,
    deletado          NUMBER(1) NOT NULL
);
ALTER TABLE feedbacks_vagas ADD CONSTRAINT krs_indice_07561 PRIMARY KEY ( id );
ALTER TABLE feedbacks_vagas
    ADD CONSTRAINT krs_indice_07563 FOREIGN KEY ( id_vinculo )
        REFERENCES vinculos_vaga ( id )
    NOT DEFERRABLE;
ALTER TABLE feedbacks_vagas
    ADD CONSTRAINT krs_indice_07564 FOREIGN KEY ( id_tipo_feedback )
        REFERENCES tipos_feedbacks ( id )
    NOT DEFERRABLE;
ALTER TABLE feedbacks_comentarios
    ADD CONSTRAINT krs_indice_07565 FOREIGN KEY ( id_vinculo )
        REFERENCES vinculos_vaga ( id )
    NOT DEFERRABLE;
ALTER TABLE feedbacks_comentarios
    ADD CONSTRAINT krs_indice_07566 FOREIGN KEY ( id_usuario )
        REFERENCES rep_usuarios ( id )
    NOT DEFERRABLE;
CREATE SEQUENCE seq_tipos_feedbacks MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE seq_feedbacks_vagas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE seq_feedbacks_comentarios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

INSERT INTO "TIPOS_FEEDBACKS" (ID, DESCRICAO, DELETADO) VALUES ('1', 'COMUNICACAO', '0');
INSERT INTO "TIPOS_FEEDBACKS" (ID, DESCRICAO, DELETADO) VALUES ('2', 'FLEXIBILIDADE', '0');
INSERT INTO "TIPOS_FEEDBACKS" (ID, DESCRICAO, DELETADO) VALUES ('3', 'ORGANIZACAO', '0');
INSERT INTO "TIPOS_FEEDBACKS" (ID, DESCRICAO, DELETADO) VALUES ('4', 'PONTUALIDADE', '0');
INSERT INTO "TIPOS_FEEDBACKS" (ID, DESCRICAO, DELETADO) VALUES ('5', 'PROATIVIDADE', '0');