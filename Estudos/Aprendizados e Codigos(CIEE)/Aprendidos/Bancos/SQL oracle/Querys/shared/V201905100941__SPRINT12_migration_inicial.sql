-- Migration inicial Sprint_12 - Service Vagas v1
--

-- PK-8738
ALTER TABLE contratos_estudantes_empresa ADD tipo_aprendiz NUMBER(1);

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_aprendiz IS
    'Flag:

0 - Capacitador
1 - Empregador';


-- PK-6853/6870/7007/8432
CREATE TABLE contrato_ta (
                             id                 NUMBER(20) NOT NULL,
                             id_contr_emp_est   NUMBER(20),
                             descricao_campo    VARCHAR2(40),
                             deletado           NUMBER,
                             data_criacao       TIMESTAMP,
                             data_alteracao     TIMESTAMP,
                             criado_por         VARCHAR2(255),
                             modificado_por     VARCHAR2(255)
);

ALTER TABLE contrato_ta ADD CONSTRAINT krs_indice_02720 PRIMARY KEY ( id );

CREATE TABLE hist_areas_atuacao_contr_emp_est (
                                                  id_contr_emp_est      NUMBER(20) NOT NULL,
                                                  codigo_area_atuacao   NUMBER(20) NOT NULL
);

CREATE TABLE hist_atividades_contr_emp_est (
                                               id_contr_emp_est   NUMBER(20) NOT NULL,
                                               codigo_atividade   NUMBER(20) NOT NULL
);

CREATE TABLE hist_beneficios_contr_emp (
                                           id                 NUMBER(20) NOT NULL,
                                           id_contr_emp_est   NUMBER(20) NOT NULL,
                                           id_beneficio       NUMBER(20) NOT NULL,
                                           valor              NUMBER(10, 2),
                                           deletado           NUMBER,
                                           data_criacao       TIMESTAMP,
                                           data_alteracao     TIMESTAMP,
                                           criado_por         VARCHAR2(255 BYTE),
                                           modificado_por     VARCHAR2(255 BYTE)
);

ALTER TABLE hist_beneficios_contr_emp ADD CONSTRAINT krs_indice_02750 PRIMARY KEY ( id );

