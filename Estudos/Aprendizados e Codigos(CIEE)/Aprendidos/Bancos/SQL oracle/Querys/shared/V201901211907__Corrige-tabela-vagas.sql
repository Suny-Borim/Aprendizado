--****************************************************
--Corrige inconsistencias na tabela de vagas_aprendiz*
--****************************************************


--************
--Ajusta tipo*
--************

ALTER TABLE vagas_aprendiz
    MODIFY (
        ddd VARCHAR2(2) NOT NULL,
        telefone VARCHAR2(60) NOT NULL,
        tipo_divulgacao NUMBER(1) NOT NULL,
        descricao_empresa VARCHAR2(150) NOT NULL,
        tipo_salario NUMBER(1) NOT NULL,
        tipo_auxilio_transporte NUMBER(1) NOT NULL,
        contrapartida_transporte VARCHAR2(100));


ALTER TABLE vagas_aprendiz
    ADD (
        tipo_salario_valor NUMBER(1) NOT NULL,
        tipo_auxilio_transporte_valor NUMBER(1) NOT NULL);


--********************************
--Deleta campos erradas da tabela*
--********************************

ALTER TABLE vagas_aprendiz
    DROP COLUMN id_turmas;


--Renomeia colunas para manter mesmo padrão de nomes

ALTER TABLE vagas_aprendiz
  RENAME COLUMN nome TO nome_contato;

ALTER TABLE vagas_aprendiz
  RENAME COLUMN departamento TO depto_contato;

ALTER TABLE vagas_aprendiz
  RENAME COLUMN email TO email_contato;

ALTER TABLE vagas_aprendiz
  RENAME COLUMN ddd TO ddd_fone_contato;

ALTER TABLE vagas_aprendiz
  RENAME COLUMN telefone TO fone_contato;

ALTER TABLE vagas_aprendiz
  RENAME COLUMN contrapartida_transporte TO contrapartida_aux_transporte;


--*******************
--Ajusta comentários*
--*******************

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_salario IS
    'Enum:

0 - Mensal

1 - Por Hora';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_salario_valor IS
    'Enum:

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN {{user}}.vagas_aprendiz.tipo_auxilio_transporte_valor IS
    'Enum:

0 - Fixo

1 - A combinar';
