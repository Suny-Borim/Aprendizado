DECLARE
    indice_existente int:=0;
BEGIN
  SELECT count(*) into indice_existente FROM all_indexes where index_name = 'KRS_INDICE_11326'; 
  if indice_existente<=0 then
     EXECUTE IMMEDIATE 'create index SERVICE_VAGAS_DEV.KRS_INDICE_11326 on SERVICE_VAGAS_DEV.REP_CONFIGURACAO_CONTRATOS("ID_CONTRATO")';
  end if;
END;

/

DECLARE
    indice_existente int:=0;
BEGIN
  SELECT count(*) into indice_existente FROM all_indexes where index_name = 'KRS_INDICE_11329'; 
  if indice_existente<=0 then
     EXECUTE IMMEDIATE 'create index SERVICE_VAGAS_DEV.KRS_INDICE_11329 on SERVICE_VAGAS_DEV.REP_CEPS_CORE("CODIGO_CEP","COD_MUNICIPIO_IBGE")';
  end if;
END;

/

DECLARE
    indice_existente int:=0;
BEGIN
  SELECT count(*) into indice_existente FROM all_indexes where index_name = 'KRS_INDICE_11330'; 
  if indice_existente<=0 then
     EXECUTE IMMEDIATE 'create index SERVICE_VAGAS_DEV.KRS_INDICE_11330 on SERVICE_VAGAS_DEV.REP_MAP_CARTEIRAS_TERRITORIOS("CODIGO_MUNICIPIO")';
  end if;
END;

/

DECLARE
    indice_existente int:=0;
BEGIN
  SELECT count(*) into indice_existente FROM all_indexes where index_name = 'KRS_INDICE_11331'; 
  if indice_existente<=0 then
     EXECUTE IMMEDIATE 'create index SERVICE_VAGAS_DEV.KRS_INDICE_11331 on SERVICE_VAGAS_DEV.REP_CIEES_CARTEIRAS_TERRITORIOS_UNIT("CEP")';
  end if;
END;