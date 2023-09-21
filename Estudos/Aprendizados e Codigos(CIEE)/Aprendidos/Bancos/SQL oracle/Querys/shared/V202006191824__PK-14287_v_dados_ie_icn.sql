create or replace view v_dados_ie_icn as

select
  rownum as id
, iee.data_alteracao as data_alteracao
, case when t.id_unidade = 101 then 'sp' else 'rj' end as uf_unidade
, t.id_unidade
, t.id_ie
, t.contato
, t.razao_social
, case when acordo.deletado = 1 then 'A' else 'I' end as situacao_conv
, acordo.data_criacao as data_conv
, t.cnpj_ie
, t.cep
, t.endereco
, t.bairro
, t.cidade
, t.nivel
, t.tel

from (
    select
        un.id_unidade_administrativa as id_unidade
        , cee.id_ie as id_ie
        , p.nome as contato
        , ie.nome_instituicao as razao_social
        , ie.ativo as situacao_conv
        , current_date as data_conv
        , ie.cnpj as cnpj_ie
        , end_ie.cep as cep
        , end_ie.endereco as endereco
        , end_ie.bairro as bairro
        , end_ie.cidade as cidade
        , ie.nivel_instituicao as nivel
        , rtel.telefone as tel
    from contratos_estudantes_empresa cee
    inner join rep_locais_contrato local on local.id = cee.id_local_contrato
    inner join rep_locais_enderecos endereco on endereco.id_local_contrato = local.id
    inner join rep_unidades_ciee un on un.id = endereco.id_unidade_ciee
    inner join rep_instituicoes_ensinos ie on ie.id = cee.id_ie
    inner join rep_contato_ie_tipo_processo iet on iet.id_instituicao_ensino = ie.id
    inner join rep_pessoas p on p.id = iet.id_pessoa
    inner join rep_enderecos_escolas end_ie on end_ie.id = ie.endereco
    inner join rep_ies_telefones r_ie_tel on r_ie_tel.id_ie = cee.id_ie
    inner join rep_telefones rtel on rtel.id = r_ie_tel.id_telefone
    where
        cee.tipo_contrato = 'E'
        and iet.active = 1
        and (iet.director = 1 or iet.vice_director = 1)
        and un.id_unidade_administrativa in (101,2401)
    group by un.id_unidade_administrativa,
          cee.id_ie
        , p.nome
        , ie.nome_instituicao
        , ie.ativo
        , ie.cnpj
        , end_ie.cep
        , end_ie.endereco
        , end_ie.bairro
        , end_ie.cidade
        , ie.nivel_instituicao
        , rtel.telefone
)  t
inner join rep_instituicoes_ensinos iee on iee.id = t.id_ie
inner join rep_ie_acordos_cooperacao acordo on acordo.id_instituicao_ensino = t.id_ie