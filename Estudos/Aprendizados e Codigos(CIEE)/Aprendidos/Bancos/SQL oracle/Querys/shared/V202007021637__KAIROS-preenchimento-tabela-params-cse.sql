ALTER TABLE PARAMS_CSE MODIFY MENSAGEM VARCHAR2(250);

INSERT INTO PARAMS_CSE(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, MENSAGEM, PRAZO, TIPO_PRAZO)
VALUES (SEQ_PARAMS_CSE.nextval, current_timestamp, current_timestamp, 'flyway', 'flyway', 0, 'O prazo de confirmação da sua situação escolar está aberto, disponibilize documento atualizado - Declaração de matrícula', 20, 0);

INSERT INTO PARAMS_CSE(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, MENSAGEM, PRAZO, TIPO_PRAZO)
VALUES (SEQ_PARAMS_CSE.nextval, current_timestamp, current_timestamp, 'flyway', 'flyway', 0, 'O prazo de confirmação da sua situação escolar está terminando, disponibilize documento atualizado - Declaração de matrícula', 20, 1);

INSERT INTO PARAMS_CSE(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, MENSAGEM, PRAZO, TIPO_PRAZO)
VALUES (SEQ_PARAMS_CSE.nextval, current_timestamp, current_timestamp, 'flyway', 'flyway', 0, 'O prazo de confirmação da sua situação escolar vai encerrar, e você perderá seu estágio, disponibilize documento atualizado - Declaração de matrícula', 10, 2);

INSERT INTO PARAMS_CSE(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, MENSAGEM, PRAZO, TIPO_PRAZO)
VALUES (SEQ_PARAMS_CSE.nextval, current_timestamp, current_timestamp, 'flyway', 'flyway', 0, 'O prazo de confirmação da sua situação escolar está encerrado, estamos atuando no encerramento do seu estágio', 10, 3);