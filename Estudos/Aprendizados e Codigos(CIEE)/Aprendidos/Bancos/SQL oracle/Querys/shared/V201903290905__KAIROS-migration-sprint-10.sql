--MIGRATION INICIAL SPRINT 10--

---------------------------------------------------------------------------------------------------------------------------------------
-- PK 5966 --

--CRIACAO DA TABELA MOTIVOS_CANCELAMENTO_VAGA

CREATE TABLE motivos_cancelamento_vaga (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(150) NOT NULL,
    origem           NUMBER(1) NOT NULL,
    ativo            NUMBER DEFAULT 1 NOT NULL,
    deletado         NUMBER DEFAULT 0,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN motivos_cancelamento_vaga.id IS
    'Codigo - Código da Motivo Vaga - Numérico (obrigatório);';

COMMENT ON COLUMN motivos_cancelamento_vaga.descricao IS
    'Descricao - Descrição do Motivo da Vaga: texto (150) (obrigatório);';

COMMENT ON COLUMN motivos_cancelamento_vaga.origem IS
    'ENUM:

1 - CIEE
2 - EMPRESA';

COMMENT ON COLUMN motivos_cancelamento_vaga.ativo IS
    'FLAG:

0 - INATIVO
1 - ATIVO';

ALTER TABLE motivos_cancelamento_vaga ADD CONSTRAINT krs_indice_02125 PRIMARY KEY ( id );


--ALTERACAO NA TABELA VAGAS_ESTAGIO
alter table vagas_estagio add id_motivo_cancelamento number(20);
alter table vagas_estagio add usuario_cancelamento varchar2(50);
alter table vagas_estagio add data_hora_cancelamento timestamp;

ALTER TABLE vagas_estagio ADD CONSTRAINT krs_indice_02123 FOREIGN KEY ( id_motivo_cancelamento ) REFERENCES motivos_cancelamento_vaga ( id );


--ALTERACAO NA TABELA VAGAS_APRENDIZ
alter table vagas_aprendiz add id_motivo_cancelamento number(20);
alter table vagas_aprendiz add usuario_cancelamento varchar2(50);
alter table vagas_aprendiz add data_hora_cancelamento timestamp;

ALTER TABLE vagas_aprendiz ADD CONSTRAINT krs_indice_02124 FOREIGN KEY ( id_motivo_cancelamento ) REFERENCES motivos_cancelamento_vaga ( id );

---------------------------------------------------------------------------------------------------------------------------------------


-- PK-6047 --

CREATE TABLE vitrine_vagas (
    id                       NUMBER(20) NOT NULL,
    id_estado                NUMBER(20) NOT NULL,
    ordem                    NUMBER(3),
    data_publicacao_inicio   TIMESTAMP NOT NULL,
    data_publicacao_fim      TIMESTAMP NOT NULL,
    data_expiracao           TIMESTAMP NOT NULL,
    situacao                 NUMBER,
    deletado                 NUMBER DEFAULT 0,
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255) NOT NULL,
    modificado_por           VARCHAR2(255) NOT NULL
);

COMMENT ON COLUMN vitrine_vagas.id_estado IS
    'Obs. ID da tabela Estados do schema CORE.';

COMMENT ON COLUMN vitrine_vagas.situacao IS
    'Flag:

 0 - Inativo
 1 - Ativo';

ALTER TABLE vitrine_vagas ADD CONSTRAINT krs_indice_02143 PRIMARY KEY ( id );

---------------------------------------------------------------------------------------------------------------------------------------


-- PK 8169 / PK 7469 --

CREATE TABLE salarios_estadual (
    id                              NUMBER(20) NOT NULL,
    id_estado                       NUMBER(20) NOT NULL,
    valor_salario_minimo_estadual   NUMBER(10, 2) NOT NULL,
    deletado                        NUMBER DEFAULT 0,
    data_criacao                    TIMESTAMP NOT NULL,
    data_alteracao                  TIMESTAMP NOT NULL,
    criado_por                      VARCHAR2(255),
    modificado_por                  VARCHAR2(255)
);

COMMENT ON COLUMN salarios_estadual.id_estado IS
    'OBS:

  Campo ID da tabela ESTADOS do schema CORE.';

ALTER TABLE salarios_estadual ADD CONSTRAINT krs_indice_02144 PRIMARY KEY ( id );



-- ALTERADO TABELA CONTRATOS_ESTUDANTES_EMPRESA ADICIONO OS CAMPOS tipo_calculo_salario_aprendiz
ALTER TABLE contratos_estudantes_empresa ADD tipo_calculo_salario_aprendiz NUMBER(1);

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_calculo_salario_aprendiz IS
    'Enum:

