DECLARE
    indice_existente int:=0;
BEGIN
  SELECT count(*) into indice_existente FROM all_indexes where index_name = 'KRS_INDICE_11449'; 
  if indice_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11449 ON SERVICE_VAGAS_DEV.MV_VAGAS_VINCULADAS_ESTUDANTE ( ID_ESTUDANTE,OCORRENCIAS,SITUACAO_VINCULO )';
  end if;
END; 