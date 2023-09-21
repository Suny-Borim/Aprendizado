/*--Migration inicial Sprint 16 - Service_Vagas v.3

--PK-9515 - Parametrização de Relatórios e Documentos de Estágio
--PK-9516 - Buscar Relatórios de Estágio
--PK-9631 - Acompanhamento do Preenchimento de Relatórios
--PK-9645 - Gerar RA - Relatório de Atividades do Estágio
--PK-9646 - Preencher RA - Relatório de Atividades do Estágio
--PK-9647 - Gerar RE - Relatório de Estágio
--PK-9648 - Preencher RE - Relatório de Estágio
--PK-9649 - Acompanhar preenchimento do RE
--PK-9650 - Gerar TRE - Termo de Realização de Estágio
--PK-9651 - Preencher TRE - Termo de Realização de Estágio
--PK-9656 - Gerar Declarações de Estágio
*/

CREATE TABLE formularios (
    id                              NUMBER(20) NOT NULL,
    data_criacao                    TIMESTAMP NOT NULL,
    data_alteracao                  TIMESTAMP NOT NULL,
    criado_por                      VARCHAR2(255) NOT NULL,
    modificado_por                  VARCHAR2(255) NOT NULL,
    deletado                        NUMBER(1) NOT NULL,
    tipo_relatorio                  NUMBER(1) NOT NULL,
    categoria_relatorio             NUMBER(1) NOT NULL,
    titulo_relatorio                VARCHAR2(100),
    id_img_logo                     NUMBER(20),
    texto_apoio_superior            VARCHAR2(300),
    texto_apoio_inferior            VARCHAR2(300),
    mostrar_atividade_estagiario    NUMBER,
    disponibiliza_relatorio_meses   NUMBER(3),
    disponibiliza_relatorio_data    NUMBER(1),
    status                          NUMBER(1),
    situacao                        NUMBER(1),
    tipo_contrato                   NUMBER(1) NOT NULL,
    id_contrato                     NUMBER(20)
);

COMMENT ON COLUMN formularios.tipo_relatorio IS
    'ENUM:

0-Relatorio de Atividades
1-Relatorio de Estagio
2-Termo de Realizacao de Estagio';

COMMENT ON COLUMN formularios.categoria_relatorio IS
    'ENUM:
0:Padrao
1:Especifico';

COMMENT ON COLUMN formularios.mostrar_atividade_estagiario IS
    'ENUM:
0:NAO
1:SIM';

COMMENT ON COLUMN formularios.disponibiliza_relatorio_data IS
    'ENUM
0: MENSAL - A PARTIR DA DATA DE INICIO DE CONTRATO
1: BIMESTRAL - A PARTIR DA DATA DE INICIO DE CONTRATO
2: TRIMESTRAL - A PARTIR DA DATA DE INICIO DE CONTRATO
3: SEMESTRAL - A PARTIR DA DATA DE INICIO DE CONTRATO
4: ANUAL - A PARTIR DA DATA DE INICIO DE CONTRATO
5: TERMINO DO CONTRATO / RESCISAO DO CONTRATO'
    ;
COMMENT ON COLUMN formularios.status IS
    'ENUM:
0-INATIVA
1-ATIVA';
COMMENT ON COLUMN formularios.situacao IS
    'ENUM:
0-PENDENTE
1-RESOLVIDO';
COMMENT ON COLUMN formularios.tipo_contrato IS
    'ENUM:
0-Estagio
1-Aprendiz';
ALTER TABLE formularios ADD CONSTRAINT krs_indice_04080 PRIMARY KEY ( id );
ALTER TABLE formularios
    ADD CONSTRAINT krs_indice_04084 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );
CREATE TABLE campos (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255) NOT NULL,
    deletado         NUMBER(1) DEFAULT 0,
    campo            VARCHAR2(150)
);
ALTER TABLE campos ADD CONSTRAINT krs_indice_04127 PRIMARY KEY ( id );
CREATE TABLE campos_formularios (
    id               NUMBER(20) DEFAULT 0 NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255) NOT NULL,
    deletado         NUMBER(1) DEFAULT 0,
    id_campo         NUMBER(20) NOT NULL,
    posicao          NUMBER(4),
    id_formulario    NUMBER(20) NOT NULL
);
ALTER TABLE campos_formularios ADD CONSTRAINT krs_indice_04129 PRIMARY KEY ( id );
ALTER TABLE campos_formularios
    ADD CONSTRAINT krs_indice_04130 FOREIGN KEY ( id_campo )
        REFERENCES campos ( id );
