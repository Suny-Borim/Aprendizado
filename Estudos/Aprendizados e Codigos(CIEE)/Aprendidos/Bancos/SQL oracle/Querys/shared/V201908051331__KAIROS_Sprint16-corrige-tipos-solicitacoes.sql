--TIPOS SOLICITAÇÕES

DELETE FROM TIPO_SOLICITACAO WHERE ID=20;
DELETE FROM TIPO_SOLICITACAO WHERE ID=21;
DELETE FROM TIPO_SOLICITACAO WHERE ID=22;

INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (20, 'Acompanhamento de estágios - RE com resposta crítica', 'carga', current_timestamp, current_timestamp, 0, 'carga');