create or replace TRIGGER {{user}}."TRIGGER_01_REP_LAUDOS_MEDICOS_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_LAUDOS_MEDICOS
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ESTUDANTE_ID||');
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

create or replace TRIGGER {{user}}."TRIGGER_01_REP_RECURSOS_ACESSIBILIDADE_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_RECURSOS_ACESSIBILIDADE
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ESTUDANTE_ID||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_REP_LAUDOS_MEDICOS_DOCUMENTOS_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_LAUDOS_MEDICOS_DOCUMENTOS
    for each row

declare
    pragma autonomous_transaction;
    v_id int;
begin

    select estudante_id into v_id
    from REP_LAUDOS_MEDICOS
    where id = :new.laudo_medico_id;

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||v_id||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_REP_INFORMACOES_ADICIONAIS_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_INFORMACOES_ADICIONAIS
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.id||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_REP_IDIOMAS_NIVEIS_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_IDIOMAS_NIVEIS
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ESTUDANTE_ID||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_REP_ESCOLARIDADES_ESTUDANTES_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_ESCOLARIDADES_ESTUDANTES
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ID_ESTUDANTE||');
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

create or replace TRIGGER {{user}}."TRIGGER_01_REP_ENDERECOS_ESTUDANTES_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_ENDERECOS_ESTUDANTES
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.id_estudante||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_REP_CONHECIMENTOS_INFORMATICA_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.REP_CONHECIMENTOS_INFORMATICA
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ID_ESTUDANTE||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_QUALIFICACOES_ESTUDANTE_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.QUALIFICACOES_ESTUDANTE
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ID_ESTUDANTE||');
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


create or replace TRIGGER {{user}}."TRIGGER_01_CONTRATOS_ESTUDANTES_EMPRESA_INSERT_UPDATE"
    after INSERT OR UPDATE on {{user}}.CONTRATOS_ESTUDANTES_EMPRESA
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => '{{user}}.REP_ESTUDANTES_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        {{user}}.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.ID_ESTUDANTE||');
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