0 - Federal
1 - Estadual
2 - Convencao

Este campo e utilizado na matricula do Aprendiz';


-- PK-5104/PK-6574/PK-6575/PK-6576/PK-5271
ALTER TABLE REP_ESTUDANTES ADD ACEITE_SMS NUMBER(1);
ALTER TABLE REP_ESTUDANTES ADD ACEITE_WHATSAPP NUMBER(1);

ALTER TABLE VINCULOS_VAGA DROP COLUMN DATA_EMAIL;
ALTER TABLE VINCULOS_VAGA DROP COLUMN DATA_SMS;
ALTER TABLE VINCULOS_VAGA ADD DATA_COMUNICACAO_CONVOCACAO TIMESTAMP;
ALTER TABLE VINCULOS_VAGA ADD TIPO_COMUNICACAO_CONVOCACAO NUMBER(1);


COMMENT ON COLUMN vinculos_vaga.data_enviado_ura IS
    'ATENCAO

Obrigatorio gravar hora e data';

COMMENT ON COLUMN vinculos_vaga.tipo_comunicacao_convocacao IS
    'ENUM:

0-SMS
1-WhatsAPP
2-E-mail';

--PK6485

CREATE TABLE parametros_solicitacoes (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(150) NOT NULL,
    link             VARCHAR2(300),
    deletado         NUMBER(1) DEFAULT 0,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 BYTE),
    modificado_por   VARCHAR2(255 BYTE)
);

COMMENT ON TABLE parametros_solicitacoes IS
    'REPLICA DA TABELA: INFORMACOES_SOCIAIS, DO SCHEMA: STUDENT';

ALTER TABLE parametros_solicitacoes ADD CONSTRAINT krs_indice_02183 PRIMARY KEY ( id );



--PK6982/PK6863/PK6869/PK-6343/PK6874/PK6871/Pk6864/PK6866

CREATE TABLE contratos_cursos_capacitacao (
    id                        NUMBER(20) NOT NULL,
    id_contr_emp_est          NUMBER(20) NOT NULL,
    id_curso_capacitacao      NUMBER(20) NOT NULL,
    nome_curso                VARCHAR2(255) NOT NULL,
    tipo                      VARCHAR2(10) NOT NULL,
    turno                     NUMBER(1) NOT NULL,
    id_area_atuacao           NUMBER(20) NOT NULL,
    descricao_area_atuacao    VARCHAR2(255) NOT NULL,
    id_turma                  NUMBER(20) NOT NULL,
    descricao_turma           VARCHAR2(150) NOT NULL,
    sala                      VARCHAR2(10) NOT NULL,
    periodo_teorico_inicio    TIMESTAMP NOT NULL,
    periodo_teorico_fim       TIMESTAMP NOT NULL,
    dias_teorico_semana       VARCHAR2(50) NOT NULL,
    data_teorico_inicial      TIMESTAMP NOT NULL,
    horario_teorico_inicial   TIMESTAMP NOT NULL,
    horario_teorico_final     TIMESTAMP NOT NULL,
    periodo_pratica_inicio    TIMESTAMP NOT NULL,
    periodo_pratica_fim       TIMESTAMP NOT NULL,
    dias_pratica_semana       VARCHAR2(50) NOT NULL,
    data_pratica_inicial      TIMESTAMP NOT NULL,
    horario_pratica_inicial   TIMESTAMP NOT NULL,
    horario_pratica_final     TIMESTAMP NOT NULL,
    data_conclusao            TIMESTAMP NOT NULL,
    id_local                  NUMBER(20) NOT NULL,
    descricao_local           VARCHAR2(150) NOT NULL,
    endereco                  VARCHAR2(255) NOT NULL,
    numero                    VARCHAR2(10) NOT NULL,
    complemento               VARCHAR2(50),
    bairro                    VARCHAR2(100) NOT NULL,
    cep                       VARCHAR2(8) NOT NULL,
    cidade                    VARCHAR2(100) NOT NULL,
    uf                        VARCHAR2(2) NOT NULL,
    deletado                  NUMBER DEFAULT 0,
    data_criacao              TIMESTAMP NOT NULL,
    data_alteracao            TIMESTAMP,
    criado_por                VARCHAR2(255) NOT NULL,
    modificado_por            VARCHAR2(255)
);

COMMENT ON COLUMN contratos_cursos_capacitacao.turno IS
    'ENUM:
0-MATUTINO
1-VERPERTINO
2-NOTURNO';

ALTER TABLE contratos_cursos_capacitacao ADD CONSTRAINT krs_indice_02203 PRIMARY KEY ( id );

