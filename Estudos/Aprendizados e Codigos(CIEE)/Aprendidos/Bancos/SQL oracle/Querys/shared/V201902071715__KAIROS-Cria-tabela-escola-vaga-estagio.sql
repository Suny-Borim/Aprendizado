--
-- Cria tabela para persistir dados de escolas que relacionam com vaga de estagio
--

CREATE TABLE {{user}}.vagas_instituicoes_ensino (
    id                      NUMBER(20) NOT NULL,
    id_vaga_estagio         NUMBER(20) NOT NULL,
    id_instituicao_ensino   NUMBER(20) NOT NULL,
    numero_convenio         NUMBER(20),
    nome_instituicao        VARCHAR2(200),
    nome_fantasia           VARCHAR2(200),
    deletado                NUMBER,
    data_criacao            TIMESTAMP,
    data_alteracao          TIMESTAMP,
    criado_por              VARCHAR2(255),
    modificado_por          VARCHAR2(255)
);

ALTER TABLE {{user}}.vagas_instituicoes_ensino ADD CONSTRAINT krs_indice_01720 PRIMARY KEY ( id );

ALTER TABLE {{user}}.vagas_instituicoes_ensino
    ADD CONSTRAINT krs_indice_01721 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id );

ALTER TABLE {{user}}.vagas_instituicoes_ensino
    ADD CONSTRAINT krs_indice_01722 FOREIGN KEY ( id_instituicao_ensino )
        REFERENCES rep_instituicoes_ensinos ( id );

CREATE SEQUENCE {{user}}.seq_vagas_instituicoes_ensino MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  ;
