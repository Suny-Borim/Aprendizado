--####################################################################################################################################################################################
-- tabela
--####################################################################################################################################################################################

--##########################################################################################
-- aparelhos_pcd
--##########################################################################################
ALTER TABLE aparelhos_pcd DROP COLUMN id_vaga_estagio_pcd CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN descricao_aparelho CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN deletado CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN data_criacao CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN data_alteracao CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN criado_por CASCADE CONSTRAINTS;
ALTER TABLE aparelhos_pcd DROP COLUMN modificado_por CASCADE CONSTRAINTS;

ALTER TABLE aparelhos_pcd RENAME COLUMN id TO id_pcd;
ALTER TABLE aparelhos_pcd MODIFY (
    id_aparelho NUMBER(19)
);

--##########################################################################################
-- aparelhos_pcd_aprendiz
--##########################################################################################	
CREATE TABLE aparelhos_pcd_aprendiz (
    id_pcd        NUMBER(20) NOT NULL,
    id_aparelho   NUMBER(19) NOT NULL
);

--##########################################################################################
-- estudantes_agenda
--##########################################################################################	

CREATE TABLE estudantes_agenda (
    id                            NUMBER(20) NOT NULL,
    id_vinculo_vaga               NUMBER(20) NOT NULL,
    id_agenda_processo_seletivo   NUMBER(20) NOT NULL,
    deletado                      NUMBER,
    data_criacao                  TIMESTAMP,
    data_alteracao                TIMESTAMP,
    criado_por                    VARCHAR2(255),
    modificado_por                VARCHAR2(255)
);

ALTER TABLE estudantes_agenda ADD CONSTRAINT krs_indice_01580 PRIMARY KEY ( id );

