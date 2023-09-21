--Migration inicial Sprint 19 - Service_Vagas v.1


-- PK-4909 - Alteração de estrutura na tabela beneficios MS de Vagas

ALTER TABLE BENEFICIOS ADD MOSTRA_VALOR NUMBER(1) DEFAULT 0;

COMMENT ON COLUMN BENEFICIOS.MOSTRA_VALOR IS
    'Enum:
    0 - Não
    1 - Real
    2 - Percentual';


--PK-10870 - Gerenciar grupos de IE para CSE
CREATE TABLE grupos_ie (
                           id                 NUMBER(20) NOT NULL,
                           data_criacao       TIMESTAMP NOT NULL,
                           data_alteracao     TIMESTAMP NOT NULL,
                           criado_por         VARCHAR2(255 CHAR),
                           modificado_por     VARCHAR2(255 CHAR),
                           deletado           NUMBER(1) DEFAULT 0,
                           tipo               NUMBER(1),
                           nome_grupo         VARCHAR2(150 CHAR),
                           nome_responsavel   VARCHAR2(150 CHAR),
                           email              VARCHAR2(150 CHAR),
                           telefone           VARCHAR2(60 CHAR) DEFAULT '0'
);

COMMENT ON COLUMN grupos_ie.tipo IS
    'ENUM:
0-IE
1-SEDUC
2-CIEEs Autonomos';

ALTER TABLE grupos_ie ADD CONSTRAINT krs_indice_04693 PRIMARY KEY ( id );

--
CREATE TABLE vinculos_grupos_ie_instituicoes_ensinos (
                                                         id_grupo_ie             NUMBER(20) NOT NULL,
                                                         id_instituicao_ensino   NUMBER(20) NOT NULL
);

ALTER TABLE vinculos_grupos_ie_instituicoes_ensinos
    ADD CONSTRAINT krs_indice_04706 FOREIGN KEY ( id_grupo_ie )
        REFERENCES grupos_ie ( id );

ALTER TABLE vinculos_grupos_ie_instituicoes_ensinos
    ADD CONSTRAINT krs_indice_04707 FOREIGN KEY ( id_instituicao_ensino )
        REFERENCES rep_instituicoes_ensinos ( id );

