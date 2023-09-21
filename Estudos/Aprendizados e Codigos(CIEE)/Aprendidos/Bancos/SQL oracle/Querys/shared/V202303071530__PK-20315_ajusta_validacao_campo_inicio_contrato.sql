DROP MATERIALIZED VIEW service_vagas_dev.mv_dados_assistencia_social;
CREATE MATERIALIZED VIEW "SERVICE_VAGAS_DEV"."MV_DADOS_ASSISTENCIA_SOCIAL" ("ID", "CODIGO_ESTUDANTE", "NOME", "NOME_SOCIAL", "DATA_INICIO", "DATA_FINAL", "PCD", "SEXO", "DESCRICAO", "ID_ETNIA", "PROGRAMAS_SOCIAIS", "NOME_IE", "NOME_CURSO_ESTUDANTE", "CODIGO_CURSO_ESTUDANTE", "DATA_INICIO_ESTAGIO", "TIPO_DURACAO_CURSO", "PERIODO_ATUAL", "ID_ESTUDANTE", "ID_LOCAL_CONTRATO", "RAZAO_SOCIAL", "SITUACAO", "DELETADO", "DATA_RESCISAO", "SIGLA_NIVEL_EDUCACAO_ESTUDANTE", "ID_CAMPUS", "ID_COMO_CONHECEU_CIEE", "DESCRICAO_COMO_CONHECEU_CIEE", "ID_PROGRAMA_RENDA", "DESCRICAO_PROGRAMA_RENDA", "ID_INCENTIVO_EDUCACIONAL", "DESCRICAO_INCENTIVO_EDUCACIONAL", "CIDADE", "UF")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "CIEE" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS select distinct
			cee.id,           
			estudante.codigo_estudante,
			estudante.nome,
			estudante.nome_social,
			case
				when cee.tipo_contrato = 'E' then 
					cee.data_inicio_estagio
				else
					case
						when ccc.usa_data_personalizada = 1 then 
							ccc.data_inicio_personalizada
						else
							ccc.data_inicio
					end
				end data_inicio,
			case
				when cee.tipo_contrato = 'E' then
					cee.data_final_estagio
				else
					cee.data_final_aprendiz
			end data_final,
			cee.pcd,
			estudante.sexo,
			etnias.descricao,
			etnias.id id_etnia,
			prog_sociais1.descricao || ';' || prog_sociais2.descricao || ';' || prog_sociais3.descricao programas_sociais,
			cee.nome_ie,
			cee.nome_curso_estudante,
			cee.codigo_curso_estudante,
			cee.data_inicio_estagio,
			cee.tipo_duracao_curso,
			cee.periodo_atual,
			cee.id_estudante,
			lc.id id_local_contrato,
			lc.razao_social razao_social,
			cee.situacao,
			cee.deletado,
			cee.data_rescisao,
			cee.sigla_nivel_educacao_estudante,
			cee.id_campus,
			info_sociais.como_conheceu_ciee id_como_conheceu_ciee,
			prog_sociais1.descricao descricao_como_conheceu_ciee,
			info_sociais.id id_programa_renda,
			prog_sociais2.descricao descricao_programa_renda,
			info_sociais.id id_incentivo_educacional,
			prog_sociais3.descricao descricao_incentivo_educacional,
			ender.cidade,
			ender.uf
		from
			service_vagas_dev.contratos_estudantes_empresa cee
			left outer join service_vagas_dev.rep_locais_contrato                  lc on cee.id_local_contrato = lc.id
			LEFT OUTER JOIN service_vagas_dev.rep_locais_enderecos                 le ON lc.id = le.id_local_contrato
			LEFT OUTER JOIN service_vagas_dev.rep_enderecos                        ender ON le.id_endereco = ender.id
			left outer join service_vagas_dev.rep_estudantes                       estudante on cee.id_estudante = estudante.id
			left outer join service_vagas_dev.rep_informacoes_adicionais           info_add on estudante.id_informacoes_adicionais = info_add.id
			left outer join service_vagas_dev.rep_etnias                           etnias on info_add.id_etnia = etnias.id
			left outer join service_vagas_dev.rep_informacoes_sociais              info_sociais on estudante.id = info_sociais.id_estudante
			left outer join service_vagas_dev.rep_programas_sociais_core           prog_sociais1 on info_sociais.como_conheceu_ciee = prog_sociais1.id
			left outer join service_vagas_dev.rep_programas_sociais_core           prog_sociais2 on info_sociais.id_programa_renda = prog_sociais2.id
			left outer join service_vagas_dev.rep_programas_sociais_core           prog_sociais3 on info_sociais.id_incentivo_educacional = prog_sociais3.id
			left outer join service_vagas_dev.contratos_cursos_capacitacao         ccc on cee.id = ccc.id_contr_emp_est;

   COMMENT ON MATERIALIZED VIEW "SERVICE_VAGAS_DEV"."MV_DADOS_ASSISTENCIA_SOCIAL"  IS 'snapshot table for snapshot SERVICE_VAGAS_DEV.MV_DADOS_ASSISTENCIA_SOCIAL';