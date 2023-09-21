alter table TRIAGENS_VAGAS
    drop column CONHECIMENTOS
;

alter table TRIAGENS_ESTUDANTES
    drop column CONHECIMENTOS
;

alter table TRIAGENS_VAGAS
    drop column IDIOMAS
;

alter table TRIAGENS_ESTUDANTES
    drop column IDIOMAS
;

alter table TRIAGENS_ESTUDANTES
    drop column PCDS;

alter table TRIAGENS_VAGAS
    drop column PCDS;

drop type CONHECIMENTOS_TYP;
drop type "CONHECIMENTO_TYP";
drop type IDIOMAS_TYP;
drop type "IDIOMA_TYP";

-- campo endereco --------------------------------
create TYPE ENDERECO_TYP AS OBJECT
(
    "UF"          VARCHAR2(2),
    "CIDADE"      VARCHAR2(100),
    "ENDERECO"    VARCHAR2(150),
    "NUMERO"      VARCHAR2(10 char),
    "COMPLEMENTO" VARCHAR2(200),
    "CEP"         VARCHAR2(8),
    "PRINCIPAL"   NUMBER(1, 0)
);
/

create type ENDERECOS_TYP as table of ENDERECO_TYP;
/

-- campo email ------------------------------------
create type EMAILS_TYP as table of VARCHAR(100);
/

-- campo telefone ---------------------------------
create type TELEFONES_TYP as table of VARCHAR(255);
/

-- campo experiencias profissionais ---------------
create type EXPERIENCIAS_PROFISSIONAIS_TYP as table of VARCHAR2(200 char);
/

-- campo conhecimentos diversos -------------------
create type CONHECIMENTOS_DIVERSOS_TYP as table of VARCHAR2(200);
/

-- campo conhecimentos -------------------------------

create TYPE CONHECIMENTO_TYP AS OBJECT
(
    "DESCRICAO"          VARCHAR2(50 BYTE),
    "NIVEL"              VARCHAR2(20 BYTE),
    "POSSUI_CERTIFICADO" NUMBER(1, 0)
);
/

create type CONHECIMENTOS_TYP as table of CONHECIMENTO_TYP;
/

-- campo idioma --------------------------------------------
create TYPE IDIOMA_TYP AS OBJECT
(
    "ID"                 NUMBER(20, 0),
    "NOME"               VARCHAR2(20 BYTE),
    "NIVEL"              NUMBER(2, 0),
    "POSSUI_CERTIFICADO" NUMBER(1, 0)
);
/

create type IDIOMAS_TYP as table of IDIOMA_TYP;
/

-- campo area profissional -------------------------

create TYPE AREA_PROFISSIONAL_TYP AS OBJECT
(
    "CODIGO_AREA_PROFISSIONAL"     NUMBER(19),
    "DESCRICAO_AREA_PROFISSIONAL"  VARCHAR2(200 char),
    "DESC_REDUZ_AREA_PROFISSIONAL" VARCHAR2(40 char),
    "CODIGO_ICONE"                 VARCHAR2(20 char)
);
/

create type AREAS_PROFISSIONAL_TYP as table of AREA_PROFISSIONAL_TYP;
/

-- campo pcd estudante ----------------------------------

create TYPE PCD_ESTUDANTE_TYP AS OBJECT
(
    "ID_CID_AGRUPADO"       NUMBER(20, 0),
    "VALIDADE_MINIMA_LAUDO" TIMESTAMP(6),
    "STATUS"                NUMBER(1),
    "PRINCIPAL"              NUMBER(1)
);
/

create type PCDS_ESTUDANTE_TYP as table of PCD_ESTUDANTE_TYP;
/

-- campo pcd vaga ----------------------------------

create TYPE PCD_VAGA_TYP AS OBJECT
(
    "ID_CID_AGRUPADO"       NUMBER(20, 0),
    "VALIDADE_MINIMA_LAUDO" TIMESTAMP(6)
);
/

create type PCDS_VAGA_TYP as table of PCD_VAGA_TYP
;
/