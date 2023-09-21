DECLARE
   job_doesnt_exist EXCEPTION;
   PRAGMA EXCEPTION_INIT( job_doesnt_exist, -27475 );
BEGIN
    BEGIN
        dbms_scheduler.drop_job(job_name => 'job_proc_processa_fila_triagem_estudante');
        EXCEPTION WHEN job_doesnt_exist THEN
        NULL;
    END;
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.job_proc_processa_fila_triagem_estudante',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                    proc_processa_fila_triagem_estudante();
               END;',
            number_of_arguments => 0,
            start_date => SYSTIMESTAMP,
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=1;',
            end_date => NULL,
            enabled => TRUE,
            comments => '');
END;