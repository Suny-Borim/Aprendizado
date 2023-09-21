declare
    id_exists number default 0;
begin
    select (case
                when
                    not exists(select id
                               from {{user}}.percentuais_triagens_classificacoes
                               where id = 1)
                    then 0
                else (select id
                      from {{user}}.percentuais_triagens_classificacoes
                      where id = 1) end)
    into id_exists
    from dual;
    if (id_exists = 0) then
        INSERT INTO {{user}}.percentuais_triagens_classificacoes (id,
                                                                           percentual_faixa_1,
                                                                           sigla_faixa_1,
                                                                           percentual_faixa_2,
                                                                           sigla_faixa_2,
                                                                           percentual_faixa_3,
                                                                           sigla_faixa_3,
                                                                           data_criacao,
                                                                           data_alteracao,
                                                                           criado_por,
                                                                           modificado_por,
                                                                           deletado)
        VALUES (1,
                10,
                'A',
                10,
                'B',
                10,
                'C',
                sysdate,
                sysdate,
                'Admin',
                'Admin',
                0);
    end if;
end;