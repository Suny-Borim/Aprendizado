declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'create index KRS_INDICE_10700 on N_ACESSIBILIDADE_VAGAS("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10701 on N_ESCOLAS_VAGAS("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10702 on N_ESTADOCIVIL_VAGAS("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10703 on N_CAPACITACAOGEOHASHS_VAGAS("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10704 on TRIAGENS_VAGAS("IDADE_MINIMA","IDADE_MAXIMA")';
exception
    when already_exists or columns_indexed then
        null;
end;