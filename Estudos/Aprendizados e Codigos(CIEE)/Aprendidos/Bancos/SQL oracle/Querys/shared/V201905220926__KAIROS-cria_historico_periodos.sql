CREATE TABLE hist_periodos (
                               ID             NUMBER(20)    not null,
                               ID_FERIAS      NUMBER(20)    not null,
                               DATA_INICIO    TIMESTAMP(6)  not null,
                               DATA_FIM       TIMESTAMP(6)  not null,
                               DELETADO       NUMBER,
                               DATA_CRIACAO   TIMESTAMP(6)  not null,
                               DATA_ALTERACAO TIMESTAMP(6),
                               CRIADO_POR     VARCHAR2(255) not null,
                               MODIFICADO_POR VARCHAR2(255)
);

ALTER TABLE hist_periodos ADD CONSTRAINT KRS_INDICE_03434 PRIMARY KEY ( id );

ALTER TABLE hist_periodos
    ADD CONSTRAINT KRS_INDICE_03435 FOREIGN KEY ( id_ferias )
        REFERENCES HIST_FERIAS ( id );


CREATE SEQUENCE SEQ_hist_periodos MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
