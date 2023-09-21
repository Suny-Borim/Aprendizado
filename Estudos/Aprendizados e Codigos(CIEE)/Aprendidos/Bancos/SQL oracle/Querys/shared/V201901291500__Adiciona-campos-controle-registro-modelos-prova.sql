ALTER TABLE {{user}}.PROVAS RENAME TO MODELOS_PROVA;

DROP SEQUENCE {{user}}.SEQ_PROVAS;
CREATE SEQUENCE SEQ_MODELOS_PROVA MINVALUE 1 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE;

ALTER TABLE {{user}}.MODELOS_PROVA
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));
