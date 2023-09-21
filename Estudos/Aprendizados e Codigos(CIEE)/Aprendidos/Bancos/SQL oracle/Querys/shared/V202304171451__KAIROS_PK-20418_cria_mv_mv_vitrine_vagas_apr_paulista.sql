DECLARE
  EXISTE_MV_VITRINE_VAGAS_APR_PAULISTA int := 0; 
BEGIN
	SELECT count(*) into EXISTE_MV_VITRINE_VAGAS_APR_PAULISTA FROM all_tables where table_name = 'MV_VITRINE_VAGAS_APR_PAULISTA';
	    if( EXISTE_MV_VITRINE_VAGAS_APR_PAULISTA = 1 ) then 
	         EXECUTE IMMEDIATE 'drop materialized view service_vagas_dev.mv_vitrine_vagas_apr_paulista'; 
	    end if;
        EXECUTE IMMEDIATE '
        		create materialized view service_vagas_dev.mv_vitrine_vagas_apr_paulista
				parallel 8 
				build immediate 
				refresh force
				as
				select vt.id_estado,
				       vt.data_alteracao,
				       va.id as id_vaga,
				       vt.codigo_vaga,
				       case when (exists(select 1 from service_vagas_dev.pcd_aprendiz pcd where pcd.id_vaga_aprendiz = va.id and pcd.deletado = 0)) then ''PCD'' else ''APRENDIZ'' end as tipo_vaga,
				       case when
				            va.divulgar_nome_empresa <> 1 then
				                ''Confidencial''
				            else
				                coalesce(rlc.razao_social, rlc.nome)
				       end as nome_empresa,
				       cast(NULL as varchar2(255)) area_profissional,
				       aa.descricao_area_atuacao area_atuacao,
				       va.valor_salario valor_bolsa,
				       cast(NULL as number) tipo_valor_bolsa,
				       cast(NULL as varchar2(255)) tipo_auxilio_bolsa,
				       case
				        when
				            va.tipo_salario_valor = 1 then ''A_COMBINAR''
				        else
				            ''FIXO''
				        end as tipo_salario_valor,
				       case
				        when
				            va.tipo_salario = 1 then ''Hora''
				        else
				            ''Mensal''
				        end as tipo_salario,        
				       cast(NULL as number) valor_bolsa_de,
				       cast(NULL as number) valor_bolsa_ate,
				       va.valor_salario_de valor_salario_de,
				       va.valor_salario_ate valor_salario_ate,
				       va.descricao,
				       vt.ordem,
					   re.tipo_logradouro,
				       re.endereco,
				       re.numero,
				       re.bairro,
				       re.complemento,
				       re.cep,
				       re.cidade,
				       re.uf,
				       1 tipo_horario ,
				       va.horario_inicio,
				       va.horario_termino,
				       cast(NULL as number) codigo_area_profissional,
				       case
				            when
				                va.escolaridade = 0 then ''T''
				            when
				                va.escolaridade = 1 then ''EF''
				            when
				                va.escolaridade = 2 then ''EM''
				            else null
				       end as nivel_ensino,
				       rcep.cod_municipio_ibge codigo_municipio
				    
				from service_vagas_dev.vitrine_vagas vt
				         inner join service_vagas_dev.vagas_aprendiz va on va.codigo_da_vaga = vt.codigo_vaga
				         inner join service_vagas_dev.rep_locais_contrato lc on va.id_local_contrato=lc.id
				         inner join service_vagas_dev.rep_contratos rc on lc.id_contrato = rc.id
				         inner join service_vagas_dev.rep_configuracao_contratos rcc on rc.id = rcc.id_contrato
				         inner join service_vagas_dev.situacoes s on s.id = va.id_situacao_vaga
				         inner join service_vagas_dev.rep_locais_contrato rlc on rlc.id = va.id_local_contrato
				         inner join service_vagas_dev.cursos_capacitacao cc on cc.id = va.id_curso_capacitacao
				         inner join service_vagas_dev.areas_atuacao_aprendiz aa on aa.id = cc.id_area_atuacao
				         left  join service_vagas_dev.rep_locais_enderecos rle on rlc.id = rle.id_local_contrato and rle.deletado=0
				         left  join service_vagas_dev.rep_enderecos re on rle.id_endereco = re.id
				         left  join service_vagas_dev.rep_ceps_core rcep on re.cep = rcep.codigo_cep
				where vt.situacao in(1,2)
				  and s.sigla in (''A'', ''B'')
				  and upper(rcc.tipo_documento) = ''APRENDIZ PAULISTA'''; 
END;
