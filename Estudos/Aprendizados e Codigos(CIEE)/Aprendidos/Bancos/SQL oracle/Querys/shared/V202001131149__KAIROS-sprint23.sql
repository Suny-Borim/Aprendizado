--Adendo - PK-11192 - Acompanhar Processo CSE (BackOffice CIEE)
CREATE TABLE processos_cse (
                                  id                         NUMBER(20) NOT NULL,
                                  id_contrato                NUMBER(20) NOT NULL,
                                  tipo                       NUMBER(1),
                                  data_inicio_processo_cse   TIMESTAMP,
                                  data_fim_processo_cse      TIMESTAMP,
                                  data_criacao               TIMESTAMP NOT NULL,
                                  data_alteracao             TIMESTAMP NOT NULL,
                                  criado_por                 VARCHAR2(255) NOT NULL,
                                  modificado_por             VARCHAR2(255) NOT NULL,
                                  deletado                   NUMBER(1) DEFAULT 0
);
COMMENT ON COLUMN processos_cse.tipo IS
    'ENUM
0: BIMESTRAL
1: TRIMESTRAL
2: SEMESTRAL
3: ANUAL';

ALTER TABLE processos_cse ADD CONSTRAINT krs_indice_06893 PRIMARY KEY ( id );
ALTER TABLE processos_cse
    ADD CONSTRAINT krs_indice_06894 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );
--
CREATE SEQUENCE SEQ_processos_cse MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
--
ALTER TABLE cse add id_processo_cse NUMBER(20) NOT NULL;
ALTER TABLE cse
    ADD CONSTRAINT krs_indice_06895 FOREIGN KEY ( id_processo_cse )
        REFERENCES processos_cse ( id );
--
CREATE TABLE dashboards_processos_cse (
                                          id                   NUMBER(20) NOT NULL,
                                          data_criacao         TIMESTAMP NOT NULL,
                                          data_alteracao       TIMESTAMP NOT NULL,
                                          criado_por           VARCHAR2(255 CHAR),
                                          modificado_por       VARCHAR2(255 CHAR),
                                          deletado             NUMBER(1) DEFAULT 0,
                                          quantidade_estudantes_pendentes            NUMBER(4),
                                          quantidade_estudantes_regulares            NUMBER(4),
                                          quantidade_estudantes_irregulares          NUMBER(4),
                                          quantidade_estudantes_analise              NUMBER(4),
                                          competencia          DATE,
                                          nome_empresa         VARCHAR2(150 CHAR),
                                          tipo                 NUMBER(1),
                                          id_contrato          NUMBER(20),
                                          id_unidade_ciee      NUMBER(19),
                                          id_processo_cse      NUMBER(20)
);

COMMENT ON COLUMN dashboards_processos_cse.tipo IS
    'ENUM
0: BIMESTRAL
1: TRIMESTRAL
2: SEMESTRAL
3: ANUAL';

ALTER TABLE dashboards_processos_cse ADD CONSTRAINT krs_indice_06860 PRIMARY KEY ( id );

CREATE SEQUENCE SEQ_dashboards_processos_cse MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

--PK-11740 - Implementar Turma Complementar na Abertura de Vagas - Aprendiz
ALTER TABLE turmas ADD turma NUMBER(1);
COMMENT ON COLUMN turmas.turma IS
    'ENUM
0-Principal
1-Complementar';
