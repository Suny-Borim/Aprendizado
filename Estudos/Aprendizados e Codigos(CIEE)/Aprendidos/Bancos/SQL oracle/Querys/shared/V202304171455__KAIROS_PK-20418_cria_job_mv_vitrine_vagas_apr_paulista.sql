DECLARE  
  EXISTE_JOB_ATUALIZAR_MV_VITRINE_VAGAS_APR_PAULISTA int :=0;
BEGIN
	Select count(*) into EXISTE_JOB_ATUALIZAR_MV_VITRINE_VAGAS_APR_PAULISTA
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_ATUALIZAR_MV_VITRINE_VAGAS_APR_PAULISTA';
	    if (EXISTE_JOB_ATUALIZAR_MV_VITRINE_VAGAS_APR_PAULISTA = 0) then
		   BEGIN
		        DBMS_SCHEDULER.CREATE_JOB
		        (
		        job_name            => 'SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_VITRINE_VAGAS_APR_PAULISTA',
		        job_type            => 'PLSQL_BLOCK',
		        job_action          => Q'[BEGIN DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_VITRINE_VAGAS_APR_PAULISTA'); END;]',
		        number_of_arguments => 0,
		        start_date          => SYSTIMESTAMP,
		        repeat_interval     => 'FREQ=MINUTELY;INTERVAL=10;',
		        end_date            => NULL,
		        enabled             => TRUE,
		        auto_drop           => FALSE,
		        comments            => 'Refresh MV SERVICE_VAGAS_DEV.MV_VITRINE_VAGAS_APR_PAULISTA'
		        );
			END;
  	 	 end if;	    
END;