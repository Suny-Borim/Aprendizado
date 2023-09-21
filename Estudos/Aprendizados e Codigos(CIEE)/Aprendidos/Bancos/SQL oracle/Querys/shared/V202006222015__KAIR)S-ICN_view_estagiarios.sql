create or replace view v_dados_estagiarios_icn as

select

rownum as id
, stag.nome
, stag.cpf
, stag.codigo_estudante
, stag.email
, stag.data_nascimento
, stag.rg
, stag.sexo
, stag.uf_rg
, stag.orgao_emissor_rg
, stag.id_unidade
, 'A' AS situacao
, stag.id_agencia
, stag.id_banco
, stag.conta_corrente
, stag.conta_corrente_digito
, stag.digito_agencia
, stag.cep
, stag.bairro
, stag.endereco
, stag.numero
, stag.cidade
, stag.uf

, case when stag.id_unidade = 101 then 'sp' else 'rj' end as uf_unidade
from(

SELECT
	con.ID_BANCO
	, con.ID_AGENCIA
	, a.ID_AGENCIA AS id_a
	, con.CONTA_CORRENTE
	, con.CONTA_CORRENTE_DIGITO
	, e.NOME
	, e.SEXO
	, e.CPF
	, e.DATA_NASCIMENTO
	, e.RG
	, e.UF_RG
	, e.ORGAO_EMISSOR_RG
	, e.CODIGO_ESTUDANTE
	, en.BAIRRO
	, en.ENDERECO
	, en.NUMERO
	, en.CIDADE
	, en.CEP
	, en.UF
	, a.DIGITO_AGENCIA
	, u.EMAIL
	, un.id_unidade_administrativa as id_unidade

	FROM REP_ESTUDANTES e
	INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA con ON con.ID_ESTUDANTE = e.ID
	INNER JOIN AGENCIAS a ON con.ID_AGENCIA = a.ID_AGENCIA
	INNER JOIN REP_ENDERECOS_ESTUDANTES en ON en.ID_ESTUDANTE = e.ID
	INNER JOIN REP_USUARIOS u ON u.CPF = e.CPF
  	INNER JOIN rep_locais_contrato lc on lc.id = con.id_local_contrato
	INNER JOIN rep_locais_enderecos enlc on enlc.id_local_contrato = lc.id
    INNER JOIN rep_unidades_ciee un on un.id = enlc.id_unidade_ciee

	WHERE
	en.PRINCIPAL = 1 AND
	con.tipo_contrato = 'E'
	AND con.SITUACAO = 0

) stag