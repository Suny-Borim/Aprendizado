--
-- Ajusta base de dados conforme modelo do AD
--

-- Gerado por Oracle SQL Developer Data Modeler 18.3.0.268.1156
--   em:        2019-02-05 14:25:47 BRST
--   site:      Oracle Database 12cR2
--   tipo:      Oracle Database 12cR2




COMMENT ON TABLE rep_agrupamento_cid_pcd IS
    'REPLICA DA TABELA: AGRUPAMENTO_CID_PCD, DO SCHEMA: CORE';
COMMENT ON TABLE rep_aparelhos IS
    'REPLICA DA TABELA: APARELHOS, DO SCHEMA: CORE';
COMMENT ON TABLE rep_areas_atuacao_atividades IS
    'REPLICA DA TABELA: AREAS_ATUACAO_ATIVIDADES, DO SCHEMA: CORE';
COMMENT ON TABLE rep_areas_atuacao_cursos IS
    'REPLICA DA TABELA: AREAS_ATUACAO_CURSOS, DO SCHEMA: CORE';
COMMENT ON TABLE rep_areas_profissionais IS
    'REPLICA DA TABELA: AREAS_PROFISSIONAIS, DO SCHEMA: CORE';
COMMENT ON TABLE rep_areas_profissional_atuacao IS
    'REPLICA DA TABELA: AREAS_PROFISSIONAL_ATUACAO, DO SCHEMA: CORE';
COMMENT ON TABLE rep_atividades IS
    'REPLICA DA TABELA: ATIVIDADES, DO SCHEMA: CORE';
COMMENT ON TABLE rep_conhecimentos_informatica IS
    'REPLICA DA TABELA: CONHECIMENTOS_INFORMATICA, DO SCHEMA: STUDENT
';
COMMENT ON TABLE rep_contratos IS
    'REPLICA DA TABELA: CONTRATOS, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_cursos IS
    'REPLICA DA TABELA: CURSOS, DO SCHEMA: CORE';
COMMENT ON TABLE rep_empresas IS
    'REPLICA DA TABELA: EMPRESAS, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_enderecos IS
    'REPLICA DA TABELA: ENDERECOS, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_enderecos_estudantes IS
    'REPLICA DA TABELA: ENDERECOS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_escolaridades_estudantes IS
    'REPLICA DA TABELA: ESCOLARIDADES_ESTUDANTES, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_estudantes IS
    'REPLICA DA TABELA: ESTUDANTES, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_idiomas_niveis IS
    'REPLICA DA TABELA: IDIOMAS_NIVEIS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_ie_acordos_cooperacao IS
    'REPLICA DA TABELA: IE_ACORDOS_COOPERACAO, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_ie_pre_cadastro IS
    'REPLICA DA TABELA: IE_PRE_CADASTRO, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_informacoes_adicionais IS
    'REPLICA DA TABELA: INFORMACOES_ADICIONAIS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_informacoes_sociais IS
    'REPLICA DA TABELA: INFORMACOES_SOCIAIS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_instituicoes_ensinos IS
    'REPLICA DA TABELA: INSTITUICOES_ENSINOS, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_laudos_medicos IS
    'REPLICA DA TABELA: LAUDOS_MEDICOS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_laudos_medicos_documentos IS
    'REPLICA DA TABELA: LAUDOS_MEDICOS_DOCUMENTOS, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_locais_contrato IS
    'REPLICA DA TABELA: LOCAIS_CONTRATO, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_locais_enderecos IS
    'REPLICA DA TABELA: LOCAIS_ENDERECOS, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_municipios IS
    'REPLICA DA TABELA: MUNICIPIOS, DO SCHEMA: CORE';
COMMENT ON TABLE rep_parametros_empresa IS
    'REPLICA DA TABELA: PARAMETROS_EMPRESA, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_parametros_escolares IS
    'REPLICA DA TABELA: PARAMETROS_ESCOLARES, DO SCHEMA: CORE';
