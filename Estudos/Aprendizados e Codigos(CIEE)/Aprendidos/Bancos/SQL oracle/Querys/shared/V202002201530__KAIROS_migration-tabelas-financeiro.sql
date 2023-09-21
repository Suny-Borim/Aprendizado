CREATE TABLE rep_configuracoes_folhas_pagamentos_financeiro
(
    id                NUMBER(20) NOT NULL,
    id_local_contrato NUMBER(20),
    descricao         VARCHAR2(150),
    tipo_configuracao NUMBER(1),
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP,
    criado_por        VARCHAR2(255 CHAR),
    modificado_por    VARCHAR2(255 CHAR),
    deletado          NUMBER(1)
);

COMMENT ON TABLE rep_configuracoes_folhas_pagamentos_financeiro IS 'FINANCEIRO_DEV:SERVICE_FINANCEIRO_DEV:CONFIGURACOES_FOLHAS_PAGAMENTOS';
COMMENT ON COLUMN rep_configuracoes_folhas_pagamentos_financeiro.tipo_configuracao IS
'ENUM:
    0-Folha não calculada - default
    1-Folha calculada
    2-Ateste Frequência';
ALTER TABLE rep_configuracoes_folhas_pagamentos_financeiro ADD CONSTRAINT krs_indice_07180 PRIMARY KEY (id);

CREATE TABLE rep_vinculos_configuracoes_folhas_locais_contratos_financeiro
(
    id                              NUMBER(20) NOT NULL,
    data_criacao                    TIMESTAMP,
    data_alteracao                  TIMESTAMP,
    criado_por                      VARCHAR2(255 CHAR),
    modificado_por                  VARCHAR2(255 CHAR),
    deletado                        NUMBER(1),
    id_configuracao_folha_pagamento NUMBER(20) NOT NULL,
    id_local_contrato               NUMBER(20) NOT NULL
);

COMMENT ON TABLE rep_vinculos_configuracoes_folhas_locais_contratos_financeiro IS
    'FINANCEIRO_DEV:SERVICE_FINANCEIRO_DEV:VINCULOS_CONFIGURACOES_FOLHAS_LOCAIS_CONTRATOS';

ALTER TABLE rep_vinculos_configuracoes_folhas_locais_contratos_financeiro
    ADD CONSTRAINT krs_indice_07181 PRIMARY KEY (id);

ALTER TABLE rep_configuracoes_folhas_pagamentos_financeiro
    ADD CONSTRAINT krs_indice_07183 FOREIGN KEY (id_local_contrato)
        REFERENCES rep_locais_contrato (id);

ALTER TABLE rep_vinculos_configuracoes_folhas_locais_contratos_financeiro
    ADD CONSTRAINT krs_indice_07184 FOREIGN KEY (id_configuracao_folha_pagamento)
        REFERENCES rep_configuracoes_folhas_pagamentos_financeiro (id);

ALTER TABLE rep_vinculos_configuracoes_folhas_locais_contratos_financeiro
    ADD CONSTRAINT krs_indice_07185 FOREIGN KEY (id_local_contrato)
        REFERENCES rep_locais_contrato (id);