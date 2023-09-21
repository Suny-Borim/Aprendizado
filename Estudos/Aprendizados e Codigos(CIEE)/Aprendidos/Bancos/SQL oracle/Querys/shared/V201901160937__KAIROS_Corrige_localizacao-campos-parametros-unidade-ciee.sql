--***********************************************************************
--Remove campos inseridos na tabela errada*
--***********************************************************************


ALTER TABLE rep_instituicoes_ensinos
    DROP (
       limite_min_encaminhados_vaga,
       limite_max_encaminhados_vaga,
       padrao_encaminhados_vaga);


--***********************************************************************
--Parametros de unidade CIEE que vão ser utilizados na validação da vaga*
--***********************************************************************

ALTER TABLE rep_parametros_unidades_ciee
    ADD (
       limite_min_encaminhados_vaga NUMBER(3),
       limite_max_encaminhados_vaga NUMBER(3),
       padrao_encaminhados_vaga NUMBER(3));