ALTER TABLE contratos_cursos_capacitacao
    ADD CONSTRAINT krs_indice_02204 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );


--

ALTER TABLE contratos_estudantes_empresa add rg_estudante varchar(20);
ALTER TABLE contratos_estudantes_empresa add data_nascimento timestamp;
ALTER TABLE contratos_estudantes_empresa add responsavel_legal varchar(255);
ALTER TABLE contratos_estudantes_empresa add nivel_escolaridade varchar(2);

COMMENT ON COLUMN contratos_estudantes_empresa.rg_estudante IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.data_nascimento IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.responsavel_legal IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.nivel_escolaridade IS
    'Este campo e utilizado na matricula do Aprendiz

    Opcoes:

    SU - Superior
    TE - Técnico
    EE - Educação Especial
    HB - Habilitação Básica
    EM - Ensino Médio
    EF - Ensino Fundamental

    Obs. vem do campo sigla_nivel_educacao da tabela rep_escolaridades_estudantes';



CREATE TABLE rep_carteira_trabalho (
    id                         NUMBER(20) NOT NULL,
    numero_carteira_trabalho   VARCHAR2(64),
    serie                      VARCHAR2(32) NOT NULL,
    uf                         VARCHAR2(2) NOT NULL,
    pis                        VARCHAR2(32),
    data_criacao               TIMESTAMP,
    data_alteracao             TIMESTAMP,
    modificado_por             VARCHAR2(255),
    criado_por                 VARCHAR2(255),
    deletado                   NUMBER(1) DEFAULT 0
);

ALTER TABLE rep_carteira_trabalho ADD CONSTRAINT krs_indice_02224 PRIMARY KEY ( id );


--

ALTER TABLE contratos_estudantes_empresa add cpf_monitor varchar(11);
ALTER TABLE contratos_estudantes_empresa add nome_monitor varchar(255);
ALTER TABLE contratos_estudantes_empresa add email_monitor varchar(100);
ALTER TABLE contratos_estudantes_empresa add telefone_monitor varchar(60);

ALTER TABLE contratos_estudantes_empresa add nome_contato varchar(255);
ALTER TABLE contratos_estudantes_empresa add email_contato varchar(100);
ALTER TABLE contratos_estudantes_empresa add telefone_contato varchar(60);

COMMENT ON COLUMN contratos_estudantes_empresa.cpf_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.nome_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.email_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.telefone_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.nome_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.email_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.telefone_contato IS
    'Este campo e utilizado na matricula do Aprendiz';



--

ALTER TABLE contratos_estudantes_empresa add tipo_salario_aprendiz NUMBER(1);
ALTER TABLE contratos_estudantes_empresa add valor_salario_aprendiz NUMBER(10, 2);

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_salario_aprendiz IS
    'Enum:

0 - Mensal

1 - Por Hora

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';




--

ALTER TABLE contratos_estudantes_empresa add tipo_auxilio_transporte_aprendiz NUMBER(1);
ALTER TABLE contratos_estudantes_empresa add tipo_auxilio_transporte_valor_aprendiz NUMBER;

ALTER TABLE contratos_estudantes_empresa add valor_transporte_fixo_aprendiz NUMBER(10, 2);
ALTER TABLE contratos_estudantes_empresa add valor_salario_aprendiz_de NUMBER(10, 2);
ALTER TABLE contratos_estudantes_empresa add valor_salario_aprendiz_ate NUMBER(10, 2);


--

COMMENT ON COLUMN contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_auxilio_transporte_aprendiz IS
    'Enum:

0 - Mensal

1 - Diario

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_auxilio_transporte_valor_aprendiz IS
    'Enum

 0 - Fixo

 1 - A Combinar

 Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.valor_transporte_fixo_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.valor_salario_aprendiz_de IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_estudantes_empresa.valor_salario_aprendiz_ate IS
    'Este campo e utilizado na matricula do Aprendiz';


--PK6863/PK6869

CREATE TABLE contratos_empresas_ferias (
    id                 NUMBER(20) NOT NULL,
    id_contr_empresa   NUMBER(20) NOT NULL,
    tipo_ferias        NUMBER(1) NOT NULL,
    data_inicio        TIMESTAMP NOT NULL,
    data_fim           TIMESTAMP NOT NULL,
    deletado           NUMBER DEFAULT 0,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP,
    criado_por         VARCHAR2(255) NOT NULL,
    modificado_por     VARCHAR2(255)
);

COMMENT ON COLUMN contratos_empresas_ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.id_contr_empresa IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.tipo_ferias IS
    'Enum:

0 - FAIXA1 (PERIODO DE 30 DIAS)

