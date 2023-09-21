alter table TRIAGENS_ESTUDANTES ADD (
    classificacao_obtida varchar2(15 CHAR) default 'C' ,
    pontuacao_obtida number(3) default 0
);

alter table TRIAGENS_VAGAS ADD (
    classificacao_empresa varchar2(15 CHAR) default 'C',
    pontuacao_empresa number(3) default 0
);
