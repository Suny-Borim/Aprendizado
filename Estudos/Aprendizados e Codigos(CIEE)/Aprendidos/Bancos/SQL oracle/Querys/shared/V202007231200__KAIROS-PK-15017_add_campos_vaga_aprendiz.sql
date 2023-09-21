--PK-15017 Adiciona os campos autorização_atendimento, numero_autorizacao, processo_personalizado e reporAprendiz na tabela vaga_aprendiz.

ALTER TABLE VAGAS_APRENDIZ ADD autorizacao_atendimento NUMBER(1) DEFAULT 0;
ALTER TABLE VAGAS_APRENDIZ ADD numero_autorizacao NUMBER(5);
ALTER TABLE VAGAS_APRENDIZ ADD processo_seletivo_empresa NUMBER(1) DEFAULT 0;
ALTER TABLE VAGAS_APRENDIZ ADD repor_aprendiz NUMBER(1) DEFAULT 0;