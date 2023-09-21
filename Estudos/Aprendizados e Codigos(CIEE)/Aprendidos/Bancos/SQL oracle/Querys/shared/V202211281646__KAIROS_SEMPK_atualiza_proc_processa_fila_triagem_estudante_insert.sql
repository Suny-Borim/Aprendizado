-- Procedure que consome a fila para ACAO='I'
create or replace procedure proc_processa_fila_triagem_estudante_insert
    is
    l_rows SERVICE_VAGAS_DEV.IDS_TYP;
    v_ds_ocorrencia varchar2(1000);
    e_queue_too_high EXCEPTION;
    PRAGMA exception_init( e_queue_too_high, -20001);
begin

    FOR rec IN (SELECT MAX(1) FROM service_vagas_dev.fila_triagem_estudante f HAVING COUNT(1)> 3000000)
        LOOP
            RAISE e_queue_too_high;
        END LOOP;

    delete from service_vagas_dev.fila_triagem_estudante where rownum <= 1000 and acao = 'I' returning id_estudante -- na mesma execução de 50 em 50! logando as operações
        bulk collect into l_rows; -- considerando um máximo de 50 linhas processadas por interação

    while l_rows.count > 0 loop
            BEGIN
                service_vagas_dev.proc_atualizar_triagem_estudante_lista(l_rows);
            EXCEPTION
                WHEN OTHERS THEN
                    v_ds_ocorrencia:= SQLERRM;
                    insert into service_vagas_dev.fila_triagem_estudante_log values (l_rows, sysdate, v_ds_ocorrencia);
                    commit;
            END;

            delete from service_vagas_dev.fila_triagem_estudante where rownum <= 1000 and acao = 'I' returning id_estudante -- na mesma execução de 50 em 50! logando as operações
                bulk collect into l_rows; -- considerando um máximo de 50 linhas processadas por interação

        end loop;

    commit;

exception
    when e_queue_too_high then
        raise_application_error(-20001, 'queue too high');

    when others then
        rollback;
        v_ds_ocorrencia:= SQLERRM;
        insert into service_vagas_dev.fila_triagem_estudante_log values (new SERVICE_VAGAS_DEV.IDS_TYP(), sysdate, 'erro geral: ' || v_ds_ocorrencia); -- envio de e-mail para sustentação e/ou outras forma de alerta
end proc_processa_fila_triagem_estudante_insert;