ALTER TABLE tipo_presencial ADD TIPO_TELEFONE NUMBER(1);  

COMMENT ON COLUMN tipo_presencial.TIPO_TELEFONE IS
  'Enum:

  0 - Celular
  1 - Fixo';