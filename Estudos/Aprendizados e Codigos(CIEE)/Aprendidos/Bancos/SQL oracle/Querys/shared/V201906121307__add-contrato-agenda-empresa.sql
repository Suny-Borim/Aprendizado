ALTER TABLE AGENDA_EMPRESA_VAGA ADD ID_CONTR_EMP_EST NUMBER (20);

ALTER TABLE AGENDA_EMPRESA_VAGA
    ADD CONSTRAINT KRS_INDICE_03783 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );
        
ALTER TABLE ACOMPANHAMENTOS_VAGAS MODIFY CODIGO_VAGA NULL;
ALTER TABLE AGENDA_EMPRESA_VAGA MODIFY CODIGO_VAGA NULL;

ALTER TABLE ACOMPANHAMENTOS_VAGAS RENAME TO ACOMPANHAMENTOS;
ALTER TABLE AGENDA_EMPRESA_VAGA RENAME TO AGENDA_EMPRESA;