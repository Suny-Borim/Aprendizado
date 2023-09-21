create or replace view V_DADOS_TCE_ICN
    as
(
    select rownum                                                 as id
         , tce.codigo_estudante
         , tce.codigo_local_contrato
         , tce.codigo_estudante_empresa
         , tce.data_inicio_estagio
         , tce.data_final_estagio
         , tce.data_alteracao
         , tce.data_rescisao
         , SUBSTR2(tce.motivo_rescisao, 0, 75)                   as motivo_rescisao
         , SUBSTR2(tce.motivo_cancelamento, 0, 75)               as motivo_cancelamento
         , tce.data_cancelamento
         , tce.valor_bolsa
         , tce.VALOR_PERCENTUAL_BASE
         , tce.VALOR_CI
         , tce.duracao_curso
         , tce.cep_estagio
         , SUBSTR2(tce.endereco_estagio, 0, 100)                  as endereco_estagio
         , SUBSTR2(tce.bairro_estagio, 0, 50)                     as bairro_estagio
         , SUBSTR2(tce.cidade_estagio, 0, 50)                     as cidade_estagio
         , tce.numero_estagio
         , tce.uf_estagio
         , SUBSTR2(tce.nome_supervisor, 0, 70)                    as nome_supervisor
         , SUBSTR2(tce.cargo_supervisor, 0, 70)                   as cargo_supervisor
         , SUBSTR2(tce.email_supervisor, 0, 70)                   as email_supervisor
         , tce.id_ie
         , SUBSTR2(tce.nome_curso_estudante, 0, 100)              as nome_curso_estudante
         , tce.periodo_atual
         , tce.tipo_duracao_curso
         , tce.nivel_escolaridade
         , tce.id_unidade
         , case when tce.id_unidade = 101 then 'sp' else 'rj' end as uf_unidade
         , case when tce.id_unidade = 101 then 'sp' else 'rj' end as uf_instituicao_ensino
         , tce.cpf_estagiario
         , tce.nome_estagiario
         , tce.cnpj_empresa
         , tce.razao_social
         , tce.SITUACAO_CONFIRMACAO                               as SITUACAO_FINALIZACAO
         , tce.DATA_ATUALIZACAO_SITUACAO
    from (
             SELECT con.codigo_estudante
                  , con.ID_LOCAL_CONTRATO        AS codigo_local_contrato
                  , con.ID                       AS codigo_estudante_empresa
                  , con.data_inicio_estagio
                  , con.DATA_FINAL_ESTAGIO
                  , con.DATA_RESCISAO
                  , con.DATA_CANCELAMENTO
                  , con.DATA_ALTERACAO
                  , con.VALOR_BOLSA
                  , lc.VALOR_CI                  as VALOR_PERCENTUAL_BASE
                  , lc.VALOR_CI
                  , re.duracao_curso
                  , con.CEP_EMPRESA              AS cep_estagio
                  , con.ENDERECO_EMPRESA         AS endereco_estagio
                  , con.NUMERO_EMPRESA           AS numero_estagio
                  , con.UF_EMPRESA               AS uf_estagio
                  , con.CIDADE_EMPRESA           AS cidade_estagio
                  , con.BAIRRO_EMPRESA           AS bairro_estagio
                  , con.NOME_SUPERVISOR
                  , con.CARGO_SUPERVISOR
                  , con.ID_IE
                  , con.NOME_CURSO_ESTUDANTE
                  , re.TIPO_DURACAO_CURSO
                  , con.PERIODO_ATUAL
                  , con.NIVEL_ESCOLARIDADE
                  , S.EMAIL                      AS email_supervisor
                  , mtv.DESCRICAO                AS motivo_rescisao
                  , mtv_ca.DESCRICAO             AS motivo_cancelamento
                  , un.id_unidade_administrativa as id_unidade
                  , e.CPF                        AS cpf_estagiario
                  , e.NOME                       AS nome_estagiario
                  , lc.CNPJ                      AS cnpj_empresa
                  , lc.RAZAO_SOCIAL
                  , cs.SITUACAO_CONFIRMACAO
                  , cs.DATA_ATUALIZACAO_SITUACAO

             FROM CONTRATOS_ESTUDANTES_EMPRESA con
                      INNER JOIN SUPERVISORES S ON S.ID = con.ID_SUPERVISOR
                      LEFT JOIN MOTIVOS_RESCISAO_CONTRATADOS mtv ON mtv.ID = con.ID_MOTIVO_RESCISAO_CONTRATADO
                      LEFT JOIN MOTIVOS_CANCELAMENTOS_CONTRATADOS mtv_ca
                                ON mtv_ca.ID = con.ID_MOTIVO_CANCELAMENTO_CONTRATADO
                      INNER JOIN rep_locais_contrato lc on lc.id = con.id_local_contrato
                      INNER JOIN rep_locais_enderecos enlc on enlc.id_local_contrato = lc.id
                      INNER JOIN rep_unidades_ciee un on un.id = enlc.id_unidade_ciee
                      INNER JOIN REP_ESTUDANTES e ON e.ID = con.ID_ESTUDANTE
                      inner join rep_escolaridades_estudantes re on re.id_estudante = e.id
                      left join cse cs on cs.id_contr_emp_est = con.id

             WHERE con.tipo_contrato = 'E'
               and re.principal = 1
               AND con.SITUACAO in (0 ,1 , 2 )
             group by con.codigo_estudante, con.ID_LOCAL_CONTRATO, con.ID, con.data_inicio_estagio,
                      con.DATA_FINAL_ESTAGIO, con.DATA_RESCISAO, con.DATA_CANCELAMENTO, con.DATA_ALTERACAO,
                      con.VALOR_BOLSA, lc.VALOR_CI, lc.VALOR_CI, re.duracao_curso, con.CEP_EMPRESA,
                      con.ENDERECO_EMPRESA, con.NUMERO_EMPRESA, con.UF_EMPRESA, con.CIDADE_EMPRESA,
                      con.BAIRRO_EMPRESA, con.NOME_SUPERVISOR, con.CARGO_SUPERVISOR, con.ID_IE,
                      con.NOME_CURSO_ESTUDANTE, re.TIPO_DURACAO_CURSO, con.PERIODO_ATUAL, con.NIVEL_ESCOLARIDADE,
                      S.EMAIL, mtv.DESCRICAO, mtv_ca.DESCRICAO, un.id_unidade_administrativa, e.CPF, e.NOME,
                      lc.CNPJ, lc.RAZAO_SOCIAL, cs.SITUACAO_CONFIRMACAO, cs.DATA_ATUALIZACAO_SITUACAO, con.SEQ_TA
             having max(con.seq_ta
                        ) = con.SEQ_TA
         ) tce
)