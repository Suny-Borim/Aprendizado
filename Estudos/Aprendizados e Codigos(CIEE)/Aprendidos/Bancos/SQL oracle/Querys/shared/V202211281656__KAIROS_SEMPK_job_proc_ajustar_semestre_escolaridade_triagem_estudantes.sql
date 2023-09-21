-- JOB Proc que remove e re-insere o estudante da Triagens Estudantes
DECLARE  
  EXISTE_JOB_PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES int :=0;
BEGIN
	Select count(*) into EXISTE_JOB_PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES';
	    if (EXISTE_JOB_PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES = 0) then
		   BEGIN
		        DBMS_SCHEDULER.CREATE_JOB
		        (
		        job_name            => 'SERVICE_VAGAS_DEV.JOB_PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES',
		        job_type            => 'PLSQL_BLOCK',
		        job_action          => Q'[BEGIN SERVICE_VAGAS_DEV.PROC_AJUSTAR_SEMESTRE_ESCOLARIDADE_TRIAGEM_ESTUDANTES; END;]',
		        number_of_arguments => 0,
		        start_date          => SYSTIMESTAMP,
		        repeat_interval     => 'FREQ=DAILY;BYHOUR=04,16',
		        end_date            => NULL,
		        enabled             => TRUE,
		        auto_drop           => FALSE,
		        comments            => 'Reprocessa Estudantes com diferenças entre a escolaridade e a triagens estudantes'
		        );
			END;
        end if;	    
END;