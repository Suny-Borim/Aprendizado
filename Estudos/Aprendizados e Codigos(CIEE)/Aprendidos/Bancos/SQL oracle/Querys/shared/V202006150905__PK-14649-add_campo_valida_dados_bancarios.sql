-- PK-14649 [Backend] - Atualizar payload com código de operação do estudante, digito da conta e ordem de pagamento (estagiário e dependente)

ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD VALIDA_DADO_BANCARIO NUMBER(1,0);