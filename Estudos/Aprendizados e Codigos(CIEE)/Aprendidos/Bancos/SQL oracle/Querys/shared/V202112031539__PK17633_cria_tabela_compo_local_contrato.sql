DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'COMPONENTES_TEMPLATES_LOCAL_CONTRATO';

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE TABLE COMPONENTES_TEMPLATES_LOCAL_CONTRATO
   (
		ID 				  NUMBER(20) NOT NULL,
		ID_LOCAL_CONTRATO   NUMBER(20) NOT NULL,
		ID_COMPONENTE       NUMBER(20) NOT NULL,
		TIPO_COMPONENTE	  NUMBER(1) NOT NULL,
		DATA_CRIACAO TIMESTAMP (6),
		DATA_ALTERACAO TIMESTAMP (6),
		CRIADO_POR VARCHAR2(255 CHAR),
		MODIFICADO_POR VARCHAR2(255 CHAR),
		DELETADO NUMBER(1,0)
	)';
    EXECUTE IMMEDIATE 'ALTER TABLE COMPONENTES_TEMPLATES_LOCAL_CONTRATO ADD CONSTRAINT ID_TMP_LOCAL_CONTRATO_PK PRIMARY KEY (ID)';
  end if;
END;
/
alter table COMPONENTES_TEMPLATES_LOCAL_CONTRATO add constraints KRS_INDICE_11002 FOREIGN KEY(ID_LOCAL_CONTRATO) references REP_LOCAIS_CONTRATO(ID);

CREATE SEQUENCE SEQ_COMPONENTES_TEMPLATE_LOCAL_CONTRATO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

CREATE INDEX KRS_INDICE_11001
ON COMPONENTES_TEMPLATES_LOCAL_CONTRATO (ID_LOCAL_CONTRATO);

COMMENT ON COLUMN COMPONENTES_TEMPLATES_LOCAL_CONTRATO.TIPO_COMPONENTE IS
    'ENUM:

  0 - Cabecalho
  1 - Dados da IE
  2 - Dados da Empresa
  3 - Dados de Estudante
  4 - Dados da Unidade CIEE
  5 - Corpo
  6 - Rodape'
;