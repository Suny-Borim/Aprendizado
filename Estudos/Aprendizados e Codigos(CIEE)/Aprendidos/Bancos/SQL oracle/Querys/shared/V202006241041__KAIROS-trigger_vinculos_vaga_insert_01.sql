create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_01_VINCULOS_VAGA_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.VINCULOS_VAGA
    for each row

declare
    pragma autonomous_transaction;
    v_id_vaga NUMBER;
    v_tipo_vaga VARCHAR2(25) := 'ESTAGIO';

begin
    IF (
                UPPER(:NEW.CRIADO_POR) != 'TRIAGEM_NOTURNA'

            AND
                (
                            :NEW.CODIGO_VAGA      != :OLD.CODIGO_VAGA OR
                            :NEW.ID_ESTUDANTE     != :OLD.ID_ESTUDANTE OR
                            :NEW.SITUACAO_VINCULO != :OLD.SITUACAO_VINCULO OR
                            :NEW.DELETADO         != :OLD.DELETADO OR
                            INSERTING
                    )
        )THEN
        SELECT nvl(ve.id, va.id), case when ve.id is not null then 'ESTAGIO' else 'APRENDIZ' end INTO v_id_vaga, v_tipo_vaga
        FROM VAGAS_ESTAGIO ve full join vagas_aprendiz va on va.codigo_da_vaga = ve.codigo_da_vaga WHERE ve.CODIGO_DA_VAGA = :new.codigo_vaga or va.CODIGO_DA_VAGA = :new.codigo_vaga;

        DBMS_SCHEDULER.CREATE_JOB (
                job_name => 'SERVICE_VAGAS_DEV.VINCULOS_VAGA_01_' || DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
                job_type => 'PLSQL_BLOCK',
                job_action => 'BEGIN
                        BEGIN
                            SERVICE_VAGAS_DEV.PROC_ATUALIZAR_TRIAGEM_VAGA_'||v_tipo_vaga||'('||v_id_vaga||');
                        EXCEPTION WHEN OTHERS THEN NULL;
                        END;
                        BEGIN
                            SERVICE_VAGAS_DEV.PROC_ATUALIZAR_TRIAGEM_ESTUDANTE('||:new.id_estudante||');
                        EXCEPTION WHEN OTHERS THEN NULL;
                        END;
                        BEGIN
                            SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''SEM_RETORNO_PENDENTE'');
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
    END IF;
exception when no_data_found then null;
end;