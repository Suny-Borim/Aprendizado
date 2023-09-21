DECLARE
  EXISTE_MV_DADOS_ESTUDANTES_SMS_EMAIL int := 0; 
BEGIN
	SELECT count(*) into EXISTE_MV_DADOS_ESTUDANTES_SMS_EMAIL FROM all_tables where table_name = 'MV_DADOS_ESTUDANTES_SMS_EMAIL';
	    if( EXISTE_MV_DADOS_ESTUDANTES_SMS_EMAIL = 1 ) then 
	         EXECUTE IMMEDIATE 'drop materialized view service_vagas_dev.MV_DADOS_ESTUDANTES_SMS_EMAIL'; 
	    end if;
        EXECUTE IMMEDIATE 'create materialized view service_vagas_dev.mv_dados_estudantes_sms_email
                            parallel 8 
                            build immediate 
                            as
                            select
                                est.id,
                                est.codigo_estudante,
                                est.nome,
                                est.cpf,
                                est.nome_social,
                                est.data_criacao                                           data_criacao_estudante,
                                est.data_alteracao                                         data_alteracao_estudante,
                                trunc((months_between(sysdate, est.data_nascimento)) / 12) idade,
                                est.data_nascimento                                        data_nascimento,
                                escol.id                                                   id_escolaridade,
                                escol.id_periodo_curso,
                                escol.oab,
                                escol.matricula,
                                escol.data_inicio,
                                escol.data_conclusao,
                                escol.periodo_atual,
                                escol.nome_escola,
                                escol.id_curso,
                                escol.tipo_periodo_curso,
                                escol.duracao_curso,
                                escol.tipo_duracao_curso,
                                escol.principal,
                                escol.status_escolaridade,
                                escol.ultimo_periodo_cursado,
                                escol.data_prevista_conclusao,
                                escol.sigla_nivel_educacao,
                                escol.id_escola,
                                escol.data_conclusao_calculada,
                                ree.cep,
                                ree.cidade,
                                ree.uf,
                                rcc.cod_municipio_ibge,
                                mct.id_unidade_ciee,
                                ruc.descricao                                              descricao_unidade_ciee,
                                ruc.id_unidade_administrativa,
                                tel.telefone                                               celular,
                                eml.email,
                                "''SMS''"                                                    termo_aceite_sms,
                                "''EMAIL''"                                                  termo_aceite_email,
                                case
                                    when v_cont_est.id is not null then 1
                                    else 0
                                end                                                        contratado_estagio,
                                case
                                    when v_cont_apr.id is not null then 1
                                    else 0
                                end                                                        contratado_aprendiz
                                
                            from
                                service_vagas_dev.mv_termos_aceite_estudante_student termos
                                inner join service_vagas_dev.rep_estudantes est on est.id = termos.id_estudante
                                inner join service_vagas_dev.rep_enderecos_estudantes ree on (est.id = ree.id_estudante and ree.deletado=0 and ree.principal=1)
                                left join  service_vagas_dev.rep_map_carteiras_territorios mct on (mct.cep = ree.cep and mct.deletado = 0) 
                                left join  service_vagas_dev.rep_unidades_ciee ruc on mct.id_unidade_ciee = ruc.id
                                left join  service_vagas_dev.rep_ceps_core rcc on ree.cep = rcc.codigo_cep
                                left join  service_vagas_dev.rep_telefones tel on (est.id = tel.id_estudante and tel.deletado = 0 and tel.principal=1 and tel.tipo_telefone =''CELULAR'')
                                left join  service_vagas_dev.rep_emails eml on (est.id = eml.id_estudante and eml.deletado = 0 and eml.principal=1)
                                inner join 
                                    (
                                        select * from (
                                            select  
                                                escolx.*,
                                                (row_number() over(partition by id_estudante order by data_criacao desc)) seq 
                                            from 
                                                service_vagas_dev.rep_escolaridades_estudantes escolx
                                            where 
                                                    escolx.principal=1   
                                                and escolx.deletado = 0
                                           )
                                        where seq=1
                                    ) escol on (escol.id_estudante = est.id and escol.principal=1)
                                left join
                                    (
                                        select
                                            *
                                        from
                                            (
                                                select
                                                    ceex.id, 
                                                    ceex.codigo_estudante, 
                                                    ceex.id_estudante,
                                                    (row_number() over(partition by id_estudante order by data_criacao desc)) seq
                                                from
                                                    service_vagas_dev.contratos_estudantes_empresa ceex
                                                where
                                                        ceex.deletado = 0
                                                    and ceex.situacao not in(1, 2)
                                                    and ceex.data_cancelamento is null
                                                    and ceex.tipo_contrato = ''E''
                                            )
                                        where
                                                seq = 1
                                    ) v_cont_est on v_cont_est.id_estudante = est.id
                                left join
                                    (
                                        select
                                            *
                                        from
                                            (
                                                select
                                                    ceex.id, 
                                                    ceex.codigo_estudante, 
                                                    ceex.id_estudante,
                                                    (row_number() over(partition by id_estudante order by data_criacao desc)) seq
                                                from
                                                    service_vagas_dev.contratos_estudantes_empresa ceex
                                                where
                                                        ceex.deletado = 0
                                                    and ceex.situacao not in(1, 2)
                                                    and ceex.data_cancelamento is null
                                                    and ceex.tipo_contrato = ''A''
                                            )
                                        where
                                                seq = 1
                                    ) v_cont_apr on v_cont_apr.id_estudante = est.id'; 
END;
