--
-- Motivos Rescisão
--
COMMENT ON COLUMN motivos_rescisao_contratados.tipo_contrato IS
    'ENUM:

0-CONTRATOS DE ESTÁGIO
1-APRENDIZ
2-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.perfil_acesso IS
    'ENUM:

0-CIEE
1-EMPRESA
2-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.acesso_ciee IS
    'ENUM:

0-SP
1-RJ
2-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.perm_emiss_declaracao_estag IS
    'Permite Emissão de Declaração de Estagio (S/N) default ''1-SIM''

Flag:

0-NAO
1-SIM';

COMMENT ON COLUMN motivos_rescisao_contratados.perm_emiss_termo_realiz_estag IS
    'Permite Emissão de Termo de Realização de Estagio (S/N) default ''1-SIM''

Flag:

0-NAO
1-SIM';

COMMENT ON COLUMN motivos_rescisao_contratados.situacao IS
    'Flag:

0-INATIVO
1-ATIVO';


--
-- Motivos Cancelamento
--
COMMENT ON COLUMN motivos_cancelamentos_contratados.tipo_contrato IS
    'ENUM:

0-CONTRATOS DE ESTÁGIO
1-APRENDIZ
2-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.perfil_acesso IS
    'ENUM:

0-CIEE
1-EMPRESA
2-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.acesso_ciee IS
    'ENUM:

0-SP
1-RJ
2-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.situacao IS
    'Flag:

0-INATIVO
1-ATIVO';

ALTER TABLE MOTIVOS_RESCISAO_CONTRATADOS MODIFY (
    perm_emiss_declaracao_estag     NUMBER(1) DEFAULT 1,
    perm_emiss_termo_realiz_estag   NUMBER(1) DEFAULT 1
    );