---
--- Migracao Inicial - Sprint 9
---
CREATE TABLE agencias (
    id_agencia        NUMBER(4) NOT NULL,
    digito_agencia    NUMBER(1) NOT NULL,
    nome_agencia      VARCHAR2(150) NOT NULL,
    id_banco          NUMBER(20) NOT NULL,
    tipo_logradouro   VARCHAR2(2) NOT NULL,
    endereco          VARCHAR2(150) NOT NULL,
    numero            VARCHAR2(10) NOT NULL,
    complemento       VARCHAR2(50) NOT NULL,
    bairro            VARCHAR2(100) NOT NULL,
    cidade            VARCHAR2(100) NOT NULL,
    uf                VARCHAR2(2) NOT NULL,
    cep               VARCHAR2(8) NOT NULL,
    deletado          NUMBER,
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
)
LOGGING;

ALTER TABLE agencias ADD CONSTRAINT krs_indice_01941 PRIMARY KEY ( id_agencia );

CREATE TABLE areas_atuacao_contr_emp_est (
    id_contr_emp_est      NUMBER(20) NOT NULL,
    codigo_area_atuacao   NUMBER(20) NOT NULL
)

logging;

CREATE TABLE atividades_contr_emp_est (
    id_contr_emp_est   NUMBER(20) NOT NULL,
    codigo_atividade   NUMBER(20) NOT NULL
)

logging;

CREATE TABLE bancos (
    id_banco          NUMBER(20) NOT NULL,
    nome_banco        VARCHAR2(100) NOT NULL,
    tipo_logradouro   VARCHAR2(2) NOT NULL,
    endereco          VARCHAR2(150) NOT NULL,
    numero            VARCHAR2(10) NOT NULL,
    complemento       VARCHAR2(50) NOT NULL,
    bairro            VARCHAR2(100) NOT NULL,
    cidade            VARCHAR2(100) NOT NULL,
    uf                VARCHAR2(2) NOT NULL,
    cep               VARCHAR2(8) NOT NULL,
    ativo             NUMBER NOT NULL,
    deletado          NUMBER,
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
)

logging;

ALTER TABLE bancos ADD CONSTRAINT krs_indice_01940 PRIMARY KEY ( id_banco );

CREATE TABLE beneficios_contr_emp_est (
    id                 NUMBER(20) NOT NULL,
    id_contr_emp_est   NUMBER(20) NOT NULL,
    id_beneficio       NUMBER(20) NOT NULL,
    valor              NUMBER(10, 2),
    deletado           NUMBER,
    data_criacao       TIMESTAMP,
    data_alteracao     TIMESTAMP,
    criado_por         VARCHAR2(255),
    modificado_por     VARCHAR2(255)
)

logging;

ALTER TABLE beneficios_contr_emp_est ADD CONSTRAINT krs_indice_01937 PRIMARY KEY ( id );

DROP TABLE contratos_estudantes_empresa;

