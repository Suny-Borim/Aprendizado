DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'VAGAS_ESTAGIO' and column_name = 'ACEITA_EMAIL_AGENDA'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VAGAS_ESTAGIO ADD ACEITA_EMAIL_AGENDA NUMBER DEFAULT 1';
	 EXECUTE IMMEDIATE 'COMMENT ON COLUMN VAGAS_ESTAGIO.ACEITA_EMAIL_AGENDA IS ''Flag 0 ou 1 - OK''';
  end if;
END;

/

DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'VAGAS_APRENDIZ' and column_name = 'ACEITA_EMAIL_AGENDA'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VAGAS_APRENDIZ ADD ACEITA_EMAIL_AGENDA NUMBER DEFAULT 1';
	 EXECUTE IMMEDIATE 'COMMENT ON COLUMN VAGAS_APRENDIZ.ACEITA_EMAIL_AGENDA IS ''Flag 0 ou 1 - OK''';
  end if;
END;