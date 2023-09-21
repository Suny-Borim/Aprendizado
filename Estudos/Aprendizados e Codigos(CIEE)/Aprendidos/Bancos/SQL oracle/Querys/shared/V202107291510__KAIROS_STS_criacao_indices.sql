declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'create index KRS_INDICE_10380 on CONTRATOS_CURSOS_CAPACITACAO("ID_CONTR_EMP_EST")';
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
    execute immediate 'create index KRS_INDICE_10400 on VAGAS_ESTAGIO("CODIGO_DA_VAGA")';
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
    execute immediate 'create index KRS_INDICE_10401 on VAGAS_APRENDIZ("CODIGO_DA_VAGA")';
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
    execute immediate 'create index KRS_INDICE_10402 on PCD_APRENDIZ("ID_VAGA_APRENDIZ")';
exception
    when already_exists or columns_indexed then
        null;
end;