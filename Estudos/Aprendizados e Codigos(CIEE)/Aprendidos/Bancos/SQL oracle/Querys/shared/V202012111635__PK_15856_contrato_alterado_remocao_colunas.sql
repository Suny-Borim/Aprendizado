/*
 PK-15592: Alterar Contrato Aprendiz
    - PK-15856: [Backend] Salvar contrato original em historico

 As colunas de ID_ORIGEM nas tabelas CONTRATOS_CURSOS_CAPACITACAO_ALTERADO, PERIODOS_ALTERADO, FERIAS_ALTERADO e
 DOCUMENTOS_CONTR_EMP_EST_ALTERADO não serão necessárias para manter o histórico de contrato aprendiz alterado,
 pois apenas criar um contrato aprendiz alterado novo é suficiente.

 */

ALTER TABLE CONTRATOS_CURSOS_CAPACITACAO_ALTERADO
    DROP COLUMN ID_ORIGEM;

ALTER TABLE PERIODOS_ALTERADO
    DROP COLUMN ID_ORIGEM;

ALTER TABLE FERIAS_ALTERADO
    DROP COLUMN ID_ORIGEM;

ALTER TABLE DOCUMENTOS_CONTR_EMP_EST_ALTERADO
    DROP COLUMN ID_ORIGEM;
