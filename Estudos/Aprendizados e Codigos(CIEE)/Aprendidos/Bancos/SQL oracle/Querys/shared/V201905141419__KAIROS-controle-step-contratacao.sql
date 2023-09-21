ALTER TABLE pre_contratos_estudantes_empresa ADD tela_step NUMBER(1) default 0;


COMMENT ON COLUMN pre_contratos_estudantes_empresa.tela_step IS
'
Flags Estagio:

    0: Rascunho
    1: Inconsistente
    2: Encaminhado RH
    3: Recusado
    4: Reenviar para o RH

Flags Aprendiz:

    0: Rascunho
    1: Inconsistente
    2: Encaminhado RH
    3: Recusado
    4: Reenviar para o RH

'
;

ALTER TABLE ferias RENAME COLUMN ID_CONTR_EMP TO ID_CONTR_EMP_EST;
ALTER TABLE pre_ferias RENAME COLUMN id_pre_contr_emp TO id_contr_emp_est;