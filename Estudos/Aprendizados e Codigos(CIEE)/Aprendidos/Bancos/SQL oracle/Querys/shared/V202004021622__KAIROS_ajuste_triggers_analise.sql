create or replace TRIGGER TRIGGER_ANALISE_COMPORTAMENTAL_INSERT_UPDATE
AFTER INSERT or UPDATE ON AVALIACOES_COMPORTAMENTAIS_STATUS
FOR EACH ROW
 declare
  pragma autonomous_transaction;
BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_ANALISE'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''ANALISE_COMPORTAMENTAL'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
   
END;
/

create or replace TRIGGER TRIGGER_REDACAO_ESTUDANTE_INSERT_UPDATE
AFTER INSERT or UPDATE ON REP_REDACOES_STUDENT
FOR EACH ROW
declare
  pragma autonomous_transaction;
BEGIN
   
    DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_REDACAO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''REDACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
		
   
END;
/