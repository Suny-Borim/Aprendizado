--Migration inicial Sprint 13 - Service_Vagas

--PK-6882 - Criar Componentes p/ Modelos de Documento
--PK-6850 - Gravar Contrato de Estágio
Insert into REP_PARAMETROS_EMPRESA (ID,DESCRICAO,LOCAL_PARAMETRO,TIPO_PARAMETRO,TIPO_CONTRATO,MSG_BACKOFFICE,MSG_EMPRESA,MSG_ESTUDANTE,SITUACAO,LOGIN,DELETADO,DATA_CRIACAO,DATA_ALTERACAO,CRIADO_POR,MODIFICADO_POR) values ('17','Impressao Norma 7789 (SEG.Trab)','C','R','E','Assinou a normativa 7789.2014 (Seguranca do Trabalho) Sim/Não','Assinou a normativa 7789.2014 (Seguranca do Trabalho) Sim/Não','Assinou a normativa 7789.2014 (Seguranca do Trabalho) Sim/Não','1',null,'0',to_timestamp('30/01/19 08:50:46,166448000','DD/MM/RR HH24:MI:SSXFF'),to_timestamp('30/01/19 08:50:46,166448000','DD/MM/RR HH24:MI:SSXFF'),'script_flyway','script_flyway');
Insert into REP_PARAMETROS_ESCOLARES (CRIADO_POR,DATA_CRIACAO,DELETADO,MODIFICADO_POR,DATA_ALTERACAO,ATIVO,DESC_PARAMETRO_ESCOLAR,COD_PARAMETRO_ESCOLAR,MENSAGEM,DESC_PARAM_ESCOLAR_REDUZIDA,ID_TIPO_PARAMETRO,MSG_BACKOFFICE,MSG_EMPRESA,MSG_ESTUDANTE) values ('MIGRACAO', to_timestamp('15/01/19 00:00:00,000000000','DD/MM/RR HH24:MI:SSXFF'),'0','MIGRACAO',to_timestamp('15/01/19 00:00:00,000000000','DD/MM/RR HH24:MI:SSXFF'),'1','Mensagem Orientativa','18','Professor Orientador assina TCE','Professor Orientador assina TCE','1','O professor Orientador Assina o TCE sim/não','O professor Orientador Assina o TCE sim/não','O professor Orientador Assina o TCE sim/não');

--
ALTER TABLE parametros_empresa_contrato ADD usa_norma_seg_trab NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN parametros_empresa_contrato.usa_norma_seg_trab IS 'Se for 1, usar id parametro 17 do PARAMENTROS_EMPRESA (COMPANY)';
ALTER TABLE parametros_ie ADD ASSINA_PROF_ORIENTADOR NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN parametros_ie.assina_prof_orientador IS 'Se for 1, usar id parametro 18 do PARAMENTROS_ESCOLARES (CORE)';

--
ALTER TABLE contratos_estudantes_empresa ADD estagio_obrigatorio NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN contratos_estudantes_empresa.estagio_obrigatorio IS 'sim=1';
ALTER TABLE contratos_estudantes_empresa ADD usa_horario_variavel NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN contratos_estudantes_empresa.usa_horario_variavel IS 'sim=1';
--
ALTER TABLE pre_contratos_estudantes_empresa ADD estagio_obrigatorio NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN pre_contratos_estudantes_empresa.estagio_obrigatorio IS 'sim=1';
ALTER TABLE pre_contratos_estudantes_empresa ADD usa_horario_variavel NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN pre_contratos_estudantes_empresa.usa_horario_variavel IS 'sim=1';
--
ALTER TABLE hist_contratos_estudantes_empresa ADD estagio_obrigatorio NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN hist_contratos_estudantes_empresa.estagio_obrigatorio IS 'sim=1';
ALTER TABLE hist_contratos_estudantes_empresa ADD usa_horario_variavel NUMBER DEFAULT 0 NOT NULL;
COMMENT ON COLUMN hist_contratos_estudantes_empresa.usa_horario_variavel IS 'sim=1';


--PK-8970 - Parâmetro de Comunicação de Contrados de Empresas
--PK-8971 - Alerta de Término de contrato
CREATE TABLE parametros_comunicacoes_empresas (
                                                  id                  NUMBER(20) NOT NULL,
                                                  id_contrato         NUMBER(20),
                                                  id_local_contrato   NUMBER(20),
                                                  email_alerta        NUMBER(1) DEFAULT 0,
                                                  dias_alerta         NUMBER(1) DEFAULT 0,
                                                  criado_por          VARCHAR2(255 BYTE) NOT NULL,
                                                  data_criacao        TIMESTAMP NOT NULL,
                                                  data_alteracao      TIMESTAMP,
                                                  modificado_por      VARCHAR2(255 BYTE),
                                                  deletado            NUMBER
);

COMMENT ON COLUMN parametros_comunicacoes_empresas.email_alerta IS
    'Flag:

0 - Envio de email liberado

1 - Envio de email bloqueado';