CREATE TABLE hist_contratos_cursos_capacitacao (
                                                   id                          NUMBER(20) NOT NULL,
                                                   id_contr_emp_est            NUMBER(20) NOT NULL,
                                                   id_curso_capacitacao        NUMBER(20) NOT NULL,
                                                   nome_curso                  VARCHAR2(255 BYTE) NOT NULL,
                                                   descricao_area_atuacao      VARCHAR2(255 BYTE) NOT NULL,
                                                   id_turma                    NUMBER(20) NOT NULL,
                                                   sala                        VARCHAR2(10 BYTE) NOT NULL,
                                                   id_local                    NUMBER(20) NOT NULL,
                                                   descricao_local             VARCHAR2(150 BYTE) NOT NULL,
                                                   endereco                    VARCHAR2(255 BYTE) NOT NULL,
                                                   numero                      VARCHAR2(10 BYTE) NOT NULL,
                                                   complemento                 VARCHAR2(50 BYTE),
                                                   bairro                      VARCHAR2(100 BYTE) NOT NULL,
                                                   cep                         VARCHAR2(8 BYTE) NOT NULL,
                                                   cidade                      VARCHAR2(100) NOT NULL,
                                                   uf                          VARCHAR2(2 BYTE) NOT NULL,
                                                   deletado                    NUMBER,
                                                   data_criacao                TIMESTAMP NOT NULL,
                                                   data_alteracao              TIMESTAMP,
                                                   criado_por                  VARCHAR2(255 BYTE) NOT NULL,
                                                   modificado_por              VARCHAR2(255 BYTE),
                                                   data_inicio                 TIMESTAMP NOT NULL,
                                                   data_inicio_personalizada   TIMESTAMP,
                                                   usa_data_personalizada      NUMBER(1),
                                                   horario_curso               VARCHAR2(20 BYTE) NOT NULL,
                                                   dia_capacitacao             VARCHAR2(50 BYTE) NOT NULL,
                                                   carga_horaria_teorica       NUMBER(5) NOT NULL,
                                                   carga_horaria_pratica       NUMBER(5) NOT NULL,
                                                   tipo_turma                  VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE hist_contratos_cursos_capacitacao ADD CONSTRAINT krs_indice_02732 PRIMARY KEY ( id );

CREATE TABLE hist_contratos_estudantes_empresa (
                                                   id                                       NUMBER(20) NOT NULL,
                                                   id_local_contrato                        NUMBER(20) NOT NULL,
                                                   id_estudante                             NUMBER(20) NOT NULL,
                                                   tipo_contrato                            VARCHAR2(1),
                                                   id_curso_capacitacao                     NUMBER(20),
                                                   carga_horaria                            TIMESTAMP,
                                                   faixa_etaria_inicial                     NUMBER(2),
                                                   faixa_etaria_final                       NUMBER(2),
                                                   id_area_profissional                     NUMBER(20),
                                                   pcd                                      NUMBER,
                                                   cpf_estudante                            VARCHAR2(11) NOT NULL,
                                                   rg_estudante                             VARCHAR2(20),
                                                   nome_estudante                           VARCHAR2(255) NOT NULL,
                                                   nome_social_estudante                    VARCHAR2(255),
                                                   nome_mae_estudante                       VARCHAR2(150),
                                                   data_nascimento                          TIMESTAMP,
                                                   responsavel_legal                        VARCHAR2(255),
                                                   email_estudante                          VARCHAR2(100) NOT NULL,
                                                   telefone_estudante                       VARCHAR2(60) NOT NULL,
                                                   endereco_estudante                       VARCHAR2(150) NOT NULL,
                                                   numero_end_estudante                     VARCHAR2(10) NOT NULL,
                                                   complemento_end_estudante                VARCHAR2(200),
                                                   bairro_end_estudante                     VARCHAR2(100) NOT NULL,
                                                   cep_end_estudante                        VARCHAR2(8) NOT NULL,
                                                   cidade_end_estudante                     VARCHAR2(100) NOT NULL,
                                                   uf_end_estudante                         VARCHAR2(2) NOT NULL,
                                                   codigo_curso_estudante                   NUMBER(20),
                                                   nome_curso_estudante                     VARCHAR2(200),
                                                   periodo_atual                            NUMBER(2),
                                                   tipo_duracao_curso                       NUMBER(2),
                                                   periodo_curso_estudante                  VARCHAR2(20),
                                                   previsao_concl_curso_estudante           TIMESTAMP,
                                                   id_ie                                    NUMBER(20),
                                                   nome_ie                                  VARCHAR2(200),
                                                   id_campus                                NUMBER(20),
                                                   nome_campus                              VARCHAR2(200),
                                                   endereco_campus                          VARCHAR2(150),
                                                   numero_campus                            VARCHAR2(10),
                                                   complemento_campus                       VARCHAR2(50),
                                                   bairro_campus                            VARCHAR2(100),
                                                   cep_campus                               VARCHAR2(8),
                                                   cidade_campus                            VARCHAR2(100),
                                                   uf_campus                                VARCHAR2(2),
                                                   id_empresa                               NUMBER(20),
                                                   nome_empresa                             VARCHAR2(150),
                                                   endereco_empresa                         VARCHAR2(150),
                                                   numero_empresa                           VARCHAR2(10),
                                                   complemento_empresa                      VARCHAR2(50),
                                                   bairro_empresa                           VARCHAR2(100),
                                                   cep_empresa                              VARCHAR2(8),
                                                   cidade_empresa                           VARCHAR2(100),
                                                   uf_empresa                               VARCHAR2(2),
                                                   codigo_da_vaga                           NUMBER(20) NOT NULL,
                                                   descricao_vaga                           VARCHAR2(150),
                                                   condicao_estagio                         NUMBER,
                                                   data_inicio_estagio                      TIMESTAMP,
                                                   data_final_estagio                       TIMESTAMP,
                                                   data_solicitacao_rescisao                TIMESTAMP,
                                                   data_rescisao_estagio                    TIMESTAMP,
                                                   matricula_rh                             NUMBER(20),
                                                   duracao_estagio                          NUMBER(5),
                                                   tipo_auxilio_bolsa                       NUMBER,
                                                   tipo_valor_bolsa                         NUMBER,
                                                   valor_bolsa                              NUMBER(10, 2),
                                                   tipo_auxilio_transporte                  NUMBER,
                                                   tipo_valor_auxilio_transporte            NUMBER,
                                                   valor_transporte_fixo                    NUMBER(10, 2),
                                                   id_banco                                 NUMBER(3),
                                                   id_agencia                               NUMBER(4),
                                                   conta_corrente                           VARCHAR2(50),
                                                   conta_corrente_digito                    VARCHAR2(2),
                                                   beneficios_adicionais_estagio            NUMBER,
                                                   id_supervisor                            NUMBER(20),
                                                   nome_supervisor                          VARCHAR2(150),
                                                   cpf_supervisor                           VARCHAR2(11),
                                                   cargo_supervisor                         VARCHAR2(150),
                                                   formacao_supervisor                      VARCHAR2(150),
                                                   id_conselho_classe_supervisor            NUMBER(20),
                                                   descricao_conselho_supervisor            VARCHAR2(100),
                                                   contratacao_direta                       NUMBER,
                                                   sigla_nivel_educacao_estudante           VARCHAR2(2),
                                                   tipo_salario                             NUMBER(1),
                                                   codigo_estudante                         VARCHAR2(20) NOT NULL,
                                                   contrapartida_aux_transporte             VARCHAR2(100),
                                                   situacao                                 NUMBER(1) DEFAULT 0 NOT NULL,
                                                   situacao_escolaridade                    NUMBER(1),
                                                   condicoes_especiais                      NUMBER(1),
                                                   nivel_escolaridade                       VARCHAR2(2),
                                                   cpf_monitor                              VARCHAR2(11),
                                                   nome_monitor                             VARCHAR2(255),
                                                   email_monitor                            VARCHAR2(100),
                                                   telefone_monitor                         VARCHAR2(60),
                                                   nome_contato                             VARCHAR2(255),
                                                   email_contato                            VARCHAR2(100),
                                                   telefone_contato                         VARCHAR2(60),
                                                   tipo_salario_aprendiz                    NUMBER(1),
                                                   valor_salario_aprendiz                   NUMBER(10, 2),
                                                   tipo_auxilio_transporte_aprendiz         NUMBER(1),
                                                   tipo_auxilio_transporte_valor_aprendiz   NUMBER,
                                                   valor_transporte_fixo_aprendiz           NUMBER(10, 2),
                                                   valor_salario_aprendiz_de                NUMBER(10, 2),
                                                   valor_salario_aprendiz_ate               NUMBER(10, 2),
                                                   numero_carteira_trabalho                 VARCHAR2(64),
                                                   serie_carteira_trabalho                  VARCHAR2(32),
                                                   uf_carteira_trabalho                     VARCHAR2(2),
                                                   pis                                      VARCHAR2(32),
                                                   data_inicio                              TIMESTAMP,
                                                   data_inicio_personalizada                TIMESTAMP,
                                                   usa_data_personalizada                   NUMBER(1),
                                                   horario_curso                            NUMBER(1),
                                                   dia_capacitacao                          VARCHAR2(50),
                                                   carga_horaria_teorica                    NUMBER(5),
                                                   carga_horaria_pratica                    NUMBER(5),
                                                   tipo_turma                               VARCHAR2(10),
                                                   horario_inicio_expdiente_aprendiz        TIMESTAMP,
                                                   horario_termino_expdiente_aprendiz       TIMESTAMP,
                                                   contrapartida_aux_transporte_aprendiz    VARCHAR2(100),
                                                   seq_ta                                   NUMBER(20),
                                                   tipo_aprendiz                            NUMBER(1),
                                                   deletado                                 NUMBER,
                                                   data_criacao                             TIMESTAMP,
                                                   data_alteracao                           TIMESTAMP NOT NULL,
                                                   criado_por                               VARCHAR2(255),
                                                   modificado_por                           VARCHAR2(255)
);

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_contrato IS
    'Flag:

A - Aprendiz

E - Estagio';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.id_curso_capacitacao IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.carga_horaria IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.faixa_etaria_inicial IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.faixa_etaria_final IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.id_area_profissional IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: E';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.pcd IS
    'Flag 0 ou 1:

0 - Normal

1 - PCD';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.rg_estudante IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.data_nascimento IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.responsavel_legal IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.periodo_curso_estudante IS
    '-

  Esse campo é preencho com dados do campo tipo_perido_curso da tabela:
  REP_ESCOLARIDADES_ESTUDANTES.

  EX: Manhã, Tarde, Noite, Integral, Variavel...'
;

COMMENT ON COLUMN hist_contratos_estudantes_empresa.endereco_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.numero_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.complemento_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.bairro_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.cep_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.cidade_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.uf_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.condicao_estagio IS
    'Enum:

0 - Obrigatório
1 - Não Obrigatório';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.duracao_estagio IS
    'OBS:

  Campo Calculado ';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_auxilio_bolsa IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_valor_bolsa IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_auxilio_transporte IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_valor_auxilio_transporte IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.beneficios_adicionais_estagio IS
    'Flag  0 ou 1';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.contratacao_direta IS
    'Enum:

0 - Contrataçao Normal

1 - Contratação Direta';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_salario IS
    'Enum:

0 - Federal
1 - Estadual
2 - Convencao

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.situacao IS
    'Flags:

0: Rascunho
1: Inconsistente';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.situacao_escolaridade IS
    'Enum:

0 - Todos

1 - Cursando

2 - Concluido

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.condicoes_especiais IS
    'Enum:

 0 - sem ressalva
1 - com inconsistencias';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.nivel_escolaridade IS
    'Este campo e utilizado na matricula do Aprendiz

Opcoes:

SU - Superior
TE - Técnico
EE - Educação Especial
HB - Habilitação Básica
EM - Ensino Médio
EF - Ensino Fundamental

Obs. vem do campo sigla_nivel_educacao da tabela rep_escolaridades_estudantes'
;

COMMENT ON COLUMN hist_contratos_estudantes_empresa.cpf_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.nome_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.email_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.telefone_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.nome_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.email_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.telefone_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_salario_aprendiz IS
    'Enum:

0 - Mensal

1 - Por Hora

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_auxilio_transporte_aprendiz IS
    'Enum:

0 - Mensal

1 - Diario

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_auxilio_transporte_valor_aprendiz IS
    'Enum

 0 - Fixo

 1 - A Combinar

 Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.valor_transporte_fixo_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz
';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.valor_salario_aprendiz_de IS
    'Este campo e utilizado na matricula do Aprendiz
';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.valor_salario_aprendiz_ate IS
    'Este campo e utilizado na matricula do Aprendiz
';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.seq_ta IS
    'Quando for igual a 0, nao existe TA.
Quando for maior que 0, existe TA.';

COMMENT ON COLUMN hist_contratos_estudantes_empresa.tipo_aprendiz IS
    'Flag:

0 - Capacitador
1 - Empregador';

ALTER TABLE hist_contratos_estudantes_empresa ADD CONSTRAINT krs_indice_02722 PRIMARY KEY ( id );

ALTER TABLE hist_contratos_estudantes_empresa ADD CONSTRAINT krs_indice_02764 UNIQUE ( id_estudante,
                                                                                       codigo_da_vaga );

CREATE TABLE hist_cursos_contr_emp_est (
                                           id_contr_emp_est   NUMBER(20) NOT NULL,
                                           codigo_curso       NUMBER(20) NOT NULL
);

CREATE TABLE hist_documentos_contr_emp_est (
                                               id                 NUMBER(20) NOT NULL,
                                               id_contr_emp_est   NUMBER(20) NOT NULL,
                                               id_documento       NUMBER(20),
                                               tipo_documento     VARCHAR2(255)
);

ALTER TABLE hist_documentos_contr_emp_est ADD CONSTRAINT krs_indice_02742 PRIMARY KEY ( id );

CREATE TABLE hist_ferias (
                             id               NUMBER(20) NOT NULL,
                             id_contr_emp     NUMBER(20) NOT NULL,
                             tipo_ferias      NUMBER(1) NOT NULL,
                             deletado         NUMBER,
                             data_criacao     TIMESTAMP NOT NULL,
                             data_alteracao   TIMESTAMP,
                             criado_por       VARCHAR2(255) NOT NULL,
                             modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN hist_ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_ferias.tipo_ferias IS
    'Enum:

0 - FAIXA1 (PERIODO DE 30 DIAS)

1 - FAIXA2 (PERIODO DE 10 A 20 DIAS)

2 - FAIXA3 (3 PERIODOS DE 10 DIAS)

Este campo e utilizado na matricula do Aprendiz'
;

COMMENT ON COLUMN hist_ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN hist_ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

ALTER TABLE hist_ferias ADD CONSTRAINT krs_indice_02748 PRIMARY KEY ( id );

CREATE TABLE hist_historico_inconsistencias (
                                                id                                NUMBER(20) NOT NULL,
                                                id_contratos_estudantes_empresa   NUMBER(20) NOT NULL,
                                                campo                             VARCHAR2(255) NOT NULL,
                                                valor                             VARCHAR2(255) NOT NULL,
                                                restritivo                        NUMBER(1) DEFAULT 1 NOT NULL
);

COMMENT ON COLUMN hist_historico_inconsistencias.campo IS
    'Nome do campo que está inconsistente';

COMMENT ON COLUMN hist_historico_inconsistencias.valor IS
    'Descrição sobre a inconsistencia';

ALTER TABLE hist_historico_inconsistencias ADD CONSTRAINT krs_indice_02744 PRIMARY KEY ( id );

CREATE TABLE hist_historico_supervisor_contrato (
                                                    id                            NUMBER(20) NOT NULL,
                                                    id_contr_emp_est              NUMBER(20),
                                                    id_supervisor                 NUMBER(20),
                                                    none                          VARCHAR2(150),
                                                    cpf                           VARCHAR2(11),
                                                    cargo                         VARCHAR2(150),
                                                    formacao                      VARCHAR2(150),
                                                    id_conselho_classe            NUMBER(20),
                                                    descricao_conselho_superior   VARCHAR2(100),
                                                    ativo                         NUMBER,
                                                    deletado                      NUMBER,
                                                    data_criacao                  TIMESTAMP,
                                                    data_alteracao                TIMESTAMP,
                                                    criado_por                    VARCHAR2(255),
                                                    modificado_por                VARCHAR2(255)
);

COMMENT ON COLUMN hist_historico_supervisor_contrato.ativo IS
    'Flag 0 ou 1';

ALTER TABLE hist_historico_supervisor_contrato ADD CONSTRAINT krs_indice_02762 PRIMARY KEY ( id );

CREATE TABLE hist_horarios_contrato_jornada (
                                                id                 NUMBER(20) NOT NULL,
                                                id_contr_emp_est   NUMBER(20) NOT NULL,
                                                dia_semana         VARCHAR2(7),
                                                hora_entrada       TIMESTAMP,
                                                hora_saida         TIMESTAMP,
                                                jornada            TIMESTAMP,
                                                intervalo          TIMESTAMP,
                                                tipo_horario       NUMBER,
                                                deletado           NUMBER,
                                                data_criacao       TIMESTAMP NOT NULL,
                                                data_alteracao     TIMESTAMP NOT NULL,
                                                criado_por         VARCHAR2(255),
                                                modificado_por     VARCHAR2(255)
);

COMMENT ON COLUMN hist_horarios_contrato_jornada.dia_semana IS
    'Ex:

 Segunda, Terça,etc....';

COMMENT ON COLUMN hist_horarios_contrato_jornada.tipo_horario IS
    'Enum:

  0 - Fixo
  1 - Horario Alternativo';

ALTER TABLE hist_horarios_contrato_jornada ADD CONSTRAINT krs_indice_02760 PRIMARY KEY ( id );

CREATE TABLE hist_termo_aditivo (
                                    id                                NUMBER(20) NOT NULL,
                                    id_contratos_estudantes_empresa   NUMBER(20) NOT NULL,
                                    condicoes_especiais               NUMBER(1) NOT NULL,
                                    status                            NUMBER(1) NOT NULL,
                                    data_envio_ta                     TIMESTAMP,
                                    tipo_envio_ta                     NUMBER(1),
                                    criado_por                        VARCHAR2(255) NOT NULL,
                                    data_criacao                      TIMESTAMP NOT NULL
);

COMMENT ON COLUMN hist_termo_aditivo.condicoes_especiais IS
    'ENUM:

0- SIM
1- NAO';

COMMENT ON COLUMN hist_termo_aditivo.status IS
    'ENUM:

0- TA de Estagio está pronto e disponivel para assinaturas
1- TA de Estagio pendente de aprovacao. Acompanhe';

COMMENT ON COLUMN hist_termo_aditivo.tipo_envio_ta IS
    'ENUM:

0- WhatsAPP
1- E-mail';

ALTER TABLE hist_termo_aditivo ADD CONSTRAINT krs_indice_02746 PRIMARY KEY ( id );

ALTER TABLE contrato_ta
    ADD CONSTRAINT krs_indice_02721 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );

ALTER TABLE hist_contratos_cursos_capacitacao
    ADD CONSTRAINT krs_indice_02730 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_02736 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_02737 FOREIGN KEY ( codigo_curso )
        REFERENCES rep_cursos ( codigo_curso );

ALTER TABLE hist_atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_02738 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_02739 FOREIGN KEY ( codigo_atividade )
        REFERENCES rep_atividades ( codigo_atividade );

ALTER TABLE hist_areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_02740 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_02741 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES rep_areas_atuacao_estagio ( codigo_area_atuacao );

ALTER TABLE hist_documentos_contr_emp_est
    ADD CONSTRAINT krs_indice_02743 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_historico_inconsistencias
    ADD CONSTRAINT krs_indice_02745 FOREIGN KEY ( id_contratos_estudantes_empresa )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_termo_aditivo
    ADD CONSTRAINT krs_indice_02747 FOREIGN KEY ( id_contratos_estudantes_empresa )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_ferias
    ADD CONSTRAINT krs_indice_02749 FOREIGN KEY ( id_contr_emp )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_beneficios_contr_emp
    ADD CONSTRAINT krs_indice_02751 FOREIGN KEY ( id_beneficio )
        REFERENCES beneficios ( id );

ALTER TABLE hist_beneficios_contr_emp
    ADD CONSTRAINT krs_indice_02752 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_horarios_contrato_jornada
    ADD CONSTRAINT krs_indice_02761 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );

