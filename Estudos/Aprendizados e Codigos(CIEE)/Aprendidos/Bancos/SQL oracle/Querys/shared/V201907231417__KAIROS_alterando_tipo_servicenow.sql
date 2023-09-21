/* Conforme alinhado com Francisco, não será necessário gerar um número de solicitação via Káiros */
ALTER TABLE SOLICITACOES_SERVICENOW DROP COLUMN NUMERO_SOLICITACAO;

/*
 Conforme documento de integração do Service Now na estória
 "Receber Número de Autorização de Atendimento do Service Now",
 o número do ticket deve ser uma string de até 40 caractéres
 */

ALTER TABLE SOLICITACOES_SERVICENOW MODIFY NUMERO_TICKET VARCHAR2(40);

ALTER TABLE SOLICITACOES_SERVICENOW ADD PRAZO TIMESTAMP(6);
