ALTER TABLE SOLICITACOES_SERVICENOW MODIFY ID_CONTR_EMP_EST null;

INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (27, 'Solicitar de Novos Locais de Curso de Capacitação', 'flyway', current_timestamp, current_timestamp, 0, 'flyway');

INSERT INTO GRUPOS_ATENDIMENTOS(DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, ID, DESCRICAO, SITUACAO, EMAIL, DELETADO, ID_TIPO_SOLICITACAO, TIPO_CONTRATO)
VALUES (current_timestamp, current_timestamp, 'flyway', 'flyway', seq_grupos_atendimentos.nextval, 'Grupo de atendimento para solicitação de Novos Locais de Curso de Capacitação', 1, 'nucleodealocacao@ciee.org.br', 0, 27, 1);
