--TIPOS SOLICITAÇÕES

INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (20, 'Consultar programação de férias', 'carga', current_timestamp, current_timestamp, 0, 'carga');
INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (21, 'Comunicar afastamento', 'carga', current_timestamp, current_timestamp, 0, 'carga');
INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (22, 'Acompanhamento de estágios - RE com resposta crítica', 'carga', current_timestamp, current_timestamp, 0, 'carga');

--
ALTER TABLE PERGUNTAS_TIPOS_RELATORIO MODIFY ID_PERGUNTA NUMBER(20);