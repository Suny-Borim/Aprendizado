create or replace TRIGGER TRIGGER_ESCOLA_NAO_IDENTIFICADA_INSERT_UPDATE
    AFTER INSERT or update of id_escola, id_periodo_curso ON REP_ESCOLARIDADES_ESTUDANTES
    FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

    if (:new.id_escola is null or :new.id_periodo_curso is null) then
        DBMS_SCHEDULER.CREATE_JOB (
                job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
                job_type => 'PLSQL_BLOCK',
                job_action => 'BEGIN
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''MODULO_ESCOLA_NAO_IDENTIFICADA'');
                       END;',
                number_of_arguments => 0,
                start_date => NULL,
                repeat_interval => NULL,
                end_date => NULL,
                enabled => TRUE,
                auto_drop => TRUE,
                comments => '');
    end if;

    COMMIT;

END;
/