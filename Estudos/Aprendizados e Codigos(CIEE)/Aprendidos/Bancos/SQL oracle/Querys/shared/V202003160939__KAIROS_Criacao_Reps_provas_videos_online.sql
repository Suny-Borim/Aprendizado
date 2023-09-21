CREATE TABLE rep_provas_online_curriculos_estudantes_student (
    id                     NUMBER(20) NOT NULL,
    id_estudante           NUMBER(20),
    status                 NUMBER(1),
    id_vinculo             NUMBER(20),
    id_prova               NUMBER(20),
    tempo_prova            NUMBER(20),
    data_conclusao_prova   TIMESTAMP,
    nota_prova             NUMBER(4, 1),
    criado_por             VARCHAR2(255 CHAR),
    data_criacao           TIMESTAMP,
    modificado_por         VARCHAR2(255 CHAR),
    data_alteracao         TIMESTAMP,
    deletado               NUMBER(1)
);

COMMENT ON TABLE rep_provas_online_curriculos_estudantes_student IS
    'STUDENT_DEV:SERVICE_STUDENT_DEV:PROVAS_ONLINE_CURRICULOS_ESTUDANTES';
	
COMMENT ON COLUMN rep_provas_online_curriculos_estudantes_student.status IS
    'ENUM:
0-PENDENTE
1-FINALIZADO';

ALTER TABLE rep_provas_online_curriculos_estudantes_student ADD CONSTRAINT krs_indice_07332 PRIMARY KEY ( id );

CREATE TABLE rep_videos_curriculos_estudantes_student (
    id                         NUMBER(20) NOT NULL,
    id_estudante               NUMBER(20),
    id_teste_video_curriculo   NUMBER(20),
    url_videos_curriculos      VARCHAR2(255 CHAR),
    criado_por                 VARCHAR2(255 CHAR),
    data_criacao               TIMESTAMP,
    modificado_por             VARCHAR2(255 CHAR),
    data_alteracao             TIMESTAMP,
    deletado                   NUMBER(1)
);

ALTER TABLE rep_videos_curriculos_estudantes_student ADD CONSTRAINT krs_indice_07333 PRIMARY KEY ( id );