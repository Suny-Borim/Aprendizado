--********************************************
--Corrige nomes das tabelas de relacionamento*
--********************************************

ALTER TABLE areas_atuacao_estagio
    RENAME TO areas_atuacao_vagas_estagio;

ALTER TABLE atividades_estagio
    RENAME TO atividades_vagas_estagio;

ALTER TABLE cursos_estagio
    RENAME TO cursos_vagas_estagio;