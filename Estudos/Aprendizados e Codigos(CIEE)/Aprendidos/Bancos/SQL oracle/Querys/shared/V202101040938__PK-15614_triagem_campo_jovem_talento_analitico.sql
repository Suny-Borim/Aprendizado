/*
 ##### PK-15614: Implementar - Jovem Talento em Triagem
 ########## PK-16058: Adição coluna jovem talento as tabelas de triagem
 */

declare
    pragma autonomous_transaction;
begin
    DBMS_SCHEDULER.CREATE_JOB(
            job_name => 'SERVICE_VAGAS_DEV.JOB_ADD_COLUMN_IF_NOT_EXISTS_JOVEM_TALENTO_CONTRATADO_ANALITICO',
            job_type => 'PLSQL_BLOCK',
            job_action => '
                            DECLARE
                                v_column_exists number := 0;
                            BEGIN

                                Select count(*) into v_column_exists
                                from USER_TAB_COLS
                                where upper(COLUMN_NAME) = ''JOVEM_TALENTO_CONTRATADO''
                                  and upper(table_name) = ''TRIAGEM_CANDIDATOS_ANALITICO'';

                                if (v_column_exists = 0) then
                                    execute immediate ''alter table TRIAGEM_CANDIDATOS_ANALITICO
                                                        add (JOVEM_TALENTO_CONTRATADO NUMBER(1))'';
                                end if;

                            end;
                          ',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => TRUE,
            auto_drop => TRUE,
            comments => '');
end;
