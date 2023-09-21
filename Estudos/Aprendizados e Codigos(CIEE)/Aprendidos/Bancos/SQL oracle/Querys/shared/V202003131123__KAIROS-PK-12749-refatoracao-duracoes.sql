---- correção sequence areas atuação aprendiz
DROP SEQUENCE SEQ_AREAS_ATUACAO_APRENDIZ;
CREATE SEQUENCE SEQ_AREAS_ATUACAO_APRENDIZ MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 25 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

---- adicionado campo da reserva no pré contrato e no contrato
ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD ID_RESERVA_SECRETARIA NUMBER(20);
ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD ID_RESERVA_SECRETARIA NUMBER(20);

---- criando as constraints da tabela de turmas
ALTER TABLE TURMAS ADD CONSTRAINT KRS_INDICE_07325 FOREIGN KEY ( ID_PRE_CONTRATOS_CURSOS_CAPACITACAO ) REFERENCES PRE_CONTRATOS_CURSOS_CAPACITACAO ( id );
ALTER TABLE TURMAS ADD CONSTRAINT KRS_INDICE_07326 FOREIGN KEY ( ID_CONTRATOS_CURSOS_CAPACITACAO ) REFERENCES CONTRATOS_CURSOS_CAPACITACAO ( id );

---- PK-12749 refatoração das durações de curso
DROP TABLE CARGAS_HORARIA CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_CARGAS_HORARIA;

DELETE FROM DURACOES_CURSOS_MTE WHERE 1 = 1;
DELETE FROM CURSOS_MTE WHERE 1 = 1;
DELETE FROM REGISTROS_DURACOES_CAPACIT WHERE 1 = 1;
DELETE FROM REGISTROS_DOCUMENTOS WHERE 1 = 1;
DELETE FROM REGISTROS_CMDCAS WHERE 1 = 1;
DELETE FROM DURACOES_CAPACIT_CBOS WHERE 1 = 1;
DELETE FROM DURACOES_CAPACITACAO WHERE 1 = 1;

ALTER TABLE DURACOES_CAPACITACAO DROP COLUMN CARGA_HORARIA_BASICA;
ALTER TABLE DURACOES_CAPACITACAO DROP COLUMN CARGA_HORARIA_ESPECIFICA;
ALTER TABLE DURACOES_CAPACITACAO DROP COLUMN CARGA_HORARIA_PRATICA;
ALTER TABLE DURACOES_CAPACITACAO DROP COLUMN CARGA_HORARIA_MODULO;

ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_APRENDIZAGEM NUMBER(20) NOT NULL;
ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_CAPACITACAO NUMBER(20) NOT NULL;
ALTER TABLE DURACOES_CAPACITACAO ADD CARGA_HORARIA_TOTAL NUMBER(20) NOT NULL;

---- Criada entidade para salvar informações da secretaria referente ao cadastro da empresa e do estudante
CREATE TABLE dados_empresas_estudantes_secretaria (
                                               id                      NUMBER(20) NOT NULL,
                                               id_empresa              NUMBER(20) NOT NULL,
                                               id_contr_empresa        NUMBER(20) NOT NULL,
                                               id_local_contrato       NUMBER(20) NOT NULL,
                                               nome_representante      VARCHAR2(100) NOT NULL,
                                               email_representante     VARCHAR2(100) NOT NULL,
                                               telefone_representante  VARCHAR2(20) NOT NULL,
                                               id_estudante            NUMBER(20) NOT NULL,
                                               id_secretaria_empresa   NUMBER(20),
                                               id_secretaria_estudante NUMBER(20),
                                               data_criacao            TIMESTAMP NOT NULL,
                                               data_alteracao          TIMESTAMP,
                                               criado_por              VARCHAR2(255) NOT NULL,
                                               modificado_por          VARCHAR2(255),
                                               deletado                NUMBER(1)
);
ALTER TABLE dados_empresas_estudantes_secretaria ADD CONSTRAINT KRS_INDICE_07327 PRIMARY KEY (id);
ALTER TABLE dados_empresas_estudantes_secretaria ADD CONSTRAINT KRS_INDICE_07328 FOREIGN KEY (id_empresa) REFERENCES rep_empresas (id);
ALTER TABLE dados_empresas_estudantes_secretaria ADD CONSTRAINT KRS_INDICE_07329 FOREIGN KEY (id_contr_empresa) REFERENCES rep_contratos (id);
ALTER TABLE dados_empresas_estudantes_secretaria ADD CONSTRAINT KRS_INDICE_07330 FOREIGN KEY (id_local_contrato) REFERENCES rep_locais_contrato (id);
ALTER TABLE dados_empresas_estudantes_secretaria ADD CONSTRAINT KRS_INDICE_07331 FOREIGN KEY (id_estudante) REFERENCES rep_estudantes (id);

CREATE SEQUENCE SEQ_dados_empresas_estudantes_secretaria MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;