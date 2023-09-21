--Migration inicial Sprint 14 - Service_Vagas

--PK-9009 - Detalhar Contratos de Estágio / Aprendiz - GMC
--PK-9000 - Agendar Contato GMC
--PK-9001 - Incluir follow-up GMC
--PK-9003 - Incluir Follow-up de Contratos em Lote
--PK-9004 - Agendar Contato GMC em Lote

ALTER TABLE ACOMPANHAMENTOS MODIFY CODIGO_VAGA NOT NULL;
ALTER TABLE AGENDA_EMPRESA MODIFY CODIGO_VAGA NOT NULL;

ALTER TABLE ACOMPANHAMENTOS DROP COLUMN ID_CONTR_EMP_EST;
ALTER TABLE AGENDA_EMPRESA DROP COLUMN ID_CONTR_EMP_EST;

ALTER TABLE ACOMPANHAMENTOS RENAME TO ACOMPANHAMENTOS_VAGAS;
ALTER TABLE AGENDA_EMPRESA RENAME TO AGENDA_EMPRESA_VAGA;

--
CREATE TABLE status_acompanhamentos_contratados (
                                                    id               NUMBER(20) NOT NULL,
                                                    descricao        VARCHAR2(150),
                                                    gera_agenda      NUMBER,
                                                    deletado         NUMBER,
                                                    data_criacao     TIMESTAMP,
                                                    data_alteracao   TIMESTAMP,
                                                    criado_por       VARCHAR2(255),
                                                    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN status_acompanhamentos_contratados.gera_agenda IS
    'Flag 0 ou 1

';

ALTER TABLE status_acompanhamentos_contratados ADD CONSTRAINT krs_indice_03807 PRIMARY KEY ( id );


--
CREATE TABLE acompanhamentos_contratados (
                                             id                 NUMBER(20) NOT NULL,
                                             id_status_acomp    NUMBER(20) NOT NULL,
                                             id_contr_emp_est   NUMBER(20) NOT NULL,
                                             descricao          CLOB,
                                             contato            VARCHAR2(60),
                                             ddd_fone_contato   VARCHAR2(2),
                                             fone_contato       VARCHAR2(60),
                                             tipo_processo      NUMBER(1),
                                             tipo_registro      NUMBER(1),
                                             id_usuario         NUMBER(19) NOT NULL,
                                             deletado           NUMBER,
                                             data_criacao       TIMESTAMP,
                                             data_alteracao     TIMESTAMP,
                                             criado_por         VARCHAR2(255),
                                             modificado_por     VARCHAR2(255)
);

COMMENT ON COLUMN acompanhamentos_contratados.tipo_processo IS
    'ENUM:

0 - VAGAS
1 - CONTRATOS';

COMMENT ON COLUMN acompanhamentos_contratados.tipo_registro IS
    'ENUM:

0 - MANUAL
1 - AUTOMATICO';

ALTER TABLE acompanhamentos_contratados ADD CONSTRAINT krs_indice_03806 PRIMARY KEY ( id );

ALTER TABLE acompanhamentos_contratados
    ADD CONSTRAINT krs_indice_03805 FOREIGN KEY ( id_usuario )
        REFERENCES rep_usuarios ( id );

ALTER TABLE acompanhamentos_contratados
    ADD CONSTRAINT krs_indice_03810 FOREIGN KEY ( id_status_acomp )
        REFERENCES status_acompanhamentos_contratados ( id );

ALTER TABLE acompanhamentos_contratados
    ADD CONSTRAINT krs_indice_03811 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );


--
CREATE TABLE agendas_empresas_contratados (
                                              id                 NUMBER(20) NOT NULL,
                                              id_empresa         NUMBER(20) NOT NULL,
                                              id_status_acomp    NUMBER(20) NOT NULL,
                                              id_contr_emp_est   NUMBER(20) NOT NULL,
                                              assunto            CLOB,
                                              data_hora          TIMESTAMP,
                                              id_usuario         NUMBER(19) NOT NULL,
                                              deletado           NUMBER,
                                              data_criacao       TIMESTAMP,
                                              data_alteracao     TIMESTAMP,
                                              criado_por         VARCHAR2(255),
                                              modificado_por     VARCHAR2(255)
);

ALTER TABLE agendas_empresas_contratados ADD CONSTRAINT krs_indice_03808 PRIMARY KEY ( id );

