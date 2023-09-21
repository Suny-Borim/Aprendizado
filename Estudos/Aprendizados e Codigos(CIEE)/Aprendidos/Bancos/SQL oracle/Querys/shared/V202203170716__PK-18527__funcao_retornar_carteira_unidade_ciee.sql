-- Crio a função retornar_carteira_unidade_ciee
create or replace function service_vagas_dev.retornar_carteira_unidade_ciee( p_id_contrato       number default null,
                                                                             p_id_local_contrato number default null,
                                                                             p_estagio_autonomo   number default null
                                                                            ) return number 
as
    v_unidade_ciee          number;
    v_id_carteira           number;
    v_cep                   varchar2(8);
    v_cep_unidade_ciee      varchar2(8);
    v_codigo_mun            number;
    v_estagio_autonomo      number := p_estagio_autonomo;
    v_tipo_contrato_empresa varchar2(50);
begin

    -- Caso o flag esteja null eu forço o mesmo para 0
    if(v_estagio_autonomo is null)then
       v_estagio_autonomo := 0;
    end if;


    if (p_id_contrato is not null) then
        
        -- Verifica o tipo de contrato da empresa 
        select 
            upper(rcc.tipo_servico) into v_tipo_contrato_empresa
        from 
            service_vagas_dev.rep_contratos rcc 
        where 
            rcc.id = p_id_contrato;
            
        if (v_tipo_contrato_empresa = 'APRENDIZ') then
            v_estagio_autonomo := 1;
        end if;     
      
    end if;
    

    if (v_estagio_autonomo = 1 and p_id_contrato is not null and p_id_local_contrato is not null) then

        -- Tento determinar a unidade via cep
       select 
            mapct.id_carteira,cast(trim(ree.cep) as number) into v_id_carteira,v_cep
        from
            service_vagas_dev.rep_locais_contrato                     rlc
            left join service_vagas_dev.rep_locais_enderecos          rle on rle.id_local_contrato = rlc.id  and rle.deletado = 0
            left join service_vagas_dev.rep_enderecos                 ree on ree.id = rle.id_endereco
            left join service_vagas_dev.rep_map_carteiras_territorios mapct on mapct.cep = ree.cep and mapct.corrente = 1
            left join service_vagas_dev.rep_unidades_ciee             uc on uc.id = mapct.id_unidade_ciee
        where 
              rlc.id_contrato = p_id_contrato
          and rlc.id          = p_id_local_contrato;

        -- Carteira retornou null
        if (v_id_carteira is null)then
            
            -- Tento determinar cep da unidade_ciee via codigo do municipio do endereco do local
            select 
                ree.cep into v_cep_unidade_ciee
            from 
                service_vagas_dev.rep_map_carteiras_territorios mapct
                left join service_vagas_dev.rep_unidades_ciee   uc  on uc.id = mapct.id_unidade_ciee
                left join service_vagas_dev.rep_enderecos       ree on ree.id = uc.id_endereco
            where 
                mapct.codigo_municipio in 
                                         (
                                            select 
                                                rc.cod_municipio_ibge
                                            from 
                                                service_vagas_dev.rep_ceps_core rc
                                            where
                                                rc.codigo_cep  = v_cep

                                         )
                and mapct.deletado = 0
                and mapct.corrente = 1
                fetch first row only;
                    
            -- Tento determinar a carteira novamente com o cep da unidade_ciee
            select 
                mapct.id_carteira into v_id_carteira
            from
                service_vagas_dev.rep_map_carteiras_territorios mapct
            where 
                mapct.cep = v_cep_unidade_ciee;
            
        end if;

    end if;

    if (v_estagio_autonomo = 0 and p_id_contrato is not null and p_id_local_contrato is not null) then

       -- Tento determinar a carteira via ciees_carteiras_territorios
       select 
            mapci.id_carteira,cast(trim(ree.cep) as number) into v_id_carteira,v_cep
        from
            service_vagas_dev.rep_locais_contrato                            rlc
            left join service_vagas_dev.rep_configuracao_contratos           rcc on rcc.id_contrato = rlc.id_contrato      
            left join service_vagas_dev.rep_unidades_ciee                    uc  on uc.id  = rcc.id_unidade_ciee  
            left join service_vagas_dev.rep_gerencias                        rg  on rg.id  = uc.id_gerencia
            left join service_vagas_dev.rep_superintendencias_unit           sp  on sp.id  = rg.codigo_superintendencia
            left join service_vagas_dev.rep_ciees                            rci on rci.id = sp.id_ciee
            left join service_vagas_dev.rep_locais_enderecos                 rle on rle.id_local_contrato = rlc.id  and rle.deletado = 0
            left join service_vagas_dev.rep_enderecos                        ree on ree.id = rle.id_endereco
            left join service_vagas_dev.rep_ciees_carteiras_territorios_unit mapci on mapci.id_ciee = rci.id and mapci.cep = ree.cep and mapci.corrente = 1

        where rlc.id_contrato = p_id_contrato
          and rlc.id          = p_id_local_contrato;


        -- Não encontrei no ciees_carteiras_territorios
        if(v_id_carteira is null)then

           -- Tento determinar a unidade via cep
           select 
                mapct.id_carteira,cast(trim(ree.cep) as number) into v_id_carteira,v_cep
            from
                service_vagas_dev.rep_locais_contrato                     rlc
                left join service_vagas_dev.rep_locais_enderecos          rle on rle.id_local_contrato = rlc.id  and rle.deletado = 0
                left join service_vagas_dev.rep_enderecos                 ree on ree.id = rle.id_endereco
                left join service_vagas_dev.rep_map_carteiras_territorios mapct on mapct.cep = ree.cep and mapct.corrente = 1
                left join service_vagas_dev.rep_unidades_ciee             uc on uc.id = mapct.id_unidade_ciee
            where 
                  rlc.id_contrato = p_id_contrato
              and rlc.id          = p_id_local_contrato;

            -- Unidade CIEE retornou null
            if (v_id_carteira is null)then
                -- Tento determinar via codigo do municipio
                select 
                    ree.cep into v_cep_unidade_ciee
                from 
                    service_vagas_dev.rep_map_carteiras_territorios mapct
                    left join service_vagas_dev.rep_unidades_ciee   uc on uc.id = mapct.id_unidade_ciee
                    left join service_vagas_dev.rep_enderecos       ree on ree.id = uc.id_endereco
                where mapct.codigo_municipio in 
                                                (
                                                    select 
                                                        rc.cod_municipio_ibge
                                                    from 
                                                        service_vagas_dev.rep_ceps_core rc
                                                    where
                                                        rc.codigo_cep  = v_cep

                                                )
                        and mapct.deletado = 0
                        and mapct.corrente = 1
                        fetch first row only;
                        
                -- Tento determinar a carteira novamente com o cep da unidade_ciee
                select 
                    mapct.id_carteira into v_id_carteira
                from
                    service_vagas_dev.rep_map_carteiras_territorios mapct
                where 
                    mapct.cep = v_cep_unidade_ciee;        
                    
            end if;

        end if;

    end if;

    return v_id_carteira;

end retornar_carteira_unidade_ciee;