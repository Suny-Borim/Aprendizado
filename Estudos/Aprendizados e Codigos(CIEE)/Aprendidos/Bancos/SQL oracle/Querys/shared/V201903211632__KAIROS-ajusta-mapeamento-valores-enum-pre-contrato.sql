--Ajusta coluna do pré-contrato para ter o mesmo tipo da tabela de contrato

ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA
  MODIFY (TIPO_DURACAO_CURSO number(2));
