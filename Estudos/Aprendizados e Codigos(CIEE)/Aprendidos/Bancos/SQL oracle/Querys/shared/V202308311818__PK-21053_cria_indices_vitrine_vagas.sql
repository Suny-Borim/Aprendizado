declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'CREATE INDEX KRS_INDICE_10860 ON service_vagas_dev.MV_VITRINE_VAGAS(ID_ESTADO)';
exception
    when already_exists or columns_indexed then
        null;
end;
/

declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'CREATE INDEX KRS_INDICE_10861 ON service_vagas_dev.MV_VITRINE_VAGAS(DATA_ALTERACAO)';
exception
    when already_exists or columns_indexed then
        null;
end;