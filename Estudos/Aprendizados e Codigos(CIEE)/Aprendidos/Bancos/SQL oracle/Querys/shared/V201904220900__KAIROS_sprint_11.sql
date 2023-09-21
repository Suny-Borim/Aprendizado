-- Migration inicial Sprint_11 - Service Vagas

--PK-8507 - Criar componentes para modelos de documentos - APRENDIZ
--PK-8505 - Vincular Componentes a Contratos
--PK-8506 - Vincular Componentes a unidade CIEE

--
CREATE TABLE template_empresa (
                                  id              NUMBER(20) NOT NULL,
                                  id_componente   NUMBER(20) NOT NULL,
                                  id_empresa      NUMBER(20) NOT NULL,
                                  id_contrato     NUMBER(20) NOT NULL
);

ALTER TABLE template_empresa ADD CONSTRAINT krs_indice_02503 PRIMARY KEY ( id );

ALTER TABLE template_empresa
    ADD CONSTRAINT krs_indice_02523 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id );

ALTER TABLE template_empresa
    ADD CONSTRAINT krs_indice_02524 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );

--
CREATE TABLE template_unidades_ciee (
                                        id                NUMBER(20) NOT NULL,
                                        id_componente     NUMBER(20) NOT NULL,
                                        id_unidade_ciee   NUMBER(19) NOT NULL
);

ALTER TABLE template_unidades_ciee ADD CONSTRAINT krs_indice_02504 PRIMARY KEY ( id );



ALTER TABLE template_unidades_ciee
    ADD CONSTRAINT krs_indice_02527 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES rep_unidades_ciee ( id );



--PK-8495 - Manter Cadastro de Quafificação com Notas
--PK-8502 - Qualificar estudante
--PK-8501 - Registrar resultado da avaliação do estudante

CREATE TABLE ASSUNTOS_QUALIFICACAO (
                                          id               NUMBER(20) NOT NULL,
                                          disciplina       VARCHAR2(255),
                                          criado_por       VARCHAR2(255),
                                          data_criacao     TIMESTAMP NOT NULL,
                                          data_alteracao   TIMESTAMP,
                                          modificado_por   VARCHAR2(255),
                                          deletado         NUMBER(1)
);

ALTER TABLE ASSUNTOS_QUALIFICACAO ADD CONSTRAINT krs_indice_02522 PRIMARY KEY ( id );


--
CREATE TABLE qualificacao (
                              id                NUMBER(20) NOT NULL,
                              id_assunto        NUMBER(20) NOT NULL,
                              nome              VARCHAR2(255) NOT NULL,
                              nivel             NUMBER(1),
                              situacao          NUMBER(1),
                              numero_questoes   NUMBER(4),
                              nota_minima       NUMBER(4),
                              nota_maxima       NUMBER(4),
                              criado_por        VARCHAR2(255),
                              data_criacao      TIMESTAMP NOT NULL,
                              data_alteracao    TIMESTAMP,
                              modificado_por    VARCHAR2(255),
                              deletado          NUMBER(1)
);

COMMENT ON COLUMN qualificacao.nivel IS
    'ENUM:

0 - medio-técnico
1 - superior';

COMMENT ON COLUMN qualificacao.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

ALTER TABLE qualificacao ADD CONSTRAINT krs_indice_02521 PRIMARY KEY ( id );

ALTER TABLE qualificacao
    ADD CONSTRAINT krs_indice_02525 FOREIGN KEY ( id_assunto )
        REFERENCES ASSUNTOS_QUALIFICACAO ( id );


--
CREATE TABLE qualificacoes_estudante (
                                         id                     NUMBER(20) NOT NULL,
                                         id_estudante           NUMBER(20) NOT NULL,
                                         id_qualificacao        NUMBER(20) NOT NULL,
                                         nome                   VARCHAR2(255),
                                         motivos_qualificacao   VARCHAR2(255),
                                         nota_obtida            NUMBER(4),
                                         data_execucao          TIMESTAMP,
                                         resultado              NUMBER(1),
                                         data_validade          TIMESTAMP,
                                         situacao               NUMBER(1),
                                         criado_por             VARCHAR2(255),
                                         data_criacao           TIMESTAMP NOT NULL,
                                         modificado_por         VARCHAR2(255),
                                         deletado               NUMBER(1)
);

COMMENT ON COLUMN qualificacoes_estudante.resultado IS
    'ENUM:

0 - Aprovado
1 - Reporvado';

COMMENT ON COLUMN qualificacoes_estudante.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