CREATE TABLE contratos_estudantes_empresa (
    id                               NUMBER(20) NOT NULL,
    id_local_contrato                NUMBER(20) NOT NULL,
    id_estudante                     NUMBER(20) NOT NULL,
    tipo_contrato                    VARCHAR2(1),
    id_curso_capacitacao             NUMBER(20),
    carga_horaria                    TIMESTAMP,
    faixa_etaria_inicial             NUMBER(2),
    faixa_etaria_final               NUMBER(2),
    id_area_profissional             NUMBER(20),
    pcd                              NUMBER,
    cpf_estudante                    VARCHAR2(11) NOT NULL,
    nome_estudante                   VARCHAR2(255) NOT NULL,
    nome_social_estudante            VARCHAR2(255) NOT NULL,
    nome_mae_estudante               VARCHAR2(150) NOT NULL,
    email_estudante                  VARCHAR2(100) NOT NULL,
    telefone_estudante               VARCHAR2(60) NOT NULL,
    endereco_estudante               VARCHAR2(150) NOT NULL,
    numero_end_estudante             VARCHAR2(10) NOT NULL,
    complemento_end_estudante        VARCHAR2(200) NOT NULL,
    bairro_end_estudante             VARCHAR2(100) NOT NULL,
    cep_end_estudante                VARCHAR2(8) NOT NULL,
    cidade_end_estudante             VARCHAR2(100) NOT NULL,
    uf_end_estudante                 VARCHAR2(2) NOT NULL,
    codigo_curso_estudante           NUMBER(20) NOT NULL,
    nome_curso_estudante             VARCHAR2(200) NOT NULL,
    ano_atual_curso_estudante        NUMBER(2) NOT NULL,
    semestre_atual_curso_estudante   NUMBER(2) NOT NULL,
    periodo_curso_estudante          VARCHAR2(20) NOT NULL,
    previsao_concl_curso_estudante   TIMESTAMP NOT NULL,
    id_ie                            NUMBER(20) NOT NULL,
    nome_ie                          VARCHAR2(200) NOT NULL,
    id_campus                        NUMBER(20) NOT NULL,
    nome_campus                      VARCHAR2(200) NOT NULL,
    endereco_campus                  VARCHAR2(150) NOT NULL,
    numero_campus                    VARCHAR2(10) NOT NULL,
    complemento_campus               VARCHAR2(50) NOT NULL,
    bairro_campus                    VARCHAR2(100) NOT NULL,
    cep_campus                       VARCHAR2(8) NOT NULL,
    cidade_campus                    VARCHAR2(100) NOT NULL,
    uf_campus                        VARCHAR2(2) NOT NULL,
    id_empresa                       NUMBER(20) NOT NULL,
    nome_empresa                     VARCHAR2(150) NOT NULL,
    endereco_empresa                 VARCHAR2(150),
    numero_empresa                   VARCHAR2(10),
    complemento_empresa              VARCHAR2(50),
    bairro_empresa                   VARCHAR2(100),
    cep_empresa                      VARCHAR2(8),
    cidade_empresa                   VARCHAR2(100),
    uf_empresa                       VARCHAR2(2),
    codigo_da_vaga                   NUMBER(20) NOT NULL,
    descricao_vaga                   VARCHAR2(150) NOT NULL,
    condicao_estagio                 NUMBER NOT NULL,
    data_inicio_estagio              TIMESTAMP NOT NULL,
    data_final_estagio               TIMESTAMP NOT NULL,
    duracao_estagio                  NUMBER(5),
    tipo_auxilio_bolsa               NUMBER NOT NULL,
    tipo_valor_bolsa                 NUMBER,
    valor_bolsa_fixo                 NUMBER(10, 2),
    valor_bolsa_de                   NUMBER(10, 2),
    valor_bolsa_ate                  NUMBER(10, 2),
    tipo_auxilio_transporte          NUMBER NOT NULL,
    tipo_valor_auxilio_transporte    NUMBER,
    valor_transporte_fixo            NUMBER(10, 2),
    id_banco                         NUMBER(3),
    id_agencia                       NUMBER(4),
    conta_corrente                   NUMBER(10),
    beneficios_adicionais_estagio    NUMBER,
    id_supervisor                    NUMBER(20),
    nome_supervidor                  VARCHAR2(150),
    cpf_supervidor                   VARCHAR2(11),
    cargo_supervidor                 VARCHAR2(150),
    formacao_supervidor              VARCHAR2(150),
    id_conselho_classe_supervidor    NUMBER(20),
    descricao_conselho_supervisor    VARCHAR2(100),
    contratacao_direta               NUMBER,
    deletado                         NUMBER,
    data_criacao                     TIMESTAMP,
    data_alteracao                   TIMESTAMP NOT NULL,
    criado_por                       VARCHAR2(255),
    modificado_por                   VARCHAR2(255)
)

logging;

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_contrato IS
    'Flag:

A - Aprendiz

E - Estagio';

COMMENT ON COLUMN contratos_estudantes_empresa.id_curso_capacitacao IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.carga_horaria IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.faixa_etaria_inicial IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.faixa_etaria_final IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.id_area_profissional IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: E';

COMMENT ON COLUMN contratos_estudantes_empresa.pcd IS
    'Flag 0 ou 1:

0 - Normal

1 - PCD';

COMMENT ON COLUMN contratos_estudantes_empresa.periodo_curso_estudante IS
    '-

  Esse campo é preencho com dados do campo tipo_perido_curso da tabela:
  REP_ESCOLARIDADES_ESTUDANTES.

  EX: Manhã, Tarde, Noite, Integral, Variavel...'
    ;

