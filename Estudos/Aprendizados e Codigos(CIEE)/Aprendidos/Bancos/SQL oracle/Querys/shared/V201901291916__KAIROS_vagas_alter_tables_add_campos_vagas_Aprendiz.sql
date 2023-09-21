--*************************************************
--Beneficios para vagas nem sempre contem um valor*
--*************************************************

ALTER TABLE {{user}}.VAGAS_APRENDIZ ADD RESERVISTA NUMBER(1);

ALTER TABLE {{user}}.VAGAS_APRENDIZ ADD SEXO VARCHAR2(1);

ALTER TABLE {{user}}.VAGAS_APRENDIZ DROP COLUMN ddd_fone_contato;

drop table {{user}}.PALAVRAS_CHAVE_APRENDIZ;

CREATE TABLE {{user}}.PALAVRAS_CHAVE_APRENDIZ
(
 VAGAS_APRENDIZ_ID number,
 PALAVRA_CHAVE VARCHAR2(30)
);

ALTER TABLE {{user}}.VAGAS_APRENDIZ  ADD HORARIO_INICIO date;
ALTER TABLE {{user}}.VAGAS_APRENDIZ  ADD HORARIO_TERMINO date;
alter table {{user}}.VAGAS_APRENDIZ add VALOR_SALARIO_DE number(10,2);
alter table {{user}}.VAGAS_APRENDIZ add VALOR_SALARIO_ATE number(10,2);
alter table {{user}}.VAGAS_APRENDIZ add VALOR_TRANSPORTE_FIXO number(7,2);

DROP TABLE {{user}}.SITUACOES_APRENDIZ CASCADE CONSTRAINTS;

ALTER TABLE {{user}}.VAGAS_APRENDIZ
   ADD CONSTRAINT krs_indice_01600 FOREIGN KEY ( ID_SITUACAO_VAGA )
       REFERENCES SITUACOES ( ID );