--##########################################################################################
-- estudantes_empresa
--##########################################################################################	
CREATE TABLE estudantes_empresa (
    id                        NUMBER NOT NULL,
    id_estudante              NUMBER(20) NOT NULL,
    id_empresa                NUMBER(20) NOT NULL,
    id_contrato_empresa       NUMBER(20),
    tipo_contrato_estudante   NUMBER(1),
    id_contrato_aprendiz      NUMBER(20),
    id_contrato_estagio       NUMBER(20),
    nivel_contrato            NUMBER(1),
    deletado                  NUMBER,
    data_criacao              TIMESTAMP,
    data_alteracao            TIMESTAMP,
    criado_por                VARCHAR2(255),
    modificado_por            VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN estudantes_empresa.tipo_contrato_estudante IS
    'Enum:

0 - Estagio

1 - Aprendiz';

COMMENT ON COLUMN estudantes_empresa.nivel_contrato IS
    'Enum:

0 - Superior

1 - Medio';

ALTER TABLE estudantes_empresa ADD CONSTRAINT krs_indice_01513 PRIMARY KEY ( id );

--##########################################################################################
-- estudantes_recusas
--##########################################################################################	
CREATE TABLE estudantes_recusas (
    id                     NUMBER(20) NOT NULL,
    id_estudante           NUMBER(20) NOT NULL,
    id_empresa             NUMBER(20) NOT NULL,
    id_contrato_emopresa   NUMBER(20),
    id_local_contrato      NUMBER(20),
    id_recusa              NUMBER(20) NOT NULL,
    login_usuario          VARCHAR2(50)
)
LOGGING;

ALTER TABLE estudantes_recusas ADD CONSTRAINT krs_indice_01517 PRIMARY KEY ( id );

--##########################################################################################
-- etapas_processo_seletivo
--##########################################################################################	
ALTER TABLE etapas_processo_seletivo ADD id_motivo_final_processo NUMBER(20);

--##########################################################################################
-- ocorrencias
--##########################################################################################	
DROP TABLE ocorrencias CASCADE CONSTRAINTS;
CREATE TABLE ocorrencias (
    id                     NUMBER(20) NOT NULL,
    descricao              VARCHAR2(100),
    bloqueia_vaga          NUMBER,
    bloqueia_contratacao   NUMBER,
    ativo                  NUMBER,
    deletado               NUMBER,
    data_criacao           TIMESTAMP,
    data_alteracao         TIMESTAMP,
    criado_por             VARCHAR2(255 BYTE),
    modificado_por         VARCHAR2(255 BYTE)
);

COMMENT ON COLUMN ocorrencias.bloqueia_vaga IS
    'Normalizado para:

0 - Não

1 - Sim';

COMMENT ON COLUMN ocorrencias.bloqueia_contratacao IS
    'Normalizado para:

0 - Não

1 - Sim';

COMMENT ON COLUMN ocorrencias.ativo IS
    'Normalizado para:

0 - Não

1 - Sim';

ALTER TABLE ocorrencias ADD CONSTRAINT krs_indice_01502 PRIMARY KEY ( id );

--##########################################################################################
-- ocorrencias_aprendiz
--##########################################################################################	
CREATE TABLE ocorrencias_aprendiz (
    id_ocorrencia      NUMBER(20) NOT NULL,
    id_vaga_aprendiz   NUMBER(20) NOT NULL,
    descricao          VARCHAR2(40) NOT NULL,
    data_cocrrencia    DATE NOT NULL,
    deletado           NUMBER(1),
    data_criacao       TIMESTAMP NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL,
    criado_por         VARCHAR2(255),
    modificado_por     VARCHAR2(255)
);

ALTER TABLE ocorrencias_aprendiz ADD CONSTRAINT krs_indice_01500 PRIMARY KEY ( id_ocorrencia );
--##########################################################################################
-- ocorrencias_estagio
--##########################################################################################	
CREATE TABLE ocorrencias_estagio (
    id_ocorrencia     NUMBER(20) NOT NULL,
    id_vaga_estagio   NUMBER(20) NOT NULL,
    descricao         VARCHAR2(40) NOT NULL,
    data_cocrrencia   DATE NOT NULL,
    deletado          NUMBER(1),
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
)
LOGGING;

ALTER TABLE ocorrencias_estagio ADD CONSTRAINT krs_indice_01012 PRIMARY KEY ( id_ocorrencia );

--##########################################################################################
-- rep_agrupamento_cid_pcd
--##########################################################################################	
CREATE TABLE rep_agrupamento_cid_pcd (
    codigo_agrupamento   NUMBER(20) NOT NULL,
    agrupamento          VARCHAR2(40) NOT NULL
);

ALTER TABLE rep_agrupamento_cid_pcd ADD CONSTRAINT krs_indice_01333 PRIMARY KEY ( codigo_agrupamento );

--##########################################################################################
-- rep_aparelhos
--##########################################################################################	
CREATE TABLE rep_aparelhos (
    id                   NUMBER(19) NOT NULL,
    codigo_aparelho      NUMBER(10),
    descricao_aparelho   VARCHAR2(150) NOT NULL,
    ativo                NUMBER(1) NOT NULL,
    deletado             NUMBER(1) NOT NULL,
    criado_por           VARCHAR2(255 CHAR),
    data_criacao         TIMESTAMP NOT NULL,
    modificado_por       VARCHAR2(255 CHAR),
    data_alteracao       TIMESTAMP NOT NULL,
    ativo1               NUMBER(1) NOT NULL
)
LOGGING;

ALTER TABLE rep_aparelhos ADD CONSTRAINT krs_indice_01336 PRIMARY KEY ( id );
--##########################################################################################
-- rep_conhecimentos_informatica
--##########################################################################################	
CREATE TABLE rep_conhecimentos_informatica (
    id                   NUMBER(20) NOT NULL,
    id_estudante         NUMBER(20) NOT NULL,
    nivel_conhecimento   VARCHAR2(30 BYTE) NOT NULL,
    tipo_conhecimento    VARCHAR2(30 BYTE) NOT NULL,
    deletado             NUMBER(1) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL,
    data_alteracao       TIMESTAMP NOT NULL,
    criado_por           VARCHAR2(255),
    modificado_por       VARCHAR2(255)
);

--##########################################################################################
-- rep_empresas
--##########################################################################################	
CREATE TABLE rep_empresas (
    id               NUMBER(20) NOT NULL,
    razao_social     VARCHAR2(150),
    nome_fantasia    VARCHAR2(150),
    cnpj             VARCHAR2(14),
    cpf              VARCHAR2(12),
    nome             VARCHAR2(150),
    deletado         NUMBER,
    data_criacao     TIMESTAMP,
    data_alteracao   TIMESTAMP,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
)
LOGGING;

ALTER TABLE rep_empresas ADD CONSTRAINT krs_indice_01508 PRIMARY KEY ( id );

--##########################################################################################
-- rep_enderecos_estudantes
--##########################################################################################	
CREATE TABLE rep_enderecos_estudantes (
    id               NUMBER(20) NOT NULL,
    id_estudante     NUMBER(20) NOT NULL,
    principal        NUMBER(1) DEFAULT 0 NOT NULL,
    latitude         FLOAT(126),
    longitude        FLOAT(126),
    deletado         NUMBER(1) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

--##########################################################################################
-- rep_idiomas_niveis
--##########################################################################################	
CREATE TABLE rep_idiomas_niveis (
    id               NUMBER(20) NOT NULL,
    estudante_id     NUMBER(19) NOT NULL,
    idioma           VARCHAR2(255 CHAR) NOT NULL,
    nivel            VARCHAR2(255 CHAR) NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

--##########################################################################################
-- rep_informacoes_adicionais
--##########################################################################################
CREATE TABLE rep_informacoes_adicionais (
    id               NUMBER(20) NOT NULL,
    fumante          NUMBER(1),
    cnh              NUMBER(1),
    reservista       NUMBER(1) DEFAULT 0 NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

--##########################################################################################
-- rep_laudos_medicos
--##########################################################################################
CREATE TABLE rep_laudos_medicos (
    id                NUMBER(20) NOT NULL,
    estudante_id      NUMBER(20) NOT NULL,
    id_cid_agrupado   NUMBER(19) NOT NULL,
    deletado          NUMBER(1) NOT NULL,
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

--##########################################################################################
-- rep_laudos_medicos_documentos
--##########################################################################################
CREATE TABLE rep_laudos_medicos_documentos (
    laudo_medico_id   NUMBER(19) NOT NULL,
    documento_id      NUMBER(19) NOT NULL,
    status            VARCHAR2(64 BYTE),
    data_vencimento   TIMESTAMP,
    deletado          NUMBER(1) NOT NULL,
    data_criacao      TIMESTAMP NOT NULL,
    data_alteracao    TIMESTAMP NOT NULL,
    criado_por        VARCHAR2(255),
    modificado_por    VARCHAR2(255)
);

--##########################################################################################
-- rep_recursos_acessibilidade
--##########################################################################################
CREATE TABLE rep_recursos_acessibilidade (
    id               NUMBER(20) NOT NULL,
    estudante_id     NUMBER(20) NOT NULL,
    aparelho_id      NUMBER(20) NOT NULL,
    deletado         NUMBER(1) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);
--##########################################################################################
-- reprovacoes_estudante_etapa
--##########################################################################################
ALTER TABLE reprovacoes_etapa RENAME TO reprovacoes_estudante_etapa;

--##########################################################################################
-- resultados_processo_seletivo
--##########################################################################################
CREATE TABLE resultados_processo_seletivo (
    id                        NUMBER(20) NOT NULL,
    id_estudante_agenda       NUMBER(20) NOT NULL,
    id_reprovacao_etapa       NUMBER(20) NOT NULL,
    nota                      NUMBER(3, 2),
    classificacao             NUMBER(5),
    ordem                     NUMBER(5),
    situacao                  NUMBER,
    ausencia_justificada      NUMBER,
    comentarios               CLOB,
    deletado                  NUMBER,
    data_criacao              TIMESTAMP,
    data_alteracao            TIMESTAMP,
    criado_por                VARCHAR2(255),
    modificado_por            VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN resultados_processo_seletivo.situacao IS
    'Enum:

0 - Reprovado

1 - Aprovado

2 - Ausente';

COMMENT ON COLUMN resultados_processo_seletivo.ausencia_justificada IS
    'Flag 0 ou 1';

ALTER TABLE resultados_processo_seletivo ADD CONSTRAINT krs_indice_01540 PRIMARY KEY ( id );
--##########################################################################################
-- triagem_candidatos_analitico
--##########################################################################################
CREATE TABLE triagem_candidatos_analitico (
    id                       NUMBER(20) NOT NULL,
    id_empresa               NUMBER(20) NOT NULL,
    id_estudante             NUMBER(20) NOT NULL,
    codigo_vaga              NUMBER(20),
    tipo_vaga                NUMBER(1),
    mora                     NUMBER,
    estuda                   NUMBER,
    semestre_vaga            NUMBER,
    data_conclusao           NUMBER,
    horario                  NUMBER,
    sexo                     NUMBER,
    faixa_etaria             NUMBER,
    estado_civil             NUMBER,
    idiomas                  NUMBER,
    conhecimentos            NUMBER,
    reservista               NUMBER,
    fumante                  NUMBER,
    cnh                      NUMBER,
    escola                   NUMBER,
    tipo_deficiencia         NUMBER,
    recurso                  NUMBER,
    validade_laudo           NUMBER,
    oferece_acessibilidade   NUMBER,
    valido_cota              NUMBER,
    capacitacao_mora         NUMBER,
    situacao                 NUMBER,
    quem_triou               NUMBER(1),
    deletado                 NUMBER,
    data_criacao             TIMESTAMP,
    data_alteracao           TIMESTAMP,
    criado_por               VARCHAR2(255),
    modificado_por           VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN triagem_candidatos_analitico.tipo_vaga IS
    'Enum:

0 - Estagio

1 - Aprendiz';

COMMENT ON COLUMN triagem_candidatos_analitico.mora IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.estuda IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.semestre_vaga IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.data_conclusao IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.horario IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.sexo IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.faixa_etaria IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.estado_civil IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.idiomas IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.conhecimentos IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.reservista IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.fumante IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.cnh IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.escola IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.tipo_deficiencia IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.recurso IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.validade_laudo IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.oferece_acessibilidade IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.valido_cota IS
    'Flag:

0 ou 1';

COMMENT ON COLUMN triagem_candidatos_analitico.capacitacao_mora IS
    'Flag:

0 ou 1

ATENÇÃO: esse flag se aplica apenas a vaga Aprendiz';

COMMENT ON COLUMN triagem_candidatos_analitico.situacao IS
    'Flag:

0 - Triado sem sucesso

1 - Triado com sucesso';

COMMENT ON COLUMN triagem_candidatos_analitico.quem_triou IS
    'Enum:

0 - SISTEMA

1 - ESTUDANTE

2 - EMPRESA';

ALTER TABLE triagem_candidatos_analitico ADD CONSTRAINT krs_indice_01524 PRIMARY KEY ( id );

--##########################################################################################
-- vinculos_convocacao
--##########################################################################################
CREATE TABLE vinculos_convocacao (
    id                          NUMBER(20) NOT NULL,
    id_vinculo                  NUMBER(20) NOT NULL,
    id_recusa                   NUMBER(20) NOT NULL,
    data_liberacao_convocacao   TIMESTAMP,
    login_usuario               VARCHAR2(50)
);

ALTER TABLE vinculos_convocacao ADD CONSTRAINT krs_indice_01563 PRIMARY KEY ( id );

--##########################################################################################
-- vinculos_encaminhamento
--##########################################################################################
CREATE TABLE vinculos_encaminhamento (
    id                              NUMBER(20) NOT NULL,
    id_vinculo                      NUMBER(20) NOT NULL,
    id_recusa                       NUMBER(20) NOT NULL,
    data_liberacao_encaminhamento   TIMESTAMP,
    login_usuario                   VARCHAR2(50)
);

ALTER TABLE vinculos_encaminhamento ADD CONSTRAINT krs_indice_01564 PRIMARY KEY ( id );

--##########################################################################################
-- vinculos_vaga
--##########################################################################################
CREATE TABLE vinculos_vaga (
    id                             NUMBER(20) NOT NULL,
    codigo_vaga                    NUMBER(20),
    id_estudante                   NUMBER(20) NOT NULL,
    tipo_selecao                   NUMBER(1),
    resp_selecao_convocacao        NUMBER(1),
    resp_selecao_encaminhamento    NUMBER(1),
    resp_selecao_contrato          NUMBER(1),
    situacao_vinculo               NUMBER(1),
    data_convocacao                TIMESTAMP,
    data_encaminhamento            TIMESTAMP,
    data_solicitacao_contratacao   TIMESTAMP,
    data_contratacao               TIMESTAMP,
    numero_contrato                NUMBER(20),
    deletado                       NUMBER,
    data_criacao                   TIMESTAMP,
    data_alteracao                 TIMESTAMP,
    criado_por                     VARCHAR2(255),
    modificado_por                 VARCHAR2(255)
)
LOGGING;

COMMENT ON COLUMN vinculos_vaga.codigo_vaga IS
    '- Esse campo faz referencia ao campo codigo_vaga nas tabelas de 

Vagas_estagio e Vagas_Aprendiz
';

COMMENT ON COLUMN vinculos_vaga.tipo_selecao IS
    'Enum:

0-Automatica
1-Manual';

COMMENT ON COLUMN vinculos_vaga.resp_selecao_convocacao IS
    'Enum:

0 - CIEE-NOTURNA
1 - CIEE-INTERNO
2 - EMPRESA
';

COMMENT ON COLUMN vinculos_vaga.resp_selecao_encaminhamento IS
    'Enum:

0 - CIEE-NOTURNA
1 - CIEE-INTERNO
2 - EMPRESA
';

COMMENT ON COLUMN vinculos_vaga.resp_selecao_contrato IS
    'Enum:

0 - CIEE-NOTURNA
1 - CIEE-INTERNO
2 - EMPRESA
';

COMMENT ON COLUMN vinculos_vaga.situacao_vinculo IS
    'Enum:

0-Convocado
1-Encaminhado';

ALTER TABLE vinculos_vaga ADD CONSTRAINT krs_indice_01512 PRIMARY KEY ( id );

--####################################################################################################################################################################################
-- constraints
--####################################################################################################################################################################################

--##########################################################################################
-- aparelhos_pcd : constraints
--##########################################################################################	
ALTER TABLE aparelhos_pcd
    ADD CONSTRAINT krs_indice_00923 FOREIGN KEY ( id_pcd )
        REFERENCES pcd ( id )
    NOT DEFERRABLE;
ALTER TABLE aparelhos_pcd
    ADD CONSTRAINT krs_indice_01337 FOREIGN KEY ( id_aparelho )
        REFERENCES rep_aparelhos ( id )
    NOT DEFERRABLE;

--##########################################################################################
-- aparelhos_pcd_aprendiz : constraints
--##########################################################################################	
ALTER TABLE aparelhos_pcd_aprendiz
    ADD CONSTRAINT krs_indice_01343 FOREIGN KEY ( id_aparelho )
        REFERENCES rep_aparelhos ( id )
    NOT DEFERRABLE;

--##########################################################################################
-- estudantes_agenda: constraints
--##########################################################################################	
ALTER TABLE estudantes_agenda
    ADD CONSTRAINT krs_indice_01527 FOREIGN KEY ( id_vinculo_vaga )
        REFERENCES vinculos_vaga ( id )
    NOT DEFERRABLE;
ALTER TABLE estudantes_agenda
    ADD CONSTRAINT krs_indice_01560 FOREIGN KEY ( id_agenda_processo_seletivo )
        REFERENCES agenda_processo_seletivo ( id )
    NOT DEFERRABLE;
	
--##########################################################################################
-- estudantes_empresa: constraints
--##########################################################################################	
ALTER TABLE estudantes_empresa
    ADD CONSTRAINT krs_indice_01514 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE estudantes_empresa
    ADD CONSTRAINT krs_indice_01515 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;
	
--##########################################################################################
-- estudantes_recusas: constraints
--##########################################################################################	
ALTER TABLE estudantes_recusas
    ADD CONSTRAINT krs_indice_01522 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE estudantes_recusas
    ADD CONSTRAINT estudantes_recusas_recusa_fk FOREIGN KEY ( id_recusa )
        REFERENCES recusa ( id )
    NOT DEFERRABLE;
ALTER TABLE estudantes_recusas
    ADD CONSTRAINT krs_indice_01523 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- etapas_processo_seletivo : constraints
--##########################################################################################	
ALTER TABLE etapas_processo_seletivo
    ADD CONSTRAINT krs_indice_01542 FOREIGN KEY ( id_motivo_final_processo )
        REFERENCES motivos_final_processo ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- ocorrencias_aprendiz: constraints
--##########################################################################################	
ALTER TABLE ocorrencias_aprendiz
    ADD CONSTRAINT krs_indice_01506 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id )
    NOT DEFERRABLE;
ALTER TABLE ocorrencias_aprendiz
    ADD CONSTRAINT krs_indice_01505 FOREIGN KEY ( id_ocorrencia )
        REFERENCES ocorrencias ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- ocorrencias_estagio: constraints
--##########################################################################################	
ALTER TABLE ocorrencias_estagio
    ADD CONSTRAINT krs_indice_01221v2 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id )
    NOT DEFERRABLE;
ALTER TABLE ocorrencias_estagio
    ADD CONSTRAINT krs_indice_01503 FOREIGN KEY ( id_ocorrencia )
        REFERENCES ocorrencias ( id )
    NOT DEFERRABLE;	
--##########################################################################################
-- resultados_processo_seletivo: constraints
--##########################################################################################	
ALTER TABLE resultados_processo_seletivo
    ADD CONSTRAINT krs_indice_01582 FOREIGN KEY ( id_reprovacao_etapa )
        REFERENCES reprovacoes_estudante_etapa ( id )
    NOT DEFERRABLE;
ALTER TABLE resultados_processo_seletivo
    ADD CONSTRAINT krs_indice_01581 FOREIGN KEY ( id_estudante_agenda )
        REFERENCES estudantes_agenda ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- triagem_candidatos_analitico: constraints
--##########################################################################################	
ALTER TABLE triagem_candidatos_analitico
    ADD CONSTRAINT krs_indice_01526 FOREIGN KEY ( id_empresa )
        REFERENCES rep_empresas ( id )
    NOT DEFERRABLE;
ALTER TABLE triagem_candidatos_analitico
    ADD CONSTRAINT krs_indice_01525 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- vinculos_convocacao: constraints
--##########################################################################################	
ALTER TABLE vinculos_convocacao
    ADD CONSTRAINT krs_indice_01565 FOREIGN KEY ( id_vinculo )
        REFERENCES vinculos_vaga ( id )
    NOT DEFERRABLE;
ALTER TABLE vinculos_convocacao
    ADD CONSTRAINT krs_indice_01584 FOREIGN KEY ( id_recusa )
        REFERENCES recusa ( id )
    NOT DEFERRABLE;	
--##########################################################################################
-- vinculos_encaminhamento: constraints
--##########################################################################################	
ALTER TABLE vinculos_encaminhamento
    ADD CONSTRAINT krs_indice_01566 FOREIGN KEY ( id_vinculo )
        REFERENCES vinculos_vaga ( id )
    NOT DEFERRABLE;
ALTER TABLE vinculos_encaminhamento
    ADD CONSTRAINT krs_indice_01585 FOREIGN KEY ( id_recusa )
        REFERENCES recusa ( id )
    NOT DEFERRABLE;
--##########################################################################################
-- vinculos_vaga: constraints
--##########################################################################################	
ALTER TABLE vinculos_vaga
    ADD CONSTRAINT krs_indice_01516 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id )
    NOT DEFERRABLE;