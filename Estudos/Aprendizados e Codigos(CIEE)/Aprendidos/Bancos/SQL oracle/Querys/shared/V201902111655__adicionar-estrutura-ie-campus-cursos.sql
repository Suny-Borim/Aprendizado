CREATE TABLE rep_campus (
    id                           NUMBER(20) NOT NULL,
    id_instituicao_ensino        NUMBER(20),
    deletado                     NUMBER,
    data_criacao                 TIMESTAMP NOT NULL,
    data_alteracao               TIMESTAMP NOT NULL,
    criado_por                   VARCHAR2(255),
    modificado_por               VARCHAR2(255)
);

CREATE TABLE rep_campus_cursos (
  id                           NUMBER(20) NOT NULL,
  id_campus                    NUMBER(20),
  deletado                     NUMBER,
  data_criacao                 TIMESTAMP NOT NULL,
  data_alteracao               TIMESTAMP NOT NULL,
  criado_por                   VARCHAR2(255),
  modificado_por               VARCHAR2(255)
  );

ALTER TABLE rep_campus
  ADD CONSTRAINT KRS_INDICE_01725 PRIMARY KEY ( id );

ALTER TABLE rep_campus
  ADD CONSTRAINT KRS_INDICE_01726 FOREIGN KEY ( id_instituicao_ensino )
    REFERENCES rep_instituicoes_ensinos ( id );

ALTER TABLE rep_campus_cursos
  ADD CONSTRAINT KRS_INDICE_01727 PRIMARY KEY ( id );

ALTER TABLE rep_campus_cursos
  ADD CONSTRAINT KRS_INDICE_01728 FOREIGN KEY ( id_campus )
    REFERENCES rep_campus ( id );

ALTER TABLE rep_campus_cursos_periodos ADD id_campus_curso NUMBER(20);

ALTER TABLE rep_campus_cursos_periodos
  ADD CONSTRAINT KRS_INDICE_01729 FOREIGN KEY ( id_campus_curso )
  REFERENCES rep_campus_cursos ( id );