ALTER TABLE agendas_empresas_contratados
    ADD CONSTRAINT krs_indice_03804 FOREIGN KEY ( id_usuario )
        REFERENCES rep_usuarios ( id );

ALTER TABLE agendas_empresas_contratados
    ADD CONSTRAINT krs_indice_03812 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id );

ALTER TABLE agendas_empresas_contratados
    ADD CONSTRAINT krs_indice_03813 FOREIGN KEY ( id_status_acomp )
        REFERENCES status_acompanhamentos_contratados ( id );

ALTER TABLE agendas_empresas_contratados
    ADD CONSTRAINT krs_indice_03814 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );



--PK-9168 - Cancelar Contrato Estagiário ou Aprendiz Capacitador
ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD DATA_IMPEDIMENTO_INICIO TIMESTAMP;
ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD DATA_IMPEDIMENTO_FIM TIMESTAMP;
ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD PARAMETRO_IMPEDIMENTO NUMBER (3);
ALTER TABLE REP_PARAMETROS_PROGRAMA_APR ADD DESCRICAO_IMPEDIMENTO VARCHAR2 (150);

ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD DATA_IMPEDIMENTO_INICIO TIMESTAMP;
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD DATA_IMPEDIMENTO_FIM TIMESTAMP;
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD PARAMETRO_IMPEDIMENTO NUMBER (3);
ALTER TABLE REP_PARAMETROS_PROGRAMA_EST ADD DESCRICAO_IMPEDIMENTO VARCHAR2 (150);


--PK-9148 - Importar Motivos de Rescisão Contratados Estagio e Aprendiz
--PK-9006 - Efetuar Rescisão de Contrato de Estágio
--PK-9010 - Efetuar Rescisão de Contrato de Aprendizagem
CREATE TABLE motivos_rescisao_contratados (
                                              id                              NUMBER(20) NOT NULL,
                                              codigo                          NUMBER(20) NOT NULL,
                                              descricao                       VARCHAR2(150) NOT NULL,
                                              tipo_contrato                   NUMBER(1),
                                              perfil_acesso                   NUMBER(1),
                                              acesso_ciee                     NUMBER(1),
                                              tempo_reversao                  NUMBER DEFAULT 0,
                                              perm_emiss_declaracao_estag     NUMBER(1) DEFAULT 0,
                                              perm_emiss_termo_realiz_estag   NUMBER(1) DEFAULT 0,
                                              situacao                        NUMBER(1),
                                              deletado                        NUMBER,
                                              data_criacao                    TIMESTAMP NOT NULL,
                                              data_alteracao                  TIMESTAMP NOT NULL,
                                              criado_por                      VARCHAR2(255) NOT NULL,
                                              modificado_por                  VARCHAR2(255) NOT NULL
);

COMMENT ON COLUMN motivos_rescisao_contratados.tipo_contrato IS
    'ENUM:

0-CONTRATOS DE ESTÁGIO
1-APRENDIZ
3-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.perfil_acesso IS
    'ENUM:

0-CIEE
1-EMPRESA
3-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.acesso_ciee IS
    'ENUM:

0-SP
1-RJ
3-AMBOS';

COMMENT ON COLUMN motivos_rescisao_contratados.tempo_reversao IS
    '0 NÃO TEM PRAZO CONTROLE DE PRAZO
XX PRAZO DE DIAS APÓS A RESCISÃO PARA REVERSÃO.';

COMMENT ON COLUMN motivos_rescisao_contratados.perm_emiss_declaracao_estag IS
    'Permite Emissão de Declaração de Estagio (S/N) default ''0-SIM''

ENUM:

0-SIM
1-NAO';

COMMENT ON COLUMN motivos_rescisao_contratados.perm_emiss_termo_realiz_estag IS
    'Permite Emissão de Termo de Realização de Estagio (S/N) default ''SIM''

ENUM:

0-SIM
1-NAO';

COMMENT ON COLUMN motivos_rescisao_contratados.situacao IS
    'ENUM:

0-ATIVO
1-INATIVO';

ALTER TABLE motivos_rescisao_contratados ADD CONSTRAINT krs_indice_03825 PRIMARY KEY ( id );

--
ALTER TABLE contratos_estudantes_empresa ADD id_motivo_rescisao_contratado NUMBER(20);
ALTER TABLE hist_contratos_estudantes_empresa ADD id_motivo_rescisao_contratado NUMBER(20);


