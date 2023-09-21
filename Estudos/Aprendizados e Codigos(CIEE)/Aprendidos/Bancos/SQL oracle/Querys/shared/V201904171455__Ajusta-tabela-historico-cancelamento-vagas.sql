-- Cria sequence para a tabela
CREATE SEQUENCE
	seq_historico_cancelamento_vaga MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER NOCYCLE;


-- Ajusta tabela removendo campos de relção com vinculo vaga
-- No momento o relacionamento com vinculo vaga não atende exatamente os nossos requisitos
ALTER TABLE SERVICE_VAGAS_DEV.HISTORICO_CANCELAMENTO_VAGA DROP CONSTRAINT KRS_INDICE_02363;
ALTER TABLE SERVICE_VAGAS_DEV.HISTORICO_CANCELAMENTO_VAGA DROP COLUMN ID_VINCULO_VAGA;

