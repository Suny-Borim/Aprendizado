-- PK-12925 PK-12928
CREATE TABLE classificacoes_estudantes_analitico (
    id                                       NUMBER(20) NOT NULL,
    data_criacao                             TIMESTAMP NOT NULL,
    data_alteracao                           TIMESTAMP NOT NULL,
    criado_por                               VARCHAR2(255 CHAR),
    modificado_por                           VARCHAR2(255 CHAR),
    deletado                                 NUMBER(1) DEFAULT 0,
    id_classificacao_estudante_consolidado   NUMBER(20) NOT NULL,
    pontuacao_atual                          NUMBER(3),
    id_classificacao_parametros_iten         NUMBER(20) NOT NULL
);
ALTER TABLE classificacoes_estudantes_analitico ADD CONSTRAINT krs_indice_07285 PRIMARY KEY ( id );
CREATE TABLE classificacoes_estudantes_consolidado (
    id                       NUMBER(20) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL,
    data_alteracao           TIMESTAMP NOT NULL,
    criado_por               VARCHAR2(255 CHAR),
    modificado_por           VARCHAR2(255 CHAR),
    deletado                 NUMBER(1) DEFAULT 0,
    id_estudante             NUMBER(20),
    pontuacao_obtida         NUMBER(3) NOT NULL,
    classificacao_obtida     VARCHAR2(15 CHAR),
    data_calculo_pontuacao   TIMESTAMP
);
ALTER TABLE classificacoes_estudantes_consolidado ADD CONSTRAINT krs_indice_07283 PRIMARY KEY ( id );
CREATE TABLE classificacoes_parametros_itens (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0,
    indicador        VARCHAR2(255 CHAR),
    periodo          NUMBER(10),
    faixa            VARCHAR2(15 CHAR),
    ponto            NUMBER(3)
);
ALTER TABLE classificacoes_parametros_itens ADD CONSTRAINT krs_indice_07281 PRIMARY KEY ( id );
CREATE TABLE classificacoes_parametros_pontos (
    id               NUMBER(20) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255 CHAR),
    modificado_por   VARCHAR2(255 CHAR),
    deletado         NUMBER(1) DEFAULT 0,
    descricao        VARCHAR2(15 CHAR),
    ponto_de         NUMBER(3),
    ponto_ate        NUMBER(3)
);
ALTER TABLE classificacoes_parametros_pontos ADD CONSTRAINT krs_indice_07282 PRIMARY KEY ( id );
ALTER TABLE classificacoes_estudantes_analitico
    ADD CONSTRAINT krs_indice_07288 FOREIGN KEY ( id_classificacao_estudante_consolidado )
        REFERENCES classificacoes_estudantes_consolidado ( id );
ALTER TABLE classificacoes_estudantes_consolidado
    ADD CONSTRAINT krs_indice_07289 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );
ALTER TABLE classificacoes_estudantes_analitico
    ADD CONSTRAINT krs_indice_07340 FOREIGN KEY ( id_classificacao_parametros_iten )
        REFERENCES classificacoes_parametros_itens ( id );