COMMENT ON COLUMN contratos_estudantes_empresa.endereco_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.numero_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.complemento_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.bairro_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.cep_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.cidade_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.uf_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN contratos_estudantes_empresa.condicao_estagio IS
    'Enum:

0 - Obrigatório
1 - Não Obrigatório';

COMMENT ON COLUMN contratos_estudantes_empresa.duracao_estagio IS
    'OBS:

  Campo Calculado ';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_auxilio_bolsa IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_valor_bolsa IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_auxilio_transporte IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_valor_auxilio_transporte IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN contratos_estudantes_empresa.beneficios_adicionais_estagio IS
    'Flag  0 ou 1';

COMMENT ON COLUMN contratos_estudantes_empresa.contratacao_direta IS
    'Enum:

0 - Contrataçao Normal

1 - Contratação Direta';

ALTER TABLE contratos_estudantes_empresa ADD CONSTRAINT krs_indice_01640v1 PRIMARY KEY ( id );

CREATE TABLE cursos_contr_emp_est (
    id_contr_emp_est   NUMBER(20) NOT NULL,
    codigo_curso       NUMBER(20) NOT NULL
)

logging;

CREATE TABLE documentos_contr_emp_est (
    id                 NUMBER(20) NOT NULL,
    id_contr_emp_est   NUMBER(20) NOT NULL,
    id_documento       NUMBER(20),
    tipo_documento     NUMBER
)

logging;

ALTER TABLE documentos_contr_emp_est ADD CONSTRAINT krs_indice_01967 PRIMARY KEY ( id );

CREATE TABLE historico_supervisor_contrato (
    id                            NUMBER(20) NOT NULL,
    id_contr_emp_est              NUMBER(20),
    id_supervisor                 NUMBER(20),
    none                          VARCHAR2(150),
    cpf                           VARCHAR2(11),
    cargo                         VARCHAR2(150),
    formacao                      VARCHAR2(150),
    id_conselho_classe            NUMBER(20),
    descricao_conselho_superior   VARCHAR2(100),
    deletado                      NUMBER,
    data_criacao                  TIMESTAMP,
    data_alteracao                TIMESTAMP,
    criado_por                    VARCHAR2(255),
    modificado_por                VARCHAR2(255)
)

logging;

ALTER TABLE historico_supervisor_contrato ADD CONSTRAINT krs_indice_01984 PRIMARY KEY ( id );

CREATE TABLE horarios_contrato_jornada (
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
)

logging;

COMMENT ON COLUMN horarios_contrato_jornada.dia_semana IS
    'Ex:

 Segunda, Terça,etc....';

COMMENT ON COLUMN horarios_contrato_jornada.tipo_horario IS
    'Enum:

  0 - Fixo
  1 - Horario Alternativo';

ALTER TABLE horarios_contrato_jornada ADD CONSTRAINT krs_indice_01935 PRIMARY KEY ( id );

CREATE TABLE pre_areas_atuacao_contr_emp_est (
    id_contr_emp_est      NUMBER(20) NOT NULL,
    codigo_area_atuacao   NUMBER(20) NOT NULL
)

logging;

CREATE TABLE pre_atividades_contr_emp_est (
    id_contr_emp_est   NUMBER(20) NOT NULL,
    codigo_atividade   NUMBER(20) NOT NULL
)

logging;

CREATE TABLE pre_beneficios_contr_emp_est (
    id                 NUMBER(20) NOT NULL,
    id_contr_emp_est   NUMBER(20) NOT NULL,
    id_beneficio       NUMBER(20) NOT NULL,
    valor              NUMBER(10, 2),
    deletado           NUMBER,
    data_criacao       TIMESTAMP,
    data_alteracao     TIMESTAMP,
    criado_por         VARCHAR2(255),
    modificado_por     VARCHAR2(255)
)

logging;

ALTER TABLE pre_beneficios_contr_emp_est ADD CONSTRAINT krs_indice_01970 PRIMARY KEY ( id );

