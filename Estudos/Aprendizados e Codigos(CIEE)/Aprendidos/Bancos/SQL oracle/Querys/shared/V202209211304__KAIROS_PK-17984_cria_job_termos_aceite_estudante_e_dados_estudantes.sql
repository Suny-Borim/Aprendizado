DECLARE  
  EXISTE_JOB_ATUALIZAR_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT int :=0;
BEGIN
	Select count(*) into EXISTE_JOB_ATUALIZAR_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_ATUALIZAR_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT';
	    if (EXISTE_JOB_ATUALIZAR_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT = 0) then
		   BEGIN
		        DBMS_SCHEDULER.CREATE_JOB
		        (
		        job_name            => 'SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT',
		        job_type            => 'PLSQL_BLOCK',
		        job_action          => Q'[BEGIN DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_TERMOS_ACEITE_ESTUDANTE_STUDENT'); DBMS_MVIEW.REFRESH('SERVICE_VAGAS_DEV.MV_DADOS_ESTUDANTES_SMS_EMAIL'); END;]',
		        number_of_arguments => 0,
		        start_date          => SYSTIMESTAMP,
		        repeat_interval     => 'FREQ=HOURLY; BYMINUTE=0',
		        end_date            => NULL,
		        enabled             => TRUE,
		        auto_drop           => FALSE,
		        comments            => 'Refresh MV SERVICE_VAGAS_DEV.MV_TERMOS_ACEITE_ESTUDANTE_STUDENT and SERVICE_VAGAS_DEV.MV_DADOS_ESTUDANTES_SMS_EMAIL'
		        );
			END;
  	 	 end if;	    
END;