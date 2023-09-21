--PK-14986 - Criação de nova feature para permitir contratos de estágio com duração menor que 30 dias

-- Adicionada parâmetro para dizer se contratos de estágio podem ter duração menor que 30 dias
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD PERMITE_DURACAO_MENOR_TRINTA_DIAS NUMBER (1) DEFAULT 0;

-- Atualiza para undidades SP e RJ permitirem contratos com duração menor que 30 dias
UPDATE REP_PARAMETROS_PROGRAMA_EST SET PERMITE_DURACAO_MENOR_TRINTA_DIAS = 1 WHERE CODIGO_CIEE = 1 OR CODIGO_CIEE = 2;