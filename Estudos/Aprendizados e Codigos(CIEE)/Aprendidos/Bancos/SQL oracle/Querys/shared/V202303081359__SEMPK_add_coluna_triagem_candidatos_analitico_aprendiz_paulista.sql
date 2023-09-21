DECLARE
                                v_column_exists number := 0;
                            BEGIN

                                Select count(*) into v_column_exists
                                from USER_TAB_COLS
                                where upper(COLUMN_NAME) = 'APRENDIZ_PAULISTA'
                                  and upper(table_name) = 'TRIAGEM_CANDIDATOS_ANALITICO';

                                if (v_column_exists = 0) then
                                    execute immediate 'alter table TRIAGEM_CANDIDATOS_ANALITICO
                                                        add (APRENDIZ_PAULISTA NUMBER(1))';
                                end if;

                            end;