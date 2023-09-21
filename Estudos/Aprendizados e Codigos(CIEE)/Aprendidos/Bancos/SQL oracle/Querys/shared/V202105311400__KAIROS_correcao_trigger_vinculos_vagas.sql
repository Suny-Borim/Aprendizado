create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_01_VINCULOS_VAGA_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.VINCULOS_VAGA
    for each row
declare
    pragma autonomous_transaction;
    v_id_vaga NUMBER;
    v_tipo_vaga VARCHAR2(25) := 'ESTAGIO';
    V_JOB_NAME VARCHAR2(150);
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

        IF updating THEN
            V_JOB_NAME:= 'VINCULOS_VAGA_01_' || :new.CODIGO_VAGA||'_'||:NEW.ID_ESTUDANTE||'_'||:NEW.SITUACAO_VINCULO||'_'||:NEW.DELETADO||'_UPD_'|| to_char(sysdate, 'yyyymmddhh24miss');
        ELSE
            V_JOB_NAME:= 'VINCULOS_VAGA_01_' || :new.CODIGO_VAGA||'_'||:NEW.ID_ESTUDANTE||'_'||:NEW.SITUACAO_VINCULO||'_'||:NEW.DELETADO||'_INS_'|| to_char(sysdate, 'yyyymmddhh24miss');
        END IF;

        WITH t as (
            select ve.id AS ID, 'ESTAGIO' as tipo, codigo_da_vaga from vagas_estagio ve
            union all
            select va.id AS ID, 'APRENDIZ' as tipo, codigo_da_vaga from vagas_aprendiz va
        )
        select id,tipo into v_id_vaga, v_tipo_vaga from t where codigo_da_vaga = :new.codigo_vaga;


        if v_tipo_vaga = 'ESTAGIO' then
            begin
                insert /*+ APPEND */ into fila_triagem_vaga_estagio (id, ID_VAGA, DATA_CRIACAO) values (seq_fila_triagem_vaga_estagio_01.nextval, v_id_vaga, :new.DATA_CRIACAO);
                COMMIT WORK WRITE WAIT IMMEDIATE;
            exception when others then null;
            end;
        else
            begin
                insert /*+ APPEND */ into fila_triagem_vaga_aprendiz (id, ID_VAGA, DATA_CRIACAO) values (seq_fila_triagem_vaga_aprendiz_01.nextval, v_id_vaga, :new.DATA_CRIACAO);
                COMMIT WORK WRITE WAIT IMMEDIATE;
            exception when others then null;
            end;
        end if;

        begin
            proc_classificacoes_estudantes_inc_fila(:new.id_estudante, 'SEM_RETORNO_PENDENTE');
            commit work write wait immediate;
        exception when others then null;
        end;

        begin
            INSERT /*+ APPEND */ INTO fila_triagem_estudante(ID_ESTUDANTE) SELECT :new.ID_ESTUDANTE from dual;
            COMMIT WORK WRITE WAIT IMMEDIATE;
        exception when others then null;
        end;

    END IF;
exception when no_data_found then null;
end;