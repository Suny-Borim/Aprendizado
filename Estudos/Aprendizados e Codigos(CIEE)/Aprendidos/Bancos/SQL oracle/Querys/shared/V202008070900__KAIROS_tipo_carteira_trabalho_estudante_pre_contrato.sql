-- Inserção do tipo de carteira de trabalho: física ou digital.
declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
begin
    execute immediate 'ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD TIPO_CARTEIRA_TRABALHO NUMBER(1)';
    exception when column_exists then null;
end;
/