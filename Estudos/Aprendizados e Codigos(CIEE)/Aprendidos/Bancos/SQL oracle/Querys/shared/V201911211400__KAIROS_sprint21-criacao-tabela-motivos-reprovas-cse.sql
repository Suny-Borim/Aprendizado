ALTER TABLE CSE DROP COLUMN motivo_reprova;
CREATE TABLE motivos_reprovas_cse (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0,
    descricao        VARCHAR2(250 CHAR)
);

ALTER TABLE motivos_reprovas_cse ADD CONSTRAINT krs_indice_06602 PRIMARY KEY ( id );
--
ALTER TABLE CSE ADD id_motivo_reprova_cse NUMBER(20);
--
ALTER TABLE cse
    ADD CONSTRAINT krs_indice_06603 FOREIGN KEY ( id_motivo_reprova_cse )
        REFERENCES motivos_reprovas_cse ( id );

CREATE SEQUENCE SEQ_MOTIVOS_REPROVAS_CSE MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;        