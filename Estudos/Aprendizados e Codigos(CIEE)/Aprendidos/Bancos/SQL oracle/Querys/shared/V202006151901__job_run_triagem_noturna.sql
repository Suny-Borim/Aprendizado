BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'JOB_exec_triagem_noturna',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                     PROC_TRIAGEM_NOTURNA_ESTUDANTE();
               END;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('15-JUN-2020 11.30.28,422550000 PM AMERICA/SAO_PAULO','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
            repeat_interval => 'FREQ=DAILY',
            end_date => NULL,
            enabled => TRUE,
            comments => '');
END;

/