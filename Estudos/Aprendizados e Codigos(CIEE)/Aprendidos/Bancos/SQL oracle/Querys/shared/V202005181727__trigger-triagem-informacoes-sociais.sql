create or replace TRIGGER SERVICE_VAGAS_DEV."TRIGGER_01_REP_INFORMACOES_SOCIAIS_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.REP_INFORMACOES_SOCIAIS
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        SERVICE_VAGAS_DEV.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ID_ESTUDANTE||');
                       END;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => TRUE,
            auto_drop => TRUE,
            comments => '');
end;