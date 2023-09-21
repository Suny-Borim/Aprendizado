declare
    seq_exists integer;
begin
    select COUNT(*) into seq_exists from ALL_SEQUENCES where SEQUENCE_NAME = 'SEQ_AGENDA_PROCESSO_SELETIVO';
    if seq_exists = 1 then
        execute immediate 'ALTER SEQUENCE SEQ_AGENDA_PROCESSO_SELETIVO CACHE 10000';
    end if;
end;
/

declare
    seq_exists integer;
begin
    select COUNT(*) into seq_exists from ALL_SEQUENCES where SEQUENCE_NAME = 'SEQ_ETAPAS_PERIODOS';
    if seq_exists = 1 then
        execute immediate 'ALTER SEQUENCE SEQ_ETAPAS_PERIODOS CACHE 10000';
    end if;
end;
/

declare
    already_exists  exception;
    columns_indexed exception;
    pragma exception_init( already_exists, -955 );
    pragma exception_init(columns_indexed, -1408);
begin
    execute immediate 'CREATE INDEX KRS_INDICE_10300 ON TRIAGEM_CANDIDATOS_ANALITICO(CODIGO_VAGA,ID_ESTUDANTE,QUEM_TRIOU)';
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
    execute immediate 'CREATE INDEX KRS_INDICE_10283 ON ATIVIDADES_VAGAS_ESTAGIO("ID_VAGA_ESTAGIO","CODIGO_ATIVIDADE")';
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
    execute immediate 'CREATE INDEX KRS_INDICE_10284 ON REP_AREAS_ATUACAO_ATIVIDADES("CODIGO_ATIVIDADE")';
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
    execute immediate 'CREATE INDEX KRS_INDICE_10285 ON AREAS_ATUACAO_VAGAS_ESTAGIO("ID_VAGA_ESTAGIO","CODIGO_AREA_ATUACAO")';
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
    execute immediate 'CREATE INDEX KRS_INDICE_10286 ON CURSOS_VAGAS_ESTAGIO("ID_VAGA_ESTAGIO","CODIGO_CURSO")';
exception
    when already_exists or columns_indexed then
        null;
end;