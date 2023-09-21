ALTER TABLE TRIAGENS_ESTUDANTES ADD APTO_TRIAGEM NUMBER(1);
CREATE INDEX IDX_TRIAGENS_ESTUDANTES_CARTEIRA on {{user}}.TRIAGENS_ESTUDANTES("STATUS_ESCOLARIDADE","APTO_TRIAGEM","TIPO_PROGRAMA", "PONTUACAO_OBTIDA");
CREATE INDEX idx_triagem_vagas_enderecogeohashs_id ON {{user}}.n_enderecogeohashs_vagas("NESTED_TABLE_ID",column_value);
--CREATE INDEX idx_triagem_vagas_cursos ON {{user}}.n_cursos_vagas("NESTED_TABLE_ID",column_value);