COMMENT ON TABLE rep_parametros_programa_apr IS
    'REPLICA DA TABELA: PARAMETROS_PROGRAMA_APRENDIZ, DO SCHEMA: CORE';
COMMENT ON TABLE rep_parametros_programa_est IS
    'REPLICA DA TABELA: PARAMETROS_PROGRAMA_ESTAGIO, DO SCHEMA: CORE';
COMMENT ON TABLE rep_parametros_unidades_ciee IS
    'REPLICA DA TABELA: PARAMETROS_UNIDADES_CIEE, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_pendencias IS
    'REPLICA DA TABELA: PENDENCIAS, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_recursos_acessibilidade IS
    'REPLICA DA TABELA: RECURSOS_ACESSIBILIDADE, DO SCHEMA: STUDENT';
COMMENT ON TABLE rep_representantes IS
    'REPLICA DA TABELA: REPRESENTANTES, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_representantes_contrato IS
    'REPLICA DA TABELA: REPRESENTANTES_CONTRATO, DO SCHEMA: COMPANY';
COMMENT ON TABLE rep_unidades_ciee IS
    'REPLICA DA TABELA: UNIDADES_CIEE, DO SCHEMA: UNIT';
COMMENT ON TABLE rep_usuarios IS
    'REPLICA DA TABELA USUARIOS DO SCHEMA AUTH';
COMMENT ON TABLE rep_verbos_acao IS
    'REPLICA DA TABELA: VERBOS_ACAO, DO SCHEMA: CORE';
CREATE TABLE replicas_vagas (
    id                   NUMBER(20) NOT NULL,
    schema_origem        VARCHAR2(40),
    nome_tabela_origem   VARCHAR2(40),
    nome_replica         VARCHAR2(40),
    data_criacao         DATE DEFAULT SYSDATE
);

alter table vinculos_encaminhamento drop constraint KRS_INDICE_01585 cascade;
alter table vinculos_convocacao drop constraint KRS_INDICE_01584 cascade;
ALTER TABLE vinculos_convocacao ADD CONSTRAINT KRS_INDICE_01584 FOREIGN KEY ( id_recusa ) REFERENCES recusa ( id );
ALTER TABLE vinculos_encaminhamento ADD CONSTRAINT KRS_INDICE_01585 FOREIGN KEY ( id_recusa ) REFERENCES recusa ( id );

ALTER TABLE replicas_vagas ADD CONSTRAINT krs_indice_01682 PRIMARY KEY ( id );
ALTER TABLE contratos_estudantes_empresa MODIFY (
    carga_horaria TIMESTAMP
);
COMMENT ON COLUMN etapas_processo_seletivo.status IS
    'Enum:

0-Finalizado
1-Classificada
2-Cancelada
3-Em Andamento
';
ALTER TABLE ocorrencias_aprendiz DROP CONSTRAINT krs_indice_01500 CASCADE;
ALTER TABLE ocorrencias_aprendiz ADD CONSTRAINT krs_indice_01500 PRIMARY KEY ( id_ocorrencia );
ALTER TABLE ocorrencias_estagio DROP CONSTRAINT krs_indice_01012 CASCADE;
ALTER TABLE ocorrencias_estagio ADD CONSTRAINT krs_indice_01012 PRIMARY KEY ( id_ocorrencia );
ALTER TABLE rep_representantes MODIFY (
    id NUMBER(20)
);
ALTER TABLE rep_representantes_contrato MODIFY (
    id_representante NUMBER(20)
);
ALTER TABLE triagem_candidatos_analitico ADD (
    parametro_escolar   NUMBER
);

COMMENT ON COLUMN triagem_candidatos_analitico.parametro_escolar IS
    'Flag:

0 ou 1';
ALTER TABLE vinculos_convocacao MODIFY (
    id_recusa NULL
);
ALTER TABLE vinculos_encaminhamento MODIFY (
    id_recusa NULL
);
ALTER TABLE etapas_processo_seletivo DROP CONSTRAINT krs_indice_01202;

alter table REP_IE_ACORDOS_COOPERACAO ADD ID_INSTITUICAO_ENSINO NUMBER(20);