--
ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_03824 FOREIGN KEY ( id_motivo_rescisao_contratado )
        REFERENCES motivos_rescisao_contratados ( id );

--
ALTER TABLE hist_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_03826 FOREIGN KEY ( id_motivo_rescisao_contratado )
        REFERENCES motivos_rescisao_contratados ( id );


--PK-9011 - Enviar Baixa de Contrato para Secretaria
--PK-9012 - Enviar Cancelamento da Baixa de Contrato para Secretaria
--PK-9013 - Solicitar Rescisão de Contrato - Estagiário e Aprendiz
--PK-9015 - Solicitar Prorrogação de Contrato de Estágio
CREATE TABLE solicitacoes_servicenow (
                                         id                      NUMBER(20) NOT NULL,
                                         id_contr_emp_est        NUMBER(20) NOT NULL,
                                         deletado                NUMBER,
                                         data_criacao            TIMESTAMP NOT NULL,
                                         data_alteracao          TIMESTAMP NOT NULL,
                                         criado_por              VARCHAR2(255) NOT NULL,
                                         modificado_por          VARCHAR2(255) NOT NULL,
                                         TIPO_SOLICITACAO     	 NUMBER,
                                         numero_ticket           NUMBER(20) NOT NULL,
                                         data_hora_solicitacao   TIMESTAMP,
                                         situacao_ticket         VARCHAR2(255),
                                         situacao_final_ticket   VARCHAR2(255)
);

COMMENT ON COLUMN solicitacoes_servicenow.TIPO_SOLICITACAO IS
    'ENUM:
0-Rescisão de contrato de estágio ou aprendiz
1-Cancelamento de contrato de estágio ou aprendiz
2-Cancelamento Prorrogação
3-Cancelamento de Rescisão
4-Cancelamento de Baixa
5-Solicitação de Alteração de férias
6-Solicitação de Alteração de Horário
7-Solicitação de Alteração de Local de Contrato
8-Solicitações de descontos
9-Solicitação de acompanhamento do Aprendiz
10-Solicitação de Alteração do Monitor do Aprendiz
11-Solicitar Alteração de Vale Transporte
12-Solicitar Alteração de VR/VA
13-Solicitação de Pedido de Demissão
14-Visualizar holerite
15-Consultar programação de férias
16-Comunicar afastamento'
;

ALTER TABLE solicitacoes_servicenow ADD CONSTRAINT krs_indice_03844 PRIMARY KEY ( id );

ALTER TABLE solicitacoes_servicenow
    ADD CONSTRAINT krs_indice_03845 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );


--
CREATE TABLE resultados_provas (
                                   id                         NUMBER(20) NOT NULL,
                                   deletado                   NUMBER,
                                   data_criacao               TIMESTAMP NOT NULL,
                                   data_alteracao             TIMESTAMP NOT NULL,
                                   criado_por                 VARCHAR2(255) NOT NULL,
                                   modificado_por             VARCHAR2(255) NOT NULL,
                                   id_estudante               NUMBER(20) NOT NULL,
                                   id_pergunta                NUMBER(20) NOT NULL,
                                   id_resposta                NUMBER(20),
                                   pontuacao_obtida_questao   NUMBER(3) NOT NULL,
                                   tempo_realizacao_prova     NUMBER(4) NOT NULL,
                                   data_inicio_prova          TIMESTAMP NOT NULL,
                                   data_finalizacao_prova     TIMESTAMP NOT NULL,
                                   finalizada                 NUMBER NOT NULL,
                                   pendente                   NUMBER NOT NULL
);

COMMENT ON COLUMN resultados_provas.id_resposta IS
    'nulo se não respondeu';

COMMENT ON COLUMN resultados_provas.pontuacao_obtida_questao IS
    'zero se não respondeu';

COMMENT ON COLUMN resultados_provas.tempo_realizacao_prova IS
    'em minutos';

COMMENT ON COLUMN resultados_provas.finalizada IS
    'Percorreu todas as questões respondendo ou não
0-Sim
1-Nao';

COMMENT ON COLUMN resultados_provas.pendente IS
    'Não percorreu todas as questões da prova
0-Sim
1-Nao';

ALTER TABLE resultados_provas ADD CONSTRAINT krs_indice_03846 PRIMARY KEY ( id );

ALTER TABLE resultados_provas
    ADD CONSTRAINT krs_indice_03847 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );


