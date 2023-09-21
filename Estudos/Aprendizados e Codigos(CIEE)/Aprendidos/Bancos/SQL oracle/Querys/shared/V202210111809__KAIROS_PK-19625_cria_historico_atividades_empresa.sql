DECLARE
tabela_existente int:=0;
BEGIN
  SELECT count(*) into tabela_existente FROM all_tables where table_name = 'HIST_ATIVIDADES_EMPRESA_CONTR_EMP_EST'; 

  if tabela_existente<=0 then
     EXECUTE IMMEDIATE 'CREATE TABLE HIST_ATIVIDADES_EMPRESA_CONTR_EMP_EST (
                                               id_contr_emp_est   NUMBER(20) NOT NULL,
                                               id_atividade   NUMBER(20) NOT NULL)';
    EXECUTE IMMEDIATE 'ALTER TABLE HIST_ATIVIDADES_EMPRESA_CONTR_EMP_EST
                        ADD CONSTRAINT KRS_INDICE_11768 FOREIGN KEY ( id_contr_emp_est )
                        REFERENCES hist_contratos_estudantes_empresa ( id )';
    EXECUTE IMMEDIATE 'ALTER TABLE HIST_ATIVIDADES_EMPRESA_CONTR_EMP_EST
                        ADD CONSTRAINT KRS_INDICE_11769 FOREIGN KEY ( id_atividade )
                        REFERENCES REP_ATIVIDADES_EMPRESAS ( id )';
  end if;
END;