DECLARE
  EXISTE_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT int := 0; 
BEGIN
	SELECT count(*) into EXISTE_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT FROM all_tables where table_name = 'MV_TERMOS_ACEITE_ESTUDANTE_STUDENT';
	    if( EXISTE_MV_TERMOS_ACEITE_ESTUDANTE_STUDENT = 0 ) then 
	         EXECUTE IMMEDIATE 'create materialized view service_vagas_dev.MV_TERMOS_ACEITE_ESTUDANTE_STUDENT
								parallel 8 
								build immediate 
								as
								select 
								    *
								from 
								    (
								        select 
								            id_estudante,
								            tipo_termo,
								            situacao
								        from
								            (
								                select
								                   id_estudante,
								                   tipo_termo,
								                   situacao
								                from
								                    (
								                        select
								                            est.id id_estudante,
								                            ''SMS'' tipo_termo,
								                            tae.situacao,
								                            row_number() over(partition by tae.id_usuario, tae.id_modelo_termo_aceite order by tae.data_alteracao desc) seq
								                        from
								                            service_vagas_dev.rep_termos_aceite_estudante_student tae
								                            join service_vagas_dev.rep_estudantes est on est.id_usuario_auth = tae.id_usuario
								                        where
								                                tae.deletado = 0
								                            and tae.id_modelo_termo_aceite = (
								                                                                select
								                                                                    rmtac.id
								                                                                from
								                                                                          service_vagas_dev.rep_modelos_termo_aceite_core rmtac
								                                                                    inner join service_vagas_dev.rep_contexto_termos_aceite_core rctac on rctac.id_modelo_termo_aceite = rmtac.id
								                                                                where
								                                                                        rctac.termo_contexto = ''ESTUDANTE''
								                                                                    and rctac.termo_item = ''SMS''
								                                                             )
								                            and tae.versao = (
								                                                select
								                                                    rvtac.codigo_versao
								                                                from
								                                                          service_vagas_dev.rep_versao_termo_aceite_core rvtac
								                                                    inner join service_vagas_dev.rep_modelos_termo_aceite_core   rmtac on rmtac.id = rvtac.id_modelo_termo_aceite
								                                                    inner join service_vagas_dev.rep_contexto_termos_aceite_core rctac on rctac.id_modelo_termo_aceite = rmtac.id
								                                                where
								                                                        rctac.termo_contexto = ''ESTUDANTE''
								                                                    and rctac.termo_item = ''SMS''
								                                             )
								                    ) 
								                    
								                where
								                    seq = 1
								                    
								                union all
								                    
								                select
								                    id_estudante,
								                    tipo_termo,
								                    situacao
								                from
								                    (
								                        select
								                            est.id id_estudante,
								                            ''EMAIL'' tipo_termo,
								                            tae.situacao,
								                            row_number() over(partition by tae.id_usuario, tae.id_modelo_termo_aceite order by tae.data_alteracao desc) seq
								                        from
								                            service_vagas_dev.rep_termos_aceite_estudante_student tae
								                            join service_vagas_dev.rep_estudantes est on est.id_usuario_auth = tae.id_usuario
								                        where
								                                tae.deletado = 0
								                            and tae.id_modelo_termo_aceite = (
								                                                                select
								                                                                    rmtac.id
								                                                                from
								                                                                          service_vagas_dev.rep_modelos_termo_aceite_core rmtac
								                                                                    inner join service_vagas_dev.rep_contexto_termos_aceite_core rctac on rctac.id_modelo_termo_aceite = rmtac.id
								                                                                where
								                                                                        rctac.termo_contexto = ''ESTUDANTE''
								                                                                    and rctac.termo_item = ''EMAIL''
								                                                             )
								                            and tae.versao = (
								                                                select
								                                                    rvtac.codigo_versao
								                                                from
								                                                          service_vagas_dev.rep_versao_termo_aceite_core rvtac
								                                                    inner join service_vagas_dev.rep_modelos_termo_aceite_core   rmtac on rmtac.id = rvtac.id_modelo_termo_aceite
								                                                    inner join service_vagas_dev.rep_contexto_termos_aceite_core rctac on rctac.id_modelo_termo_aceite = rmtac.id
								                                                where
								                                                        rctac.termo_contexto = ''ESTUDANTE''
								                                                    and rctac.termo_item = ''EMAIL''
								                                             )
								                    )
								                where
								                    seq = 1    
								                   
								             )
								             group by id_estudante,
								                      tipo_termo,
								                      situacao
								    )
								PIVOT
								(
								  sum(situacao)
								  FOR tipo_termo IN (''SMS'',''EMAIL'')
								)
								ORDER BY id_estudante'; 
	    end if;
END;