1 - FAIXA2 (PERIODO DE 10 A 20 DIAS)

2 - FAIXA3 (3 PERIODOS DE 10 DIAS)

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.data_inicio IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.data_fim IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN contratos_empresas_ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

ALTER TABLE contratos_empresas_ferias ADD CONSTRAINT krs_indice_02225 PRIMARY KEY ( id );

ALTER TABLE contratos_empresas_ferias
    ADD CONSTRAINT krs_indice_02226 FOREIGN KEY ( id_contr_empresa )
        REFERENCES contratos_estudantes_empresa ( id );


--

CREATE TABLE pre_contratos_cursos_capacitacao (
    id                        NUMBER(20) NOT NULL,
    id_contr_emp_est          NUMBER(20) NOT NULL,
    id_curso_capacitacao      NUMBER(20) NOT NULL,
    nome_curso                VARCHAR2(255) NOT NULL,
    tipo                      VARCHAR2(10) NOT NULL,
    turno                     NUMBER(1) NOT NULL,
    id_area_atuacao           NUMBER(20) NOT NULL,
    descricao_area_atuacao    VARCHAR2(255) NOT NULL,
    id_turma                  NUMBER(20) NOT NULL,
    descricao_turma           VARCHAR2(150) NOT NULL,
    sala                      VARCHAR2(10) NOT NULL,
    periodo_teorico_inicio    TIMESTAMP NOT NULL,
    periodo_teorico_fim       TIMESTAMP NOT NULL,
    dias_teorico_semana       VARCHAR2(50) NOT NULL,
    data_teorico_inicial      TIMESTAMP NOT NULL,
    horario_teorico_inicial   TIMESTAMP NOT NULL,
    horario_teorico_final     TIMESTAMP NOT NULL,
    periodo_pratica_inicio    TIMESTAMP NOT NULL,
    periodo_pratica_fim       TIMESTAMP NOT NULL,
    dias_pratica_semana       VARCHAR2(50) NOT NULL,
    data_pratica_inicial      TIMESTAMP NOT NULL,
    horario_pratica_inicial   TIMESTAMP NOT NULL,
    horario_pratica_final     TIMESTAMP NOT NULL,
    data_conclusao            TIMESTAMP NOT NULL,
    id_local                  NUMBER(20) NOT NULL,
    descricao_local           VARCHAR2(150) NOT NULL,
    endereco                  VARCHAR2(255) NOT NULL,
    numero                    VARCHAR2(10) NOT NULL,
    complemento               VARCHAR2(50),
    bairro                    VARCHAR2(100) NOT NULL,
    cep                       VARCHAR2(8) NOT NULL,
    cidade                    VARCHAR2(100) NOT NULL,
    uf                        VARCHAR2(2) NOT NULL,
    deletado                  NUMBER DEFAULT 0,
    data_criacao              TIMESTAMP NOT NULL,
    data_alteracao            TIMESTAMP,
    criado_por                VARCHAR2(255) NOT NULL,
    modificado_por            VARCHAR2(255)
);

COMMENT ON COLUMN pre_contratos_cursos_capacitacao.turno IS
    'ENUM:
0-MATUTINO
1-VERPERTINO
2-NOTURNO';

ALTER TABLE pre_contratos_cursos_capacitacao ADD CONSTRAINT krs_indice_02227 PRIMARY KEY ( id );

ALTER TABLE pre_contratos_cursos_capacitacao
    ADD CONSTRAINT pre_contratos_cursos_capacitacao_pre_contratos_estudantes_empresa_fk FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id );


--PK6982/PK6863/PK6869/PK-6343/PK6874/PK6871/Pk6864/PK6866

CREATE TABLE pre_contratos_empresas_ferias (
    id                 NUMBER(20) NOT NULL,
    id_contr_empresa   NUMBER(20) NOT NULL,
    tipo_ferias        NUMBER(1) NOT NULL,
    data_inicio        TIMESTAMP NOT NULL,
    data_fim           TIMESTAMP NOT NULL,
    deletado           NUMBER DEFAULT 0,
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP,
    criado_por         VARCHAR2(255) NOT NULL,
    modificado_por     VARCHAR2(255)
);

COMMENT ON COLUMN pre_contratos_empresas_ferias.id IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.id_contr_empresa IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.tipo_ferias IS
    'Enum:

0 - FAIXA1 (PERIODO DE 30 DIAS)

1 - FAIXA2 (PERIODO DE 10 A 20 DIAS)

2-FAIXA3 (3 PERIODOS DE 10 DIAS)

Este campo e utilizado na matricula do Aprendiz'
    ;