ALTER TABLE campos_formularios
    ADD CONSTRAINT krs_indice_04131 FOREIGN KEY ( id_formulario )
        REFERENCES formularios ( id );
CREATE TABLE relatorios_estudantes (
    id                          NUMBER(20) NOT NULL,
    data_criacao                TIMESTAMP NOT NULL,
    data_alteracao              TIMESTAMP NOT NULL,
    criado_por                  VARCHAR2(255) NOT NULL,
    modificado_por              VARCHAR2(255) NOT NULL,
    deletado                    NUMBER(1),
    id_formulario               NUMBER(20) NOT NULL,
    id_contr_emp_est            NUMBER(20) NOT NULL,
    situacao                    NUMBER(1),
    id_documento                NUMBER(20),
    id_envelope                 NUMBER(20),
    id_solicitacao_servicenow   NUMBER(20),
    contato                     VARCHAR2(150)
);
COMMENT ON COLUMN relatorios_estudantes.situacao IS
    'ENUM:
0 - PENDENTE
1- PREENCHIDO
2 - MANUAL';
ALTER TABLE relatorios_estudantes ADD CONSTRAINT krs_indice_04081 PRIMARY KEY ( id );
ALTER TABLE relatorios_estudantes
    ADD CONSTRAINT krs_indice_04085 FOREIGN KEY ( id_formulario )
        REFERENCES formularios ( id );
ALTER TABLE relatorios_estudantes
    ADD CONSTRAINT krs_indice_04086 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );

ALTER TABLE relatorios_estudantes
    ADD CONSTRAINT krs_indice_04137 FOREIGN KEY ( id_solicitacao_servicenow )
        REFERENCES solicitacoes_servicenow ( id );
CREATE TABLE respostas_estudantes (
    id                       NUMBER(20) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255) NOT NULL,
    modificado_por           VARCHAR2(255) NOT NULL,
    deletado                 NUMBER(1),
    id_relatorio_estudante   NUMBER(20) NOT NULL,
    descricao_pergunta       VARCHAR2(300) NOT NULL,
    descricao_resposta       VARCHAR2(300) NOT NULL,
    resposta_critica         NUMBER(1) DEFAULT 0,
    tipo_social              NUMBER(1)
);
COMMENT ON COLUMN respostas_estudantes.resposta_critica IS
    'ENUM:
0-NÃO
1-SIM';
COMMENT ON COLUMN respostas_estudantes.tipo_social IS
    'ENUM:
0-Não
1-Sim';
ALTER TABLE respostas_estudantes ADD CONSTRAINT krs_indice_04082 PRIMARY KEY ( id );
ALTER TABLE respostas_estudantes
    ADD CONSTRAINT krs_indice_04087 FOREIGN KEY ( id_relatorio_estudante )
        REFERENCES relatorios_estudantes ( id );
CREATE TABLE acompanhamentos_formularios (
    id                       NUMBER(20) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255) NOT NULL,
    modificado_por           VARCHAR2(255) NOT NULL,
    deletado                 NUMBER(1),
    descricao                VARCHAR2(300) NOT NULL,
    id_relatorio_estudante   NUMBER(20) NOT NULL
);
ALTER TABLE acompanhamentos_formularios ADD CONSTRAINT krs_indice_04088 PRIMARY KEY ( id );
ALTER TABLE acompanhamentos_formularios
    ADD CONSTRAINT krs_indice_04092 FOREIGN KEY ( id_relatorio_estudante )
        REFERENCES relatorios_estudantes ( id );