COMMENT ON COLUMN parametros_comunicacoes_empresas.dias_alerta IS
    'XX dias de antecedência - XX quantidade de dias antes da data de términos dos contratos de estágio e aprendiz';

ALTER TABLE parametros_comunicacoes_empresas ADD CONSTRAINT krs_indice_03455 PRIMARY KEY ( id );

ALTER TABLE parametros_comunicacoes_empresas
    ADD CONSTRAINT krs_indice_03475 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );

ALTER TABLE parametros_comunicacoes_empresas
    ADD CONSTRAINT krs_indice_03501 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id );

--
CREATE TABLE contatos_principais_empresas (
                                              id                         NUMBER(20) NOT NULL,
                                              id_parametro_com_empresa   NUMBER(20) NOT NULL,
                                              nome                       VARCHAR2(150) NOT NULL,
                                              departamento               VARCHAR2(150),
                                              telefone                   VARCHAR2(60) NOT NULL,
                                              email                      VARCHAR2(150) NOT NULL,
                                              criado_por                 VARCHAR2(255 BYTE) NOT NULL,
                                              data_criacao               TIMESTAMP NOT NULL,
                                              data_alteracao             TIMESTAMP,
                                              modificado_por             VARCHAR2(255 BYTE),
                                              deletado                   NUMBER
);

ALTER TABLE contatos_principais_empresas ADD CONSTRAINT krs_indice_03454 PRIMARY KEY ( id );

ALTER TABLE contatos_principais_empresas
    ADD CONSTRAINT krs_indice_03474 FOREIGN KEY ( id_parametro_com_empresa )
        REFERENCES parametros_comunicacoes_empresas ( id );


--PK-8965 - Dashboard de Acompanhamnento GMC
--PK-8967 - Listar Contratos GMC
ALTER TABLE ACOMPANHAMENTOS_VAGAS ADD ID_CONTR_EMP_EST NUMBER (20);
ALTER TABLE acompanhamentos_vagas
    ADD CONSTRAINT krs_indice_03574 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );

--
CREATE TABLE acompanhamentos_gmc (
                                     id                    NUMBER(20) NOT NULL,
                                     id_contr_emp_est      NUMBER(20) NOT NULL,
                                     tipo_periodo          NUMBER(1),
                                     tipo_acompanhamento   NUMBER(1),
                                     criado_por            VARCHAR2(255 BYTE) NOT NULL,
                                     data_criacao          TIMESTAMP NOT NULL,
                                     data_alteracao        TIMESTAMP,
                                     modificado_por        VARCHAR2(255 BYTE),
                                     deletado              NUMBER
);

COMMENT ON COLUMN acompanhamentos_gmc.tipo_periodo IS
    'ENUM:

0 - 30 dias
1 - 60 dias
2 - 90 dias
3 - 120 dias';

COMMENT ON COLUMN acompanhamentos_gmc.tipo_acompanhamento IS
    'ENUM:

0 - Prorrogação
1 - Reposição
2 - Rescisão
';

ALTER TABLE acompanhamentos_gmc ADD CONSTRAINT krs_indice_03575 PRIMARY KEY ( id );

ALTER TABLE acompanhamentos_gmc
    ADD CONSTRAINT krs_indice_03576 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );


--PK-8972 - Receber via API analise comportamental
--PK-8973 - Visualizar Resultado de Analise Comportamental
CREATE TABLE analises (
                          id                    NUMBER(20) NOT NULL,
                          id_estudante          NUMBER(20) NOT NULL,
                          graph_d               NUMBER(4),
                          graph_i               NUMBER(4),
                          graph_s               NUMBER(4),
                          graph_c               NUMBER(4),
                          graph_di              NUMBER(4),
                          graph_ii              NUMBER(4),
                          graph_si              NUMBER(4),
                          graph_ci              NUMBER(4),
                          payload_full          CLOB,
                          autoriza_visualizar   NUMBER(1),
                          criado_por            VARCHAR2(255 BYTE) NOT NULL,
                          data_criacao          TIMESTAMP NOT NULL,
                          data_alteracao        TIMESTAMP,
                          modificado_por        VARCHAR2(255 BYTE),
                          deletado              NUMBER
);

COMMENT ON COLUMN analises.autoriza_visualizar IS
    'Enum

0-Sim
1-Não

Se efetuar a autorização de exibição a informação ficará disponível ao back-office e a Empresa. ';

ALTER TABLE analises ADD CONSTRAINT krs_indice_03494 PRIMARY KEY ( id );

ALTER TABLE analises
    ADD CONSTRAINT krs_indice_03497 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );


--
CREATE TABLE radar (
                       id               NUMBER(20) NOT NULL,
                       id_analise       NUMBER(20) NOT NULL,
                       comportamento    NUMBER(20),
                       criado_por       VARCHAR2(255 BYTE) NOT NULL,
                       data_criacao     TIMESTAMP NOT NULL,
                       data_alteracao   TIMESTAMP,
                       modificado_por   VARCHAR2(255 BYTE),
                       deletado         NUMBER
);

