CREATE OR REPLACE TRIGGER TRIGGER_01_OCORRENCIAS_ESTAGIO_INSERT_UPDATE
    after INSERT OR UPDATE on OCORRENCIAS_ESTAGIO
    for each row

declare
    pragma autonomous_transaction;
begin

    begin
        insert into fila_triagem_vaga_estagio (ID_VAGA, DATA_CRIACAO) values (:new.id_vaga_estagio, :new.DATA_CRIACAO);
    exception when others then null;
    end;

end;