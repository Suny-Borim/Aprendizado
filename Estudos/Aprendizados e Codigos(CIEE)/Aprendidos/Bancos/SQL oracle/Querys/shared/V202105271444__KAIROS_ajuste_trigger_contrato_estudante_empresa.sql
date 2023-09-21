create or replace trigger TRIGGER_01_CONTRATOS_ESTUDANTES_EMPRESA_INSERT_UPDATE
    after update
    on CONTRATOS_ESTUDANTES_EMPRESA
    for each row
declare
    pragma autonomous_transaction;
begin
    INSERT INTO fila_triagem_estudante(ID_ESTUDANTE)
    SELECT :new.ID_ESTUDANTE FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM fila_triagem_estudante t WHERE t.ID_ESTUDANTE = :new.ID_ESTUDANTE);
    commit work write wait immediate;
end;