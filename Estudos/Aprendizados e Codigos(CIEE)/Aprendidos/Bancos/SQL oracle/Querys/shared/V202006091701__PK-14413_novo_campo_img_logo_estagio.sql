--insere a columa ID_IMG_LOGO para gravar o id do documento com o logo da empresa a ser divulgado na vaga.

declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
begin
    execute immediate 'ALTER TABLE VAGAS_ESTAGIO add ID_IMG_LOGO NUMBER(20)';
    exception when column_exists then null;
end;
/