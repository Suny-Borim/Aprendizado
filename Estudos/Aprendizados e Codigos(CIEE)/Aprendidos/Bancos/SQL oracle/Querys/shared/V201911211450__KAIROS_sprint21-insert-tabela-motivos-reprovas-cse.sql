INSERT INTO MOTIVOS_REPROVAS_CSE (
  ID,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR,
  DELETADO,
  DESCRICAO
)
VALUES (
         SEQ_MOTIVOS_REPROVAS_CSE.NEXTVAL,
         sysdate,
         sysdate,
         null,
         null,
         0,
         'Documento ilegível'
       );

INSERT INTO MOTIVOS_REPROVAS_CSE (
  ID,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR,
  DELETADO,
  DESCRICAO
)
VALUES (
         SEQ_MOTIVOS_REPROVAS_CSE.NEXTVAL,
         sysdate,
         sysdate,
         null,
         null,
         0,
         'Documento não é uma declaração de matrícula'
       );

INSERT INTO MOTIVOS_REPROVAS_CSE (
  ID,
  DATA_CRIACAO,
  DATA_ALTERACAO,
  CRIADO_POR,
  MODIFICADO_POR,
  DELETADO,
  DESCRICAO
)
VALUES (
         SEQ_MOTIVOS_REPROVAS_CSE.NEXTVAL,
         sysdate,
         sysdate,
         null,
         null,
         0,
         'Declaração escolar é de uma IE diferente da que está no cadastro do estagiário'
       );