CREATE TABLE pre_contratos_estudantes_empresa (
    id                               NUMBER(20) NOT NULL,
    id_local_contrato                NUMBER(20) NOT NULL,
    id_estudante                     NUMBER(20) NOT NULL,
    tipo_contrato                    VARCHAR2(1),
    id_curso_capacitacao             NUMBER(20),
    carga_horaria                    TIMESTAMP,
    faixa_etaria_inicial             NUMBER(2),
    faixa_etaria_final               NUMBER(2),
    id_area_profissional             NUMBER(20),
    pcd                              NUMBER,
    cpf_estudante                    VARCHAR2(11) NOT NULL,
    nome_estudante                   VARCHAR2(255) NOT NULL,
    nome_social_estudante            VARCHAR2(255) NOT NULL,
    nome_mae_estudante               VARCHAR2(150) NOT NULL,
    email_estudante                  VARCHAR2(100) NOT NULL,
    telefone_estudante               VARCHAR2(60) NOT NULL,
    endereco_estudante               VARCHAR2(150) NOT NULL,
    numero_end_estudante             VARCHAR2(10) NOT NULL,
    complemento_end_estudante        VARCHAR2(200) NOT NULL,
    bairro_end_estudante             VARCHAR2(100) NOT NULL,
    cep_end_estudante                VARCHAR2(8) NOT NULL,
    cidade_end_estudante             VARCHAR2(100) NOT NULL,
    uf_end_estudante                 VARCHAR2(2) NOT NULL,
    codigo_curso_estudante           NUMBER(20) NOT NULL,
    nome_curso_estudante             VARCHAR2(200) NOT NULL,
    ano_atual_curso_estudante        NUMBER(2) NOT NULL,
    semestre_atual_curso_estudante   NUMBER(2) NOT NULL,
    periodo_curso_estudante          VARCHAR2(20) NOT NULL,
    previsao_concl_curso_estudante   TIMESTAMP NOT NULL,
    id_ie                            NUMBER(20) NOT NULL,
    nome_ie                          VARCHAR2(200) NOT NULL,
    id_campus                        NUMBER(20) NOT NULL,
    nome_campus                      VARCHAR2(200) NOT NULL,
    endereco_campus                  VARCHAR2(150) NOT NULL,
    numero_campus                    VARCHAR2(10) NOT NULL,
    complemento_campus               VARCHAR2(50) NOT NULL,
    bairro_campus                    VARCHAR2(100) NOT NULL,
    cep_campus                       VARCHAR2(8) NOT NULL,
    cidade_campus                    VARCHAR2(100) NOT NULL,
    uf_campus                        VARCHAR2(2) NOT NULL,
    id_empresa                       NUMBER(20) NOT NULL,
    nome_empresa                     VARCHAR2(150) NOT NULL,
    endereco_empresa                 VARCHAR2(150),
    numero_empresa                   VARCHAR2(10),
    complemento_empresa              VARCHAR2(50),
    bairro_empresa                   VARCHAR2(100),
    cep_empresa                      VARCHAR2(8),
    cidade_empresa                   VARCHAR2(100),
    uf_empresa                       VARCHAR2(2),
    codigo_da_vaga                   NUMBER(20) NOT NULL,
    descricao_vaga                   VARCHAR2(150) NOT NULL,
    condicao_estagio                 NUMBER NOT NULL,
    data_inicio_estagio              TIMESTAMP NOT NULL,
    data_final_estagio               TIMESTAMP NOT NULL,
    duracao_estagio                  NUMBER(5),
    tipo_auxilio_bolsa               NUMBER NOT NULL,
    tipo_valor_bolsa                 NUMBER,
    valor_bolsa_fixo                 NUMBER(10, 2),
    valor_bolsa_de                   NUMBER(10, 2),
    valor_bolsa_ate                  NUMBER(10, 2),
    tipo_auxilio_transporte          NUMBER NOT NULL,
    tipo_valor_auxilio_transporte    NUMBER,
    valor_transporte_fixo            NUMBER(10, 2),
    id_banco                         NUMBER(3),
    id_agencia                       NUMBER(4),
    conta_corrente                   NUMBER(10),
    beneficios_adicionais_estagio    NUMBER,
    id_supervisor                    NUMBER(20),
    nome_supervidor                  VARCHAR2(150),
    cpf_supervidor                   VARCHAR2(11),
    cargo_supervidor                 VARCHAR2(150),
    formacao_supervidor              VARCHAR2(150),
    id_conselho_classe_supervidor    NUMBER(20),
    descricao_conselho_supervisor    VARCHAR2(100),
    contratacao_direta               NUMBER,
    deletado                         NUMBER,
    data_criacao                     TIMESTAMP,
    data_alteracao                   TIMESTAMP NOT NULL,
    criado_por                       VARCHAR2(255),
    modificado_por                   VARCHAR2(255)
)

