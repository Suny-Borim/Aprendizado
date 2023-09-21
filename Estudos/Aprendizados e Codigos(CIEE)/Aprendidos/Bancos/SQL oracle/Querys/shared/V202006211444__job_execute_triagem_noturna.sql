declare
   job_doesnt_exist EXCEPTION;
   PRAGMA EXCEPTION_INIT( job_doesnt_exist, -27475 );
begin
    begin
        dbms_scheduler.drop_job(job_name => 'JOB_EXEC_TRIAGEM_NOTURNA');
        exception when job_doesnt_exist then
        null;
    end;

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.JOB_EXEC_TRIAGEM_NOTURNA',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                    PROC_TRIAGEM_NOTURNA_ESTUDANTE();
                    PROC_TRIAGEM_NOTURNA_ESTUDANTE_APRENDIZ();
               END;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('15-JUN-2020 11.30.28,422550000 PM AMERICA/SAO_PAULO','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
            repeat_interval => 'FREQ=DAILY',
            end_date => NULL,
            enabled => TRUE,
            comments => '');
end;


