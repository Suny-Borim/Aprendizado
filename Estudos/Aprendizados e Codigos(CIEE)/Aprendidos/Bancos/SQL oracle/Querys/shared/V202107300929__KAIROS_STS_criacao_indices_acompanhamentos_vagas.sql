declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'create index KRS_INDICE_10420 on ACOMPANHAMENTOS_VAGAS("CODIGO_VAGA","DELETADO")';
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
    execute immediate 'create index KRS_INDICE_10421 on ACOMPANHAMENTOS_VAGAS("CODIGO_VAGA","TIPO_REGISTRO","DELETADO")';
exception
    when already_exists or columns_indexed then
        null;
end;