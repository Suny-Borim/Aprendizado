--
DROP TABLE destaques_areas_prof_tce;
DROP TABLE destaques_areas_atua_tce;

--
CREATE TABLE destaques_areas_prof_tce (
    id                            NUMBER(20) NOT NULL,
    id_area_profissional          NUMBER(20),
    descricao_area_profissional   VARCHAR2(200),
    id_nivel_educacional          VARCHAR2(5),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    id_area_atuacao               NUMBER(20) NOT NULL,
    descricao_area_atuacao        VARCHAR2(200) NOT NULL
);

COMMENT ON TABLE destaques_areas_prof_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa 
   razão tambem deixei de fora as colunas de controle.
- Essa tabela armazena o processamento Geral'
    ;

ALTER TABLE destaques_areas_prof_tce ADD CONSTRAINT krs_indice_01114 PRIMARY KEY ( id );


CREATE TABLE destaques_areas_prof_tce_emp (
    id                            NUMBER(20) NOT NULL,
    id_empresa                    NUMBER(20),
    razao_social                  VARCHAR2(150),
    id_contrato                   NUMBER(20),
    id_area_profissional          NUMBER(20),
    id_nivel_educacional          VARCHAR2(5),
    descricao_area_profissional   VARCHAR2(200),
    uf                            VARCHAR2(2),
    municipio                     VARCHAR2(150),
    id_area_atuacao               NUMBER(20) NOT NULL,
    descricao_area_atuacao        VARCHAR2(200) NOT NULL
);

COMMENT ON TABLE destaques_areas_prof_tce_emp IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa 
   razão tambem deixei de fora as colunas de controle.
- Essa tabela armazena o processamento por Empresas'
    ;

ALTER TABLE destaques_areas_prof_tce_emp ADD CONSTRAINT krs_indice_02700 PRIMARY KEY ( id );

--
CREATE TABLE destaques_areas_atua_tce_emp (
    id                       NUMBER(20) NOT NULL,
    id_empresa               NUMBER(20),
    razao_social             VARCHAR2(150),
    id_contrato              NUMBER(20),
    id_nivel_educacional     VARCHAR2(5),
    uf                       VARCHAR2(2),
    municipio                VARCHAR2(150),
    id_area_atuacao          NUMBER(20),
    descricao_area_atuacao   VARCHAR2(200)
);

COMMENT ON TABLE destaques_areas_atua_tce_emp IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa 
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE destaques_areas_atua_tce_emp ADD CONSTRAINT krs_indice_01112 PRIMARY KEY ( id );


CREATE TABLE destaques_areas_atua_tce (
    id                       NUMBER(20) NOT NULL,
    id_contrato              NUMBER(20),
    id_nivel_educacional     VARCHAR2(5),
    uf                       VARCHAR2(2),
    municipio                VARCHAR2(150),
    id_area_atuacao          NUMBER(20),
    descricao_area_atuacao   VARCHAR2(200)
);

COMMENT ON TABLE destaques_areas_atua_tce IS
    '- Essa tabela não tem ligações via constraint por será preenchida via processamento.
- Sempre que o processamento acontece os registros serão apagados e inseridos novamente, por essa 
   razão tambem deixei de fora as colunas de controle.'
    ;

ALTER TABLE destaques_areas_atua_tce ADD CONSTRAINT krs_indice_02701 PRIMARY KEY ( id );

CREATE OR REPLACE VIEW V_DESTAQUES_AREAS_PROFISSIONAIS AS (
  SELECT
    CONCAT(ID_AREA_PROFISSIONAL, 1) AS ID, ID_AREA_PROFISSIONAL, DESCRICAO_AREA_PROFISSIONAL, ID_CONTRATO, UF, MUNICIPIO, ID_NIVEL_EDUCACIONAL, 1 AS ORDEM
  FROM
    DESTAQUES_AREAS_PROF_TCE_EMP
  UNION ALL
  SELECT
    CONCAT(ID_AREA_PROFISSIONAL, 2) AS ID, ID_AREA_PROFISSIONAL, DESCRICAO_AREA_PROFISSIONAL, NULL AS ID_CONTRATO, UF, MUNICIPIO, ID_NIVEL_EDUCACIONAL, 2 AS ORDEM 
  FROM
    DESTAQUES_AREAS_PROF_TCE
  UNION ALL
  SELECT
    CONCAT(CODIGO_AREA_PROFISSIONAL, 3) AS ID, CODIGO_AREA_PROFISSIONAL, DESCRICAO_AREA_PROFISSIONAL, NULL AS ID_CONTRATO, NULL AS UF, NULL AS MUNICIPIO, ID_NIVEL_EDUCACIONAL, 3 AS ORDEM
  FROM
    REP_AREAS_PROFISSIONAIS
);
