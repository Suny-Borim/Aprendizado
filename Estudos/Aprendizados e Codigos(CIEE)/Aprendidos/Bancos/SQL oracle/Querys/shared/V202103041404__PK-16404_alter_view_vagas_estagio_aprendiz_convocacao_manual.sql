CREATE OR REPLACE VIEW V_VAGAS_ESTAGIO_APRENDIZ_PARA_CONVOCACAO_MANUAL 
AS SELECT
	vaga.id,
    vaga.descricao,
    vaga.tipo,
    vaga.codigo,
    vaga.pcd,
    vaga.pp,
    vaga.RAZAO_SOCIAL,
    vaga.NOME_FANTASIA,
    vaga.ID_CONTRATO, 
    vaga.DATA_CRIACAO, 
    (select count(id) from vinculos_vaga where codigo_vaga = vaga.codigo  and deletado = 0) as QUANTIDADE_CONVOCADOS,
    unidade.descricao as descricaounidade,
    CASE 
    	WHEN locais_enderecos.id_unidade_ciee_local IS NULL 
    	THEN LOCAIS_ENDERECOS.ID_UNIDADE_CIEE 
    	ELSE locais_enderecos.id_unidade_ciee_local END AS ID_UNIDADE_LOCAL,
    LOCAIS_ENDERECOS.ID_UNIDADE_CIEE AS ID_UNIDADE_ORIGEM,    
    LOCAIS_ENDERECOS.ID_CARTEIRA AS ID_CARTEIRA_ORIGEM,
    CASE 
    	WHEN LOCAIS_ENDERECOS.ID_CARTEIRA_LOCAL IS NULL 
    	THEN LOCAIS_ENDERECOS.ID_CARTEIRA 
    	ELSE LOCAIS_ENDERECOS.ID_CARTEIRA_LOCAL END AS ID_CARTEIRA_LOCAL
 from (select               
			rlc.RAZAO_SOCIAL as RAZAO_SOCIAL,
		    rlc.NOME_FANTASIA as NOME_FANTASIA,
		    va.id,
		    va.descricao,
		    'APRENDIZ' as tipo,
		    va.codigo_da_vaga as codigo,
		    pcd,
		    processo_seletivo_empresa as pp,
		    va.id_local_contrato,
		    va.deletado,
		    va.TIPO_DIVULGACAO,
		    va.ID_SITUACAO_VAGA, 
		    va.DATA_CRIACAO AS DATA_CRIACAO, 
		    rlc.ID_CONTRATO AS ID_CONTRATO 
	    from vagas_aprendiz va          
	    inner join REP_LOCAIS_CONTRATO rlc on rlc.id = va.ID_LOCAL_CONTRATO          
	    WHERE va.TIPO_DIVULGACAO <> 1 and  (va.ID_SITUACAO_VAGA = 1 OR (va.ID_SITUACAO_VAGA = 2               
	    AND not exists (select 1 from OCORRENCIAS_APRENDIZ oa WHERE oa.ID_VAGA_APRENDIZ = va.ID and oa.DELETADO = 0)))          
	    union          
	    select               
		    rlc.RAZAO_SOCIAL as RAZAO_SOCIAL,
		    rlc.NOME_FANTASIA as NOME_FANTASIA,
		    ve.id,
		    ve.descricao,
		    'ESTAGIO' as tipo,
		    ve.codigo_da_vaga as codigo,
		    pcd,
		    processo_personalizado as pp,
		    ve.id_local_contrato,
		    ve.deletado,
		    ve.TIPO_DIVULGACAO,
		    ve.ID_SITUACAO_VAGA,
		    ve.DATA_CRIACAO AS DATA_CRIACAO, 
		    rlc.ID_CONTRATO AS ID_CONTRATO
	    from vagas_estagio ve            
	    inner join REP_LOCAIS_CONTRATO rlc on rlc.id = ve.ID_LOCAL_CONTRATO           
	    WHERE ve.TIPO_DIVULGACAO <> 1 and  (ve.ID_SITUACAO_VAGA = 1 OR (ve.ID_SITUACAO_VAGA = 2               
    	AND not exists (select 1 from OCORRENCIAS_ESTAGIO oe WHERE oe.ID_VAGA_ESTAGIO = ve.ID AND oe.DELETADO = 0)))) vaga    
inner join rep_locais_enderecos locais_enderecos on vaga.id_local_contrato = locais_enderecos.id_local_contrato    
inner join rep_unidades_ciee unidade on locais_enderecos.id_unidade_ciee = unidade.id