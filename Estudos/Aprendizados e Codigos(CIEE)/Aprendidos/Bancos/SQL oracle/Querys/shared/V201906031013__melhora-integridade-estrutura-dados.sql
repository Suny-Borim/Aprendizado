-- Adiciona campos de valor para tabela de campos dinânimos com integração da recrutei
ALTER TABLE RADAR ADD VALOR NUMBER(4) NOT NULL;
ALTER TABLE PARAMS ADD VALOR NUMBER(4) NOT NULL;


--Adiciona constraint para evitar uma mesma vaga se relacionar com uma mesma qualificação
ALTER TABLE vinculo_qualificacao_vaga ADD CONSTRAINT krs_indice_03634 UNIQUE (id_vaga_estagio, id_vaga_aprendiz, id_qualificacao);
