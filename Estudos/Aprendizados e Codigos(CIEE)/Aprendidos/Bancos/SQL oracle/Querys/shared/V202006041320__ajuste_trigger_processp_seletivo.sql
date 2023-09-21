create or replace TRIGGER TRIGGER_RESULTADOS_PROCESSO_SELETIVO_INSERT_UPDATE
AFTER INSERT or update ON RESULTADOS_PROCESSO_SELETIVO
FOR EACH ROW
DECLARE
	pragma autonomous_transaction;
    estudante_id number := 0;
BEGIN

  select v.id_estudante  INTO estudante_id from ESTUDANTES_AGENDA ea
  inner join VINCULOS_VAGA v on (v.id = ea.id_vinculo_vaga)
  where ea.id = :NEW.id_estudante_agenda
  group by v.id_estudante;
  
  IF (estudante_id > 0) THEN
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_FALTA'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||estudante_id||', ''FALTA_INJUSTIFICADA_ETAPA'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
		
  END IF;
exception when no_data_found then null;

END;