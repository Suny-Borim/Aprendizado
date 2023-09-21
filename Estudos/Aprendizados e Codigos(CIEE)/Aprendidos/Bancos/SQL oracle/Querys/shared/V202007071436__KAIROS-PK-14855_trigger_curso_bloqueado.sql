create or replace TRIGGER TRIGGER_REP_CAMPUS_CURSO_BLOQUEADO_INSERT_UPDATE
    AFTER INSERT or update of bloqueado ON REP_CAMPUS_CURSOS
    FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN
        DBMS_SCHEDULER.CREATE_JOB (
                job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
                job_type => 'PLSQL_BLOCK',
                job_action => 'BEGIN
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''MODULO_CAMPUS_INATIVO'');
                       END;',
                number_of_arguments => 0,
                start_date => NULL,
                repeat_interval => NULL,
                end_date => NULL,
                enabled => TRUE,
                auto_drop => TRUE,
                comments => '');
END;
