
-- Adicionando coluna LINK_DOC na DOCUMENTOS_SOLICITACOES_SERVICENOW

ALTER TABLE DOCUMENTOS_SOLICITACOES_SERVICENOW ADD LINK_DOC VARCHAR2(255 char);

-- Migrando os dados de documentos da SOLICITACOES_SERVICENOW para DOCUMENTOS_SOLICITACOES_SERVICENOW

MERGE INTO DOCUMENTOS_SOLICITACOES_SERVICENOW documento
USING (SELECT s.id, s.link_doc
       from SOLICITACOES_SERVICENOW s
       where s.LINK_DOC is not null) solicitacao
ON (documento.ID_SOLICITACAO_SERVICENOW = solicitacao.ID)
WHEN NOT MATCHED THEN
    INSERT (documento.id, documento.link_doc, documento.ID_SOLICITACAO_SERVICENOW, documento.CODIGO_DOCUMENTO,
            documento.DESCRICAO, documento.DATA_CRIACAO, documento.DATA_ALTERACAO, documento.CRIADO_POR,
            documento.MODIFICADO_POR, documento.DELETADO)
    VALUES (SEQ_DOCUMENTOS_SOLICITACOES_SERVICENOW.nextval, solicitacao.link_doc, solicitacao.ID, null, null, current_timestamp,
            current_timestamp, 'flyway', 'flyway', 0);