COMMENT ON COLUMN pre_contratos_empresas_ferias.data_inicio IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.data_fim IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.deletado IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.data_criacao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.data_alteracao IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.criado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_empresas_ferias.modificado_por IS
    'Este campo e utilizado na matricula do Aprendiz';

ALTER TABLE pre_contratos_empresas_ferias ADD CONSTRAINT krs_indice_02229 PRIMARY KEY ( id );

ALTER TABLE pre_contratos_empresas_ferias
    ADD CONSTRAINT krs_indice_02230 FOREIGN KEY ( id_contr_empresa )
        REFERENCES pre_contratos_estudantes_empresa ( id );


--ALTERADO TABELA pre_contratos_estudantes_empresa ADICIONADO OS CAMPOS tipo_calculo_salario_aprendiz
ALTER TABLE pre_contratos_estudantes_empresa ADD tipo_calculo_salario_aprendiz NUMBER(1);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_calculo_salario_aprendiz IS
    'Enum:

0 - Federal
1 - Estadual
2 - Convencao';


--

ALTER TABLE pre_contratos_estudantes_empresa add rg_estudante varchar(20);
ALTER TABLE pre_contratos_estudantes_empresa add data_nascimento timestamp;
ALTER TABLE pre_contratos_estudantes_empresa add responsavel_legal varchar(255);
ALTER TABLE pre_contratos_estudantes_empresa add nivel_escolaridade varchar(2);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.rg_estudante IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.data_nascimento IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.responsavel_legal IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.nivel_escolaridade IS
    'Este campo e utilizado na matricula do Aprendiz

    Opcoes:

    SU - Superior
    TE - Técnico
    EE - Educação Especial
    HB - Habilitação Básica
    EM - Ensino Médio
    EF - Ensino Fundamental

    Obs. vem do campo sigla_nivel_educacao da tabela rep_escolaridades_estudantes';


--

ALTER TABLE pre_contratos_estudantes_empresa add cpf_monitor varchar(11);
ALTER TABLE pre_contratos_estudantes_empresa add nome_monitor varchar(255);
ALTER TABLE pre_contratos_estudantes_empresa add email_monitor varchar(100);
ALTER TABLE pre_contratos_estudantes_empresa add telefone_monitor varchar(60);

ALTER TABLE pre_contratos_estudantes_empresa add nome_contato varchar(255);
ALTER TABLE pre_contratos_estudantes_empresa add email_contato varchar(100);
ALTER TABLE pre_contratos_estudantes_empresa add telefone_contato varchar(60);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.cpf_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.nome_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.email_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.telefone_monitor IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.nome_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.email_contato IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.telefone_contato IS
    'Este campo e utilizado na matricula do Aprendiz';


--

ALTER TABLE pre_contratos_estudantes_empresa add tipo_salario_aprendiz NUMBER(1);
ALTER TABLE pre_contratos_estudantes_empresa add valor_salario_aprendiz NUMBER(10, 2);

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_salario_aprendiz IS
    'Enum:

0 - Mensal

1 - Por Hora

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';


--

ALTER TABLE pre_contratos_estudantes_empresa add tipo_auxilio_transporte_aprendiz NUMBER(1);
ALTER TABLE pre_contratos_estudantes_empresa add tipo_auxilio_transporte_valor_aprendiz NUMBER;

ALTER TABLE pre_contratos_estudantes_empresa add valor_transporte_fixo_aprendiz NUMBER(10, 2);
ALTER TABLE pre_contratos_estudantes_empresa add valor_salario_aprendiz_de NUMBER(10, 2);
ALTER TABLE pre_contratos_estudantes_empresa add valor_salario_aprendiz_ate NUMBER(10, 2);


--


COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_salario_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_auxilio_transporte_aprendiz IS
    'Enum:

0 - Mensal

1 - Diario

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_auxilio_transporte_valor_aprendiz IS
    'Enum

 0 - Fixo

 1 - A Combinar

 Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_transporte_fixo_aprendiz IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_salario_aprendiz_de IS
    'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.valor_salario_aprendiz_ate IS
    'Este campo e utilizado na matricula do Aprendiz';


--

CREATE SEQUENCE SEQ_MOTIVOS_CANCELAMENTO_VAGA  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_VITRINE_VAGAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_SALARIOS_ESTADUAL  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PARAMETROS_SOLICITACOES  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_CONTRATOS_CURSOS_CAPACITACAO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_REP_CARTEIRA_TRABALHO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_CONTRATOS_EMPRESAS_FERIA  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PRE_CONTRATOS_CURSOS_CAPACITACAO  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_PRE_CONTRATOS_EMPRESAS_FERIAS  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
