-- PROCS

create or replace procedure proc_processa_fila_triagem_vaga_estagio
as
    v_data_execucao DATE;
    v_id number;
begin

    v_data_execucao:=sysdate - 3/86400;
    select max(id) into v_id from fila_triagem_vaga_estagio where data_criacao <= v_data_execucao;

    for rec in (select distinct ID_VAGA from fila_triagem_vaga_estagio)
        loop
            proc_atualizar_triagem_vaga_estagio(rec.ID_VAGA);
            delete from fila_triagem_vaga_estagio where ID_VAGA = rec.ID_VAGA and id <= v_id and data_criacao <= v_data_execucao;
            commit;
        end loop;
exception when others then null;
end;