ALTER TABLE qualificacoes_estudante ADD CONSTRAINT krs_indice_02523v3 PRIMARY KEY ( id );

ALTER TABLE qualificacoes_estudante
    ADD CONSTRAINT krs_indice_02526 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );

ALTER TABLE qualificacoes_estudante
    ADD CONSTRAINT krs_indice_02528 FOREIGN KEY ( id_qualificacao )
        REFERENCES qualificacao ( id );



--PK-4544 - Incluir Prova Online
--PK-8499 - Consultar / Editar Prova Online

--FK-1159 - EXCLUIDA
DROP TABLE MODELOS_PROVA CASCADE CONSTRAINTS;

--

CREATE TABLE prova (
                       id               NUMBER(20) NOT NULL,
                       nome             VARCHAR2(150) NOT NULL,
                       descricao        VARCHAR2(255),
                       tempo_prova      NUMBER(4) NOT NULL,
                       situacao         NUMBER(1),
                       status           NUMBER(1),
                       data_inicial     TIMESTAMP NOT NULL,
                       data_final       TIMESTAMP NOT NULL,
                       criado_por       VARCHAR2(255),
                       data_criacao     TIMESTAMP NOT NULL,
                       data_alteracao   TIMESTAMP,
                       modificado_por   VARCHAR2(255),
                       deletado         NUMBER(1)
);

COMMENT ON COLUMN prova.tempo_prova IS
    'tempo máximo recomendado para realizar a prova (em minutos) (obrigatório)';

COMMENT ON COLUMN prova.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

COMMENT ON COLUMN prova.status IS
    'ENUM:

0 - Em construcao
1 - Finalizado';

ALTER TABLE prova ADD CONSTRAINT krs_indice_02540 PRIMARY KEY ( id );


--

CREATE TABLE questoes (
                          id                   NUMBER(20) NOT NULL,
                          descricao_questoes   VARCHAR2(250),
                          imagem_questoes      VARCHAR2(150),
                          situacao             NUMBER(1),
                          criado_por           VARCHAR2(255),
                          data_criacao         TIMESTAMP NOT NULL,
                          data_alteracao       TIMESTAMP,
                          modificado_por       VARCHAR2(255),
                          deletado             NUMBER(1)
);

COMMENT ON COLUMN questoes.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

ALTER TABLE questoes ADD CONSTRAINT krs_indice_02541 PRIMARY KEY ( id );


--

CREATE TABLE respostas (
                           id                    NUMBER(20) NOT NULL,
                           id_questao            NUMBER(20) NOT NULL,
                           descricao_respostas   VARCHAR2(150),
                           correta               NUMBER(1),
                           imagem_questoes       VARCHAR2(150),
                           situacao              NUMBER(1),
                           criado_por            VARCHAR2(255),
                           data_criacao          TIMESTAMP NOT NULL,
                           data_alteracao        TIMESTAMP,
                           modificado_por        VARCHAR2(255),
                           deletado              NUMBER(1)
);

COMMENT ON COLUMN respostas.correta IS
    'ENUM:

0 - Sim
1 - Nao';

COMMENT ON COLUMN respostas.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

ALTER TABLE respostas ADD CONSTRAINT krs_indice_02542 PRIMARY KEY ( id );

ALTER TABLE respostas
    ADD CONSTRAINT krs_indice_02543 FOREIGN KEY ( id_questao )
        REFERENCES questoes ( id );


--

CREATE TABLE "PROVAS_QUESTOES" (
                                   id_prova      NUMBER(20) NOT NULL,
                                   id_questoes   NUMBER(20) NOT NULL
);

ALTER TABLE "PROVAS_QUESTOES"
    ADD CONSTRAINT krs_indice_02560 FOREIGN KEY ( id_prova )
        REFERENCES prova ( id );

ALTER TABLE "PROVAS_QUESTOES"
    ADD CONSTRAINT krs_indice_02561 FOREIGN KEY ( id_questoes )
        REFERENCES questoes ( id );

--

ALTER TABLE tipo_prova
    ADD CONSTRAINT krs_indice_02562 FOREIGN KEY ( id_prova )
        REFERENCES prova ( id );


--

CREATE SEQUENCE SEQ_TEMPLATE_EMPRESA  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_TEMPLATE_UNIDADES_CIEE  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_ASSUNTOS_QUALIFICACAO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_QUALIFICACAO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_QUALIFICACOES_ESTUDANTE  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_QUESTOES  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_RESPOSTAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PROVA  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;