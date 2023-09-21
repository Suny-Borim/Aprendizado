BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.JOB_MANUTENCAO_fila_triagem_estudante',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                    alter table fila_triagem_estudante shrink space;
                    exec dbms_stats.gather_table_stats(null, ''fila_triagem_estudante'', estimate_percent => dbms_stats.auto_sample_size);
               END;',
            number_of_arguments => 0,
            start_date => '28-05-2020 22:00:00',
            repeat_interval => 'FREQ=DAILY',
            end_date => NULL,
            enabled => TRUE,
            comments => '');
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.job_proc_processa_fila_triagem_estudante',
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                    proc_processa_fila_triagem_estudante()
               END;',
            number_of_arguments => 0,
            start_date => '28-05-2020 18:00:00',
            repeat_interval => 'FREQ=MINUTELY;INTERVAL=1;',
            end_date => NULL,
            enabled => TRUE,
            comments => '');
END;
/
