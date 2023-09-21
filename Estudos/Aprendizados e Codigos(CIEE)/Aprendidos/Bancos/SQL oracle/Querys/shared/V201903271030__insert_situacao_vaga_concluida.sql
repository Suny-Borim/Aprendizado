
INSERT INTO SITUACOES (
  ID,
  SIGLA,
  DESCRICAO,
  DELETADO,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR
)
VALUES (
         SEQ_SITUACOES.nextval,
         'C',
         'Concluída',
         0,
         TO_TIMESTAMP('2019-03-27 10:29:12.299000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
         TO_TIMESTAMP('2019-03-27 10:29:14.361000', 'YYYY-MM-DD HH24:MI:SS.FF6'),
         'carga',
         'carga'
       );