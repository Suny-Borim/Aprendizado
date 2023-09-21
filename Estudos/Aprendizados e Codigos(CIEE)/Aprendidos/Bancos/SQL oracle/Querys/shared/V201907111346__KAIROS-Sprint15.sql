--Migration inicial Sprint 15 - Service_Vagas

--PK-9393 - Ativar /Desativar Vagas com Priorização no sistema POM
--Conforme alinhamento ficou estabelecido que os campos para o sistema POM, ficariam dentro das vagas.
ALTER TABLE vinculos_vaga DROP COLUMN priorizacao_cto;
ALTER TABLE vinculos_vaga DROP COLUMN identificacao_cto;

--
ALTER TABLE vagas_estagio ADD prioriza_pom NUMBER;
ALTER TABLE vagas_estagio ADD identifica_pom VARCHAR2(2);

ALTER TABLE vagas_aprendiz ADD prioriza_pom NUMBER;
ALTER TABLE vagas_aprendiz ADD identifica_pom VARCHAR2(2);

--PK-9400 - Efetuar Rescisão Automática
ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD dias_rescisao_automatica NUMBER(3);
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD dias_rescisao_automatica NUMBER(3);


--PK-8796 - Gerenciar Grupos de Atendimento das Solicitações
--Cria Tabela p/ os tipos de solicitação
--PK-8796 - Gerenciar Grupos de Atendimento das Solicitações
CREATE TABLE grupos_atendimentos (
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255) NOT NULL,
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(150) NOT NULL,
    situacao         NUMBER DEFAULT 0,
    email            VARCHAR2(150) NOT NULL,
    deletado         NUMBER(1)
);

COMMENT ON COLUMN grupos_atendimentos.situacao IS
    'FLAG:

0-ATIVO
1-INATIVO';

ALTER TABLE grupos_atendimentos ADD CONSTRAINT krs_indice_04000 PRIMARY KEY ( id );

CREATE TABLE tipo_solicitacao (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(255) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255) NOT NULL,
    deletado         NUMBER(1)
);

ALTER TABLE tipo_solicitacao ADD CONSTRAINT krs_indice_04020 PRIMARY KEY ( id );


--Exclui campo que virou tabela e add novos campos solicitados
ALTER TABLE SOLICITACOES_SERVICENOW DROP COLUMN TIPO_SOLICITACAO;
ALTER TABLE SOLICITACOES_SERVICENOW ADD DATA_ULTIMA_CONSULTA TIMESTAMP(6);
ALTER TABLE SOLICITACOES_SERVICENOW ADD SOLUCAO CLOB;


--Adiciona relacionamento com a nova tabela
ALTER TABLE SOLICITACOES_SERVICENOW ADD ID_TIPO_SOLICITACAO NUMBER(20) NOT NULL;

ALTER TABLE solicitacoes_servicenow
    ADD CONSTRAINT krs_indice_04021 FOREIGN KEY ( id_tipo_solicitacao )
        REFERENCES tipo_solicitacao ( id );


--Adiciona relacionamento com a nova tabela
ALTER TABLE GRUPOS_ATENDIMENTOS ADD ID_TIPO_SOLICITACAO NUMBER(20) NOT NULL;

ALTER TABLE grupos_atendimentos
    ADD CONSTRAINT krs_indice_04022 FOREIGN KEY ( id_tipo_solicitacao )
        REFERENCES tipo_solicitacao ( id );


--Realoca campo de tabela refatorada
ALTER TABLE GRUPOS_ATENDIMENTOS ADD tipo_contrato NUMBER(1) NOT NULL;

COMMENT ON COLUMN grupos_atendimentos.tipo_contrato IS
    'ENUM:
0-Estágio
1-Aprendiz Capacitador
2-Aprendiz Empregador';

--PK-8752 - Implementar melhorias no Currículo do Estudante
ALTER TABLE rep_estudantes ADD autoriza_visualizar_redacao	NUMBER (1);
ALTER TABLE rep_estudantes ADD autoriza_visualizar_video_apre NUMBER (1);

COMMENT ON COLUMN rep_estudantes.autoriza_visualizar_redacao IS
    'Enum

0-Sim
1-Não';

COMMENT ON COLUMN rep_estudantes.autoriza_visualizar_video_apre IS
    'Enum

0-Sim
1-Não';


--PK-9405 - Parametrização de Formulários - Perguntas e Respostas
CREATE TABLE perguntas_formularios (
    data_criacao         TIMESTAMP NOT NULL,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255) NOT NULL,
    modificado_por       VARCHAR2(255) NOT NULL,
    id                   NUMBER(20) NOT NULL,
    descricao_pergunta   VARCHAR2(200) NOT NULL,
    tipo_social          NUMBER(1) DEFAULT 0,
    tipo_relatorio       NUMBER(1),
    situacao             NUMBER(1),
    deletado             NUMBER(1)
);

COMMENT ON COLUMN perguntas_formularios.tipo_social IS
    'ENUM:

0-Não
1-Sim';

COMMENT ON COLUMN perguntas_formularios.tipo_relatorio IS
    'ENUM:

0-Relatorio de Atividades
1-Relatorio de Estagio
2-Termo de Realizacao de Estagio';

COMMENT ON COLUMN perguntas_formularios.situacao IS
    'ENUM:

0-ATIVA
1-INATIVA';

ALTER TABLE perguntas_formularios ADD CONSTRAINT krs_indice_04005 PRIMARY KEY ( id );


--
CREATE TABLE respostas_formularios (
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255) NOT NULL,
    modificado_por           VARCHAR2(255) NOT NULL,
    id                       NUMBER(20) NOT NULL,
    id_pergunta_formulario   NUMBER(20) NOT NULL,
    resposta_descricao       VARCHAR2(100) NOT NULL,
    resposta_critica         NUMBER(1) DEFAULT 0,
    tipo_resposta            NUMBER(1),
    situacao                 NUMBER(1),
    deletado                 NUMBER(1)
);

COMMENT ON COLUMN respostas_formularios.resposta_critica IS
    'ENUM:

0-NÃO
1-SIM';

COMMENT ON COLUMN respostas_formularios.tipo_resposta IS
    'ENUM:

0-FECHADA
1-ABERTA';

COMMENT ON COLUMN respostas_formularios.situacao IS
    'ENUM:

0-ATIVA
1-INATIVA';

ALTER TABLE respostas_formularios ADD CONSTRAINT krs_indice_04006 PRIMARY KEY ( id );

ALTER TABLE respostas_formularios
    ADD CONSTRAINT krs_indice_04008 FOREIGN KEY ( id_pergunta_formulario )
        REFERENCES perguntas_formularios ( id );



--SEQUENCES
CREATE SEQUENCE SEQ_grupos_atendimentos MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_grupos_atendimentos_solicitacoes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_perguntas_formularios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_respostas_formularios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;