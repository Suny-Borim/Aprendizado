DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'IMPRESSOES_CERTIFICADOS_APRENDIZ'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE '
	     create table impressoes_certificados_aprendiz(
			id                NUMBER(20) NOT NULL,
			id_contr_est_empr NUMBER(20) NOT NULL,
			controle_impressao VARCHAR2(255 BYTE),
			cpf_estudante      VARCHAR2(11 BYTE),
			data_hora_certificado  TIMESTAMP NOT NULL,     
			data_criacao      TIMESTAMP NOT NULL,
			data_alteracao    TIMESTAMP,
			criado_por        VARCHAR2(255 BYTE),
			modificado_por    VARCHAR2(255 BYTE),
			deletado          NUMBER(1)
			)';
    EXECUTE IMMEDIATE 'ALTER TABLE impressoes_certificados_aprendiz ADD CONSTRAINT KRS_INDICE_12048 FOREIGN KEY (id_contr_est_empr) REFERENCES CONTRATOS_ESTUDANTES_EMPRESA (ID)';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_IMPRESSOES_CERTIFICADOS_APRENDIZ INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL';
  end if;
END;