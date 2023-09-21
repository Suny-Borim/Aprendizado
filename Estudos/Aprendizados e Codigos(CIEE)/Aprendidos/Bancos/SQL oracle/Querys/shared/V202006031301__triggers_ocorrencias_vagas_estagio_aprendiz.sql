CREATE OR REPLACE EDITIONABLE TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_01_OCORRENCIAS_APRENDIZ_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.OCORRENCIAS_APRENDIZ
    for each row

declare
    pragma autonomous_transaction;
begin

        DBMS_SCHEDULER.CREATE_JOB (
                job_name => 'SERVICE_VAGAS_DEV.OCORRENCIAS_APRENDIZ_' || DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
                job_type => 'PLSQL_BLOCK',
                job_action => 'BEGIN
                        BEGIN
                            SERVICE_VAGAS_DEV.PROC_ATUALIZAR_TRIAGEM_VAGA_APRENDIZ('||:new.ID_VAGA_APRENDIZ||');
                        EXCEPTION WHEN OTHERS THEN NULL;
                        END;
                    END;',
                number_of_arguments => 0,
                start_date => NULL,
                repeat_interval => NULL,
                end_date => NULL,
                enabled => TRUE,
                auto_drop => TRUE,
                comments => '');
exception when no_data_found then null;
end;
/

CREATE OR REPLACE EDITIONABLE TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_01_OCORRENCIAS_ESTAGIO_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.OCORRENCIAS_ESTAGIO
    for each row

declare
    pragma autonomous_transaction;
begin

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.OCORRENCIAS_ESTAGIO_' || DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => 'BEGIN
                        BEGIN
                            SERVICE_VAGAS_DEV.PROC_ATUALIZAR_TRIAGEM_VAGA_ESTAGIO('||:new.ID_VAGA_ESTAGIO||');
                        EXCEPTION WHEN OTHERS THEN NULL;
                        END;
                    END;',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => TRUE,
            auto_drop => TRUE,
            comments => '');
exception when no_data_found then null;
end;
/