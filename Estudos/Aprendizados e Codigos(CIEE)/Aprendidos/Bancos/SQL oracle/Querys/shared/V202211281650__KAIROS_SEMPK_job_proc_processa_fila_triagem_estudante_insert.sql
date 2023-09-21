-- JOB
DECLARE  
  EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT int :=0;
BEGIN
	Select count(*) into EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT';
	    if (EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT = 0) then
		   BEGIN
                DBMS_SCHEDULER.CREATE_JOB
                (
                job_name            => 'SERVICE_VAGAS_DEV.JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT',
                job_type            => 'PLSQL_BLOCK',
                job_action          => Q'[BEGIN SERVICE_VAGAS_DEV.PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE_INSERT; END;]',
                number_of_arguments => 0,
                start_date          => SYSTIMESTAMP,
                repeat_interval     => 'FREQ=MINUTELY;INTERVAL=2;BYHOUR=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,23',
                end_date            => NULL,
                enabled             => TRUE,
                auto_drop           => FALSE,
                comments            => 'Reprocessa fila INSERTS'
                );
            END;
        end if;	    
END;