logging;

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_contrato IS
    'Flag:

A - Aprendiz

E - Estagio';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.id_curso_capacitacao IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.carga_horaria IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.faixa_etaria_inicial IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.faixa_etaria_final IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.id_area_profissional IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: E';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.pcd IS
    'Flag 0 ou 1:

0 - Normal

1 - PCD';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.periodo_curso_estudante IS
    '-

  Esse campo é preencho com dados do campo tipo_perido_curso da tabela:
  REP_ESCOLARIDADES_ESTUDANTES.

  EX: Manhã, Tarde, Noite, Integral, Variavel...'
    ;

COMMENT ON COLUMN pre_contratos_estudantes_empresa.endereco_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.numero_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.complemento_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.bairro_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.cep_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.cidade_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.uf_empresa IS
    'OBS:

  Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.condicao_estagio IS
    'Enum:

0 - Obrigatório
1 - Não Obrigatório';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.duracao_estagio IS
    'OBS:

  Campo Calculado ';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_auxilio_bolsa IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_valor_bolsa IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_auxilio_transporte IS
    'Enum:

 0 - Mensal
 1 - Por Hora';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.tipo_valor_auxilio_transporte IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.beneficios_adicionais_estagio IS
    'Flag  0 ou 1';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.contratacao_direta IS
    'Enum:

0 - Contrataçao Normal

1 - Contratação Direta';

ALTER TABLE pre_contratos_estudantes_empresa ADD CONSTRAINT krs_indice_01960 PRIMARY KEY ( id );

CREATE TABLE pre_cursos_contr_emp_est (
    id_contr_emp_est   NUMBER(20) NOT NULL,
    codigo_curso       NUMBER(20) NOT NULL
)

logging;

CREATE TABLE pre_documentos_contr_emp_est (
    id                 NUMBER(20) NOT NULL,
    id_contr_emp_est   NUMBER(20) NOT NULL,
    id_documento       NUMBER(20),
    tipo_documento     VARCHAR2(255)
)

logging;

ALTER TABLE pre_documentos_contr_emp_est ADD CONSTRAINT krs_indice_01981 PRIMARY KEY ( id );

CREATE TABLE pre_horarios_contrato_jornada (
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
)

logging;

COMMENT ON COLUMN pre_horarios_contrato_jornada.dia_semana IS
    'Ex:

 Segunda, Terça,etc....';

COMMENT ON COLUMN pre_horarios_contrato_jornada.tipo_horario IS
    'Enum:

  0 - Fixo
  1 - Horario Alternativo';

ALTER TABLE pre_horarios_contrato_jornada ADD CONSTRAINT krs_indice_01969 PRIMARY KEY ( id );

CREATE TABLE rep_conselho_classes (
    id               NUMBER(20) NOT NULL,
    descricao        VARCHAR2(100 CHAR) NOT NULL,
    ativo            NUMBER(1) DEFAULT 1,
    deletado         NUMBER,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 BYTE),
    modificado_por   VARCHAR2(255 BYTE)
)

logging;

ALTER TABLE rep_conselho_classes ADD CONSTRAINT krs_indice_01923 PRIMARY KEY ( id );

CREATE TABLE supervisores (
    id                   NUMBER(20) NOT NULL,
    id_contrato          NUMBER(20) NOT NULL,
    id_conselho_classe   NUMBER(20) NOT NULL,
    cpf                  VARCHAR2(11),
    nome                 VARCHAR2(150) NOT NULL,
    ddd_fone             VARCHAR2(2),
    fone                 VARCHAR2(60),
    email                VARCHAR2(100) NOT NULL,
    cargo                VARCHAR2(150) NOT NULL,
    formacao             VARCHAR2(150) NOT NULL,
    deletado             NUMBER NOT NULL,
    data_criacao         TIMESTAMP,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255),
    modificado_por       VARCHAR2(255)
)

logging;

ALTER TABLE supervisores ADD CONSTRAINT krs_indice_01924 PRIMARY KEY ( id );

ALTER TABLE supervisores
    ADD CONSTRAINT krs_indice_01925 FOREIGN KEY ( id_conselho_classe )
        REFERENCES rep_conselho_classes ( id )
    NOT DEFERRABLE;

