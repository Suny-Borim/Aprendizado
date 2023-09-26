DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'FORMULARIOS_TEXTOS'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE TABLE FORMULARIOS_TEXTOS (
		ID				NUMBER(20,0)     NOT NULL,
        ID_FORMULARIO   NUMBER(20,0)     NOT NULL,
		TEXTO			VARCHAR2(1000 CHAR) NOT NULL,		
        TIPO_CONTRATO NUMBER(1) DEFAULT 0, 
        ORDEM               NUMBER(3),
		CRIADO_POR		    	VARCHAR2(255 CHAR) NOT NULL,
		DATA_CRIACAO		TIMESTAMP NOT NULL,
		MODIFICADO_POR		VARCHAR2(255 CHAR) NOT NULL,
		DATA_ALTERACAO		TIMESTAMP NOT NULL,
		DELETADO		    	NUMBER(1) NOT NULL)';
     	EXECUTE IMMEDIATE 'ALTER TABLE FORMULARIOS_TEXTOS ADD CONSTRAINT KRS_INDICE_12049 PRIMARY KEY ( ID )';
        EXECUTE IMMEDIATE 'ALTER TABLE FORMULARIOS_TEXTOS ADD CONSTRAINT KRS_INDICE_12050 FOREIGN KEY ( ID_FORMULARIO ) REFERENCES FORMULARIOS( ID ) NOT DEFERRABLE';
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_FORMULARIOS_TEXTOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN FORMULARIOS_TEXTOS.TIPO_CONTRATO IS ''Enum: 0-ESTAGIO; 1-APRENDIZ;''';    
  end if;
END;