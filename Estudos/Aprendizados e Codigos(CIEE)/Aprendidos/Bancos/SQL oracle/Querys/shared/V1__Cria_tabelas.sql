--***********************************************************
--DDL gerado a partir da modelagem atual do sistema de vagas*
--***********************************************************
-- Gerado por Oracle SQL Developer Data Modeler 18.3.0.268.1156
--   em:        2019-01-10 14:41:28 BRST
--   site:      Oracle Database 12c
--   tipo:      Oracle Database 12c

CREATE TABLE {{user}}.agenda_processo_seletivo (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    tipo_horario                 NUMBER,
    data                         TIMESTAMP,
    duracao                      NUMBER(10),
    quantidade_candidatos        NUMBER(10),
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.agenda_processo_seletivo.tipo_horario IS
    'Flag 0 ou 1:

0 - Individual

1 - Em Grupo';

ALTER TABLE {{user}}.agenda_processo_seletivo ADD CONSTRAINT krs_indice_01160 PRIMARY KEY ( id );

CREATE TABLE {{user}}.aparelhos_pcd (
    id                    NUMBER(20) NOT NULL,
    id_vaga_estagio_pcd   NUMBER(20) NOT NULL,
    id_aparelho           NUMBER(20) NOT NULL,
    descricao_aparelho    VARCHAR2(70) NOT NULL,
    deletado              NUMBER(1),
    data_criacao          TIMESTAMP NOT NULL,
    data_alteracao        TIMESTAMP NOT NULL,
    criado_por            VARCHAR2(255 BYTE),
    modificado_por        VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN {{user}}.aparelhos_pcd.id_aparelho IS
    'ID APARELHO, Vem da tabela APARELHOS  do CORE. OK';

COMMENT ON COLUMN {{user}}.aparelhos_pcd.descricao_aparelho IS
    'DESCRICAO APARELHO, Vem da tabela APARELHOS do CORE. OK';

ALTER TABLE {{user}}.aparelhos_pcd ADD CONSTRAINT krs_indice_00922 PRIMARY KEY ( id );

CREATE TABLE {{user}}.areas_atuacao_aprendiz (
    id                       NUMBER(20) NOT NULL,
    id_grupo_empresa         NUMBER(20),
    descricao_area_atuacao   VARCHAR2(200) NOT NULL,
    nivel_area_atuacao       VARCHAR2(20) NOT NULL,
    tipo_programa            VARCHAR2(10) DEFAULT 'Aprendiz',
    identificador            NUMBER,
    situacao                 NUMBER,
    deletado                 NUMBER(1),
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.areas_atuacao_aprendiz.id_grupo_empresa IS
    'tabela do core, relacionamento via funcionalidade';

COMMENT ON COLUMN {{user}}.areas_atuacao_aprendiz.nivel_area_atuacao IS
    'Enum:

1 - Geral
2 - Medio
3 - Tecnico';

COMMENT ON COLUMN {{user}}.areas_atuacao_aprendiz.tipo_programa IS
    'Esse campo tem valor default:

 Aprendiz';

COMMENT ON COLUMN {{user}}.areas_atuacao_aprendiz.identificador IS
    'Flag 0 ou 1

0-CIEE
1-Empresas';

COMMENT ON COLUMN {{user}}.areas_atuacao_aprendiz.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.areas_atuacao_aprendiz ADD CONSTRAINT krs_indice_01028 PRIMARY KEY ( id );

CREATE TABLE areas_atuacao_estagio (
    id_vaga_estagio       NUMBER(20) NOT NULL,
    codigo_area_atuacao   NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.atividades_aprendiz (
    id                       NUMBER(20) NOT NULL,
    verbos_acao              VARCHAR2(40) NOT NULL,
    descricao_atv_aprendiz   VARCHAR2(200) NOT NULL,
    situacao                 NUMBER NOT NULL,
    deletado                 NUMBER(1),
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.atividades_aprendiz.situacao IS
    'Flag 0 ou 1

0 - Inativo

1 - Ativo';

ALTER TABLE {{user}}.atividades_aprendiz ADD CONSTRAINT krs_indice_01024 PRIMARY KEY ( id );

CREATE TABLE {{user}}.atividades_estagio (
    id_vaga_estagio    NUMBER(20) NOT NULL,
    codigo_atividade   NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.beneficios (
    id                       NUMBER(20) NOT NULL,
    descricao                VARCHAR2(100 BYTE) NOT NULL,
    tem_valor_monetario      NUMBER(1) DEFAULT 0,
    utiliza_na_contratacao   NUMBER(1) DEFAULT 0,
    tipo_valor               VARCHAR2(10 BYTE),
    periodo_pagamento        VARCHAR2(10 BYTE),
    tipo_beneficio           VARCHAR2(10 BYTE),
    deletado                 NUMBER(1),
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255 BYTE),
    modificado_por           VARCHAR2(255 BYTE)
);

ALTER TABLE {{user}}.beneficios ADD CONSTRAINT krs_indice_00905 PRIMARY KEY ( id );

CREATE TABLE {{user}}.beneficios_adic_aprendiz (
    id                 NUMBER(20) NOT NULL,
    id_vaga_aprendiz   NUMBER(20) NOT NULL,
    id_beneficio       NUMBER(20) NOT NULL,
    valor              NUMBER(10, 2) NOT NULL,
    deletado           NUMBER(1),
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255 BYTE),
    modificado_por     VARCHAR2(255 BYTE)
);

ALTER TABLE {{user}}.beneficios_adic_aprendiz ADD CONSTRAINT krs_indice_01183 PRIMARY KEY ( id );

CREATE TABLE {{user}}.beneficios_adicionais (
    id                NUMBER(20) NOT NULL,
    id_vaga_estagio   NUMBER(20) NOT NULL,
    id_beneficio      NUMBER(20) NOT NULL,
    valor             NUMBER(10, 2) NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255 BYTE),
    modificado_por    VARCHAR2(255 BYTE)
);

ALTER TABLE {{user}}.beneficios_adicionais ADD CONSTRAINT krs_indice_00925 PRIMARY KEY ( id );

CREATE TABLE {{user}}.cargas_horaria (
    id                         NUMBER(20) NOT NULL,
    id_duracoes                NUMBER(20) NOT NULL,
    id_unidade_ciee            NUMBER(19),
    id_local_capacitacao       NUMBER(20),
    tipo_carga_horaria         NUMBER(1),
    encontros_basicos          NUMBER(4),
    encontros_especificos      NUMBER(4),
    encontros_complementares   NUMBER(4),
    encontros_iniciais         NUMBER(4),
    encontros_finais           NUMBER(4),
    deletado                   NUMBER(1),
    data_criacao               TIMESTAMP,
    data_alteracao             TIMESTAMP,
    criado_por                 VARCHAR2(255),
    modificado_por             VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.cargas_horaria.tipo_carga_horaria IS
    'Normalização:

0 - Geral
1 - Unidade CIEE
2 - Local de capacitação';

COMMENT ON COLUMN {{user}}.cargas_horaria.encontros_basicos IS
    'Quantidade de Encontros Básicos';

COMMENT ON COLUMN {{user}}.cargas_horaria.encontros_especificos IS
    'Quantidade de Encontros Específicos';

COMMENT ON COLUMN {{user}}.cargas_horaria.encontros_complementares IS
    'Quantidade de Encontros Complementares';

COMMENT ON COLUMN {{user}}.cargas_horaria.encontros_iniciais IS
    'Quantidade de Encontros Iniciais';

COMMENT ON COLUMN {{user}}.cargas_horaria.encontros_finais IS
    'Quantidade de Encontros Finais';

ALTER TABLE {{user}}.cargas_horaria ADD CONSTRAINT krs_indice_01046 PRIMARY KEY ( id );

CREATE TABLE {{user}}.cbo_atividades_aprendiz (
    id_cbo         NUMBER(20) NOT NULL,
    id_atividade   NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.cbos (
    id                   NUMBER(20) NOT NULL,
    codigo_externo_cbo   VARCHAR2(20) NOT NULL,
    descricao_cbo        VARCHAR2(100) NOT NULL,
    situacao_cbo         NUMBER NOT NULL,
    deletado             NUMBER(1),
    data_criacao         TIMESTAMP,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255),
    modificado_por       VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.cbos.situacao_cbo IS
    'Flag 0 ou 1

1 - Ativo

0 - Inativo';

ALTER TABLE {{user}}.cbos ADD CONSTRAINT krs_indice_01025 PRIMARY KEY ( id );

CREATE TABLE {{user}}.conhecimentos (
    id             NUMBER(20) NOT NULL,
    conhecimento   VARCHAR2(50)
);

ALTER TABLE {{user}}.conhecimentos ADD CONSTRAINT krs_indice_01200 PRIMARY KEY ( id );

CREATE TABLE {{user}}.conhecimentos_inf_estagio (
    id                    NUMBER(20) NOT NULL,
    id_vaga_estagio       NUMBER(20) NOT NULL,
    id_conhecimento       NUMBER(20) NOT NULL,
    nivel                 VARCHAR2(20 BYTE),
    somente_certificado   NUMBER,
    deletado              NUMBER(1),
    data_criacao          TIMESTAMP NOT NULL,
    data_alteracao        TIMESTAMP NOT NULL,
    criado_por            VARCHAR2(255 BYTE),
    modificado_por        VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN {{user}}.conhecimentos_inf_estagio.nivel IS
    'Nivel do Conhecimento ex:

Basico, intermediario, etc

OK
';

COMMENT ON COLUMN {{user}}.conhecimentos_inf_estagio.somente_certificado IS
    'Flag 0 ou 1';

ALTER TABLE {{user}}.conhecimentos_inf_estagio ADD CONSTRAINT krs_indice_00920 PRIMARY KEY ( id );

CREATE TABLE {{user}}.cursos_capacitacao (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(100) NOT NULL,
    modalidade       NUMBER NOT NULL,
    situacao         NUMBER NOT NULL,
    deletado         NUMBER(1),
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.cursos_capacitacao.modalidade IS
    'Enum:

Modalidade do Curso de Capacitação

 0- Presencial
 1 - Ensino à Distância';

COMMENT ON COLUMN {{user}}.cursos_capacitacao.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo
';

ALTER TABLE {{user}}.cursos_capacitacao ADD CONSTRAINT krs_indice_01032 PRIMARY KEY ( id );

CREATE TABLE {{user}}.cursos_estagio (
    id_vaga_estagio   NUMBER(20) NOT NULL,
    codigo_curso      NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.cursos_mte (
    id                     NUMBER(20) NOT NULL,
    id_unidade_ciee        NUMBER(19) NOT NULL,
    id_municipio_ibge      NUMBER(19) NOT NULL,
    id_curso_capacitacao   NUMBER(20) NOT NULL,
    codigo_mte             VARCHAR2(20),
    situacao               NUMBER,
    deletado               NUMBER,
    data_criacao           TIMESTAMP,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255),
    modificado_por         VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.cursos_mte.situacao IS
    'Enum

  0 - Inativo
  1 - Ativo';

ALTER TABLE {{user}}.cursos_mte ADD CONSTRAINT krs_indice_01033 PRIMARY KEY ( id );

CREATE TABLE {{user}}.destaques_areas_atua_tce (
    id                       NUMBER(20) NOT NULL,
    id_empresa               NUMBER(20),
    razao_social             VARCHAR2(150),
    id_contrato              NUMBER(20),
    uf                       VARCHAR2(2),
    municipio                VARCHAR2(150),
    id_area_atuacao          NUMBER(20),
    descricao_area_atuacao   VARCHAR2(200)
);

COMMENT ON TABLE {{user}}.destaques_areas_atua_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.destaques_areas_atua_tce ADD CONSTRAINT krs_indice_01112 PRIMARY KEY ( id );

CREATE TABLE {{user}}.destaques_areas_prof_tce (
    id                            NUMBER(20) NOT NULL,
    id_empresa                    NUMBER(20),
    razao_social                  VARCHAR2(150),
    id_contrato                   NUMBER(20),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    id_area_profissional          NUMBER(20),
    descricao_area_profissional   VARCHAR2(200)
);

COMMENT ON TABLE {{user}}.destaques_areas_prof_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.destaques_areas_prof_tce ADD CONSTRAINT krs_indice_01114 PRIMARY KEY ( id );

CREATE TABLE {{user}}.destaques_atv_tce (
    id                            NUMBER(20) NOT NULL,
    id_empresa                    NUMBER(20),
    razao_social                  VARCHAR2(150),
    id_contrato                   NUMBER(20),
    id_area_profissional          NUMBER(20),
    descricao_area_profissional   VARCHAR2(200),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    id_atividade                  NUMBER(20),
    descricao_atividade           VARCHAR2(200)
);

COMMENT ON TABLE {{user}}.destaques_atv_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.destaques_atv_tce ADD CONSTRAINT krs_indice_01108 PRIMARY KEY ( id );

CREATE TABLE {{user}}.destaques_cursos_tce (
    id                NUMBER(20) NOT NULL,
    id_empresa        NUMBER(20),
    razao_social      VARCHAR2(150),
    id_contrato       NUMBER(20),
    uf                VARCHAR2(2),
    municipio         VARCHAR2(150),
    id_curso          NUMBER(20),
    descricao_curso   VARCHAR2(200)
);

COMMENT ON TABLE {{user}}.destaques_cursos_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.destaques_cursos_tce ADD CONSTRAINT krs_indice_01110 PRIMARY KEY ( id );

CREATE TABLE {{user}}.duracoes_capacit_cbos (
    id_duracoes   NUMBER(20) NOT NULL,
    id_cbos       NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.duracoes_capacitacao (
    id                        NUMBER(20) NOT NULL,
    id_curso_capacit          NUMBER(20) NOT NULL,
    id_area_atuacao           NUMBER(20) NOT NULL,
    id_portaria               NUMBER(20) NOT NULL,
    codigo_ciee               NUMBER(20) NOT NULL,
    duracao_curso             NUMBER(2) NOT NULL,
    jornada_diaria            NUMBER(2) NOT NULL,
    dias_uteis                NUMBER(2) NOT NULL,
    jornada_semanal           NUMBER(4) NOT NULL,
    jornada_diaria_capacit    NUMBER(2) NOT NULL,
    dias_uteis_capacit        NUMBER(2) NOT NULL,
    jornada_semanal_capacit   NUMBER(4) NOT NULL,
    carga_horaria_modulo      NUMBER(4) NOT NULL,
    idade_inicial             NUMBER(2) NOT NULL,
    idade_final               NUMBER(2) NOT NULL,
    situacao                  NUMBER NOT NULL,
    deletado                  NUMBER(1),
    data_criacao              TIMESTAMP,
    data_alteracao            TIMESTAMP NOT NULL,
    criado_por                VARCHAR2(255),
    modificado_por            VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.codigo_ciee IS
    'Codigo via funcionalidade:

 Refere-se ao ID da tabela CIEEs do esquema UNIT

';

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.duracao_curso IS
    '
Ex: 24 meses';

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.jornada_diaria IS
    'Total de horas diarias...';

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.idade_inicial IS
    'Faixa Etária, idade inicial.';

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.idade_final IS
    'Faixa Etária, idade final.';

COMMENT ON COLUMN {{user}}.duracoes_capacitacao.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.duracoes_capacitacao ADD CONSTRAINT krs_indice_01041 PRIMARY KEY ( id );

CREATE TABLE {{user}}.duracoes_cursos_mte (
    id                   NUMBER(20) NOT NULL,
    id_curso_mte         NUMBER(20) NOT NULL,
    id_duracao_capacit   NUMBER(20) NOT NULL,
    id_situacao          NUMBER(20) NOT NULL,
    validade             TIMESTAMP NOT NULL,
    login                VARCHAR2(50) NOT NULL,
    senha                VARCHAR2(8) NOT NULL,
    protocolo            VARCHAR2(15),
    data_protocolo       TIMESTAMP
);

ALTER TABLE {{user}}.duracoes_cursos_mte ADD CONSTRAINT krs_indice_01052 PRIMARY KEY ( id );

CREATE TABLE {{user}}.escolas (
    id                     NUMBER(20) NOT NULL,
    id_vaga_estagio        NUMBER(20) NOT NULL,
    id_escola              NUMBER(20) NOT NULL,
    nome_fantasia_escola   VARCHAR2(255) NOT NULL,
    deletado               NUMBER(1),
    data_criacao           TIMESTAMP NOT NULL,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255 BYTE),
    modificado_por         VARCHAR2(255 BYTE)
);

ALTER TABLE {{user}}.escolas ADD CONSTRAINT krs_indice_00914 PRIMARY KEY ( id );

CREATE TABLE {{user}}.etapas_periodos (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    data_inicio                  TIMESTAMP,
    hora_inicio                  TIMESTAMP,
    data_final                   TIMESTAMP,
    hora_final                   TIMESTAMP,
    duracao                      NUMBER(10),
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP,
    data_alteracao               TIMESTAMP,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

ALTER TABLE {{user}}.etapas_periodos ADD CONSTRAINT krs_indice_01157 PRIMARY KEY ( id );

CREATE TABLE {{user}}.etapas_processo_seletivo (
    id                      NUMBER(20) NOT NULL,
    id_vaga                 NUMBER(20),
    tipo_vaga               VARCHAR2(1),
    id_ferramenta_selecao   NUMBER(20) NOT NULL,
    ordem_etapa             NUMBER(2),
    deletado                NUMBER,
    data_criacao            TIMESTAMP NOT NULL,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255) NOT NULL,
    modificado_por          VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.etapas_processo_seletivo.tipo_vaga IS
    '- Esse campo determina se a vaga é de estagio ou de aprendiz

Enum:

 A - Aprendiz
 E  - Estagio';

ALTER TABLE {{user}}.etapas_processo_seletivo ADD CONSTRAINT krs_indice_01118 PRIMARY KEY ( id );

CREATE TABLE {{user}}.favoritos (
    id_usuario     NUMBER NOT NULL,
    id_candidato   VARCHAR2(40 CHAR) NOT NULL
);

ALTER TABLE {{user}}.favoritos ADD CONSTRAINT krs_indice_00924 PRIMARY KEY ( id_usuario,
                                                                    id_candidato );

CREATE TABLE {{user}}.ferramentas_selecao (
    id                      NUMBER(20) NOT NULL,
    nome_ferramenta         VARCHAR2(200) NOT NULL,
    descricao               VARCHAR2(200),
    ferramenta_presencial   NUMBER(1) NOT NULL,
    orientacao              VARCHAR2(300),
    disponivel              NUMBER(1),
    id_empresa              NUMBER(20),
    deletado                NUMBER(1),
    data_criacao            TIMESTAMP,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255),
    modificado_por          VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.ferramentas_selecao.ferramenta_presencial IS
    'Enum:

0 - Presencial
1 - Conferencia On Line
2 - Upload via Portal
3 - Prova On line
4 - Ligação Telefônica';

COMMENT ON COLUMN {{user}}.ferramentas_selecao.disponivel IS
    'Flag 0 ou 1

0 - CIEE
1 - Empresa';

COMMENT ON COLUMN {{user}}.ferramentas_selecao.id_empresa IS
    'Preenchimento desse campo depende do campo tipo_ferramenta,

Se tipo_ferramente=1 (Empresa), esse campo deve receber o ID da empresa caso contrario esse campo nao deve ser preenchido.'
    ;

ALTER TABLE {{user}}.ferramentas_selecao ADD CONSTRAINT krs_indice_01031 PRIMARY KEY ( id );

CREATE TABLE {{user}}.idiomas (
    id       NUMBER(20) NOT NULL,
    idioma   VARCHAR2(20) NOT NULL
);

ALTER TABLE {{user}}.idiomas ADD CONSTRAINT krs_indice_01198 PRIMARY KEY ( id );

CREATE TABLE {{user}}.idiomas_estagio (
    id                    NUMBER(20) NOT NULL,
    id_vaga_estagio       NUMBER(20) NOT NULL,
    id_idioma             NUMBER(20) NOT NULL,
    nivel                 VARCHAR2(20 BYTE),
    somente_certificado   NUMBER,
    deletado              NUMBER(1),
    data_criacao          TIMESTAMP NOT NULL,
    data_alteracao        TIMESTAMP NOT NULL,
    criado_por            VARCHAR2(255 BYTE),
    modificado_por        VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN {{user}}.idiomas_estagio.nivel IS
    'Nivel do Idioma ex:

Basico, intermediario, etc

OK
';

COMMENT ON COLUMN {{user}}.idiomas_estagio.somente_certificado IS
    'Flag 0 ou 1';

ALTER TABLE {{user}}.idiomas_estagio ADD CONSTRAINT krs_indice_00918 PRIMARY KEY ( id );

CREATE TABLE {{user}}.locais_capacitacao (
    id                      NUMBER(20) NOT NULL,
    id_unidade_ciee         NUMBER(20) NOT NULL,
    situacao_local          NUMBER NOT NULL,
    cep                     VARCHAR2(8) NOT NULL,
    tipo_logradouro_local   VARCHAR2(40) NOT NULL,
    endereco_local          VARCHAR2(150) NOT NULL,
    numero_local            VARCHAR2(10) NOT NULL,
    complemento_local       VARCHAR2(50),
    bairro_local            VARCHAR2(100) NOT NULL,
    cidade_local            VARCHAR2(100) NOT NULL,
    uf_local                VARCHAR2(2) NOT NULL,
    descricao_local         VARCHAR2(100),
    capacidade_local        NUMBER(20),
    cnpj_local              VARCHAR2(14),
    data_inicio_atv_local   TIMESTAMP,
    latitude                FLOAT,
    longitude               FLOAT,
    geohash                 VARCHAR2(12),
    deletado                NUMBER(1),
    data_criacao            TIMESTAMP,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255),
    modificado_por          VARCHAR2(255)
);

ALTER TABLE {{user}}.locais_capacitacao ADD CONSTRAINT krs_indice_01021 PRIMARY KEY ( id );

CREATE TABLE {{user}}.motivos_final_processo (
    id                  NUMBER(20) NOT NULL,
    descricao           VARCHAR2(100) NOT NULL,
    enviar_usuario      NUMBER DEFAULT 0 NOT NULL,
    cancelamento_vaga   NUMBER DEFAULT 0 NOT NULL,
    nova_triagem        NUMBER DEFAULT 0 NOT NULL,
    situacao            NUMBER NOT NULL,
    deletado            NUMBER,
    data_criacao        TIMESTAMP,
    data_alteracao      TIMESTAMP NOT NULL,
    criado_por          VARCHAR2(255),
    modificado_por      VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.motivos_final_processo.enviar_usuario IS
    'Flag 0 ou 1

0 - Nao
1 - Sim';

COMMENT ON COLUMN {{user}}.motivos_final_processo.cancelamento_vaga IS
    'Flag 0 ou 1

0 - Nao
1 - Sim';

COMMENT ON COLUMN {{user}}.motivos_final_processo.nova_triagem IS
    'Flag 0 ou 1

0 - Nao
1 - Sim';

COMMENT ON COLUMN {{user}}.motivos_final_processo.situacao IS
    'Flag 0 ou 1

0 - Nao
1 - Sim';

ALTER TABLE {{user}}.motivos_final_processo ADD CONSTRAINT krs_indice_01084 PRIMARY KEY ( id );

CREATE TABLE {{user}}.ocorrencias (
    id                NUMBER(20) NOT NULL,
    id_vaga_estagio   NUMBER(20) NOT NULL,
    descricao         VARCHAR2(40) NOT NULL,
    data_cocrrencia   DATE NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

ALTER TABLE {{user}}.ocorrencias ADD CONSTRAINT krs_indice_01012 PRIMARY KEY ( id );

CREATE TABLE {{user}}.palavras_chave (
    id                NUMBER(20) NOT NULL,
    id_vaga_estagio   NUMBER(20) NOT NULL,
    palavra           VARCHAR2(30 BYTE) NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

ALTER TABLE {{user}}.palavras_chave ADD CONSTRAINT krs_indice_00916 PRIMARY KEY ( id );

CREATE TABLE {{user}}.palavras_chave_aprendiz (
    id                 NUMBER(20) NOT NULL,
    id_vaga_aprendiz   NUMBER(20) NOT NULL,
    palavra            VARCHAR2(30 BYTE) NOT NULL,
    deletado           NUMBER(1),
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255),
    modificado_por     VARCHAR2(255)
);

ALTER TABLE {{user}}.palavras_chave_aprendiz ADD CONSTRAINT krs_indice_01163 PRIMARY KEY ( id );

CREATE TABLE {{user}}.parametros_empresa_contrato (
    id                     NUMBER(20) NOT NULL,
    id_empresa             NUMBER(20),
    id_contrato            NUMBER(20),
    id_local_contrato      NUMBER(20),
    id_parametro_empresa   NUMBER(20) NOT NULL,
    respostas              CLOB,
    msg_backoffice         VARCHAR2(200),
    msg_empresa            VARCHAR2(200),
    msg_estudante          VARCHAR2(200),
    deletado               NUMBER,
    data_criacao           TIMESTAMP,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255),
    modificado_por         VARCHAR2(255)
);

ALTER TABLE {{user}}.parametros_empresa_contrato ADD CONSTRAINT krs_indice_01090 PRIMARY KEY ( id );

CREATE TABLE {{user}}.parametros_ie (
    id               NUMBER(20) NOT NULL,
    id_ie            NUMBER(20),
    id_campus        NUMBER(20),
    id_curso         NUMBER(20),
    id_parametro     NUMBER(20) NOT NULL,
    respostas        CLOB,
    msg_backoffice   VARCHAR2(200),
    msg_empresa      VARCHAR2(200),
    msg_estudante    VARCHAR2(200),
    situacao         NUMBER,
    deletado         NUMBER,
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.parametros_ie.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.parametros_ie ADD CONSTRAINT krs_indice_01088 PRIMARY KEY ( id );

CREATE TABLE {{user}}.pcd (
    id                         NUMBER(20) NOT NULL,
    id_vaga_estagio            NUMBER(20) NOT NULL,
    id_cid_agrupado            NUMBER(20) NOT NULL,
    descricao_cid_agrupado     VARCHAR2(40) NOT NULL,
    qtd_meses_laudo_valido     NUMBER(3),
    valido_cota                NUMBER NOT NULL,
    necessita_acessibilidade   NUMBER,
    deletado                   NUMBER(1),
    data_criacao               TIMESTAMP NOT NULL,
    data_alteracao             TIMESTAMP NOT NULL,
    criado_por                 VARCHAR2(255 BYTE),
    modificado_por             VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN {{user}}.pcd.id_cid_agrupado IS
    'ID DO CID, Vem da tabela AGRUPAMENTO_CID_PCD do CORE. OK';

COMMENT ON COLUMN {{user}}.pcd.descricao_cid_agrupado IS
    'DESCRICAO DO CID, Vem da tabela AGRUPAMENTO_CID_PCD do CORE. OK';

COMMENT ON COLUMN {{user}}.pcd.qtd_meses_laudo_valido IS
    'Validade minima do laudo em meses - OK';

ALTER TABLE {{user}}.pcd ADD CONSTRAINT krs_indice_00901 PRIMARY KEY ( id );

CREATE TABLE {{user}}.periodo_capacitacao_anteriores (
    id                      NUMBER(20) NOT NULL,
    id_estudante            NUMBER(20) NOT NULL,
    id_curso_capacitacao    NUMBER(20) NOT NULL,
    data_inicio_curso       TIMESTAMP,
    data_final_curso        TIMESTAMP,
    quantidade_meses        NUMBER(2) NOT NULL,
    entidade_capacitadora   VARCHAR2(100) NOT NULL,
    empresa_capacitadora    VARCHAR2(100),
    deletado                NUMBER,
    data_criacao            TIMESTAMP,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255),
    modificado_por          VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.periodo_capacitacao_anteriores.quantidade_meses IS
    'Obs:

Calculado: Data Final do Curso - Data Início do Curso';

ALTER TABLE {{user}}.periodo_capacitacao_anteriores ADD CONSTRAINT krs_indice_01081 PRIMARY KEY ( id );

CREATE TABLE {{user}}.portarias_mte (
    id                   NUMBER(20) NOT NULL,
    descricao_portaria   VARCHAR2(255) NOT NULL,
    situacao_portaria    NUMBER NOT NULL,
    deletado             NUMBER(1),
    data_criacao         TIMESTAMP,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255),
    modificado_por       VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.portarias_mte.situacao_portaria IS
    'Normalizacao:

  Campo tipo Flag 0 ou 1

   0-Inativo
   1-Ativo
 ';

ALTER TABLE {{user}}.portarias_mte ADD CONSTRAINT krs_indice_01020 PRIMARY KEY ( id );

CREATE TABLE {{user}}.provas (
    id          NUMBER NOT NULL,
    descricao   VARCHAR2(150),
    duracao     NUMBER(10)
);

ALTER TABLE {{user}}.provas ADD CONSTRAINT krs_indice_01156 PRIMARY KEY ( id );

CREATE TABLE {{user}}.recusa (
    id                     NUMBER(20) NOT NULL,
    descricao_motivo       VARCHAR2(200) NOT NULL,
    descricao_externa      VARCHAR2(200) NOT NULL,
    envia_comunicacao      NUMBER NOT NULL,
    disponivel_estudante   NUMBER NOT NULL,
    disponivel_empresa     NUMBER NOT NULL,
    situacao_motivo        NUMBER NOT NULL,
    deletado               NUMBER,
    data_criacao           TIMESTAMP,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255),
    modificado_por         VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.recusa.envia_comunicacao IS
    'Enum:

  0 - Não
  1 - Sim';

COMMENT ON COLUMN {{user}}.recusa.disponivel_estudante IS
    'Enum:

  0 - Não
  1 - Sim';

COMMENT ON COLUMN {{user}}.recusa.disponivel_empresa IS
    'Enum:

  0 - Não
  1 - Sim';

COMMENT ON COLUMN {{user}}.recusa.situacao_motivo IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.recusa ADD CONSTRAINT krs_indice_01029 PRIMARY KEY ( id );

CREATE TABLE {{user}}.redes_sociais (
    id                NUMBER(20) NOT NULL,
    id_vaga_estagio   NUMBER(20) NOT NULL,
    descricao         VARCHAR2(40) NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.redes_sociais.descricao IS
    '- Descricao da situação da vaga';

ALTER TABLE {{user}}.redes_sociais ADD CONSTRAINT krs_indice_01006 PRIMARY KEY ( id );

CREATE TABLE {{user}}.registros_cmdcas (
    id                   NUMBER(20) NOT NULL,
    id_unidade_ciee      NUMBER(19) NOT NULL,
    id_municipio_ibge    NUMBER(19) NOT NULL,
    tipo_documento       VARCHAR2(15) NOT NULL,
    numero_documento     VARCHAR2(20) NOT NULL,
    validade             TIMESTAMP NOT NULL,
    situacao             NUMBER,
    protocolo            VARCHAR2(15),
    data_protocolo       TIMESTAMP,
    situacao_protocolo   VARCHAR2(10)
);

COMMENT ON COLUMN {{user}}.registros_cmdcas.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.registros_cmdcas ADD CONSTRAINT krs_indice_01059 PRIMARY KEY ( id );

CREATE TABLE {{user}}.registros_documentos (
    id_registro_cmdcas   NUMBER(20) NOT NULL,
    id_documento         NUMBER(20)
);

COMMENT ON COLUMN {{user}}.registros_documentos.id_documento IS
    '- ID de ligação com a tabela documentos do MS service_documents, com é uma realação fraca via funcionalidade.';

CREATE TABLE {{user}}.registros_duracoes_capacit (
    id_registro_cmdcas   NUMBER(20) NOT NULL,
    id_duracao_capacit   NUMBER(20) NOT NULL
);

CREATE TABLE {{user}}.rep_areas_atuacao_atividades (
    id                    NUMBER(20) NOT NULL,
    codigo_area_atuacao   NUMBER(20) NOT NULL,
    codigo_atividade      NUMBER(20) NOT NULL,
    deletado              NUMBER,
    data_criacao          TIMESTAMP,
    data_alteracao        TIMESTAMP,
    criado_por            VARCHAR2(255),
    modificado_por        VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_areas_atuacao_atividades ADD CONSTRAINT krs_indice_01133 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_areas_atuacao_cursos (
    id                    NUMBER(20) NOT NULL,
    codigo_area_atuacao   NUMBER(20) NOT NULL,
    codigo_curso          NUMBER(20) NOT NULL,
    deletado              NUMBER,
    data_criacao          TIMESTAMP,
    data_alteracao        TIMESTAMP,
    criado_por            VARCHAR2(255),
    modificado_por        VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_areas_atuacao_cursos ADD CONSTRAINT krs_indice_01132 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_areas_atuacao_estagio (
    codigo_area_atuacao      NUMBER(20) NOT NULL,
    descricao_area_atuacao   VARCHAR2(200) NOT NULL,
    deletado                 NUMBER(1),
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
);

COMMENT ON TABLE {{user}}.rep_areas_atuacao_estagio IS
    'Tabela de replica da tabela areas_atuacao_estagio do CORE';

ALTER TABLE {{user}}.rep_areas_atuacao_estagio ADD CONSTRAINT krs_indice_01105 PRIMARY KEY ( codigo_area_atuacao );

CREATE TABLE {{user}}.rep_areas_prof_atuacao (
    id                         NUMBER(20) NOT NULL,
    codigo_area_profissional   NUMBER(20) NOT NULL,
    codigo_area_atuacao        NUMBER(20) NOT NULL,
    deletado                   NUMBER,
    data_criacao               TIMESTAMP,
    data_alteracao             TIMESTAMP,
    criado_por                 VARCHAR2(255),
    modificado_por             VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_areas_prof_atuacao ADD CONSTRAINT krs_indice_01124 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_areas_profissionais (
    codigo_area_profissional      NUMBER(20) NOT NULL,
    descricao_area_profissional   VARCHAR2(200) NOT NULL,
    deletado                      NUMBER(1),
    data_criacao                  TIMESTAMP NOT NULL,
    data_alteracao                TIMESTAMP NOT NULL,
    criado_por                    VARCHAR2(255),
    modificado_por        VARCHAR2(255)
);

COMMENT ON TABLE {{user}}.rep_areas_profissionais IS
    'Tabela de replica da tabela areas_profissionais do CORE';

ALTER TABLE {{user}}.rep_areas_profissionais ADD CONSTRAINT krs_indice_01104 PRIMARY KEY ( codigo_area_profissional );

CREATE TABLE {{user}}.rep_atividades (
    codigo_atividade      NUMBER(20) NOT NULL,
    descricao_atividade   NUMBER(20),
    deletado              NUMBER(1),
    data_criacao          TIMESTAMP NOT NULL,
    data_alteracao        TIMESTAMP NOT NULL,
    criado_por            VARCHAR2(255),
    modificado_por        VARCHAR2(255)
);

COMMENT ON TABLE {{user}}.rep_atividades IS
    '
Tabela de replica da tabela atividades do CORE';

ALTER TABLE {{user}}.rep_atividades ADD CONSTRAINT krs_indice_01107 PRIMARY KEY ( codigo_atividade );

CREATE TABLE {{user}}.rep_cursos (
    codigo_curso                NUMBER(20) NOT NULL,
    descricao_curso             VARCHAR2(200) NOT NULL,
    descricao_abreviada_curso   VARCHAR2(60),
    nilvel_curso                VARCHAR2(5),
    modalidade                  VARCHAR2(1),
    deletado                    NUMBER(1),
    data_criacao                TIMESTAMP NOT NULL,
    data_alteracao              TIMESTAMP NOT NULL,
    criado_por                  VARCHAR2(255),
    modificado_por              VARCHAR2(255)
);

COMMENT ON TABLE {{user}}.rep_cursos IS
    'Tabela de replica da tabela cursos do CORE';

ALTER TABLE {{user}}.rep_cursos ADD CONSTRAINT krs_indice_01106 PRIMARY KEY ( codigo_curso );

CREATE TABLE {{user}}.rep_enderecos (
    id                NUMBER(20) NOT NULL,
    tipo_logradouro   VARCHAR2(150 CHAR) NOT NULL,
    endereco          VARCHAR2(150 CHAR) NOT NULL,
    numero            VARCHAR2(10 CHAR),
    bairro            VARCHAR2(100 CHAR) NOT NULL,
    complemento       VARCHAR2(50 CHAR),
    cep               VARCHAR2(8 CHAR) NOT NULL,
    cidade            VARCHAR2(100 CHAR) NOT NULL,
    uf                VARCHAR2(2 CHAR) NOT NULL,
    deletado          NUMBER,
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255 CHAR),
    modificado_por    VARCHAR2(255 CHAR)
);

ALTER TABLE {{user}}.rep_enderecos ADD CONSTRAINT krs_indice_01177 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_estudantes (
    id               NUMBER NOT NULL,
    cpf              VARCHAR2(11),
    nome             VARCHAR2(255),
    deletado         NUMBER,
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_estudantes ADD CONSTRAINT krs_indice_01068 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_instituicao_ensino (
    id                          NUMBER(20) NOT NULL,
    cnpj                        VARCHAR2(14),
    nome_instituicao            VARCHAR2(50),
    nome_instituicao_reduzido   VARCHAR2(50),
    nome_fantasia_reduzido      VARCHAR2(50),
    nome_popular                VARCHAR2(50),
    deletado                    NUMBER(1),
    data_criacao                TIMESTAMP,
    data_alteracao              TIMESTAMP,
    criado_por                  VARCHAR2(255),
    modificado_por              VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_instituicao_ensino ADD CONSTRAINT rep_instituicao_ensino_pk PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_locais_contrato (
    id               NUMBER(20) NOT NULL,
    id_contrato      NUMBER NOT NULL,
    cnpj             VARCHAR2(14 CHAR),
    nome_fantasia    VARCHAR2(150 CHAR),
    cpf              VARCHAR2(11 CHAR),
    nome             VARCHAR2(150 CHAR),
    deletado         NUMBER,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR)
);

ALTER TABLE {{user}}.rep_locais_contrato ADD CONSTRAINT krs_indice_01169 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_locais_enderecos (
    id                  NUMBER(20) NOT NULL,
    id_local_contrato   NUMBER(20) NOT NULL,
    id_endereco         NUMBER(20) NOT NULL,
    deletado            NUMBER,
    data_criacao        TIMESTAMP NOT NULL,
    data_alteracao      TIMESTAMP NOT NULL,
    criado_por          VARCHAR2(255 CHAR),
    modificado_por      VARCHAR2(255 CHAR)
);

CREATE TABLE {{user}}.rep_municipios (
    codigo_municipio   NUMBER(19) NOT NULL,
    nome_municipio     VARCHAR2(150 CHAR) NOT NULL,
    ativo              NUMBER(1) NOT NULL,
    deletado           NUMBER(1) NOT NULL,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255 CHAR),
    modificado_por     VARCHAR2(255 CHAR)
);

ALTER TABLE {{user}}.rep_municipios ADD CONSTRAINT krs_indice_01056 PRIMARY KEY ( codigo_municipio );

CREATE TABLE {{user}}.rep_parametros_empresa (
    id                NUMBER(20) NOT NULL,
    descricao         VARCHAR2(100) NOT NULL,
    local_parametro   VARCHAR2(1) NOT NULL,
    tipo_contrato     VARCHAR2(2),
    tipo_parametro    VARCHAR2(1) NOT NULL,
    msg_backoffice    VARCHAR2(200) NOT NULL,
    msg_empresa       VARCHAR2(200) NOT NULL,
    msg_estudante     VARCHAR2(200) NOT NULL,
    situacao          NUMBER NOT NULL,
    login             VARCHAR2(50),
    deletado          NUMBER,
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.rep_parametros_empresa.local_parametro IS
    'Flag com as seguintes opções:

O - Abertura de Vagas
T - Triagem
E - Encaminhamento
C - Contratação
P - Prorrogação
I -  Impressão'
    ;

COMMENT ON COLUMN {{user}}.rep_parametros_empresa.tipo_contrato IS
    'Flag com as seguintes opções:

A - Aprendiz
E - Estagio
AE - Aprendiz e Estagio';

COMMENT ON COLUMN {{user}}.rep_parametros_empresa.tipo_parametro IS
    'Flag com as seguintes opções:

R - Restritivo;
O - Orientativo;';

COMMENT ON COLUMN {{user}}.rep_parametros_empresa.situacao IS
    'Flag 0 ou 1

0 - Inativo

1 - Ativo';

ALTER TABLE {{user}}.rep_parametros_empresa ADD CONSTRAINT krs_indice_01089 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_parametros_escolares (
    cod_parametro_escolar         NUMBER(20) NOT NULL,
    desc_parametro_escolar        VARCHAR2(100) NOT NULL,
    desc_param_escolar_reduzida   VARCHAR2(35) NOT NULL,
    mensagem                      VARCHAR2(100),
    id_tipo_parametro             NUMBER(20) NOT NULL,
    ativo                         NUMBER NOT NULL,
    msg_backoffice                VARCHAR2(200),
    msg_empresa                   VARCHAR2(200),
    msg_estudante                 VARCHAR2(200),
    deletado                      NUMBER NOT NULL,
    data_criacao                  TIMESTAMP NOT NULL,
    data_alteracao                TIMESTAMP NOT NULL,
    criado_por                    VARCHAR2(255),
    modificado_por                VARCHAR2(255)
);

ALTER TABLE {{user}}.rep_parametros_escolares ADD CONSTRAINT krs_indice_01085 PRIMARY KEY ( cod_parametro_escolar );

CREATE TABLE {{user}}.rep_parametros_unidades_ciee (
    id                              NUMBER NOT NULL,
    id_ciee                         NUMBER,
    id_unidade_ciee                 NUMBER,
    numero_min_estudantes_triagem   NUMBER(3),
    dias_prazo_ret_empresa          NUMBER(3),
    dias_prazo_tratar               NUMBER(3),
    dias_ret_assistente             NUMBER(3),
    numero_tentativas_contato       NUMBER(3),
    deletado                        NUMBER(1),
    data_criacao                    TIMESTAMP,
    data_alteracao                  TIMESTAMP NOT NULL,
    criado_por                      VARCHAR2(255 CHAR),
    modificado_por                  VARCHAR2(255 CHAR)
);

ALTER TABLE {{user}}.rep_parametros_unidades_ciee ADD CONSTRAINT krs_indice_01035 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_representantes (
    id               NUMBER NOT NULL,
    nome             VARCHAR2(150 BYTE) NOT NULL,
    cargo            VARCHAR2(100 BYTE) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1)
);

ALTER TABLE {{user}}.rep_representantes ADD CONSTRAINT krs_indice_01186 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_representantes_contrato (
    id                 NUMBER NOT NULL,
    id_representante   NUMBER NOT NULL,
    id_contrato        NUMBER NOT NULL,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255 CHAR),
    modificado_por     VARCHAR2(255 CHAR),
    deletado           NUMBER(1)
);

CREATE TABLE {{user}}.rep_unidades_ciee (
    id               NUMBER(19) NOT NULL,
    descricao        VARCHAR2(150 CHAR) NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR)
);

ALTER TABLE {{user}}.rep_unidades_ciee ADD CONSTRAINT krs_indice_01039 PRIMARY KEY ( id );

CREATE TABLE {{user}}.rep_usuarios (
    id               NUMBER(19) NOT NULL,
    codigo           VARCHAR2(100 CHAR),
    email            VARCHAR2(100 CHAR),
    nome             VARCHAR2(300 CHAR),
    tipo_usuario     VARCHAR2(255 CHAR),
    cpf              VARCHAR2(11 BYTE),
    criado_por       VARCHAR2(255 CHAR),
    data_criacao     TIMESTAMP NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    modificado_por   VARCHAR2(255 CHAR),
    data_alteracao   TIMESTAMP NOT NULL
);

ALTER TABLE {{user}}.rep_usuarios ADD CONSTRAINT krs_indice_01036 PRIMARY KEY ( id );

CREATE TABLE {{user}}.reprovacoes_etapa (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(200) NOT NULL,
    situacao         NUMBER NOT NULL,
    deletado         NUMBER(1),
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.reprovacoes_etapa.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.reprovacoes_etapa ADD CONSTRAINT krs_indice_01030 PRIMARY KEY ( id );

CREATE TABLE {{user}}.salas_capacitacao (
    id                NUMBER(20) NOT NULL,
    id_local          NUMBER(20) NOT NULL,
    descricao_sala    VARCHAR2(100) NOT NULL,
    capacidade_sala   NUMBER(20) NOT NULL,
    situacao          NUMBER DEFAULT 1 NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.salas_capacitacao.situacao IS
    'Flag:

  0 - Inativo
  1 Ativo';

ALTER TABLE {{user}}.salas_capacitacao ADD CONSTRAINT krs_indice_01022 PRIMARY KEY ( id );

CREATE TABLE {{user}}.situacoes (
    id               NUMBER(20) NOT NULL,
    sigla            VARCHAR2(1) NOT NULL,
    descricao        VARCHAR2(40) NOT NULL,
    deletado         NUMBER(1),
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.situacoes.sigla IS
    '- A operação usa sigla que são letras, a intenção aqui é facilitar para o usuario final.
- Ex.:
ID-SIGLA-DESCRICAO
1     A        Aberta
2     B         Bloqueada
3     C        Cancelada
4     E         Processo Seletivo Empresa
5     I          Visita do Assistente
6     K        Marcação de Contrato
7     P        Preenchida
8     S        Processo Seletivo CIEE'
    ;

COMMENT ON COLUMN {{user}}.situacoes.descricao IS
    '- Descricao da situação da vaga';

ALTER TABLE {{user}}.situacoes ADD CONSTRAINT krs_indice_01004 PRIMARY KEY ( id );

CREATE TABLE {{user}}.situacoes_cursos_mte (
    id                       NUMBER(20) NOT NULL,
    descricao                VARCHAR2(150) NOT NULL,
    disponivel_contratacao   NUMBER NOT NULL,
    situacao                 NUMBER NOT NULL,
    deletado                 NUMBER,
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.situacoes_cursos_mte.disponivel_contratacao IS
    'Flag 0 ou 1

0 - Não disponivel
1 - Disponivel
';

COMMENT ON COLUMN {{user}}.situacoes_cursos_mte.situacao IS
    'Flag 0 ou 1

0 - Inativo
1 - Ativo';

ALTER TABLE {{user}}.situacoes_cursos_mte ADD CONSTRAINT krs_indice_01051 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_conferencia (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    link                         VARCHAR2(255) NOT NULL,
    instrucoes_apoio             CLOB,
    id_responsavel_processo      NUMBER NOT NULL,
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

ALTER TABLE {{user}}.tipo_conferencia ADD CONSTRAINT krs_indice_01143 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_ligacao_tef (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    instrucoes_apoio             CLOB,
    data_ligacao                 TIMESTAMP NOT NULL,
    hora_ligacao                 TIMESTAMP NOT NULL,
    id_responsavel_processo      NUMBER NOT NULL,
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

ALTER TABLE {{user}}.tipo_ligacao_tef ADD CONSTRAINT krs_indice_01150 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_presencial (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    cep                          NUMBER(19) NOT NULL,
    cidade                       VARCHAR2(100) NOT NULL,
    uf                           VARCHAR2(2) NOT NULL,
    endereco                     VARCHAR2(150) NOT NULL,
    numero                       VARCHAR2(10) NOT NULL,
    complemento                  VARCHAR2(200),
    bairro                       VARCHAR2(100) NOT NULL,
    ponto_referencia             VARCHAR2(100),
    entrevista                   NUMBER,
    contato                      VARCHAR2(50),
    telefone_contato             VARCHAR2(64),
    id_responsavel_processo      NUMBER NOT NULL,
    quantidade_candidatos        NUMBER(10),
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.tipo_presencial.entrevista IS
    'Flag:

 0 - Individual
 1 - Coletiva';

ALTER TABLE {{user}}.tipo_presencial ADD CONSTRAINT krs_indice_01120 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_presencial_docs (
    id_tipo_presencial   NUMBER(20) NOT NULL,
    documento            VARCHAR2(100)
);

CREATE TABLE {{user}}.tipo_prova (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    id_prova                     NUMBER(20) NOT NULL,
    instrucoes_apoio             CLOB,
    instrucoes_prova             CLOB,
    duracao_prova                NUMBER(10),
    id_responsavel_processo      NUMBER NOT NULL,
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.tipo_prova.duracao_prova IS
    'OBS:
   trazer o tempo cadastrado no Modelo de Prova selecionado
   e permitir que esse valor seja alterado.';

ALTER TABLE {{user}}.tipo_prova ADD CONSTRAINT krs_indice_01147 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_upload (
    id                           NUMBER(20) NOT NULL,
    id_etapa_processo_seletivo   NUMBER(20) NOT NULL,
    instrucoes_apoio             CLOB,
    id_responsavel_processo      NUMBER NOT NULL,
    data_limite                  TIMESTAMP,
    hora_limite                  TIMESTAMP,
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

ALTER TABLE {{user}}.tipo_upload ADD CONSTRAINT krs_indice_01146 PRIMARY KEY ( id );

CREATE TABLE {{user}}.tipo_upload_ext (
    id_tipo_upload   NUMBER(20) NOT NULL,
    extensao         VARCHAR2(10)
);

CREATE TABLE {{user}}.turmas (
    id                       NUMBER(20) NOT NULL,
    id_vaga_aprendiz         NUMBER(20) NOT NULL,
    id_curso                 NUMBER(20),
    nome_curso               VARCHAR2(255),
    nome_local_capacitacao   VARCHAR2(255),
    endereco                 VARCHAR2(255),
    numero                   VARCHAR2(10),
    complemento              VARCHAR2(50),
    cep                      VARCHAR2(8),
    cidade                   VARCHAR2(100),
    uf                       VARCHAR2(2),
    faixa_etaria_inicial     VARCHAR2(2) NOT NULL,
    faixa_etaria_final       VARCHAR2(2) NOT NULL,
    dias_semana              VARCHAR2(30) NOT NULL,
    horario_inicial          TIMESTAMP NOT NULL,
    horario_final            TIMESTAMP NOT NULL,
    distancia                NUMBER(3) NOT NULL,
    total_horas_teoricas     NUMBER(5),
    total_horas_praticas     NUMBER(5),
    carga_horaria_diaria     TIMESTAMP,
    modulo_curso             VARCHAR2(255),
    id_controle_turma        NUMBER(20),
    tipo_turma               VARCHAR2(10),
    latitude                 FLOAT,
    longitude                FLOAT,
    tipo_pesquisa            VARCHAR2(30),
    deletado                 NUMBER,
    preferencial             NUMBER,
    confirmado               NUMBER,
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.turmas.preferencial IS
    'Flag 0 ou 1

Marcar o Curso de Capacitacao  Preferencial';

COMMENT ON COLUMN {{user}}.turmas.confirmado IS
    'Flag 0 ou 1:

  Esse campo serve para marcar a resposta do webservice de secretaria no momento de confirmação da vaga.';

ALTER TABLE {{user}}.turmas ADD CONSTRAINT krs_indice_01184 PRIMARY KEY ( id );

CREATE TABLE {{user}}.usuarios_cto (
    id               NUMBER(20) NOT NULL,
    id_usuario       NUMBER(19) NOT NULL,
    cto              NUMBER(1) NOT NULL,
    deletado         NUMBER(1),
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.usuarios_cto.cto IS
    'Normalizacao:

1 = CTOSP
2 = CTODF
3 = CTOCE';

ALTER TABLE {{user}}.usuarios_cto ADD CONSTRAINT krs_indice_01037 PRIMARY KEY ( id );

CREATE TABLE {{user}}.vagas_aprendiz (
    id                         NUMBER(20) NOT NULL,
    prioriza_vulneravel        NUMBER,
    localizacao                NUMBER(1) NOT NULL,
    nome                       VARCHAR2(60),
    departamento               VARCHAR2(40),
    email                      VARCHAR2(150),
    ddd                        VARCHAR2(2),
    telefone                   VARCHAR2(60),
    descricao                  VARCHAR2(50) NOT NULL,
    numero_vagas               NUMBER(5) NOT NULL,
    tipo_divulgacao            NUMBER(1),
    divulgar_nome_empresa      NUMBER,
    descricao_empresa          VARCHAR2(150),
    divulgar_logo_empresa      NUMBER,
    id_area_atuacao_aprendiz   NUMBER(20) NOT NULL,
    id_turmas                  NUMBER(20) NOT NULL,
    escolaridade               NUMBER,
    situacao_escolaridade      NUMBER,
    tipo_salario               NUMBER(1),
    valor_salario              NUMBER(10, 2),
    tipo_auxilio_transporte    NUMBER(1),
    contrapartida_transporte   VARCHAR2(50),
    beneficios_adicionais      NUMBER(1),
    codigo_da_vaga             NUMBER(20),
    deletado                   NUMBER,
    data_criacao               TIMESTAMP,
    data_alteracao             TIMESTAMP,
    criado_por                 VARCHAR2(255),
    modificado_por             VARCHAR2(255)
);

COMMENT ON COLUMN {{user}}.vagas_aprendiz.prioriza_vulneravel IS
    'Flag 0 ou 1
';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.localizacao IS
    'Enum:

0 - Todos
1 - Onde o estudante mora
2 - Onde o estudante estuda
3 - Onde o estudante mora e estuda
4 - Onde o estudante faz capacitacao e mora
5 - Onde o estudante faz capacitacao
6 - Onde o estudante faz capacitacao e estuda
'
    ;

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_divulgacao IS
    'Tipo de divulgação da vaga podendo ser:

1 - Pública
2 - Confidencial
3 -Restrita';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.divulgar_nome_empresa IS
    'Flag 0 ou 1';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.divulgar_logo_empresa IS
    'Flag 0 ou 1';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.escolaridade IS
    'Enum:

0 - Todos

1 - Ensino Fundamental

2 - Ensino Medio';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.situacao_escolaridade IS
    'Enum:

0 - Todos

1 - Cursando

2 - Concluido';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_salario IS
    'Enum:

0 - Mensal

1 - Por Hora

2 - Fixo

3 - A combinar';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_auxilio_transporte IS
    'Enum:

0 - Mensal

1 - Diario

2 - Fixo

3 - A combinar';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.beneficios_adicionais IS
    'Flag 0 ou 1';

ALTER TABLE {{user}}.vagas_aprendiz ADD CONSTRAINT krs_indice_01162 PRIMARY KEY ( id );

CREATE TABLE {{user}}.vagas_estagio (
    id                             NUMBER(20) NOT NULL,
    id_local_contrato              NUMBER(20) NOT NULL,
    localizacao                    NUMBER(1),
    autorizacao_atendimento        NUMBER,
    numero_autorizacao             VARCHAR2(20),
    processo_personalizado         NUMBER,
    repor_estagiario               NUMBER,
    prioriza_vulneravel            NUMBER,
    descricao                      VARCHAR2(50 BYTE) NOT NULL,
    numero_vagas                   NUMBER(5) NOT NULL,
    tipo_divulgacao                NUMBER(1) NOT NULL,
    divulgar_nome_empresa          NUMBER DEFAULT 0 NOT NULL,
    descricao_empresa              VARCHAR2(150 BYTE),
    divulgar_logo_empresa          NUMBER NOT NULL,
    nome_contato                   VARCHAR2(60) NOT NULL,
    depto_contato                  VARCHAR2(40) NOT NULL,
    email_contato                  VARCHAR2(150) NOT NULL,
    ddd_fone_contato               VARCHAR2(2) NOT NULL,
    fone_contato                   VARCHAR2(60) NOT NULL,
    semestre_inicial               NUMBER(2),
    semestre_final                 NUMBER(2),
    data_conclusao                 DATE,
    nivel_estudante_vaga           NUMBER(1) NOT NULL,
    tipo_horario_estagio           NUMBER(1) NOT NULL,
    horario_entrada                TIMESTAMP,
    horario_saida                  TIMESTAMP,
    jornada                        TIMESTAMP,
    intervalo                      TIMESTAMP,
    tipo_auxilio_bolsa             NUMBER(1) NOT NULL,
    valor_bolsa_fixo               NUMBER(10, 2),
    valor_bolsa_de                 NUMBER(10, 2),
    valor_bolsa_ate                NUMBER(10, 2),
    valor_medio_mercado            NUMBER(10, 2),
    valor_medio_empresa            NUMBER(10, 2),
    tipo_auxilio_transporte        NUMBER(1) NOT NULL,
    valor_transporte_fixo          NUMBER(10, 2),
    contrapartida_aux_transporte   VARCHAR2(100),
    num_encaminhamento_vaga        NUMBER(5) NOT NULL,
    id_rede_social                 NUMBER(20),
    beneficios_adicionais          NUMBER NOT NULL,
    assertividade_idioma           NUMBER(3),
    assertividade_conhecimento     NUMBER(3),
    sexo                           VARCHAR2(1 BYTE),
    estado_civil                   NUMBER(1),
    reservista                     NUMBER,
    fumante                        NUMBER,
    possui_cnh                     NUMBER,
    faixa_etaria                   NUMBER(1),
    idade_minima                   NUMBER(2),
    idade_maxima                   NUMBER(2),
    id_situacao_vaga               NUMBER(20) NOT NULL,
    data_cancelamento              DATE,
    tipo_distancia_raio            NUMBER(1),
    id_ocorrencia                  NUMBER(20),
    codigo_area_profissional       NUMBER(20) NOT NULL,
    codigo_da_vaga                 NUMBER(20),
    deletado                       NUMBER(1),
    data_criacao                   TIMESTAMP NOT NULL,
    data_alteracao                 TIMESTAMP NOT NULL,
    criado_por                     VARCHAR2(255 BYTE),
    modificado_por                 VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN {{user}}.vagas_estagio.localizacao IS
    'Enum:

0 - Todos
1 - Onde o estudante mora
2 - Onde o estudante estuda
3 - Onde o estudante mora e estuda
';

COMMENT ON COLUMN {{user}}.vagas_estagio.autorizacao_atendimento IS
    'Flag 0 ou 1

';

COMMENT ON COLUMN {{user}}.vagas_estagio.processo_personalizado IS
    'Flag 0 ou 1

';

COMMENT ON COLUMN {{user}}.vagas_estagio.repor_estagiario IS
    'Flag 0 ou 1';

COMMENT ON COLUMN {{user}}.vagas_estagio.prioriza_vulneravel IS
    'Flag 0 ou 1';

COMMENT ON COLUMN {{user}}.vagas_estagio.descricao IS
    'Descrição da Vaga - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.numero_vagas IS
    'Quantidade de Vagas - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.tipo_divulgacao IS
    'Tipo de divulgação da vaga podendo ser:

Pública=1,
Confidencial=2
Restrita=3

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.divulgar_nome_empresa IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.descricao_empresa IS
    'Texto a ser informado quando flag divulga_descricao_empresa for = 1,
Exemplo: Empresa Lider no segmento farmaceutico.
OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.divulgar_logo_empresa IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.nome_contato IS
    'Nome do conto da vaga na empresa. - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.depto_contato IS
    'Depto do contato da vaga na empresa.  - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.email_contato IS
    'Email do contato da vaga na empresa - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.ddd_fone_contato IS
    'Telefone do contato da vaga na empresa OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.fone_contato IS
    'Telefone do contato da vaga na empresa OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.data_conclusao IS
    'Data de conclusão do estagio. - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.nivel_estudante_vaga IS
    'Nivel de escolaridade para preenchimento da vaga:
pode ser preenchida:

Médio    =1
Técnico =2
Superior=3

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.tipo_horario_estagio IS
    'Tipo de horario de estagio, pode ser preenchido:

A combinar=1
Definido      =2

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.horario_entrada IS
    'Horario de Entrada preenchido, qdo tipo_horario_entrada=D. OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.horario_saida IS
    'Horario de Saida, preenchido qdo tipo_horario_entrada=D. OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.tipo_auxilio_bolsa IS
    'Tipo de Bolsa Auxilio pode ser preenchido:

Mensal         =1
Por Hora      =2
Fixo              =3
A Combinar=4

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.valor_bolsa_fixo IS
    'Valor Fixo da Bolsa Auxilio - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.valor_bolsa_de IS
    'Para o Tipo A combinar o valor da bolsa é um range, esse campo é o valor inicial - ok';

COMMENT ON COLUMN {{user}}.vagas_estagio.valor_bolsa_ate IS
    'Para o Tipo A combinar o valor da bolsa é um range, esse campo é o valor final - ok';

COMMENT ON COLUMN {{user}}.vagas_estagio.tipo_auxilio_transporte IS
    'Tipo de  Auxilio Transporte pode ser preenchido:

Mensal         =1
Por Hora      =2
Fixo              =3
A Combinar=4

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.valor_transporte_fixo IS
    'Valor Fixo Vale Transporte - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.contrapartida_aux_transporte IS
    'Campo de Texto para informar a contrapartida do auxilio transporte. OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.num_encaminhamento_vaga IS
    'Numero de Candidatos que devem ser encaminhados para vaga - OK
PARA BACKOFFICE';

COMMENT ON COLUMN {{user}}.vagas_estagio.id_rede_social IS
    '- id da tabela vaga_est_rede_social';

COMMENT ON COLUMN {{user}}.vagas_estagio.beneficios_adicionais IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.assertividade_idioma IS
    'PARA BACKOFFICE';

COMMENT ON COLUMN {{user}}.vagas_estagio.assertividade_conhecimento IS
    'Nivel minimo de assertividade do conhecimento para a vaga. - OK
PARA BACKOFFICE';

COMMENT ON COLUMN {{user}}.vagas_estagio.sexo IS
    'Pode ser preenchido:

Indiferente=I
Feminino   =F
Masculino =M

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.estado_civil IS
    'Estado Civil, campo normalizado preenchimento:

1- SOLTEIRO;
2- CASADO;
3- SEPARADO;
4- DIVORCIADO;
5- VIUVO;

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.reservista IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.fumante IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.possui_cnh IS
    'Flag 0 ou 1 - OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.faixa_etaria IS
    'Faixa Etária, campo normalizado preenchimento:

1-Indiferente
2-Menor de Idade
3-Maior de 18 anos
4-Especifico.

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.idade_minima IS
    'Quando campo Faixa_Etaria = 4

Preencher a idade minima para vaga.

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.idade_maxima IS
    'Quando campo Faixa_Etaria = 4

Preencher a idade maxima  para vaga.

OK';

COMMENT ON COLUMN {{user}}.vagas_estagio.data_cancelamento IS
    '- Caso o id da situação da vaga seja de cancelamento o preenchimento da
data torna-se obrigatório.';

COMMENT ON COLUMN {{user}}.vagas_estagio.tipo_distancia_raio IS
    '- Tipo a considerar para o calculo do raio
- Ex:

1 Mora ou Estuda (defalt)
2 Estuda
3 Mora
4 Mora e Estuda
5 Mora e Capácitacao
6 Estuda e Capacitacao'
    ;

ALTER TABLE {{user}}.vagas_estagio ADD CONSTRAINT krs_indice_00900 PRIMARY KEY ( id );

CREATE TABLE {{user}}.valor_medio_bolsa_hora (
    id                            NUMBER(20) NOT NULL,
    id_empresa                    NUMBER(20),
    razao_social                  VARCHAR2(150),
    id_contrato                   NUMBER(20),
    id_area_profissional          NUMBER(20),
    descricao_area_profissional   VARCHAR2(200),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    valor_bolsas_hora             NUMBER(12, 2),
    quantidade_tce                NUMBER(12, 2)
);

COMMENT ON TABLE {{user}}.valor_medio_bolsa_hora IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.valor_medio_bolsa_hora ADD CONSTRAINT krs_indice_01116 PRIMARY KEY ( id );

CREATE TABLE {{user}}.valor_medio_bolsa_mensal (
    id                            NUMBER(20) NOT NULL,
    id_empresa                    NUMBER(20),
    razao_social                  VARCHAR2(150),
    id_contrato                   NUMBER(20),
    id_area_profissional          NUMBER(20),
    descricao_area_profissional   VARCHAR2(200),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    valor_bolsas_mensal           NUMBER(12, 2),
    quantidade_tce                NUMBER(12, 2)
);

COMMENT ON TABLE {{user}}.valor_medio_bolsa_mensal IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE {{user}}.valor_medio_bolsa_mensal ADD CONSTRAINT krs_indice_01115 PRIMARY KEY ( id );

ALTER TABLE {{user}}.pcd
    ADD CONSTRAINT krs_indice_00902 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.beneficios_adicionais
    ADD CONSTRAINT krs_indice_00903 FOREIGN KEY ( id_beneficio )
        REFERENCES {{user}}.beneficios ( id );

ALTER TABLE {{user}}.beneficios_adicionais
    ADD CONSTRAINT krs_indice_00904 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.areas_atuacao_estagio
    ADD CONSTRAINT krs_indice_00909 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.cursos_estagio
    ADD CONSTRAINT krs_indice_00911 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.atividades_estagio
    ADD CONSTRAINT krs_indice_00913 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.escolas
    ADD CONSTRAINT krs_indice_00915 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.palavras_chave
    ADD CONSTRAINT krs_indice_00917 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.idiomas_estagio
    ADD CONSTRAINT krs_indice_00919 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.conhecimentos_inf_estagio
    ADD CONSTRAINT krs_indice_00921 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.aparelhos_pcd
    ADD CONSTRAINT krs_indice_00923 FOREIGN KEY ( id_vaga_estagio_pcd )
        REFERENCES {{user}}.pcd ( id );

ALTER TABLE {{user}}.redes_sociais
    ADD CONSTRAINT krs_indice_01007 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.ocorrencias
    ADD CONSTRAINT krs_indice_01013 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES {{user}}.vagas_estagio ( id );

ALTER TABLE {{user}}.vagas_estagio
    ADD CONSTRAINT krs_indice_01014 FOREIGN KEY ( id_situacao_vaga )
        REFERENCES {{user}}.situacoes ( id );

ALTER TABLE {{user}}.salas_capacitacao
    ADD CONSTRAINT krs_indice_01023 FOREIGN KEY ( id_local )
        REFERENCES {{user}}.locais_capacitacao ( id );

ALTER TABLE {{user}}.cbo_atividades_aprendiz
    ADD CONSTRAINT krs_indice_01026 FOREIGN KEY ( id_atividade )
        REFERENCES {{user}}.atividades_aprendiz ( id );

ALTER TABLE {{user}}.cbo_atividades_aprendiz
    ADD CONSTRAINT krs_indice_01027 FOREIGN KEY ( id_cbo )
        REFERENCES {{user}}.cbos ( id );

ALTER TABLE {{user}}.usuarios_cto
    ADD CONSTRAINT krs_indice_01038 FOREIGN KEY ( id_usuario )
        REFERENCES {{user}}.rep_usuarios ( id );

ALTER TABLE {{user}}.duracoes_capacitacao
    ADD CONSTRAINT krs_indice_01042 FOREIGN KEY ( id_curso_capacit )
        REFERENCES {{user}}.cursos_capacitacao ( id );

ALTER TABLE {{user}}.duracoes_capacitacao
    ADD CONSTRAINT krs_indice_01043 FOREIGN KEY ( id_area_atuacao )
        REFERENCES {{user}}.areas_atuacao_aprendiz ( id );

ALTER TABLE {{user}}.duracoes_capacitacao
    ADD CONSTRAINT krs_indice_01045 FOREIGN KEY ( id_portaria )
        REFERENCES {{user}}.portarias_mte ( id );

ALTER TABLE {{user}}.cargas_horaria
    ADD CONSTRAINT krs_indice_01047 FOREIGN KEY ( id_duracoes )
        REFERENCES {{user}}.duracoes_capacitacao ( id );

ALTER TABLE {{user}}.cargas_horaria
    ADD CONSTRAINT krs_indice_01048 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES {{user}}.rep_unidades_ciee ( id );

ALTER TABLE {{user}}.cargas_horaria
    ADD CONSTRAINT krs_indice_01049 FOREIGN KEY ( id_local_capacitacao )
        REFERENCES {{user}}.locais_capacitacao ( id );

ALTER TABLE {{user}}.cursos_mte
    ADD CONSTRAINT krs_indice_01050 FOREIGN KEY ( id_curso_capacitacao )
        REFERENCES {{user}}.cursos_capacitacao ( id );

ALTER TABLE {{user}}.duracoes_cursos_mte
    ADD CONSTRAINT krs_indice_01053 FOREIGN KEY ( id_situacao )
        REFERENCES {{user}}.situacoes_cursos_mte ( id );

ALTER TABLE {{user}}.duracoes_cursos_mte
    ADD CONSTRAINT krs_indice_01054 FOREIGN KEY ( id_curso_mte )
        REFERENCES {{user}}.cursos_mte ( id );

ALTER TABLE {{user}}.cursos_mte
    ADD CONSTRAINT krs_indice_01055 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES {{user}}.rep_unidades_ciee ( id );

ALTER TABLE {{user}}.cursos_mte
    ADD CONSTRAINT krs_indice_01058 FOREIGN KEY ( id_municipio_ibge )
        REFERENCES {{user}}.rep_municipios ( codigo_municipio );

ALTER TABLE {{user}}.registros_cmdcas
    ADD CONSTRAINT krs_indice_01060 FOREIGN KEY ( id_unidade_ciee )
        REFERENCES {{user}}.rep_unidades_ciee ( id );

ALTER TABLE {{user}}.registros_cmdcas
    ADD CONSTRAINT krs_indice_01061 FOREIGN KEY ( id_municipio_ibge )
        REFERENCES {{user}}.rep_municipios ( codigo_municipio );

ALTER TABLE {{user}}.registros_duracoes_capacit
    ADD CONSTRAINT krs_indice_01065 FOREIGN KEY ( id_registro_cmdcas )
        REFERENCES {{user}}.registros_cmdcas ( id );

ALTER TABLE {{user}}.registros_duracoes_capacit
    ADD CONSTRAINT krs_indice_01066 FOREIGN KEY ( id_duracao_capacit )
        REFERENCES {{user}}.duracoes_capacitacao ( id );

ALTER TABLE {{user}}.registros_documentos
    ADD CONSTRAINT krs_indice_01067 FOREIGN KEY ( id_registro_cmdcas )
        REFERENCES {{user}}.registros_cmdcas ( id );

ALTER TABLE {{user}}.duracoes_capacit_cbos
    ADD CONSTRAINT krs_indice_01069 FOREIGN KEY ( id_duracoes )
        REFERENCES {{user}}.duracoes_capacitacao ( id );

ALTER TABLE {{user}}.duracoes_capacit_cbos
    ADD CONSTRAINT krs_indice_01070 FOREIGN KEY ( id_cbos )
        REFERENCES {{user}}.cbos ( id );

ALTER TABLE {{user}}.duracoes_cursos_mte
    ADD CONSTRAINT krs_indice_01080 FOREIGN KEY ( id_duracao_capacit )
        REFERENCES {{user}}.duracoes_capacitacao ( id );

ALTER TABLE {{user}}.periodo_capacitacao_anteriores
    ADD CONSTRAINT krs_indice_01082 FOREIGN KEY ( id_estudante )
        REFERENCES {{user}}.rep_estudantes ( id );

ALTER TABLE {{user}}.periodo_capacitacao_anteriores
    ADD CONSTRAINT krs_indice_01083 FOREIGN KEY ( id_curso_capacitacao )
        REFERENCES {{user}}.cursos_capacitacao ( id );

ALTER TABLE {{user}}.parametros_ie
    ADD CONSTRAINT krs_indice_01087 FOREIGN KEY ( id_parametro )
        REFERENCES {{user}}.rep_parametros_escolares ( cod_parametro_escolar );

ALTER TABLE {{user}}.parametros_empresa_contrato
    ADD CONSTRAINT krs_indice_01091 FOREIGN KEY ( id_parametro_empresa )
        REFERENCES {{user}}.rep_parametros_empresa ( id );

ALTER TABLE {{user}}.etapas_processo_seletivo
    ADD CONSTRAINT krs_indice_01119 FOREIGN KEY ( id_ferramenta_selecao )
        REFERENCES {{user}}.ferramentas_selecao ( id );

ALTER TABLE {{user}}.rep_areas_prof_atuacao
    ADD CONSTRAINT krs_indice_01122 FOREIGN KEY ( codigo_area_profissional )
        REFERENCES {{user}}.rep_areas_profissionais ( codigo_area_profissional );

ALTER TABLE {{user}}.rep_areas_prof_atuacao
    ADD CONSTRAINT krs_indice_01123 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES {{user}}.rep_areas_atuacao_estagio ( codigo_area_atuacao );

ALTER TABLE {{user}}.rep_areas_atuacao_cursos
    ADD CONSTRAINT krs_indice_01127 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES {{user}}.rep_areas_atuacao_estagio ( codigo_area_atuacao );

ALTER TABLE {{user}}.rep_areas_atuacao_cursos
    ADD CONSTRAINT krs_indice_01128 FOREIGN KEY ( codigo_curso )
        REFERENCES {{user}}.rep_cursos ( codigo_curso );

ALTER TABLE {{user}}.rep_areas_atuacao_atividades
    ADD CONSTRAINT krs_indice_01130 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES {{user}}.rep_areas_atuacao_estagio ( codigo_area_atuacao );

ALTER TABLE {{user}}.rep_areas_atuacao_atividades
    ADD CONSTRAINT krs_indice_01131 FOREIGN KEY ( codigo_atividade )
        REFERENCES {{user}}.rep_atividades ( codigo_atividade );

ALTER TABLE {{user}}.areas_atuacao_estagio
    ADD CONSTRAINT krs_indice_01134 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES {{user}}.rep_areas_atuacao_estagio ( codigo_area_atuacao );

ALTER TABLE {{user}}.cursos_estagio
    ADD CONSTRAINT krs_indice_01135 FOREIGN KEY ( codigo_curso )
        REFERENCES {{user}}.rep_cursos ( codigo_curso );

ALTER TABLE {{user}}.atividades_estagio
    ADD CONSTRAINT krs_indice_01136 FOREIGN KEY ( codigo_atividade )
        REFERENCES {{user}}.rep_atividades ( codigo_atividade );

ALTER TABLE {{user}}.vagas_estagio
    ADD CONSTRAINT krs_indice_01137 FOREIGN KEY ( codigo_area_profissional )
        REFERENCES {{user}}.rep_areas_profissionais ( codigo_area_profissional );

ALTER TABLE {{user}}.tipo_presencial_docs
    ADD CONSTRAINT krs_indice_01142 FOREIGN KEY ( id_tipo_presencial )
        REFERENCES {{user}}.tipo_presencial ( id );

ALTER TABLE {{user}}.tipo_presencial
    ADD CONSTRAINT krs_indice_01151 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.tipo_conferencia
    ADD CONSTRAINT krs_indice_01152 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.tipo_upload
    ADD CONSTRAINT krs_indice_01153 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.tipo_prova
    ADD CONSTRAINT krs_indice_01154 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.rep_locais_enderecos
    ADD CONSTRAINT krs_indice_01179 FOREIGN KEY ( id_endereco )
        REFERENCES {{user}}.rep_enderecos ( id );

ALTER TABLE {{user}}.rep_locais_enderecos
    ADD CONSTRAINT krs_indice_01180 FOREIGN KEY ( id_local_contrato )
        REFERENCES {{user}}.rep_locais_contrato ( id );

ALTER TABLE {{user}}.vagas_estagio
    ADD CONSTRAINT krs_indice_01182 FOREIGN KEY ( id_local_contrato )
        REFERENCES {{user}}.rep_locais_contrato ( id );

ALTER TABLE {{user}}.tipo_upload_ext
    ADD CONSTRAINT krs_indice_01185 FOREIGN KEY ( id_tipo_upload )
        REFERENCES {{user}}.tipo_upload ( id );

ALTER TABLE {{user}}.rep_representantes_contrato
    ADD CONSTRAINT krs_indice_01187 FOREIGN KEY ( id_representante )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.tipo_presencial
    ADD CONSTRAINT krs_indice_01192 FOREIGN KEY ( id_responsavel_processo )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.tipo_conferencia
    ADD CONSTRAINT krs_indice_01193 FOREIGN KEY ( id_responsavel_processo )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.tipo_upload
    ADD CONSTRAINT krs_indice_01194 FOREIGN KEY ( id_responsavel_processo )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.tipo_prova
    ADD CONSTRAINT krs_indice_01195 FOREIGN KEY ( id_responsavel_processo )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.tipo_ligacao_tef
    ADD CONSTRAINT krs_indice_01196 FOREIGN KEY ( id_responsavel_processo )
        REFERENCES {{user}}.rep_representantes ( id );

ALTER TABLE {{user}}.conhecimentos_inf_estagio
    ADD CONSTRAINT krs_indice_01201 FOREIGN KEY ( id_conhecimento )
        REFERENCES {{user}}.conhecimentos ( id );

ALTER TABLE {{user}}.tipo_ligacao_tef
    ADD CONSTRAINT krs_indice_01155 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.etapas_periodos
    ADD CONSTRAINT krs_indice_01158 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.tipo_prova
    ADD CONSTRAINT krs_indice_01159 FOREIGN KEY ( id_prova )
        REFERENCES {{user}}.provas ( id );

ALTER TABLE {{user}}.agenda_processo_seletivo
    ADD CONSTRAINT krs_indice_01161 FOREIGN KEY ( id_etapa_processo_seletivo )
        REFERENCES {{user}}.etapas_processo_seletivo ( id );

ALTER TABLE {{user}}.palavras_chave_aprendiz
    ADD CONSTRAINT krs_indice_01164 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES {{user}}.vagas_aprendiz ( id );

ALTER TABLE {{user}}.vagas_aprendiz
    ADD CONSTRAINT krs_indice_01165 FOREIGN KEY ( id_area_atuacao_aprendiz )
        REFERENCES {{user}}.areas_atuacao_aprendiz ( id );

ALTER TABLE {{user}}.beneficios_adic_aprendiz
    ADD CONSTRAINT krs_indice_01166 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES {{user}}.vagas_aprendiz ( id );

ALTER TABLE {{user}}.beneficios_adic_aprendiz
    ADD CONSTRAINT krs_indice_01167 FOREIGN KEY ( id_beneficio )
        REFERENCES {{user}}.beneficios ( id );

ALTER TABLE {{user}}.turmas
    ADD CONSTRAINT krs_indice_01168 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES {{user}}.vagas_aprendiz ( id );

ALTER TABLE {{user}}.idiomas_estagio
    ADD CONSTRAINT krs_indice_01199 FOREIGN KEY ( id_idioma )
        REFERENCES {{user}}.idiomas ( id );


--***************************************
--Dados gerados durante a criação do DDL*
--***************************************


-- Relatório do Resumo do Oracle SQL Developer Data Modeler:
--
-- CREATE TABLE                            84
-- CREATE INDEX                             0
-- ALTER TABLE                            229
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
--
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
--
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
--
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
--
-- ERRORS                                   0
-- WARNINGS                                 0
