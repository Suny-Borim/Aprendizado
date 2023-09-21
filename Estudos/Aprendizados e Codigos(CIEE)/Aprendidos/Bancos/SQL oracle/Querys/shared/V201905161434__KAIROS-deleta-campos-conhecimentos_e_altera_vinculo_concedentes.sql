ALTER TABLE conhecimentos DROP (deletado,data_criacao,data_alteracao,criado_por,modificado_por);

DROP TABLE VINCULO_LOCAIS_CONTR_CONCENDENTES cascade constraints;

create table VINCULO_LOCAIS_CONTR_CONCEDENTES
(
    ID_CONCEDENTE    NUMBER(20) not null
        constraint KRS_INDICE_03394
            references CONCEDENTES ,
    ID_LOCAL_CONTRATO NUMBER(20) not null
        constraint KRS_INDICE_03395
            references REP_LOCAIS_CONTRATO
)