ALTER TABLE hist_historico_supervisor_contrato
    ADD CONSTRAINT krs_indice_02763 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES hist_contratos_estudantes_empresa ( id );


-- PK-8740/8741
COMMENT ON COLUMN vinculos_vaga.situacao_vinculo IS
    'Enum:

0 - Convocado
1 - Encaminhado
2 - Marcar Contrato
3 - Liberado da oportunidade
4 - Contratação em andamento
5 - Contratado
6 - Encaminhado para o RH'
;


--PK-8746
CREATE TABLE recessos (
                          id                NUMBER NOT NULL,
                          id_contrato_emp   NUMBER(20) NOT NULL,
                          data_inicio       TIMESTAMP,
                          data_fim          TIMESTAMP,
                          criado_por        VARCHAR2(255),
                          data_criacao      TIMESTAMP NOT NULL,
                          data_alteracao    TIMESTAMP,
                          modificado_por    VARCHAR2(255),
                          deletado          NUMBER(1)
);

ALTER TABLE recessos ADD CONSTRAINT krs_indice_02800 PRIMARY KEY ( id );

ALTER TABLE recessos
    ADD CONSTRAINT krs_indice_02820 FOREIGN KEY ( id_contrato_emp )
        REFERENCES contratos_estudantes_empresa ( id );


