----------------------------------------------------
-- Inclusão dos campos de parametrização de Whatsapp
----------------------------------------------------

ALTER TABLE parametros_comunicacao ADD(whatsapp_liberado NUMBER(*) DEFAULT 0 NOT NULL);
ALTER TABLE parametros_comunicacao ADD(whatsapp_sms_liberado NUMBER(*) DEFAULT 0 NOT NULL);
ALTER TABLE parametros_comunicacao ADD(whatsapp_ciee_telefone VARCHAR2(15 CHAR) DEFAULT '5511998935940' NOT NULL);
ALTER TABLE parametros_comunicacao ADD(whatsapp_api_link VARCHAR2(150 CHAR) DEFAULT 'https://api.whatsapp.com' NOT NULL);

COMMENT ON COLUMN parametros_comunicacao.whatsapp_liberado IS
    'Flag:

0 - Envio de mensagens whatsapp liberado

1 - Envio de mensagens whatsapp bloqueado';


COMMENT ON COLUMN parametros_comunicacao.whatsapp_sms_liberado IS
    'Flag:

0 - Envio de link de mensagem para atendimento via whatsapp por SMS liberado

1 - Envio de link de mensagem para atendimento via whatsapp por SMS bloqueado';