--PK-9021 - Receber resultado de entrevista online (integração Recrutei)
CREATE TABLE dados_score_card (
                                  id                         NUMBER(20) NOT NULL,
                                  deletado                   NUMBER,
                                  data_criacao               TIMESTAMP NOT NULL,
                                  data_alteracao             TIMESTAMP NOT NULL,
                                  criado_por                 VARCHAR2(255) NOT NULL,
                                  modificado_por             VARCHAR2(255) NOT NULL,
                                  codigo_score               NUMBER(20) NOT NULL,
                                  descricao_score            VARCHAR2(150),
                                  codigo_pontuacao           NUMBER(20) NOT NULL,
                                  descricao_tipo_pontuacao   VARCHAR2(150),
                                  valor_pontuacao            NUMBER(4) NOT NULL
);

ALTER TABLE dados_score_card ADD CONSTRAINT krs_indice_03849 PRIMARY KEY ( id );

--
CREATE TABLE resultados_entrevistas_online (
                                               id                   NUMBER(20) NOT NULL,
                                               deletado             NUMBER,
                                               data_criacao         TIMESTAMP NOT NULL,
                                               data_alteracao       TIMESTAMP NOT NULL,
                                               criado_por           VARCHAR2(255) NOT NULL,
                                               modificado_por       VARCHAR2(255) NOT NULL,
                                               id_vaga              NUMBER(20) NOT NULL,
                                               id_etapa             NUMBER(20) NOT NULL,
                                               id_estudante         NUMBER(20) NOT NULL,
                                               id_usuario_empresa   NUMBER(20) NOT NULL,
                                               descricao            VARCHAR2(255),
                                               id_dado_score_card   NUMBER(20) NOT NULL
);

ALTER TABLE resultados_entrevistas_online ADD CONSTRAINT krs_indice_03848 PRIMARY KEY ( id );

ALTER TABLE resultados_entrevistas_online
    ADD CONSTRAINT krs_indice_03851 FOREIGN KEY ( id_etapa )
        REFERENCES etapas_processo_seletivo ( id );

ALTER TABLE resultados_entrevistas_online
    ADD CONSTRAINT krs_indice_03852 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );

ALTER TABLE resultados_entrevistas_online
    ADD CONSTRAINT krs_indice_03853 FOREIGN KEY ( id_dado_score_card )
        REFERENCES dados_score_card ( id );


--PK-9176 - Importar Motivos de Cancelamento de Contratados Estagio ou Aprendiz
ALTER TABLE contratos_estudantes_empresa ADD id_motivo_cancelamento_contratado NUMBER(20);
ALTER TABLE hist_contratos_estudantes_empresa ADD id_motivo_cancelamento_contratado NUMBER(20);

--
CREATE TABLE motivos_cancelamentos_contratados (
                                                   id               NUMBER(20) NOT NULL,
                                                   codigo           NUMBER(20) NOT NULL,
                                                   descricao        VARCHAR2(150) NOT NULL,
                                                   tipo_contrato    NUMBER(1),
                                                   perfil_acesso    NUMBER(1),
                                                   acesso_ciee      NUMBER(1),
                                                   tempo_reversao   NUMBER DEFAULT 0,
                                                   situacao         NUMBER(1),
                                                   deletado         NUMBER,
                                                   data_criacao     TIMESTAMP NOT NULL,
                                                   data_alteracao   TIMESTAMP NOT NULL,
                                                   criado_por       VARCHAR2(255) NOT NULL,
                                                   modificado_por   VARCHAR2(255) NOT NULL
);

COMMENT ON COLUMN motivos_cancelamentos_contratados.tipo_contrato IS
    'ENUM:

0-CONTRATOS DE ESTÁGIO
1-APRENDIZ
3-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.perfil_acesso IS
    'ENUM:

0-CIEE
1-EMPRESA
3-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.acesso_ciee IS
    'ENUM:

0-SP
1-RJ
3-AMBOS';

COMMENT ON COLUMN motivos_cancelamentos_contratados.tempo_reversao IS
    '0 NÃO TEM PRAZO CONTROLE DE PRAZO
XX PRAZO DE DIAS APÓS A RESCISÃO PARA REVERSÃO.';

COMMENT ON COLUMN motivos_cancelamentos_contratados.situacao IS
    'ENUM:

0-ATIVO
1-INATIVO';

