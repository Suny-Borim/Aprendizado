DECLARE
    job_doesnt_exist EXCEPTION;
    PRAGMA EXCEPTION_INIT( job_doesnt_exist, -27475 );
BEGIN
    BEGIN
        dbms_scheduler.drop_job(job_name => 'JOB_ATUALIZAR_MV_VITRINE_VAGAS');
    EXCEPTION WHEN job_doesnt_exist THEN
        NULL;
    END;
    DBMS_SCHEDULER.CREATE_JOB
        (
            job_name            => 'SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_VITRINE_VAGAS',
            job_type            => 'PLSQL_BLOCK',
            job_action          => Q'[BEGIN DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_VITRINE_VAGAS'); END;]',
            number_of_arguments => 0,
            start_date          => SYSTIMESTAMP,
            repeat_interval     => 'FREQ=MINUTELY;INTERVAL=10;',
            end_date            => NULL,
            enabled             => TRUE,
            auto_drop           => FALSE,
            comments            => 'Refresh MV SERVICE_VAGAS_DEV.MV_VITRINE_VAGAS'
        );
END;