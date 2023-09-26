DECLARE
    tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'NOTIFICACAO_PENDENCIA_4VIA';

if tabela_existente<=0 then
     EXECUTE IMMEDIATE '	
    create table NOTIFICACAO_PENDENCIA_4VIA (
        ID                  NUMBER(20,0) NOT NULL,
        ID_CONTR_EST_EMPR   NUMBER(20,0) NOT NULL,
        ID_USUARIO          NUMBER(20,0) NOT NULL,
        EMAIL_ENVIO		    VARCHAR2(255 CHAR) NOT NULL,
        TIPO_NOTIFICACAO    VARCHAR2(255 CHAR) NOT NULL,
        TIPO_PENDENCIA		VARCHAR2(255 CHAR) NOT NULL,
        CRIADO_POR		    VARCHAR2(255 CHAR) NOT NULL,
        DATA_CRIACAO		TIMESTAMP NOT NULL,
        MODIFICADO_POR		VARCHAR2(255 CHAR),
        DATA_ALTERACAO		TIMESTAMP,
        DELETADO		    NUMBER(1) NOT NULL
    )';
    EXECUTE IMMEDIATE 'ALTER TABLE NOTIFICACAO_PENDENCIA_4VIA ADD CONSTRAINT KRS_INDICE_11628 PRIMARY KEY ( ID )';
    EXECUTE IMMEDIATE 'ALTER TABLE NOTIFICACAO_PENDENCIA_4VIA ADD CONSTRAINT KRS_INDICE_11629 FOREIGN KEY ( ID_CONTR_EST_EMPR ) REFERENCES CONTRATOS_ESTUDANTES_EMPRESA( ID ) NOT DEFERRABLE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_NOTIFICACAO_PENDENCIA_4VIA  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';
  end if;
END;