ALTER TABLE motivos_cancelamentos_contratados ADD CONSTRAINT krs_indice_03855 PRIMARY KEY ( id );

--
ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_03854 FOREIGN KEY ( id_motivo_cancelamento_contratado )
        REFERENCES motivos_cancelamentos_contratados ( id );

--
ALTER TABLE hist_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_03856 FOREIGN KEY ( id_motivo_cancelamento_contratado )
        REFERENCES motivos_cancelamentos_contratados ( id );


--PK-9218 - Gerenciar assinatura-cabeçalho de IE
CREATE TABLE parametros_contratos_ie (
                                         id                         NUMBER(20) NOT NULL,
                                         deletado                   NUMBER,
                                         data_criacao               TIMESTAMP NOT NULL,
                                         data_alteracao             TIMESTAMP NOT NULL,
                                         criado_por                 VARCHAR2(255) NOT NULL,
                                         modificado_por             VARCHAR2(255) NOT NULL,
                                         assinar_eletronicamente    NUMBER(1) DEFAULT 1 NOT NULL,
                                         possui_cabecalho_proprio   NUMBER(1) DEFAULT 1,
                                         id_instituicao_ensino      NUMBER(20) NOT NULL
);

COMMENT ON COLUMN parametros_contratos_ie.assinar_eletronicamente IS
    'ENUM:
0-SIM
1-NAO';

COMMENT ON COLUMN parametros_contratos_ie.possui_cabecalho_proprio IS
    'ENUM:
0-SIM
1-NAO';

ALTER TABLE parametros_contratos_ie ADD CONSTRAINT krs_indice_03858 PRIMARY KEY ( id );

ALTER TABLE parametros_contratos_ie
    ADD CONSTRAINT krs_indice_03859 FOREIGN KEY ( id_instituicao_ensino )
        REFERENCES rep_instituicoes_ensinos ( id );


--PK-9220 - Gerenciar ass de contratos das empresas
CREATE TABLE params_ass_contratos_empresas (
                                               id                         NUMBER(20) NOT NULL,
                                               deletado                   NUMBER,
                                               data_criacao               TIMESTAMP NOT NULL,
                                               data_alteracao             TIMESTAMP NOT NULL,
                                               criado_por                 VARCHAR2(255) NOT NULL,
                                               modificado_por             VARCHAR2(255) NOT NULL,
                                               assinar_eletronicamente    NUMBER(1) DEFAULT 0,
                                               possui_logo_proprio        NUMBER(1) DEFAULT 1,
                                               possui_imagem_assinatura   NUMBER(1) DEFAULT 1,
                                               id_img_logo                NUMBER(20),
                                               id_img_assinatura          NUMBER(20) NOT NULL,
                                               id_contratos               NUMBER NOT NULL
);

COMMENT ON COLUMN params_ass_contratos_empresas.assinar_eletronicamente IS
    'ENUM:
0-SIM
1-NAO';

COMMENT ON COLUMN params_ass_contratos_empresas.possui_logo_proprio IS
    'ENUM:
0-SIM
1-NAO';

COMMENT ON COLUMN params_ass_contratos_empresas.possui_imagem_assinatura IS
    'ENUM:
0-SIM
1-NAO';

ALTER TABLE params_ass_contratos_empresas ADD CONSTRAINT krs_indice_03857 PRIMARY KEY ( id );

ALTER TABLE params_ass_contratos_empresas
    ADD CONSTRAINT krs_indice_03860 FOREIGN KEY ( id_contratos )
        REFERENCES rep_contratos ( id );


--PS
ALTER TABLE contratos_estudantes_empresa ADD emissao_documento_pendente NUMBER;
ALTER TABLE hist_contratos_estudantes_empresa ADD emissao_documento_pendente NUMBER;

COMMENT ON COLUMN contratos_estudantes_empresa.emissao_documento_pendente IS
    'Flag para identificar pendência de emissão de documento.';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.emissao_documento_pendente IS
    'Flag para identificar pendência de emissão de documento.';



--SEQUENCES
CREATE SEQUENCE SEQ_status_acompanhamentos_contratados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_acompanhamentos_contratados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_agendas_empresas_contratados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_motivos_rescisao_contratados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_solicitacoes_servicenow MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_resultados_provas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_dados_score_card MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_resultados_entrevistas_online MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_motivos_cancelamentos_contratados MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_parametros_contratos_ie MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_params_ass_contratos_empresas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;