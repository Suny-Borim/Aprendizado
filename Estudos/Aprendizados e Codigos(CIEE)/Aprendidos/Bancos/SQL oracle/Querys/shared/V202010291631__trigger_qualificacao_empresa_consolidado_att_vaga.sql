create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_01_QUALIFICACOES_EMPRESAS_CONSOLIDADO_INSERT_UPDATE"
    after INSERT OR UPDATE on SERVICE_VAGAS_DEV.QUALIFICACOES_EMPRESAS_CONSOLIDADO
    for each row

declare
    pragma autonomous_transaction;

begin
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'SERVICE_VAGAS_DEV.TRIGGER_01_QUALIFICACOES_EMPRESAS_CONSOLIDADO_INSERT_UPDATE_'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
            job_type => 'PLSQL_BLOCK',
            job_action => '
                        declare
                            id_vaga number ;
                        begin
                            for r in (
                                select tri.CODIGO_DA_VAGA, tri.TIPO_VAGA
                                from TRIAGENS_VAGAS tri
                                where ID_EMPRESA = : ' || new.ID_EMPRESA || '
                                )
                                loop
                                    if (r.TIPO_VAGA = ''E'') then
                                        select id into id_vaga from VAGAS_ESTAGIO where CODIGO_DA_VAGA = r.CODIGO_DA_VAGA;
                                        PROC_ATUALIZAR_TRIAGEM_VAGA_ESTAGIO(id_vaga);
                                    else
                                        select id into id_vaga from VAGAS_APRENDIZ where CODIGO_DA_VAGA = r.CODIGO_DA_VAGA;
                                        PROC_ATUALIZAR_TRIAGEM_VAGA_APRENDIZ(id_vaga);
                                    end if;

                                end loop;
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