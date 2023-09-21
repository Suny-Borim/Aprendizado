DECLARE
    coluna_existente_vinculos_convocacao int:=0;
    coluna_existente_vinculos_encaminhamento int:=0;
    coluna_existente_vinculos_contratacao int:=0;
BEGIN
  SELECT count(*) into coluna_existente_vinculos_convocacao from all_tab_columns where table_name = 'VINCULOS_CONVOCACAO' and column_name = 'TIPO_USUARIO'; 

  if coluna_existente_vinculos_convocacao<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VINCULOS_CONVOCACAO ADD TIPO_USUARIO VARCHAR2(255 CHAR)';
  end if;
  
  SELECT count(*) into coluna_existente_vinculos_encaminhamento from all_tab_columns where table_name = 'VINCULOS_ENCAMINHAMENTO' and column_name = 'TIPO_USUARIO'; 

  if coluna_existente_vinculos_encaminhamento<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VINCULOS_ENCAMINHAMENTO ADD TIPO_USUARIO VARCHAR2(255 CHAR)';
  end if;
  
   SELECT count(*) into coluna_existente_vinculos_contratacao from all_tab_columns where table_name = 'VINCULOS_CONTRATACAO' and column_name = 'TIPO_USUARIO'; 

  if coluna_existente_vinculos_contratacao<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VINCULOS_CONTRATACAO ADD TIPO_USUARIO VARCHAR2(255 CHAR)';
  end if;
END;