CREATE TABLE relatorios (
    id                       NUMBER(20) DEFAULT 0 NOT NULL,
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255) NOT NULL,
    modificado_por           VARCHAR2(255) NOT NULL,
    deletado                 NUMBER(1) DEFAULT 0,
    posicao                  NUMBER(4),
    id_pergunta_formulario   NUMBER(20) DEFAULT 0 NOT NULL,
    id_formulario            NUMBER(20) DEFAULT 0 NOT NULL
);
ALTER TABLE relatorios ADD CONSTRAINT krs_indice_04132 PRIMARY KEY ( id );
ALTER TABLE relatorios
    ADD CONSTRAINT krs_indice_04133 FOREIGN KEY ( id_formulario )
        REFERENCES formularios ( id );
ALTER TABLE relatorios
    ADD CONSTRAINT krs_indice_04134 FOREIGN KEY ( id_pergunta_formulario )
        REFERENCES perguntas_formularios ( id );
--PK-9652 - Confirmação de Situação Escolar - CSE
CREATE TABLE cse (
    id                                NUMBER(20) NOT NULL,
    data_criacao                      TIMESTAMP NOT NULL,
    data_alteracao                    TIMESTAMP NOT NULL,
    criado_por                        VARCHAR2(255) NOT NULL,
    modificado_por                    VARCHAR2(255) NOT NULL,
    deletado                          NUMBER(1) DEFAULT 0,
    data_inicio_contrato              TIMESTAMP,
    data_termino_contrato             TIMESTAMP,
    situacao_contrato                 NUMBER,
    data_inicio_processo_cse          TIMESTAMP,
    situacao_confirmacao              NUMBER,
    data_atualizacao_situacao         TIMESTAMP,
    forma_comprovacao                 VARCHAR2(150),
    responsavel_aprovacao_documento   VARCHAR2(150),
    id_documento_declaracao           NUMBER(20),
    id_contr_emp_est                  NUMBER(20) NOT NULL
);
COMMENT ON COLUMN cse.situacao_contrato IS
    'ENUM:
0-ATIVO
1-DESLIGADO
2-CANCELADO
3-VENCIDO';
COMMENT ON COLUMN cse.situacao_confirmacao IS
    'ENUM:
0-Pendente
1-Em Analise
2-Confirmado';
ALTER TABLE cse ADD CONSTRAINT krs_indice_04100 PRIMARY KEY ( id );
ALTER TABLE cse
    ADD CONSTRAINT krs_indice_04102 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );
--
CREATE TABLE params_cse (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255) NOT NULL,
    modificado_por   VARCHAR2(255) NOT NULL,
    deletado         NUMBER(1) DEFAULT 0,
    mensagem         VARCHAR2(150) NOT NULL,
    prazo            NUMBER(3)
);
ALTER TABLE params_cse ADD CONSTRAINT krs_indice_04101 PRIMARY KEY ( id );
--PK-9657 - Pontuar critérios de vulnerabilidade
    --Aguardando alinhamento de onde será adicionado e replicado esse novo criterio de pontuação.
--PK-8507 - Criar componentes para modelos de documentos - APRENDIZ
--PK-9787 - Implementar campos em "componentes para modelos de documentos - Aprendiz"
ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD CARGO_MONITOR_APRENDIZ VARCHAR2(150);
ALTER TABLE HIST_CONTRATOS_ESTUDANTES_EMPRESA ADD CARGO_MONITOR_APRENDIZ VARCHAR2(150);
CREATE TABLE vinculos_cbos (
    id_duracao                      NUMBER(20) NOT NULL,
    id_contrato_curso_capacitacao   NUMBER(20) NOT NULL
);
ALTER TABLE vinculos_cbos
    ADD CONSTRAINT krs_indice_04135 FOREIGN KEY ( id_duracao )
        REFERENCES duracoes_capacitacao ( id );
ALTER TABLE vinculos_cbos
    ADD CONSTRAINT krs_indice_04136 FOREIGN KEY ( id_contrato_curso_capacitacao )
        REFERENCES contratos_cursos_capacitacao ( id );
--SEQUENCES
CREATE SEQUENCE SEQ_formularios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_relatorios_estudantes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_respostas_estudantes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_acompanhamentos_formularios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_cse MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_params_cse MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
