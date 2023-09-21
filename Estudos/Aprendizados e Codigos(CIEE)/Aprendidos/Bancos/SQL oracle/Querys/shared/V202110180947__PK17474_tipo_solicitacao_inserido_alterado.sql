UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Cancelamento do contrato de estágio' where DESCRICAO ='Cancelamento de contrato de estágio ou aprendiz';

UPDATE TIPO_SOLICITACAO SET DESCRICAO = 'Rescisão do contrato de estágio'  where DESCRICAO = 'Rescisão de contrato de estágio ou aprendiz';

INSERT INTO TIPO_SOLICITACAO (ID,DESCRICAO,DATA_CRIACAO,DATA_ALTERACAO,CRIADO_POR,MODIFICADO_POR,DELETADO)
values (28,'Rescisão do contrato de aprendiz', current_timestamp, current_timestamp,
'FLYWAY', 'FLYWAY', 0);

INSERT INTO TIPO_SOLICITACAO (ID,DESCRICAO,DATA_CRIACAO,DATA_ALTERACAO,CRIADO_POR,MODIFICADO_POR,DELETADO)
values (29,'Cancelamento de contrato aprendiz', current_timestamp, current_timestamp,
'FLYWAY', 'FLYWAY', 0);