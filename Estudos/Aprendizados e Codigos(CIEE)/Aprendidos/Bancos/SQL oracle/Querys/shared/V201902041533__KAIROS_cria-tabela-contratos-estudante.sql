--
-- Tabela para gravar dados de contratos entre estudante com empresas(TCE/TCA)
--


CREATE TABLE contratos_estudantes_empresa (
    id                     NUMBER(20) NOT NULL,
    codigo_da_vaga         NUMBER(20),
    id_local_contrato      NUMBER(20) NOT NULL,
    id_estudante           NUMBER(20) NOT NULL,
    tipo_contrato          VARCHAR2(1),
    id_curso_capacitacao   NUMBER(20),
    carga_horaria          NUMBER(3),
    faixa_etaria_inicial   NUMBER(2),
    faixa_etaria_final     NUMBER(2),
    data_inicio            TIMESTAMP,
    data_final             TIMESTAMP,
    id_area_profissional   NUMBER(20),
    id_curso               NUMBER,
    deletado               NUMBER,
    data_criacao           TIMESTAMP,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255),
    modificado_por         VARCHAR2(255)
);

COMMENT ON COLUMN contratos_estudantes_empresa.tipo_contrato IS
    'Flag:

A - Aprendiz

E - Estagio';

COMMENT ON COLUMN contratos_estudantes_empresa.id_curso_capacitacao IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.carga_horaria IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.faixa_etaria_inicial IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.faixa_etaria_final IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN contratos_estudantes_empresa.id_area_profissional IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: E';

COMMENT ON COLUMN contratos_estudantes_empresa.id_curso IS
    'Obs:

  Este campo é preenchido quando o tipo do contrato for: E';

ALTER TABLE contratos_estudantes_empresa ADD CONSTRAINT krs_indice_01640 PRIMARY KEY ( id );
CREATE TABLE rep_ie_acordos_cooperacao (
    id                NUMBER(20) NOT NULL,
    codigo_convenio   NUMBER(20),
    deletado          NUMBER,
    data_criacao      TIMESTAMP,
    data_alteracao    TIMESTAMP,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

ALTER TABLE rep_ie_acordos_cooperacao ADD CONSTRAINT krs_indice_01660 PRIMARY KEY ( id );
CREATE TABLE rep_ie_pre_cadastro (
    id               NUMBER(20) NOT NULL,
    deletado         NUMBER,
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

ALTER TABLE rep_ie_pre_cadastro ADD CONSTRAINT krs_indice_01662 PRIMARY KEY ( id );
CREATE TABLE rep_pendencias (
    id                      NUMBER(20) NOT NULL,
    id_instituicao_ensino   NUMBER(20),
    deletado                NUMBER,
    data_criacao            TIMESTAMP,
    data_alteracao          TIMESTAMP,
    criado_por              VARCHAR2(255),
    modificado_por          VARCHAR2(255)
);

ALTER TABLE rep_pendencias ADD CONSTRAINT krs_indice_01661 PRIMARY KEY ( id );
ALTER TABLE palavras_chave_aprendiz MODIFY (
    id_vaga_aprendiz
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE palavras_chave_aprendiz RENAME COLUMN palavra_chave TO palavra;

ALTER TABLE palavras_chave_aprendiz MODIFY (
    palavra
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);
ALTER TABLE pcd ADD (
    validade_minima_laudo   TIMESTAMP
);
ALTER TABLE rep_instituicoes_ensinos MODIFY (
    nome_instituicao VARCHAR2(200)
);
ALTER TABLE rep_instituicoes_ensinos ADD (
    mantenedora   VARCHAR2(255)
);
ALTER TABLE vagas_aprendiz MODIFY (
    descricao VARCHAR2(50)
);
ALTER TABLE vagas_aprendiz MODIFY (
    valido_cota DEFAULT 0
);
ALTER TABLE vagas_estagio MODIFY (
    descricao VARCHAR2(50 BYTE)
);
ALTER TABLE vagas_estagio MODIFY (
    valido_cota DEFAULT 0
);
ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01642 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;
ALTER TABLE contratos_estudantes_empresa
    ADD CONSTRAINT krs_indice_01641 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id )
    NOT DEFERRABLE;
ALTER TABLE rep_aparelhos
    DROP COLUMN ativo1;


CREATE SEQUENCE {{user}}.seq_contratos_est_emp MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  ;
