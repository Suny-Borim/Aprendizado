create or replace PROCEDURE PROC_VERIFICACAO_CRIACAO_DEFENSIVA_VAGA_TRIAGEM(
    V_CODIGO_VAGA NUMBER DEFAULT NULL
)
as
    id_vaga             number ;
    tipo_vaga           varchar2(1);
    existe_vaga_triagem number(1) default 1;
begin


    select count(1) into existe_vaga_triagem from TRIAGENS_VAGAS where CODIGO_DA_VAGA = V_CODIGO_VAGA;
    if existe_vaga_triagem = 0 then
        select id, tipo
        into id_vaga, tipo_vaga
        from (
                 select id, 'E' tipo
                 from VAGAS_ESTAGIO
                 where CODIGO_DA_VAGA = V_CODIGO_VAGA
                 union all
                 select id, 'A'
                 from VAGAS_APRENDIZ
                 where CODIGO_DA_VAGA = V_CODIGO_VAGA
             );

        if (tipo_vaga = 'E') then
            PROC_ATUALIZAR_TRIAGEM_VAGA_ESTAGIO(id_vaga);
        elsif (tipo_vaga = 'A') then
                PROC_ATUALIZAR_TRIAGEM_VAGA_APRENDIZ(id_vaga);
        end if;
    end if;
end ;