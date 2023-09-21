create table impressoes_declaracao_matricula(
id                NUMBER(20) NOT NULL,
id_contr_empr_est NUMBER(20) NOT NULL,
controle_impressao VARCHAR2(255 BYTE),
cpf_estudante      VARCHAR2(11 BYTE),
data_hora_matricula  TIMESTAMP NOT NULL,     
data_criacao      TIMESTAMP NOT NULL,
data_alteracao    TIMESTAMP,
criado_por        VARCHAR2(255 BYTE),
modificado_por    VARCHAR2(255 BYTE),
deletado          NUMBER(1)
);

ALTER TABLE impressoes_declaracao_matricula ADD CONSTRAINT KRS_INDICE_10710 FOREIGN KEY (id_contr_empr_est) REFERENCES CONTRATOS_ESTUDANTES_EMPRESA (ID);
CREATE SEQUENCE SEQ_IMPRESSAO_DECLARACAO_MATRICULA INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE NOKEEP NOSCALE GLOBAL;