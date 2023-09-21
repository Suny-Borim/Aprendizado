declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'create index KRS_INDICE_10323 on AGENDA_PROCESSO_SELETIVO("ID_ETAPA_PROCESSO_SELETIVO","ID")';
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
    execute immediate 'create index KRS_INDICE_10324 on RESULTADOS_PROCESSO_SELETIVO("SITUACAO","ID_ESTUDANTE_AGENDA")';
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
    execute immediate 'create index KRS_INDICE_10325 on RESULTADOS_PROCESSO_SELETIVO("SITUACAO","DELETADO","ID_ESTUDANTE_AGENDA")';
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
    execute immediate 'create index KRS_INDICE_10326 on VINCULOS_VAGA("SITUACAO_VINCULO","ID")';
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
    execute immediate 'create index KRS_INDICE_10327 on ETAPAS_PROCESSO_SELETIVO("ID_VAGA","DELETADO")';
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
    execute immediate 'create index KRS_INDICE_10328 on ESTUDANTES_AGENDA("ID_AGENDA_PROCESSO_SELETIVO")';
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
    execute immediate 'create index KRS_INDICE_10360 on PRE_AREAS_ATUACAO_CONTR_EMP_EST("ID_CONTR_EMP_EST")';
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
    execute immediate 'create index KRS_INDICE_10361 on PRE_ATIVIDADES_CONTR_EMP_EST("ID_CONTR_EMP_EST")';
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
    execute immediate 'create index KRS_INDICE_10364 on SUPERVISORES("ID_CONTRATO","ATIVO")';
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
    execute immediate 'create index KRS_INDICE_10365 on CONTRATOS_ESTUDANTES_EMPRESA("ID_SUPERVISOR")';
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
    execute immediate 'create index KRS_INDICE_10366 on CONTRATOS_ESTUDANTES_EMPRESA("ID_LOCAL_CONTRATO","PCD")';
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
    execute immediate 'create index KRS_INDICE_10367 on REP_LOCAIS_CONTRATO("ID_CONTRATO","CONTRATACAO_JOVEM_TALENTO")';
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
    execute immediate 'create index KRS_INDICE_10368 on CONTRATOS_ESTUDANTES_EMPRESA("ID_LOCAL_CONTRATO")';
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
    execute immediate 'create index KRS_INDICE_10369 on REP_MAP_CARTEIRAS_TERRITORIOS("CEP","ID_UNIDADE_CIEE")';
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
    execute immediate 'create index KRS_INDICE_10370 on TEMPLATE_EMPRESA("ID_EMPRESA","ID_CONTRATO")';
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
    execute immediate 'create index KRS_INDICE_10371 on COMPONENTES_TEMPLATES_EMPRESA("ID_TEMPLATE_EMPRESA")';
exception
    when already_exists or columns_indexed then
        null;
end;