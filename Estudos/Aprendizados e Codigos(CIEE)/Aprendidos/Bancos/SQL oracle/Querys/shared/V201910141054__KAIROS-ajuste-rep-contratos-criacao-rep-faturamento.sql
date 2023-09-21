ALTER TABLE REP_CONTRATOS ADD ID_TIPO_SIS_PGA_ESTAGIARIO NUMBER(20);

CREATE TABLE rep_configuracoes_faturamentos_company (
    id                      NUMBER(20) NOT NULL,
    id_contrato             NUMBER NOT NULL,
    data_criacao            TIMESTAMP NOT NULL,
    data_alteracao          TIMESTAMP NOT NULL,
    criado_por              VARCHAR2(255 CHAR),
    modificado_por          VARCHAR2(255 CHAR),
    deletado                NUMBER(1) DEFAULT 0,
    descricao               VARCHAR2(150) NOT NULL,
    reajuste_ci_anual       NUMBER(1) DEFAULT 1,
    repasse_empresa         NUMBER(1) DEFAULT 0,
    tipo_emissao            NUMBER(1),
    dia_emissao             NUMBER(2),
    validar_condicao        NUMBER(1) NOT NULL,
    permuta_faturamento     NUMBER(1) DEFAULT 0,
    banco_faixa             NUMBER(1) DEFAULT 1,
    maximo_cobrado          NUMBER(10, 2),
    id_banco                NUMBER(20),
    nome                    VARCHAR2(150),
    cpf                     VARCHAR2(11),
    area_setor              VARCHAR2(150),
    cargo                   VARCHAR2(150),
    email                   VARCHAR2(100),
    telefone                VARCHAR2(60),
    valor_repasse_empresa   NUMBER(3),
    id_banco_excedido       NUMBER(20),
    id_indice               NUMBER,
    motivo_recusa           VARCHAR2(300)
);

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.reajuste_ci_anual IS
    'ENUM:
0-Não
1-Sim - default ';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.repasse_empresa IS
    'ENUM:
0-Não- default
1-Sim  ';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.tipo_emissao IS
    'ENUM:
0-Primeira Emissao e Segunda Emissao 
1-Segunga Emissao somente
2-Diferenciada';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.dia_emissao IS
    'Diferenciada: (dd) Informe o dia em que deverá ser gerada a emissão do faturamento do contrato selecionado.';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.validar_condicao IS
    'ENUM:
0-inativo
1-ativo
2-em progresso
3-pendente
4-reprovado';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.permuta_faturamento IS
    'ENUM:
0-Não- default
1-Sim  ';

COMMENT ON COLUMN rep_configuracoes_faturamentos_company.banco_faixa IS
    '0-Nao
1-Sim';

ALTER TABLE rep_configuracoes_faturamentos_company ADD CONSTRAINT krs_indice_04770 PRIMARY KEY ( id  );