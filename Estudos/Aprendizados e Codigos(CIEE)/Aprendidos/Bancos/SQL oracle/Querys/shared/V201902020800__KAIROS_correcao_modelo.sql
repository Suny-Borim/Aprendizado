CREATE TABLE pcd_aprendiz (
    id                     NUMBER(20) NOT NULL,
    id_vaga_apendiz        NUMBER(20) NOT NULL,
    id_cid_agrupado        NUMBER(20) NOT NULL,
    validade_minma_laudo   TIMESTAMP,
    deletado               NUMBER,
    data_criacao           TIMESTAMP NOT NULL,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255 BYTE),
    modificado_por         VARCHAR2(255 BYTE)
);

ALTER TABLE pcd_aprendiz ADD CONSTRAINT krs_indice_01338 PRIMARY KEY ( id );
CREATE TABLE rep_informacoes_sociais (
    id                             NUMBER NOT NULL,
    id_estudante                   NUMBER(19) NOT NULL,
    possui_incentivo_educacional   NUMBER(1),
    documento_cadunico             NUMBER(19),
    como_conheceu_ciee             NUMBER(19),
    deletado                       NUMBER(1),
    data_criacao                   TIMESTAMP NOT NULL,
    data_alteracao                 TIMESTAMP NOT NULL,
    criado_por                     VARCHAR2(255 BYTE),
    modificado_por                 VARCHAR2(255 BYTE)
);

ALTER TABLE rep_informacoes_sociais ADD CONSTRAINT krs_indice_01627 PRIMARY KEY ( id );

ALTER TABLE parametros_empresa_contrato MODIFY (
    id_empresa
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE parametros_empresa_contrato MODIFY (
    id_contrato
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE pcd ADD (
    validade_minma_laudo   TIMESTAMP
);

ALTER TABLE rep_conhecimentos_informatica ADD CONSTRAINT krs_indice_01620 PRIMARY KEY ( id );
ALTER TABLE rep_enderecos ADD (
    latitude   FLOAT
);
ALTER TABLE rep_enderecos ADD (
    longitude   FLOAT
);
ALTER TABLE rep_enderecos_estudantes ADD CONSTRAINT krs_indice_01621 PRIMARY KEY ( id );
ALTER TABLE rep_escolaridades_estudantes MODIFY (
    nome_escola VARCHAR2(355)
);
ALTER TABLE rep_estudantes ADD (
    sexo   VARCHAR2(10)
);
ALTER TABLE rep_estudantes ADD (
    estado_civil   VARCHAR2(20)
);
ALTER TABLE rep_estudantes ADD (
    tipo_programa   VARCHAR2(20)
);
ALTER TABLE rep_idiomas_niveis ADD CONSTRAINT krs_indice_01622 PRIMARY KEY ( id );
ALTER TABLE rep_informacoes_adicionais ADD CONSTRAINT krs_indice_01623 PRIMARY KEY ( id );
ALTER TABLE rep_laudos_medicos ADD CONSTRAINT krs_indice_01624 PRIMARY KEY ( id );
ALTER TABLE rep_laudos_medicos_documentos ADD CONSTRAINT krs_indice_01625 PRIMARY KEY ( laudo_medico_id );
ALTER TABLE rep_recursos_acessibilidade ADD CONSTRAINT krs_indice_01626 PRIMARY KEY ( id );

ALTER TABLE PALAVRAS_CHAVE_APRENDIZ RENAME COLUMN vagas_aprendiz_id TO id_vaga_aprendiz;

ALTER TABLE vagas_aprendiz ADD (
    ddd_fone_contato   VARCHAR2(2) NOT NULL
);
COMMENT ON COLUMN vagas_aprendiz.escolaridade IS
    'Enum:

0 - Todos

1 - Ensino Fundamental

2 - Ensino Medio';
COMMENT ON COLUMN vagas_aprendiz.situacao_escolaridade IS
    'Enum:

0 - Todos

1 - Cursando

2 - Concluido';

ALTER TABLE vagas_aprendiz MODIFY (
    situacao_escolaridade NUMBER
);
ALTER TABLE vagas_aprendiz MODIFY (
    tipo_salario_valor NUMBER
);
ALTER TABLE vagas_aprendiz ADD (
    distancia   NUMBER(20)
);
ALTER TABLE vagas_aprendiz ADD (
    valido_cota   NUMBER
);

COMMENT ON COLUMN vagas_aprendiz.valido_cota IS
    'Flag 0 ou 1';
ALTER TABLE vagas_aprendiz ADD (
    empresa_com_acessibilidade   NUMBER
);

COMMENT ON COLUMN vagas_aprendiz.empresa_com_acessibilidade IS
    'Flag 0 ou 1';
ALTER TABLE vagas_aprendiz ADD (
    num_encaminhamento_vaga   NUMBER(5)
);
ALTER TABLE vagas_estagio ADD (
    distancia   NUMBER(20)
);
ALTER TABLE vagas_estagio ADD (
    valido_cota   NUMBER
);

COMMENT ON COLUMN vagas_estagio.valido_cota IS
    'Flag

 0 ou 1';
ALTER TABLE vagas_estagio ADD (
    empresa_com_acessibilidade   NUMBER
);

COMMENT ON COLUMN vagas_estagio.empresa_com_acessibilidade IS
    'Flag 

0 ou 1';
ALTER TABLE aparelhos_pcd_aprendiz
    ADD CONSTRAINT krs_indice_01341 FOREIGN KEY ( id_pcd )
        REFERENCES pcd_aprendiz ( id )
    NOT DEFERRABLE;
ALTER TABLE palavras_chave_aprendiz
    ADD CONSTRAINT krs_indice_01164 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id )
    NOT DEFERRABLE;
ALTER TABLE parametros_empresa_contrato
    ADD CONSTRAINT krs_indice_01507 FOREIGN KEY ( id_contrato )
        REFERENCES rep_locais_contrato ( id )
    NOT DEFERRABLE;
ALTER TABLE parametros_empresa_contrato
    ADD CONSTRAINT krs_indice_01509 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE pcd
    ADD CONSTRAINT krs_indice_01335 FOREIGN KEY ( id_cid_agrupado )
        REFERENCES rep_agrupamento_cid_pcd ( codigo_agrupamento )
    NOT DEFERRABLE;
ALTER TABLE pcd_aprendiz
    ADD CONSTRAINT krs_indice_01340 FOREIGN KEY ( id_cid_agrupado )
        REFERENCES rep_agrupamento_cid_pcd ( codigo_agrupamento )
    NOT DEFERRABLE;
ALTER TABLE pcd_aprendiz
    ADD CONSTRAINT krs_indice_01339 FOREIGN KEY ( id_vaga_apendiz )
        REFERENCES vagas_aprendiz ( id )
    NOT DEFERRABLE;