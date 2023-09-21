/*
 ##### PK-15614: Implementar - Jovem Talento em Triagem
 ########## PK-16058: Adição coluna jovem talento as tabelas de triagem
 */

declare
    pragma autonomous_transaction;
begin
    DBMS_SCHEDULER.CREATE_JOB(
            job_name => 'SERVICE_VAGAS_DEV.JOB_ADD_COLUMN_IF_NOT_EXISTS_AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO',
            job_type => 'PLSQL_BLOCK',
            job_action => '
                            DECLARE
                                v_column_exists number := 0;
                            BEGIN

                                Select count(*) into v_column_exists
                                from USER_TAB_COLS
                                where upper(COLUMN_NAME) = ''AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO''
                                  and upper(table_name) = ''TRIAGENS_ESTUDANTES'';

                                if (v_column_exists = 0) then
                                    execute immediate ''alter table TRIAGENS_ESTUDANTES
                                                        add (AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO IDS_TYP)
                                                        NESTED TABLE AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO store as n_areas_profissionais_jt_contratado'';
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
