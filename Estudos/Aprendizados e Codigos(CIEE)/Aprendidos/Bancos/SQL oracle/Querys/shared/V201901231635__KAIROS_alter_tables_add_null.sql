--*************************************************
--Beneficios para vagas nem sempre contem um valor*
--*************************************************

ALTER TABLE beneficios_adic_aprendiz
    MODIFY valor NUMBER(10, 2) NULL;

ALTER TABLE beneficios_adicionais
    MODIFY valor NUMBER(10, 2) NULL;
