DECLARE
    coluna_existente int:=0;
BEGIN
  SELECT count(*) into coluna_existente from all_tab_columns where table_name = 'VINCULOS_VAGA' and column_name = 'ORIGEM'; 
  if coluna_existente<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE VINCULOS_VAGA ADD ORIGEM VARCHAR2(255 CHAR)';
  end if;
END;