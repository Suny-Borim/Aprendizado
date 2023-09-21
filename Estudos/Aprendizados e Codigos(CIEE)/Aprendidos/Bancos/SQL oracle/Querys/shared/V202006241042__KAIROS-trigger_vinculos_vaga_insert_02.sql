create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_02_VINCULOS_VAGA_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.VINCULOS_VAGA
    for each row

declare
    v_id_vaga NUMBER;
    v_tipo_vaga VARCHAR2(25) := 'ESTAGIO';

begin
    IF (
                UPPER(:NEW.CRIADO_POR) != 'TRIAGEM_NOTURNA' AND
                (
                            :NEW.CODIGO_VAGA      != :OLD.CODIGO_VAGA OR
                            :NEW.ID_ESTUDANTE     != :OLD.ID_ESTUDANTE OR
                            :NEW.SITUACAO_VINCULO != :OLD.SITUACAO_VINCULO OR
                            :NEW.DELETADO         != :OLD.DELETADO or
                            INSERTING
                    )
        )THEN
        SELECT nvl(ve.id, va.id), case when ve.id is not null then 'ESTAGIO' else 'APRENDIZ' end INTO v_id_vaga, v_tipo_vaga
        FROM VAGAS_ESTAGIO ve full join vagas_aprendiz va on va.codigo_da_vaga = ve.codigo_da_vaga WHERE ve.CODIGO_DA_VAGA = :new.codigo_vaga or va.CODIGO_DA_VAGA = :new.codigo_vaga;

        INSERT INTO fila_triagem_estudante(ID_ESTUDANTE)
        SELECT :new.ID_ESTUDANTE FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM fila_triagem_estudante t WHERE t.ID_ESTUDANTE = :new.ID_ESTUDANTE);

    END IF;
exception when no_data_found then null;
end;