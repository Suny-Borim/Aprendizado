alter table REP_ESTUDANTES
    add SITUACAO_ANALISE_PCD VARCHAR2(25 char);
;

alter table REP_AREAS_PROFISSIONAIS
    add (
        DESC_REDUZ_AREA_PROFISSIONAL VARCHAR2(40 char),
        CODIGO_ICONE VARCHAR2(20 char)
        )
;

alter table REP_IDIOMAS_NIVEIS
    add DOCUMENTO_ID VARCHAR2(25 BYTE);

alter table REP_CONHECIMENTOS_INFORMATICA
    add ID_DOCUMENTO NUMBER(19,0);

CREATE TABLE rep_experiencias_profissionais_student
(
    id             NUMBER(20) NOT NULL,
    id_estudante   NUMBER(19),
    nome_empresa   VARCHAR2(200 CHAR),
    cargo          VARCHAR2(100 CHAR),
    atividades     VARCHAR2(500 CHAR),
    emprego_atual  NUMBER(1),
    data_criacao   TIMESTAMP,
    data_alteracao TIMESTAMP,
    criado_por     VARCHAR2(255 BYTE),
    modificado_por VARCHAR2(255 BYTE),
    deletado       NUMBER(1),
    data_inicio    VARCHAR2(10 CHAR),
    data_saida     VARCHAR2(10 CHAR)
);
COMMENT ON TABLE rep_experiencias_profissionais_student IS
    'STUDENT_DEV:SERVICE_STUDENT_DEV:EXPERIENCIAS_PROFISSIONAIS';
ALTER TABLE rep_experiencias_profissionais_student
    ADD CONSTRAINT krs_indice_07081 PRIMARY KEY (id);

CREATE TABLE rep_conhecimentos_diversos_student
(
    id               NUMBER(20) NOT NULL,
    criado_por       VARCHAR2(255 BYTE),
    data_criacao     TIMESTAMP,
    deletado         NUMBER(1),
    modificado_por   VARCHAR2(255 BYTE),
    data_alteracao   TIMESTAMP,
    nome_curso       VARCHAR2(200 BYTE),
    id_documento     NUMBER(19),
    data_termino     DATE,
    nome_instituicao VARCHAR2(300 BYTE),
    data_inicio      DATE,
    carga_horaria    NUMBER,
    id_estudante     NUMBER(20)
);

COMMENT ON TABLE rep_conhecimentos_diversos_student IS
    'STUDENT_DEV:SERVICE_STUDENT_DEV:CONHECIMENTOS_DIVERSOS';
ALTER TABLE rep_conhecimentos_diversos_student
    ADD CONSTRAINT krs_indice_07080 PRIMARY KEY (id);



