ALTER TABLE perguntas_formularios ADD TIPO_PERGUNTA NUMBER(1) NOT NULL;

COMMENT ON COLUMN perguntas_formularios.TIPO_PERGUNTA IS
    'ENUM:

0-Multipla escolha
1-Dissertativa';