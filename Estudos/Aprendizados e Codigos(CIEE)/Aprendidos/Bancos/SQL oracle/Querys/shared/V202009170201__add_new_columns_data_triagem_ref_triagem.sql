declare
    pragma autonomous_transaction;
begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.JOB_ADD_COLUMN_IF_NOT_EXISTS_DATA_TRIAGEM',
            job_type => 'PLSQL_BLOCK',
            job_action => '
                            DECLARE
                                v_column_exists number := 0;
                            BEGIN

                                Select count(*) into v_column_exists
                                from USER_TAB_COLS
                                where upper(COLUMN_NAME) = ''DATA_TRIAGEM''
                                  and upper(table_name) = ''TRIAGENS_VAGAS'';

                                if (v_column_exists = 0) then
                                    execute immediate ''alter table TRIAGENS_VAGAS add DATA_TRIAGEM DATE'';
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