ALTER TABLE radar ADD CONSTRAINT krs_indice_03496 PRIMARY KEY ( id );

ALTER TABLE radar
    ADD CONSTRAINT krs_indice_03498 FOREIGN KEY ( id_analise )
        REFERENCES analises ( id );


--
CREATE TABLE params (
                        id               NUMBER(20) NOT NULL,
                        id_analise       NUMBER(20) NOT NULL,
                        comportamento    NUMBER(4),
                        criado_por       VARCHAR2(255 BYTE) NOT NULL,
                        data_criacao     TIMESTAMP NOT NULL,
                        data_alteracao   TIMESTAMP,
                        modificado_por   VARCHAR2(255 BYTE),
                        deletado         NUMBER
);

ALTER TABLE params ADD CONSTRAINT krs_indice_03495 PRIMARY KEY ( id );

ALTER TABLE params
    ADD CONSTRAINT krs_indice_03499 FOREIGN KEY ( id_analise )
        REFERENCES analises ( id );


--
CREATE TABLE dics_recrutei (
                               id               NUMBER(20) NOT NULL,
                               comportamento    VARCHAR2(255 BYTE) NOT NULL,
                               traducao         VARCHAR2(255 BYTE) NOT NULL,
                               criado_por       VARCHAR2(255 BYTE) NOT NULL,
                               data_criacao     TIMESTAMP NOT NULL,
                               data_alteracao   TIMESTAMP,
                               modificado_por   VARCHAR2(255 BYTE),
                               deletado         NUMBER
);

ALTER TABLE dics_recrutei ADD CONSTRAINT krs_indice_03514 PRIMARY KEY ( id );


--
CREATE TABLE files_recrutei (
                                id               NUMBER(20) NOT NULL,
                                descricao        VARCHAR2(150 BYTE) NOT NULL,
                                path_icon        VARCHAR2(255 BYTE) NOT NULL,
                                criado_por       VARCHAR2(255 BYTE) NOT NULL,
                                data_criacao     TIMESTAMP NOT NULL,
                                data_alteracao   TIMESTAMP,
                                modificado_por   VARCHAR2(255 BYTE),
                                deletado         NUMBER
);

ALTER TABLE files_recrutei ADD CONSTRAINT krs_indice_03515 PRIMARY KEY ( id );


--PK-8496 - Registrar origem vulnerável
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD ID_LOCAIS_ENCAMINHAMENTO_SOCIAL	NUMBER;
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD RENDA_MENSAL NUMBER (15,2);
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD PESSOAS_MORANDO_JUNTO NUMBER (2);
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD PARTICIPA_PROGRAMA_RENDA NUMBER (1);
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD ID_PROGRAMA_RENDA NUMBER (19);
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD ID_INCENTIVO_EDUCACIONAL NUMBER (19);
ALTER TABLE REP_INFORMACOES_SOCIAIS ADD IDENTIFICADOR_CADUNICO VARCHAR2 (20 BYTE);

--
CREATE TABLE rep_locais_encaminhamento_social (
                                                  id                   NUMBER NOT NULL,
                                                  id_programa_social   NUMBER(19) NOT NULL,
                                                  descricao            VARCHAR2(300 BYTE) NOT NULL,
                                                  ativo                NUMBER(1) DEFAULT 1 NOT NULL,
                                                  id_responsavel       NUMBER NOT NULL,
                                                  criado_por           VARCHAR2(255 CHAR),
                                                  data_criacao         TIMESTAMP NOT NULL,
                                                  deletado             NUMBER(1) NOT NULL,
                                                  modificado_por       VARCHAR2(255 CHAR),
                                                  data_alteracao       TIMESTAMP NOT NULL
);

COMMENT ON TABLE rep_locais_encaminhamento_social IS
    'Réplica da tabela LOCAIS_ENCAMINHAMENTO_SOCIAL do Service_Core';

ALTER TABLE rep_locais_encaminhamento_social ADD CONSTRAINT krs_indice_03577 PRIMARY KEY ( id );


--
ALTER TABLE rep_informacoes_sociais
    ADD CONSTRAINT krs_indice_03578 FOREIGN KEY ( id_locais_encaminhamento_social )
        REFERENCES rep_locais_encaminhamento_social ( id );


--PK-8968 - Implementar a Qualificação em Vagas
--PK-8969 - Implementar a Qualificação em Triagem
CREATE TABLE vinculo_qualificacao_vaga (
                                           id_vaga_estagio    NUMBER(20),
                                           id_vaga_aprendiz   NUMBER(20),
                                           id_qualificacao    NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_qualificacao_vaga
    ADD CONSTRAINT krs_indice_03594 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id );

ALTER TABLE vinculo_qualificacao_vaga
    ADD CONSTRAINT krs_indice_03595 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id );

ALTER TABLE vinculo_qualificacao_vaga
    ADD CONSTRAINT krs_indice_03596 FOREIGN KEY ( id_qualificacao )
        REFERENCES qualificacao ( id );