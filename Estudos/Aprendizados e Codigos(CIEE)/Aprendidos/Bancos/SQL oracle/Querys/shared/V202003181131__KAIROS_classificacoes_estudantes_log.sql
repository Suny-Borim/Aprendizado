CREATE TABLE classificacoes_estudantes_log (
    id                      			NUMBER(20) NOT NULL,
	data_criacao     					TIMESTAMP NOT NULL,
    data_alteracao   					TIMESTAMP NOT NULL,
    criado_por       					VARCHAR2(255 CHAR),
    modificado_por   					VARCHAR2(255 CHAR),
    deletado         					NUMBER(1) DEFAULT 0,
    id_estudante            			NUMBER(20) NULL,
	id_classificacoes_parametros_itens	NUMBER(20) NOT NULL,
    inicio_processo         			TIMESTAMP NOT NULL,
    fim_processo            			TIMESTAMP NOT NULL,
    mensagem                   			VARCHAR2(255 CHAR)
);

ALTER TABLE classificacoes_estudantes_log ADD CONSTRAINT krs_indice_07987 PRIMARY KEY ( id );

ALTER TABLE classificacoes_estudantes_log
    ADD CONSTRAINT krs_indice_07988 FOREIGN KEY ( id_estudante )
        REFERENCES rep_estudantes ( id );
    
ALTER TABLE classificacoes_estudantes_log
    ADD CONSTRAINT krs_indice_07989 FOREIGN KEY ( id_classificacoes_parametros_itens )
        REFERENCES classificacoes_parametros_itens ( id );

CREATE SEQUENCE SEQ_classificacoes_estudantes_log MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;