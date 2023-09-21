DECLARE
    coluna_existente_token_documento int:=0;    

BEGIN
  SELECT count(*) into coluna_existente_token_documento from all_tab_columns where table_name = 'DOCUMENTOS_SOLICITACOES_SERVICENOW' and column_name = 'TOKEN_DOCUMENTO'; 

  if coluna_existente_token_documento<=0 then
     EXECUTE IMMEDIATE 'alter table DOCUMENTOS_SOLICITACOES_SERVICENOW ADD TOKEN_DOCUMENTO VARCHAR2(255 CHAR)';
  end if; 
END;