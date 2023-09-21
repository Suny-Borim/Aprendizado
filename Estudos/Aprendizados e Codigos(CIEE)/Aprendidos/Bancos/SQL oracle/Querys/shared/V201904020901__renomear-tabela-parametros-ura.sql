-- Renomear tabela parametros_ura para parametros_comunicacao
ALTER TABLE parametros_ura RENAME TO parametros_comunicacao;

-- Adicionar coluna link divulgacao
ALTER TABLE parametros_comunicacao add link_divulgacao_vaga VARCHAR2(150 CHAR)
    DEFAULT 'https://cieebr.service-now.com/sp/?id=sc_cat_item&sys_id=e2bfd94fdb87eb4446034410ba961912' NOT NULL;