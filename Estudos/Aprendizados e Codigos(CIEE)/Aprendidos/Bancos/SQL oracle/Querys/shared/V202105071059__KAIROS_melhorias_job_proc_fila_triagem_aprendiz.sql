BEGIN
    dbms_scheduler.create_job('"JOB_PROC_FILA_TRIAGEM_VAGA_APRENDIZ"',
                              job_type=>'PLSQL_BLOCK', job_action=>'BEGIN
                                            proc_processa_fila_triagem_vaga_aprendiz();
                                            EXCEPTION WHEN OTHERS THEN NULL;
                                        END;',
                              number_of_arguments=>0,
                              start_date=>TO_TIMESTAMP_TZ('14-MAY-2021 05.30.28 PM AMERICA/SAO_PAULO','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
                              repeat_interval=> 'FREQ=SECONDLY; INTERVAL=5',
                              end_date=>NULL,
                              job_class=>'"DEFAULT_JOB_CLASS"',
                              enabled=>TRUE,
                              auto_drop=>FALSE,
                              comments=>'JOB que processa a fila da triagem de vagas aprendiz'
        );
END;