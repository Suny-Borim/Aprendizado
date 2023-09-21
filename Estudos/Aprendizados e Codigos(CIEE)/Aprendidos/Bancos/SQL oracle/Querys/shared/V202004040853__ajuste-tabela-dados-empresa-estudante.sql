-- Remove obrigatoriedade do campo estudante

ALTER TABLE dados_empresas_estudantes_secretaria MODIFY (id_estudante NULL);