--PK-8749/8751
CREATE TABLE rep_atividades_empresas (
                                         id                     NUMBER(20) NOT NULL,
                                         id_area_profissional   NUMBER(20) NOT NULL,
                                         id_contrato            NUMBER(20) NOT NULL,
                                         descricao              VARCHAR2(150),
                                         situacao               NUMBER(1),
                                         status                 NUMBER(1),
                                         motivo_reprovacao      VARCHAR2(255),
                                         criado_por             VARCHAR2(255),
                                         data_criacao           TIMESTAMP NOT NULL,
                                         data_alteracao         TIMESTAMP,
                                         modificado_por         VARCHAR2(255),
                                         deletado               NUMBER(1)
);

COMMENT ON COLUMN rep_atividades_empresas.situacao IS
    'ENUM:

0 - Ativa
1 - Inativa';

COMMENT ON COLUMN rep_atividades_empresas.status IS
    'ENUM:

0-Aprovado
1-Reprovado
2-Em Analise';

ALTER TABLE rep_atividades_empresas ADD CONSTRAINT krs_indice_02801 PRIMARY KEY ( id );

CREATE TABLE rep_atividades_empresas_areas_atuacao (
                                                       codigo_area_atuacao      NUMBER(10) NOT NULL,
                                                       id_atividades_empresas   NUMBER(20)
);

