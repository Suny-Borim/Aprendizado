-- PK-15576 - Criação de novas ocorrências para bloquear a vaga que quando aberta não atender aos parametros de empresa específicos cadastrados.
ALTER TABLE OCORRENCIAS_ESTAGIO MODIFY DESCRICAO VARCHAR2(40 char);
ALTER TABLE OCORRENCIAS_APRENDIZ MODIFY DESCRICAO VARCHAR2(40 char);

-- Ocorrencia para bloquear vaga quando parâmetro de empresa 'Carga horária diaria de estágio' não for cumprido
INSERT INTO OCORRENCIAS (ID, DESCRICAO, BLOQUEIA_VAGA, BLOQUEIA_CONTRATACAO, ATIVO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
VALUES (55, 'Vaga com pendência no parâmetro de empresa de carga horária diária.', 1, 1, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'FLYWAY', 'FLYWAY');

-- Ocorrencia para bloquear vaga quando parâmetro de empresa 'Faixa etária aprendiz' não for cumprido
INSERT INTO OCORRENCIAS (ID, DESCRICAO, BLOQUEIA_VAGA, BLOQUEIA_CONTRATACAO, ATIVO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
VALUES (56, 'Vaga com pendência no parâmetro de empresa de faixa etária do aprendiz.', 1, 1, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'FLYWAY', 'FLYWAY');

-- Ocorrencia para bloquear vaga quando parâmetro de empresa 'Padrão de distância da triagem' não for cumprido para estágio e aprendiz
INSERT INTO OCORRENCIAS (ID, DESCRICAO, BLOQUEIA_VAGA, BLOQUEIA_CONTRATACAO, ATIVO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
VALUES (57, 'Vaga com pendência no parâmetro de empresa de padrão de distância da triagem.', 1, 1, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'FLYWAY', 'FLYWAY');

-- Ocorrencia para bloquear vaga quando parâmetro de empresa 'Bolsa-auxílio fixa e beneficios' não for cumprido para estágio
INSERT INTO OCORRENCIAS (ID, DESCRICAO, BLOQUEIA_VAGA, BLOQUEIA_CONTRATACAO, ATIVO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
VALUES (58, 'Vaga com pendência no parâmetro de empresa de bolsa-auxílio fixa e benefícios.', 1, 1, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'FLYWAY', 'FLYWAY');
