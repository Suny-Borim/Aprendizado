INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (24, 'Baixa do estudante do curso de capacitação', 'flyway', current_timestamp, current_timestamp, 0, 'flyway');

INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (25, 'Cancelamento da baixa do estudante do curso de capacitação', 'flyway', current_timestamp, current_timestamp, 0, 'flyway');

INSERT INTO GRUPOS_ATENDIMENTOS(DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, ID, DESCRICAO, SITUACAO, EMAIL, DELETADO, ID_TIPO_SOLICITACAO, TIPO_CONTRATO)
VALUES (current_timestamp, current_timestamp, 'flyway', 'flyway', seq_grupos_atendimentos.nextval, 'Grupo de atendimento para baixa do estudante do curso de capacitação', 1, 'teste@teste.com.br', 0, 24, 1);

INSERT INTO GRUPOS_ATENDIMENTOS(DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, ID, DESCRICAO, SITUACAO, EMAIL, DELETADO, ID_TIPO_SOLICITACAO, TIPO_CONTRATO)
VALUES (current_timestamp, current_timestamp, 'flyway', 'flyway', seq_grupos_atendimentos.nextval, 'Grupo de atendimento para cancelamento da baixa do estudante do curso de capacitação', 1, 'teste@teste.com.br', 0, 25, 1);