ALTER TABLE rep_atividades_empresas_areas_atuacao
    ADD CONSTRAINT krs_indice_02802 FOREIGN KEY ( id_atividades_empresas )
        REFERENCES rep_atividades_empresas ( id );

ALTER TABLE rep_atividades_empresas_areas_atuacao
    ADD CONSTRAINT krs_indice_02803 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES rep_areas_profissional_atuacao ( id );

--
CREATE TABLE vinculo_vaga_est_ativi_emp (
                                            id_vaga_estagio          NUMBER(20) NOT NULL,
                                            id_atividades_empresas   NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_vaga_est_ativi_emp
    ADD CONSTRAINT krs_indice_02840 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id );

ALTER TABLE vinculo_vaga_est_ativi_emp
    ADD CONSTRAINT krs_indice_02841 FOREIGN KEY ( id_atividades_empresas )
        REFERENCES rep_atividades_empresas ( id );

CREATE TABLE vinculo_tce_atividade_empresas (
                                                id_contrato_emp          NUMBER(20) NOT NULL,
                                                id_atividades_empresas   NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_tce_atividade_empresas
    ADD CONSTRAINT krs_indice_02842 FOREIGN KEY ( id_contrato_emp )
        REFERENCES contratos_estudantes_empresa ( id );

ALTER TABLE vinculo_tce_atividade_empresas
    ADD CONSTRAINT vinculo_tce_atividade_empresas_rep_atividades_empresas_fk FOREIGN KEY ( id_atividades_empresas )
        REFERENCES rep_atividades_empresas ( id );

CREATE TABLE pre_vinculo_tce_ativi_empresas (
                                                id_pre_contr_emp         NUMBER(20) NOT NULL,
                                                id_atividades_empresas   NUMBER(20) NOT NULL
);

ALTER TABLE pre_vinculo_tce_ativi_empresas
    ADD CONSTRAINT krs_indice_02844 FOREIGN KEY ( id_pre_contr_emp )
        REFERENCES pre_contratos_estudantes_empresa ( id );

ALTER TABLE pre_vinculo_tce_ativi_empresas
    ADD CONSTRAINT krs_indice_02845 FOREIGN KEY ( id_atividades_empresas )
        REFERENCES rep_atividades_empresas ( id );

--PK-8753/8754
CREATE TABLE concendentes (
                              id                             NUMBER(20) NOT NULL,
                              nome                           VARCHAR2(150) NOT NULL,
                              cpf                            VARCHAR2(11),
                              cnpj                           VARCHAR2(14),
                              endereco                       VARCHAR2(255) NOT NULL,
                              numero VARCHAR2(10 BYTE) NOT NULL,
                              complemento VARCHAR2(50 BYTE),
                              bairro VARCHAR2(100 BYTE),
                              cep VARCHAR2(8 BYTE) NOT NULL,
                              cidade VARCHAR2(100) NOT NULL,
                              uf VARCHAR2(2 BYTE) NOT NULL,
                              TIPO_LOGRADOURO VARCHAR2(150 BYTE) NOT NULL,
                              telefone                       VARCHAR2(60) NOT NULL,
                              nome_concedente_responsavel    VARCHAR2(150) NOT NULL,
                              cargo_concedente_responsavel   VARCHAR2(150) NOT NULL,
                              situacao                       NUMBER(1),
                              criado_por                     VARCHAR2(255),
                              data_criacao                   TIMESTAMP NOT NULL,
                              data_alteracao                 TIMESTAMP,
                              modificado_por                 VARCHAR2(255),
                              deletado                       NUMBER(1)
);

COMMENT ON COLUMN concendentes.situacao IS
    'ENUM:
1-ATIVO
0-INATIVO';

ALTER TABLE concendentes ADD CONSTRAINT krs_indice_02804 PRIMARY KEY ( id );

CREATE TABLE vinculo_contratos_concendentes (
                                                id_concendente   NUMBER(20) NOT NULL,
                                                id_contrato      NUMBER(20) NOT NULL
);

CREATE TABLE vinculo_locais_contr_concendentes (
                                                   id_concendente      NUMBER(20) NOT NULL,
                                                   id_local_contrato   NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_contratos_concendentes
    ADD CONSTRAINT krs_indice_02805 FOREIGN KEY ( id_concendente )
        REFERENCES concendentes ( id );

ALTER TABLE vinculo_contratos_concendentes
    ADD CONSTRAINT krs_indice_02806 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );

ALTER TABLE vinculo_locais_contr_concendentes
    ADD CONSTRAINT krs_indice_02807 FOREIGN KEY ( id_concendente )
        REFERENCES concendentes ( id );

ALTER TABLE vinculo_locais_contr_concendentes
    ADD CONSTRAINT krs_indice_02808 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id );


