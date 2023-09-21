--********************************************************************************
--Tabela que será utilizada para guardar os estados civis de uma abertura de vaga*
--********************************************************************************

CREATE TABLE estado_civil_vaga_estagio (
   id                NUMBER(20) NOT NULL,
   id_vaga_estagio   NUMBER(20) NOT NULL,
   estado_civil      NUMBER(1)
);

ALTER TABLE estado_civil_vaga_estagio ADD CONSTRAINT krs_indice_01227 PRIMARY KEY ( id );

ALTER TABLE estado_civil_vaga_estagio
   ADD CONSTRAINT krs_indice_01228 FOREIGN KEY ( id_vaga_estagio )
       REFERENCES vagas_estagio ( id );

COMMENT ON COLUMN estado_civil_vaga_estagio.estado_civil IS
    'Estado Civil, campo normalizado preenchimento:

1- SOLTEIRO;
2- CASADO;
3- SEPARADO;
4- DIVORCIADO;
5- VIUVO;

OK';

--***********************************************************
--Cria sequence para ser utilizada na tabela de estado civil*
--***********************************************************
CREATE SEQUENCE seq_estado_civil_vaga_estagio MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER NOCYCLE;


--**************************************************
--Remove coluna de estado civil da abertura de vaga*
--**************************************************

ALTER TABLE vagas_estagio
    DROP COLUMN estado_civil;
