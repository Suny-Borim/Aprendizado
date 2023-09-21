--***********************************************************************
--Parametros de unidade CIEE que vão ser utilizados na validação da vaga*
--***********************************************************************


ALTER TABLE rep_instituicoes_ensinos
    ADD (
       limite_min_encaminhados_vaga NUMBER(3),
       limite_max_encaminhados_vaga NUMBER(3),
       padrao_encaminhados_vaga NUMBER(3));

