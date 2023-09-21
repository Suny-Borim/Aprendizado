--***************************************************************************
--Corrige inconsistencias para tabelas de relacionamentos com vagas aprendiz*
--***************************************************************************

--*************************************
--Altera tipos das colunas das tabelas*
--*************************************

ALTER TABLE areas_atuacao_aprendiz
    MODIFY nivel_area_atuacao NUMBER(1);

ALTER TABLE turmas
    MODIFY (
        faixa_etaria_inicial NUMBER(2),
        faixa_etaria_final NUMBER(2)
    );

