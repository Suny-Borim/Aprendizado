ALTER TABLE pre_contratos_estudantes_empresa ADD tipo_aprendiz NUMBER(1);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_aprendiz IS
    'Flag:

0 - Capacitador
1 - Empregador';
