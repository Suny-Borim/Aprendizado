DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'FORMULARIOS_TEXTOS' and column_name = 'IDENTIFICACAO'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE formularios_textos RENAME COLUMN tipo_contrato to identificacao';
     EXECUTE IMMEDIATE 'COMMENT ON COLUMN formularios_textos.identificacao IS ''Enum: 0-SUPERIOR; 1-INFERIOR;''';    
  end if;   
END;
/
DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'FORMULARIOS' and column_name = 'MODALIDADE'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE formularios add MODALIDADE NUMBER(1)';
     EXECUTE IMMEDIATE 'COMMENT ON COLUMN formularios.MODALIDADE IS ''Enum: 0-PRESENCIAL; 1-EAD;''';    
  end if;   
END;