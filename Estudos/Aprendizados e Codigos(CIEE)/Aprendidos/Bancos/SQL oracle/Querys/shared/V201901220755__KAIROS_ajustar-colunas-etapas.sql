alter table TIPO_LIGACAO_TEF drop column DATA_LIGACAO;
alter table TIPO_LIGACAO_TEF drop column HORA_LIGACAO;
alter table TIPO_PROVA drop column INSTRUCOES_PROVA;
alter table TIPO_PROVA add VALIDADE_PROVA TIMESTAMP;