ALTER TABLE areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_01929 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_01930 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES rep_areas_atuacao_estagio ( codigo_area_atuacao )
    NOT DEFERRABLE;

ALTER TABLE atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_01931 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_01932 FOREIGN KEY ( codigo_atividade )
        REFERENCES rep_atividades ( codigo_atividade )
    NOT DEFERRABLE;

ALTER TABLE cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_01933 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_01934 FOREIGN KEY ( codigo_curso )
        REFERENCES rep_cursos ( codigo_curso )
    NOT DEFERRABLE;

ALTER TABLE horarios_contrato_jornada
    ADD CONSTRAINT krs_indice_01936 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE beneficios_contr_emp_est
    ADD CONSTRAINT krs_indice_01938 FOREIGN KEY ( id_beneficio )
        REFERENCES beneficios ( id )
    NOT DEFERRABLE;

ALTER TABLE beneficios_contr_emp_est
    ADD CONSTRAINT krs_indice_01939 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE supervisores
    ADD CONSTRAINT krs_indice_01945 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01954 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01955 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01956 FOREIGN KEY ( id_area_profissional )
        REFERENCES rep_areas_profissionais ( codigo_area_profissional )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01957 FOREIGN KEY ( id_agencia )
        REFERENCES agencias ( id_agencia )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01958 FOREIGN KEY ( id_banco )
        REFERENCES bancos ( id_banco )
    NOT DEFERRABLE;

ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01959 FOREIGN KEY ( id_supervisor )
        REFERENCES supervisores ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01961 FOREIGN KEY ( id_agencia )
        REFERENCES agencias ( id_agencia )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01962 FOREIGN KEY ( id_banco )
        REFERENCES bancos ( id_banco )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01963 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01964 FOREIGN KEY ( id_supervisor )
        REFERENCES supervisores ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01965 FOREIGN KEY ( id_area_profissional )
        REFERENCES rep_areas_profissionais ( codigo_area_profissional )
    NOT DEFERRABLE;

ALTER TABLE pre_contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01966 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;

ALTER TABLE documentos_contr_emp_est
    ADD CONSTRAINT krs_indice_01968 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_01971 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_areas_atuacao_contr_emp_est
    ADD CONSTRAINT krs_indice_01972 FOREIGN KEY ( codigo_area_atuacao )
        REFERENCES rep_areas_atuacao_estagio ( codigo_area_atuacao )
    NOT DEFERRABLE;

ALTER TABLE pre_atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_01973 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_atividades_contr_emp_est
    ADD CONSTRAINT krs_indice_01974 FOREIGN KEY ( codigo_atividade )
        REFERENCES rep_atividades ( codigo_atividade )
    NOT DEFERRABLE;

ALTER TABLE pre_cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_01977 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_cursos_contr_emp_est
    ADD CONSTRAINT krs_indice_01978 FOREIGN KEY ( codigo_curso )
        REFERENCES rep_cursos ( codigo_curso )
    NOT DEFERRABLE;

ALTER TABLE pre_beneficios_contr_emp_est
    ADD CONSTRAINT krs_indice_01979 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_horarios_contrato_jornada
    ADD CONSTRAINT krs_indice_01980 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_documentos_contr_emp_est
    ADD CONSTRAINT krs_indice_01982 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES pre_contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE pre_beneficios_contr_emp_est
    ADD CONSTRAINT krs_indice_01983 FOREIGN KEY ( id_beneficio )
        REFERENCES beneficios ( id )
    NOT DEFERRABLE;

ALTER TABLE historico_supervisor_contrato
    ADD CONSTRAINT krs_indice_01985 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id )
    NOT DEFERRABLE;

ALTER TABLE agencias
    ADD CONSTRAINT krs_indice_01986 FOREIGN KEY ( id_banco )
        REFERENCES bancos ( id_banco )
    NOT DEFERRABLE;


--- Sequences

CREATE SEQUENCE service_vagas_dev.seq_documentos_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_contratos_estudantes_emp MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_beneficios_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_horarios_contrato_jornada MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_supervisores MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_historico_supervisor_contr MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_pre_doc_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_pre_cont_estudantes_emp MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_pre_benef_contr_emp_est MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
CREATE SEQUENCE service_vagas_dev.seq_pre_hora_contrato_jornada MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

