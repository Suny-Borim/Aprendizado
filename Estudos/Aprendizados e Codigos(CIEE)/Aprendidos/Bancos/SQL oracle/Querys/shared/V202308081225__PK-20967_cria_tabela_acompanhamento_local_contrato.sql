DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'ACOMPANHAMENTOS_LOCAIS_CONTRATOS';

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE TABLE ACOMPANHAMENTOS_LOCAIS_CONTRATOS (
		ID				        NUMBER(20,0)      		NOT NULL,
		STATUS_ACOMPANHAMENTO   NUMBER(1,0)          	NOT NULL,
        ID_LOCAL_CONTRATO      	NUMBER(20,0)        	NOT NULL,
        ID_USUARIO      	     NUMBER(20,0)        	NOT NULL,
        TIPO_PROCESSO           NUMBER(1,0)         	NOT NULL,
        CONTATO                 VARCHAR2(255 CHAR)   	,
        DESCRICAO                 VARCHAR2(255 CHAR)   	,
        TELEFONE                VARCHAR2(255 CHAR)   	,
        DDD                     VARCHAR2(255 CHAR)   	,
        TIPO_REGISTRO           NUMBER(1,0)          	NOT NULL,
		CRIADO_POR		        VARCHAR2(255 CHAR)   	NOT NULL,
		DATA_CRIACAO	     	TIMESTAMP            	NOT NULL,
		MODIFICADO_POR		    VARCHAR2(255 CHAR)   	NOT NULL,
		DATA_ALTERACAO		    TIMESTAMP            	NOT NULL,
		DELETADO		    	NUMBER(1)            	NOT NULL)';
		EXECUTE IMMEDIATE 'ALTER TABLE ACOMPANHAMENTOS_LOCAIS_CONTRATOS ADD CONSTRAINT KRS_INDICE_12413 PRIMARY KEY ( ID )';
        end if;
END;
/
DECLARE
  SEQUENCE_EXISTENTE number := 0;
BEGIN
  select count(*) into SEQUENCE_EXISTENTE
    from ALL_SEQUENCES
    where upper(sequence_name) = 'SEQ_ACOMPANHAMENTOS_LOCAIS_CONTRATOS';
  if (SEQUENCE_EXISTENTE = 0) then
      execute immediate 'CREATE SEQUENCE SEQ_ACOMPANHAMENTOS_LOCAIS_CONTRATOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';
  end if;
end;

/
COMMENT ON COLUMN ACOMPANHAMENTOS_LOCAIS_CONTRATOS.STATUS_ACOMPANHAMENTO IS '0 - Resolvido, 1 - Em análise, 2 - Aguardando retorno do cliente, 3 - Direcionado para unidade de atendimento, 4 - Direcionado para área responsável';
COMMENT ON COLUMN ACOMPANHAMENTOS_LOCAIS_CONTRATOS.TIPO_PROCESSO IS '0 - Financeiro, 1 - Abertura de vaga, 2 - Contratação, 3 - Termo aditivo, 4 - Desligamento, 5 - Dúvidas';
COMMENT ON COLUMN ACOMPANHAMENTOS_LOCAIS_CONTRATOS.TIPO_REGISTRO IS '0 - Manual, 1 - Autómatico, 2 - Encerrado';
