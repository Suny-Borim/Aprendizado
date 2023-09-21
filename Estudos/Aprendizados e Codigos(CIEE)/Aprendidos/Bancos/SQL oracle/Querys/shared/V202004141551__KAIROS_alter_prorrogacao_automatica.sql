--PK-10075 - Prorrogação Automática de Contratos de Estágio
alter table parametros_empresa_contrato add prorrogacao_automatica NUMBER(1) DEFAULT 1;
alter table parametros_empresa_contrato add prazo_antecipacao_prorrogacao NUMBER(3) DEFAULT 30;
COMMENT ON COLUMN parametros_empresa_contrato.prorrogacao_automatica IS
    '0 - NAO
1 - SIM - DEFAULT';

alter table parametros_ie add prorrogacao_automatica NUMBER(1) DEFAULT 1;
alter table parametros_ie add prazo_antecipacao_prorrogacao NUMBER(3) DEFAULT 30;
COMMENT ON COLUMN parametros_ie.prorrogacao_automatica IS
    '0 - NAO
1 - SIM - DEFAULT';

alter table contratos_estudantes_empresa add prorrogacao_automatica NUMBER(1) DEFAULT 0;
COMMENT ON COLUMN contratos_estudantes_empresa.prorrogacao_automatica IS
    '0 - NAO - DEFAULT
1 - SIM ';

alter table hist_contratos_estudantes_empresa add prorrogacao_automatica NUMBER(1) DEFAULT 0;
COMMENT ON COLUMN hist_contratos_estudantes_empresa.prorrogacao_automatica IS
    '0 - NAO - DEFAULT
1 - SIM';