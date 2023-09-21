UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Cancelamento de contrato de estágio ou aprendiz'
WHERE ID = 1;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Cancelamento prorrogação'
WHERE ID = 2;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Cancelamento de rescisão'
WHERE ID = 3;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Cancelamento de baixa'
WHERE ID = 4;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de alteração de férias'
WHERE ID = 5;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de alteração de horário'
WHERE ID = 6;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de alteração de local de contrato aprendiz empregador'
WHERE ID = 7;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitações de descontos'
WHERE ID = 8;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de acompanhamento do aprendiz'
WHERE ID = 9;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de alteração do monitor do aprendiz'
WHERE ID = 10;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitar alteração de vale transporte'
WHERE ID = 11;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitar alteração de VR/VA'
WHERE ID = 12;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Solicitação de pedido de demissão'
WHERE ID = 13;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Visualizar holerite'
WHERE ID = 14;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Consultar programação de férias'
WHERE ID = 15;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Comunicar afastamento'
WHERE ID = 16;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Rescisão de contrato de estágio ou aprendiz'
WHERE ID = 17;

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Contato para assistente GMC'
WHERE ID = 18;

INSERT INTO TIPO_SOLICITACAO (ID, DESCRICAO, CRIADO_POR, DATA_ALTERACAO, DATA_CRIACAO, DELETADO, MODIFICADO_POR)
VALUES (19, 'Solicitação de alteração de local de contrato aprendiz capacitador', 'ricardo.souza@iteris.com.br', current_timestamp, current_timestamp, 0, 'ricardo.souza@iteris.com.br');