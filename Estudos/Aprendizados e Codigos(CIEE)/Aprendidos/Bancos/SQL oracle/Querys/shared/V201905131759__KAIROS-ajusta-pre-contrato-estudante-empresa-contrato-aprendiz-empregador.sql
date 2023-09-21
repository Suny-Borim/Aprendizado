ALTER TABLE pre_contratos_estudantes_empresa ADD pendencia VARCHAR2(500);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.situacao IS
    'Flags:

0: Rascunho
1: Inconsistente
2: Encaminhado RH
3: Recusado
4: Reenviar para o RH';
