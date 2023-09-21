-- Proc que remove e re-insere o estudante da Triagens Estudantes
create or replace procedure service_vagas_dev.proc_ajustar_semestre_escolaridade_triagem_estudantes
is
begin
    
   for r in 
                (
                    select
                       te.id_estudante,
                       te.data_alteracao dttriagem,
                       escol.data_alteracao dtescol
                    from 
                        service_vagas_dev.rep_estudantes                 re  
                        join service_vagas_dev.triagens_estudantes       te  on te.id_estudante = re.id
                        inner join 
                            (
                                select * from (
                                    select  
                                        escolx.id_estudante,
                                        escolx.principal,
                                        escolx.data_alteracao,
                                        (row_number() over(partition by id_estudante order by data_alteracao desc)) seq 
                                    from 
                                        service_vagas_dev.rep_escolaridades_estudantes escolx
                                    where 
                                            escolx.principal=1   
                                        and escolx.deletado = 0
                                   )
                                where seq=1
                            ) escol on (escol.id_estudante = re.id)
                    where
                        re.deletado = 0 
                        and 
                        te.data_alteracao < escol.data_alteracao 
                )
   loop
        
        
       begin
            -- Deleta da Triagens Estudantes
            execute immediate 'delete from service_vagas_dev.triagens_estudantes where id_estudante = :1' using r.id_estudante;
            commit work write wait immediate;
            exception when others then null;
       end; 
       begin
            -- Insere na fila
            execute immediate 'insert into service_vagas_dev.fila_triagem_estudante(id_estudante,dt_ocorrencia,acao) values(:1,sysdate,:2)' using r.id_estudante,'I';
            commit work write wait immediate;
            exception when others then null;
       end; 
       begin
            -- Insere na tabela de LOG
            execute immediate 'insert into service_vagas_dev.log_ajustar_semestre_escolaridade_triagem_estudantes( id_estudante,data_execucao,data_escolaridade,data_triagem) values(:1,sysdate,:2,:3)' using r.id_estudante,r.dtescol,r.dttriagem;
            commit work write wait immediate;
            exception when others then null;
       end; 
        
   end loop; 
   
end;