

INSERT INTO qualificacoes_parametros_empresas (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado, indicador, periodo, faixa_confirmacao, ponto, parametro_descricao) VALUES (seq_qualificacoes_parametros_empresas.NEXTVAL, current_timestamp, current_timestamp, 'CARGA', 'CARGA', '0', 'ATE_QUATRO_BENEF', 730, 1, 10, 'Fornece até 4 benefícios no estágio');
INSERT INTO qualificacoes_parametros_empresas (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado, indicador, periodo, faixa_confirmacao, ponto, parametro_descricao) VALUES (seq_qualificacoes_parametros_empresas.NEXTVAL, current_timestamp, current_timestamp, 'CARGA', 'CARGA', '0', 'ACIMA_QUATRO_BENEF', 730, 1, 25, 'Fornece acima de 4 benefícios no estágio');
INSERT INTO qualificacoes_parametros_empresas (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado, indicador, periodo, faixa_confirmacao, ponto, parametro_descricao) VALUES (seq_qualificacoes_parametros_empresas.NEXTVAL, current_timestamp, current_timestamp, 'CARGA', 'CARGA', '0', 'EFETIVACAO', 730, 1, 10, 'Geralmente efetiva os estagiários');
INSERT INTO qualificacoes_parametros_empresas (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado, indicador, periodo, faixa_confirmacao, ponto, parametro_descricao) VALUES (seq_qualificacoes_parametros_empresas.NEXTVAL, current_timestamp, current_timestamp, 'CARGA', 'CARGA', '0', 'TREINAM_DESENV', 730, 1, 15, 'Tem plano de treinamento e desenvolvimento');

UPDATE QUALIFICACOES_PARAMETROS_EMPRESAS SET PARAMETRO_DESCRICAO = 'Participa das 500 maiores empresas' WHERE INDICADOR = 'PARTICIPA_1000_MAIORES';    
UPDATE QUALIFICACOES_PARAMETROS_EMPRESAS SET PONTO = 20 WHERE INDICADOR = 'BOLSA_ACIMA_MEDIA'; 
UPDATE QUALIFICACOES_PARAMETROS_EMPRESAS SET PONTO = 30 WHERE INDICADOR = 'EMPRESA_DESTAQUE_MERCADO';

UPDATE QUALIFICACOES_PARAMETROS_PONTOS SET PONTO_DE = 75 WHERE SIGLA = 'A';  
UPDATE QUALIFICACOES_PARAMETROS_PONTOS SET PONTO_DE = 50, PONTO_ATE = 74 WHERE SIGLA = 'B';  
UPDATE QUALIFICACOES_PARAMETROS_PONTOS SET PONTO_ATE = 49 WHERE SIGLA = 'C';    