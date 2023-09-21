create or replace TRIGGER SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_APRENDIZ_DELETE
    before
        DELETE on SERVICE_VAGAS_DEV.PCD_APRENDIZ
    for each row
declare
    pragma autonomous_transaction;
begin

    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.TRIGGER_MARCA_PCD_APRENDIZ_DELETE_' || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => '
                           declare
                                vaga_pcd number default 0;
                           begin
                                SELECT COUNT(*) INTO vaga_pcd from SERVICE_VAGAS_DEV.PCD_APRENDIZ WHERE ID_VAGA_APRENDIZ =  ' || :OLD.ID_VAGA_APRENDIZ ||
                          'and ID <> ' || :OLD.ID|| ';
                                IF vaga_pcd = 0  THEN
                                    UPDATE SERVICE_VAGAS_DEV.VAGAS_APRENDIZ SET PCD=0 WHERE ID = ' || :OLD.ID_VAGA_APRENDIZ|| ';
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