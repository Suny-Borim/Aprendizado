create or replace TRIGGER {{user}}."TRIGGER_01_REP_INFORMACOES_ADICIONAIS_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_INFORMACOES_ADICIONAIS
    for each row

declare
    pragma autonomous_transaction;
    v_id_estudante number;

begin
    select id into v_id_estudante from rep_estudantes where id_informacoes_adicionais = :new.id;

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||v_id_estudante||');
                       END;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => TRUE,
            auto_drop => TRUE,
            comments => '');
end;
/