--PK8755
CREATE TABLE parametros_tce (
                                id               NUMBER(20) NOT NULL,
                                id_contrato      NUMBER(20) NOT NULL,
                                campo            VARCHAR2(40),
                                tela_step        NUMBER(1),
                                criado_por       VARCHAR2(255),
                                data_criacao     TIMESTAMP NOT NULL,
                                data_alteracao   TIMESTAMP,
                                modificado_por   VARCHAR2(255),
                                deletado         NUMBER(1)
);

ALTER TABLE parametros_tce ADD CONSTRAINT krs_indice_02809 PRIMARY KEY ( id );

ALTER TABLE parametros_tce
    ADD CONSTRAINT krs_indice_02810 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );


--
ALTER TABLE contratos_estudantes_empresa ADD data_original TIMESTAMP(6);
ALTER TABLE pre_contratos_estudantes_empresa ADD data_original TIMESTAMP(6);

--
CREATE SEQUENCE SEQ_contrato_ta MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_areas_atuacao_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_atividades_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_beneficios_contr_emp MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_contratos_cursos_capacitacao MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_contratos_estudantes_empresa MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_cursos_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_documentos_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_ferias MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_historico_inconsistencias MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_historico_supervisor_contrato MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_horarios_contrato_jornada MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_hist_termo_aditivo MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_recessos MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_rep_atividades_empresas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_rep_atividades_empresas_areas_atuacao MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_concendentes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_vinculo_contratos_concendentes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_vinculo_locais_contr_concendentes MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_parametros_tce MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_VINCULO_VAGA_EST_ATIVI_EMP MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_VINCULO_TCE_ATIVIDADE_EMPRESAS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_pre_vinculo_tce_ativi_empresas MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
