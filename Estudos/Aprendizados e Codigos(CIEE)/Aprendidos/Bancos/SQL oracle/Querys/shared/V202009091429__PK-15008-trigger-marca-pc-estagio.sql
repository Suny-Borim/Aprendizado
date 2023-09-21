create or replace trigger TRIGGER_MARCA_PCD_DELETE
    before delete
                         on PCD_ESTAGIO
                         for each row
declare
    pragma autonomous_transaction;
begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_DELETE' || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => '
                           declare
                                vaga_pcd number default 0;
                           begin
                                SELECT COUNT(*) INTO vaga_pcd from SERVICE_VAGAS_DEV.PCD_ESTAGIO WHERE ID_VAGA_ESTAGIO =  ' || :OLD.ID_VAGA_ESTAGIO ||
                                'and ID <> ' || :OLD.ID|| ';
                                IF vaga_pcd = 0  THEN
                                    UPDATE SERVICE_VAGAS_DEV.VAGAS_ESTAGIO SET PCD=0 WHERE ID = ' || :OLD.ID_VAGA_ESTAGIO|| ';
                                END IF;
                           end;
                          ',
            number_of_arguments => 0,
            start_date => NULL,
            repeat_interval => NULL,
            end_date => NULL,
            enabled => TRUE,
            auto_drop => TRUE,
            comments => '');
end;