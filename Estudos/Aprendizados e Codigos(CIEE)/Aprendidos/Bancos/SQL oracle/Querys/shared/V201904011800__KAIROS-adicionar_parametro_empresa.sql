INSERT INTO REP_PARAMETROS_EMPRESA (
  ID,
  DESCRICAO,
  LOCAL_PARAMETRO,
  TIPO_CONTRATO,
  TIPO_PARAMETRO,
  MSG_BACKOFFICE,
  MSG_EMPRESA,
  MSG_ESTUDANTE,
  SITUACAO,
  LOGIN,
  DELETADO,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR
  )
VALUES (
  14,
  'Gerenciar Supervisor de Estágio',
  'C',
  'E',
  'R',
  'Gerenciar Supervisores de Estagio: @gersuper@',
  'Gerenciar Supervisores de Estagio: @gersuper@',
  'Gerenciar Supervisores de Estagio: @gersuper@',
  1,
  '',
  0,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  'FLYWAY',
  'FLYWAY'
  );

  INSERT INTO REP_PARAMETROS_EMPRESA (
  ID,
  DESCRICAO,
  LOCAL_PARAMETRO,
  TIPO_CONTRATO,
  TIPO_PARAMETRO,
  MSG_BACKOFFICE,
  MSG_EMPRESA,
  MSG_ESTUDANTE,
  SITUACAO,
  LOGIN,
  DELETADO,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR
  )
VALUES (
  16,
  'Salário Mínimo Aprendiz',
  'C',
  'A',
  'R',
  'Usa Salário Mínimo @TipoSalario@ @valor@',
  'Usa Salário Mínimo @TipoSalario@ @valor@',
  'Usa Salário Mínimo @TipoSalario@ @valor@',
  1,
  '',
  0,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP,
  'FLYWAY',
  'FLYWAY'
  );

  ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD VALOR_SALARIO_MINIMO_FEDERAL NUMBER(10,2);

