DECLARE
    mv_existente int:=0;
BEGIN
  SELECT count(*) into mv_existente FROM all_mviews where upper(mview_name) = upper('mv_unidades_ciee'); 
  if mv_existente<=0 then
     EXECUTE IMMEDIATE 'create materialized view service_vagas_dev.mv_unidades_ciee
as
select 
    rlc.id_contrato,
    rlc.id id_local_contrato,
    service_vagas_dev.retornar_unidade_ciee(rlc.id_contrato,rlc.id,0) id_unidade_ciee_est_autonomo_false,
    rucf.descricao unidade_ciee_est_autonomo_false,
    service_vagas_dev.retornar_carteira_unidade_ciee(rlc.id_contrato,rlc.id,0) id_carteira_unidade_ciee_est_autonomo_false,
    rcf.descricao carteira_unidade_ciee_est_autonomo_false,
    service_vagas_dev.retornar_unidade_ciee(rlc.id_contrato,rlc.id,1) id_unidade_ciee_est_autonomo_true,
    ruct.descricao unidade_ciee_est_autonomo_true,
    service_vagas_dev.retornar_carteira_unidade_ciee(rlc.id_contrato,rlc.id,1) id_carteira_unidade_ciee_est_autonomo_true,
    rct.descricao carteira_unidade_ciee_est_autonomo_true
from 
    service_vagas_dev.rep_locais_contrato rlc
    left join service_vagas_dev.rep_unidades_ciee rucf on rucf.id = (service_vagas_dev.retornar_unidade_ciee(rlc.id_contrato,rlc.id,0))
    left join service_vagas_dev.rep_unidades_ciee ruct on ruct.id = (service_vagas_dev.retornar_unidade_ciee(rlc.id_contrato,rlc.id,1))
    left join service_vagas_dev.rep_carteiras rcf on rcf.id = (service_vagas_dev.retornar_carteira_unidade_ciee(rlc.id_contrato,rlc.id,0))
    left join service_vagas_dev.rep_carteiras rct on rct.id = (service_vagas_dev.retornar_carteira_unidade_ciee(rlc.id_contrato,rlc.id,1))';
  end if;
END;