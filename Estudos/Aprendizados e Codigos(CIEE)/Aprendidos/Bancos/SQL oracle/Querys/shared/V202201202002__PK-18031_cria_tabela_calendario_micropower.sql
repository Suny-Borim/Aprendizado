create table  CALENDARIOS_APRENDIZ_MICROPOWER(
id                NUMBER(20) NOT NULL,
id_local_contrato NUMBER(20) NOT NULL,
cpf_estudante     VARCHAR2(11 BYTE) NOT NULL,
data_inicio_contrato  TIMESTAMP NOT NULL, 
data_termino_contrato  TIMESTAMP NOT NULL,
pdf_micropower clob not null,
id_contr_empr_est NUMBER(20),
data_criacao      TIMESTAMP NOT NULL,
data_alteracao    TIMESTAMP,
criado_por        VARCHAR2(255 BYTE),
modificado_por    VARCHAR2(255 BYTE),
deletado          NUMBER(1)
);

DECLARE
  SEQUENCE_EXISTENTE number := 0;  
BEGIN
  Select count(*) into SEQUENCE_EXISTENTE
    from ALL_SEQUENCES
    where upper(sequence_name) = 'SEQ_CALENDARIOS_APRENDIZ_MICROPOWER';
  if (SEQUENCE_EXISTENTE = 0) then
      execute immediate 'CREATE SEQUENCE SEQ_CALENDARIOS_APRENDIZ_MICROPOWER MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';
  end if;
end;

