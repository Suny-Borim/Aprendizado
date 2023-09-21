-- Inserção de campo de dígito da conta
declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
begin
    execute immediate 'ALTER TABLE REP_DEPENDENTES_STUDENT ADD DIGITO_CONTA VARCHAR2(2 CHAR)';
    exception when column_exists then null;
end;
/