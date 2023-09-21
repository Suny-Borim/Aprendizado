

declare
    column_exists exception;
    pragma exception_init (column_exists , -01430);
begin
    execute immediate 'ALTER TABLE TEMPLATE_UNIDADES_CIEE ADD SISTEMA_PAGAMENTO NUMBER(1,0)';
    exception when column_exists then null;
end;
/

update TEMPLATE_UNIDADES_CIEE set SISTEMA_PAGAMENTO = 0 where tipo_template = 0;