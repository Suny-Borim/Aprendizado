DECLARE
    job_existente int:=0;
BEGIN
    SELECT count(*) into job_existente FROM ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_ATUALIZAR_MV_UNIDADES_CIEE'; 
    if job_existente<=0 then
        BEGIN
            DBMS_SCHEDULER.CREATE_JOB
            (
            job_name            => 'SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_UNIDADES_CIEE',
            job_type            => 'PLSQL_BLOCK',
            job_action          => Q'[BEGIN DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_UNIDADES_CIEE'); END;]',
            number_of_arguments => 0,
            start_date          => SYSTIMESTAMP,
            repeat_interval     => 'FREQ=HOURLY; BYMINUTE=0',
            end_date            => NULL,
            enabled             => TRUE,
            auto_drop           => FALSE,
            comments            => 'Refresh MV SERVICE_VAGAS_DEV.MV_UNIDADES_CIEE'
            );
        END;
    end if;
END;