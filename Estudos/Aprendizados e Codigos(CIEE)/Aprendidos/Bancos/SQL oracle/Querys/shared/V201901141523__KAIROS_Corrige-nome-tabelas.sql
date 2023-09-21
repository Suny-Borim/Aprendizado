--**************************************************
--Corrige o nome da tabela de instituição de ensino*
--**************************************************


ALTER TABLE rep_instituicao_ensino
    RENAME TO rep_instituicoes_ensinos;

ALTER TABLE rep_instituicoes_ensinos
    MODIFY (nome_instituicao VARCHAR2(255),
            nome_instituicao_reduzido VARCHAR2(255),
            nome_fantasia_reduzido VARCHAR2(255),
            nome_popular VARCHAR2(255));


--**************************************************************************
--Corrige nome da tabela de relacionamento de area profissional com atuacao*
--**************************************************************************

ALTER TABLE REP_AREAS_PROF_ATUACAO
    RENAME TO REP_AREAS_PROFISSIONAL_ATUACAO;