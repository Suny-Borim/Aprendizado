create table REP_GERENCIAS
(
    ID                      NUMBER(19)         not null,
    CRIADO_POR              VARCHAR2(255 char),
    DATA_CRIACAO            TIMESTAMP(6)       not null,
    DELETADO                NUMBER(1)          not null,
    MODIFICADO_POR          VARCHAR2(255 char),
    DATA_ALTERACAO          TIMESTAMP(6)       not null,
    ATIVO                   NUMBER(1)          not null,
    DESCRICAO               VARCHAR2(100 char) not null,
    SIGLA                   VARCHAR2(2 char)   not null,
    DESCRICAO_REDUZIDA      VARCHAR2(50 char)  not null,
    ID_RESPONSAVEL          NUMBER(19),
    CODIGO_SUPERINTENDENCIA NUMBER(19)         not null,
    ID_DOMINIO              NUMBER(19)
);

alter table REP_GERENCIAS
    add constraint krs_indice_04089 primary key (ID);

alter table REP_GERENCIAS
    add constraint krs_indice_04090 foreign key (ID_RESPONSAVEL) references REP_PESSOAS (ID);

alter table REP_UNIDADES_CIEE
    add constraint krs_indice_04091 foreign key (ID_GERENCIA) references REP_GERENCIAS (ID);