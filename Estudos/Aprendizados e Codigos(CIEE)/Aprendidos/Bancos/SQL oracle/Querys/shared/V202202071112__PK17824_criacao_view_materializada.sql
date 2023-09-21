-- Create MV or DROP CREATE
DECLARE
    MV_EXISTENTE  number := 0;
BEGIN
    Select count(*) into MV_EXISTENTE from ALL_MVIEWS where upper(MVIEW_NAME) = 'MV_DADOS_SUPERVISORES_TCES';

    if (MV_EXISTENTE = 0) then
        execute immediate 'create materialized view service_vagas_dev.mv_dados_supervisores_tces
      parallel 8
      build immediate
      refresh force
      on demand
      as
      select
          rlc.id_contrato,
          rlc.id                           id_local_contrato,
          nvl(rlc.nome, rlc.razao_social)  descricao_local_contrato,
          tots.total_supervisores          quantidade_supervisores,
          tote.total_estudantes            quantidade_estagiarios,
          rec.tipo_logradouro,
          rec.endereco,
          rec.numero,
          rec.bairro,
          rec.complemento,
          rec.cep,
          rec.cidade,
          rec.uf,
          rec.cidade||''/''||rec.uf cidade_uf
          from service_vagas_dev.rep_locais_contrato rlc
          left join service_vagas_dev.rep_locais_enderecos rle on (rle.id_local_contrato = rlc.id and rle.endereco_principal = 1)
          left join service_vagas_dev.rep_enderecos rec on rec.id = rle.id_endereco
          left join (
                   select rlc0.id,
                        count( distinct cee.id_supervisor) total_supervisores
                   from  service_vagas_dev.contratos_estudantes_empresa cee
                   left join service_vagas_dev.rep_locais_contrato rlc0 on cee.id_local_contrato = rlc0.id
                   where
                      cee.id_supervisor is not null
                      and rlc0.situacao = ''ATIVO''
                      and rlc0.deletado = 0
                      and cee.situacao <> 2
                      and cee.deletado = 0
                      and sysdate <= cee.data_final_estagio
                      and (cee.data_rescisao is null or (cee.data_rescisao is not null) and cee.data_rescisao >= sysdate )
                   group by rlc0.id
          ) tots on  tots.id = rlc.id
          inner join (
                   select rlc1.id, count(*) total_estudantes
                   from service_vagas_dev.contratos_estudantes_empresa cee
                   left join service_vagas_dev.rep_locais_contrato rlc1 on cee.id_local_contrato = rlc1.id
                   where
                      rlc1.situacao = ''ATIVO''
                      and rlc1.deletado = 0
                      and cee.tipo_contrato = ''E''
                      and cee.situacao <> 2
                      and cee.deletado = 0
                      and sysdate <= cee.data_final_estagio
                      and (cee.data_rescisao is null or (cee.data_rescisao is not null and cee.data_rescisao >= sysdate) )
                      group by rlc1.id
                  ) tote on tote.id = rlc.id';

      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11160 ON service_vagas_dev.mv_dados_supervisores_tces (id_contrato)';
      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11161 ON service_vagas_dev.mv_dados_supervisores_tces (cep)';
      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11162 ON service_vagas_dev.mv_dados_supervisores_tces (cidade_uf)';

   else
    execute immediate 'DROP MATERIALIZED VIEW service_vagas_dev.mv_dados_supervisores_tces';

      execute immediate 'create materialized view service_vagas_dev.mv_dados_supervisores_tces
      parallel 8
      build immediate
      refresh force
      on demand
      as
      select
          rlc.id_contrato,
          rlc.id                           id_local_contrato,
          nvl(rlc.nome, rlc.razao_social)  descricao_local_contrato,
          tots.total_supervisores          quantidade_supervisores,
          tote.total_estudantes            quantidade_estagiarios,
          rec.tipo_logradouro,
          rec.endereco,
          rec.numero,
          rec.bairro,
          rec.complemento,
          rec.cep,
          rec.cidade,
          rec.uf,
          rec.cidade||''/''||rec.uf cidade_uf
          from service_vagas_dev.rep_locais_contrato rlc
          left join service_vagas_dev.rep_locais_enderecos rle on (rle.id_local_contrato = rlc.id and rle.endereco_principal = 1)
          left join service_vagas_dev.rep_enderecos rec on rec.id = rle.id_endereco
          left join (
                   select rlc0.id,
                        count( distinct cee.id_supervisor) total_supervisores
                   from  service_vagas_dev.contratos_estudantes_empresa cee
                   left join service_vagas_dev.rep_locais_contrato rlc0 on cee.id_local_contrato = rlc0.id
                   where
                      cee.id_supervisor is not null
                      and rlc0.situacao = ''ATIVO''
                      and rlc0.deletado = 0
                      and cee.situacao <> 2
                      and cee.deletado = 0
                      and sysdate <= cee.data_final_estagio
                      and (cee.data_rescisao is null or (cee.data_rescisao is not null) and cee.data_rescisao >= sysdate )
                   group by rlc0.id
          ) tots on  tots.id = rlc.id
          inner join (
                   select rlc1.id, count(*) total_estudantes
                   from service_vagas_dev.contratos_estudantes_empresa cee
                   left join service_vagas_dev.rep_locais_contrato rlc1 on cee.id_local_contrato = rlc1.id
                   where
                      rlc1.situacao = ''ATIVO''
                      and rlc1.deletado = 0
                      and cee.tipo_contrato = ''E''
                      and cee.situacao <> 2
                      and cee.deletado = 0
                      and sysdate <= cee.data_final_estagio
                      and (cee.data_rescisao is null or (cee.data_rescisao is not null and cee.data_rescisao >= sysdate) )
                      group by rlc1.id
                  ) tote on tote.id = rlc.id';

      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11160 ON service_vagas_dev.mv_dados_supervisores_tces (id_contrato)';
      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11161 ON service_vagas_dev.mv_dados_supervisores_tces (cep)';
      execute immediate 'CREATE INDEX SERVICE_VAGAS_DEV.KRS_INDICE_11162 ON service_vagas_dev.mv_dados_supervisores_tces (cidade_uf)';
  end if;
end;