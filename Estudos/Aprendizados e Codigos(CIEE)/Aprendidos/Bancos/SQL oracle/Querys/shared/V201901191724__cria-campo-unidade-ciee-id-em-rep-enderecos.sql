--*************************************************
--Beneficios para vagas nem sempre contem um valor*
--*************************************************

alter table {{user}}.REP_LOCAIS_ENDERECOS
    add (ID_UNIDADE_CIEE        NUMBER);
