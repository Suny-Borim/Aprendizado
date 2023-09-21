create materialized view service_vagas_dev.mv_vagas_estagio_ie
build immediate 
as
select 
    vagas_ie.id_ie, 
    vagas_ie.id_campus , 
    vagas_ie.codigo_curso, 
    vagas_ie.id_vaga_estagio, 
    vagas_ie.codigo_da_vaga, 
    vagas_ie.codigo_area_profissional, 
    vagas_ie.id_local_contrato,
    vagas_ie.distancia 
from (
        select 
            ie.id as id_ie, 
            ca.id as id_campus , 
            cve.codigo_curso as codigo_curso, 
            ve.id as id_vaga_estagio, 
            ve.codigo_da_vaga, 
            ve.codigo_area_profissional, 
            ve.id_local_contrato,
            SDO_GEOM.SDO_DISTANCE(re.geo_point, ree.geo_point, 0.005, 'unit=km') as distancia
        from 
            service_vagas_dev.vagas_estagio ve 
            inner join service_vagas_dev.situacoes sit on sit.id = ve.id_situacao_vaga
            inner join service_vagas_dev.cursos_vagas_estagio cve on cve.id_vaga_estagio = ve.id
            inner join service_vagas_dev.rep_locais_enderecos rle on rle.id_local_contrato = ve.id_local_contrato and rle.endereco_principal = 1
            inner join service_vagas_dev.rep_enderecos re on re.id = rle.id_endereco
            inner join service_vagas_dev.rep_campus_cursos cac on cac.id_curso = cve.codigo_curso
            inner join service_vagas_dev.rep_campus ca on ca.id = cac.id_campus
            inner join service_vagas_dev.rep_enderecos_escolas ree on ree.id = ca.id_endereco
            inner join service_vagas_dev.rep_instituicoes_ensinos ie on ca.id_instituicao_ensino = ie.id
        where 
            sit.sigla in ('A','B') 
        and ve.contratacao_direta = 0 
        and re.latitude is not null 
        and re.longitude is not null
     ) vagas_ie 
where vagas_ie.distancia <= 20;



-- Create Update JOB
BEGIN
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name            => 'SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_VAGAS_ESTAGIO_IE',
        job_type            => 'PLSQL_BLOCK',
        job_action          => Q'[BEGIN DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_VAGAS_ESTAGIO_IE'); END;]',
        number_of_arguments => 0,
        start_date          => SYSTIMESTAMP,
        repeat_interval     => 'FREQ=HOURLY; BYMINUTE=0',
        end_date            => NULL,
        enabled             => TRUE,
        auto_drop           => FALSE,
        comments            => 'Refresh MV SERVICE_VAGAS_DEV.MV_VAGAS_ESTAGIO_IE'
        );
END;
/