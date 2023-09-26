-- cria réplica rep_dados_concessao_company

CREATE TABLE REP_DADOS_CONCESSAO_COMPANY (	
	ID NUMBER NOT NULL, 
	ID_CONTRATO NUMBER NOT NULL, 
	DATA_INICIO DATE NOT NULL, 
	DATA_VALIDADE DATE, 
	JUSTIFICATIVA VARCHAR2(150 CHAR) NOT NULL, 
	SITUACAO VARCHAR2(50 CHAR) NOT NULL, 
	VALOR_CONTRIBUICAO NUMBER(5,2) NOT NULL, 
	TIPO_INDICE VARCHAR2(100 CHAR) NOT NULL, 
	DATA_CRIACAO TIMESTAMP (6) NOT NULL, 
	DATA_ALTERACAO TIMESTAMP (6) NOT NULL, 
	CRIADO_POR VARCHAR2(255 CHAR), 
	MODIFICADO_POR VARCHAR2(255 CHAR), 
	DELETADO NUMBER(1,0), 
	CLASSIFICACAO_CONCESSAO VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE REP_DADOS_CONCESSAO_COMPANY ADD CONSTRAINT krs_indice_10885 PRIMARY KEY ( id );
COMMENT ON TABLE REP_DADOS_CONCESSAO_COMPANY IS 'COMPANY_DEV:SERVICE_COMPANY_DEV:DADOS_CONCESSAO:id';