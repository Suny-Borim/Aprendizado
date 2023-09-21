declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'create index KRS_INDICE_10240 on PRE_HORARIOS_CONTRATO_JORNADA("ID_CONTR_EMP_EST")';
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
    execute immediate 'create index KRS_INDICE_10260 on ETAPAS_PROCESSO_SELETIVO("ID_VAGA","ID")';
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
    execute immediate 'create index KRS_INDICE_10261 on ETAPAS_PERIODOS("DATA_INICIO","ID_ETAPA_PROCESSO_SELETIVO")';
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
    execute immediate 'create index KRS_INDICE_10262 on SITUACOES("SIGLA")';
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
    execute immediate 'create index KRS_INDICE_10263 on REP_LOCAIS_ENDERECOS("ID_UNIDADE_CIEE_LOCAL")';
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
    execute immediate 'create index KRS_INDICE_10264 on OCORRENCIAS_APRENDIZ("ID_VAGA_APRENDIZ","DELETADO")';
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
    execute immediate 'create index KRS_INDICE_10265 on ETAPAS_PERIODOS("ID_ETAPA_PROCESSO_SELETIVO")';
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
    execute immediate 'create index KRS_INDICE_10266 on PCD_ESTAGIO("ID_VAGA_ESTAGIO")';
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
    execute immediate 'create index KRS_INDICE_10267 on N_AREAS_PROFISSIONAIS_JT_CONTRATADO("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10268 on N_QUALIFICACOES_VAGAS("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10269 on N_ENDERECO_GEOHASHS_EST("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10270 on N_RECURSOS_ESTUD("NESTED_TABLE_ID","COLUMN_VALUE")';
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
    execute immediate 'create index KRS_INDICE_10271 on  TRIAGENS_VAGAS("CODIGO_AREA_PROFISSIONAL","TIPO_VAGA","POSSUI_PCD")';
exception
    when already_exists or columns_indexed then
        null;
end;