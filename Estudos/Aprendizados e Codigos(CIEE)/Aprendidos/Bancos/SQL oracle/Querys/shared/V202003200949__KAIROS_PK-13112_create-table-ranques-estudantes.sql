CREATE TABLE ranques_estudantes (
    id              NUMBER(20) NOT NULL,
    data_criacao    TIMESTAMP NOT NULL,
    data_alteracao  TIMESTAMP NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    modificado_por  VARCHAR2(255 CHAR),
    deletado        NUMBER(1) DEFAULT 0,
    ranque          NUMBER(2),
    menor_valor     NUMBER(10),
    maior_valor     NUMBER(10)
);
ALTER TABLE ranques_estudantes ADD CONSTRAINT krs_indice_07361 PRIMARY KEY ( id );
COMMENT ON COLUMN ranques_estudantes.ranque IS
    'Enum:
0-INICIANTE
1-INTERMEDIARIO
2-AVANCADO
3-CAMPEAO';
CREATE SEQUENCE SEQ_ranques_estudantes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;