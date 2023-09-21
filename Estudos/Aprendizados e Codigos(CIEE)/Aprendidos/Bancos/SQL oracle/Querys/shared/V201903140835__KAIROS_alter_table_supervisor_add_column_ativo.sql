ALTER TABLE SUPERVISORES ADD ATIVO NUMBER;

ALTER TABLE historico_supervisor_contrato ADD ativo number;

COMMENT ON COLUMN historico_supervisor_contrato.ativo IS
    'Flag 0 ou 1';

COMMENT ON COLUMN SUPERVISORES.ativo IS
    'Flag 0 ou 1';