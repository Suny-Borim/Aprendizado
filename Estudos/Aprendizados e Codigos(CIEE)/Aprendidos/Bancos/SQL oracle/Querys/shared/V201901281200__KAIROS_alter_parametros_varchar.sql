--*************************************************
-- Aumentando varchar de mensagens de PARAMETRO_EMPRESA
--*************************************************

ALTER TABLE {{user}}.REP_PARAMETROS_EMPRESA
    MODIFY MSG_BACKOFFICE VARCHAR2(500);

ALTER TABLE {{user}}.REP_PARAMETROS_EMPRESA
    MODIFY MSG_EMPRESA VARCHAR2(500);

ALTER TABLE {{user}}.REP_PARAMETROS_EMPRESA
    MODIFY MSG_ESTUDANTE VARCHAR2(500);

ALTER TABLE {{user}}.PARAMETROS_EMPRESA_CONTRATO
    MODIFY MSG_BACKOFFICE VARCHAR2(500);

ALTER TABLE {{user}}.PARAMETROS_EMPRESA_CONTRATO
    MODIFY MSG_EMPRESA VARCHAR2(500);

ALTER TABLE {{user}}.PARAMETROS_EMPRESA_CONTRATO
    MODIFY MSG_ESTUDANTE VARCHAR2(500);
