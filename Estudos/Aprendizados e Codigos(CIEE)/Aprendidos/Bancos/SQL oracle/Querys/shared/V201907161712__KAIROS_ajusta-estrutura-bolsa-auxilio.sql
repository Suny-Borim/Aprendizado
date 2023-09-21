
--
-- Remove campos que não são mais necessarios nas tabelas de valor de médio bolsa
--
ALTER TABLE VALOR_MEDIO_BOLSA_MENSAL DROP (descricao_area_profissional,razao_social,id_contrato);
ALTER TABLE VALOR_MEDIO_BOLSA_HORA DROP (descricao_area_profissional,razao_social,id_contrato);
