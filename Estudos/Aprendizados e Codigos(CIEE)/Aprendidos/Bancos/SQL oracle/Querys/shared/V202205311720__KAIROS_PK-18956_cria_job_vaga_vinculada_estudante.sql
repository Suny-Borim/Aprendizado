-- Create OR drop JOB
DECLARE
  JOB_EXISTENTE number := 0;
BEGIN
  Select count(*) into JOB_EXISTENTE
    from ALL_SCHEDULER_JOBS where upper(JOB_NAME) = 'JOB_ATUALIZAR_MV_VAGAS_VINCULADAS_ESTUDANTE';
    if (JOB_EXISTENTE = 0) then
      execute immediate 'BEGIN
        DBMS_SCHEDULER.CREATE_JOB
        (
        job_name            => ''SERVICE_VAGAS_DEV.JOB_ATUALIZAR_MV_VAGAS_VINCULADAS_ESTUDANTE'',
        job_type            => ''PLSQL_BLOCK'',
        job_action          => Q''[BEGIN DBMS_MVIEW.REFRESH(''SERVICE_VAGAS_DEV.MV_VAGAS_VINCULADAS_ESTUDANTE''); END;]'',
        number_of_arguments => 0,
        start_date          => SYSTIMESTAMP,
        repeat_interval     => ''FREQ=MINUTELY;INTERVAL=10;'',
        end_date            => NULL,
        enabled             => TRUE,
        auto_drop           => FALSE,
        comments            => ''Refresh MV SERVICE_VAGAS_DEV.MV_VAGAS_VINCULADAS_ESTUDANTE''
        );
		END;';    
  end if;
end;
