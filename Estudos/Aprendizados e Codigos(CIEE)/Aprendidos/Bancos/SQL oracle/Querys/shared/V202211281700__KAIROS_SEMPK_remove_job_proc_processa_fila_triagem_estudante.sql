-- REMOVER O JOB ANTIGO
DECLARE  
  EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE int :=0;
BEGIN
	Select count(*) into EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE';
	    if (EXISTE_JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE = 1) then
		   BEGIN
			    DBMS_SCHEDULER.DROP_JOB(job_name => '"SERVICE_VAGAS_DEV"."JOB_PROC_PROCESSA_FILA_TRIAGEM_ESTUDANTE"',
				                                defer => false,
				                                force => false);
				END;
        end if;	    
END;