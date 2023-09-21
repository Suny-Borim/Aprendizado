-- Cria a view com informações de saldo de recesso de estagiários

create or replace view V_SALDO_DIAS_RECESSO as
    select
        c.ID,
        c.ID_LOCAL_CONTRATO,
        c.ID_ESTUDANTE,
        c.CODIGO_ESTUDANTE,
        c.NOME_ESTUDANTE,
        c.NOME_SOCIAL_ESTUDANTE,
        c.CPF_ESTUDANTE,
        c.DATA_INICIO_ESTAGIO,
        c.DATA_FINAL_ESTAGIO,
        d.QTD_DIAS_FERIAS_CLT,
        d.QTD_DIAS_FERIAS_CLT_ATE_FINAL,
        nvl(
        	(
        		d.QTD_DIAS_FERIAS_CLT
        		-
        		(
        			SELECT COALESCE (SUM(EXTRACT(DAY from (DATA_FIM - DATA_INICIO))),0)
        			FROM RECESSOS
        			WHERE ID_CONTR_EMP_EST = c.ID
        			AND DELETADO = 0
        			GROUP BY ID_CONTR_EMP_EST
        		)
        	), d.QTD_DIAS_FERIAS_CLT
        ) as saldo_clt,
        d.QTD_DIAS_FERIAS_PROPORCIONAL,
        d.qtd_dias_ferias_proporcional_ate_final,
        nvl(
        	(
        		d.QTD_DIAS_FERIAS_PROPORCIONAL
        		-
        		(
        			SELECT COALESCE (SUM(EXTRACT(DAY from (DATA_FIM - DATA_INICIO))),0)
        			FROM RECESSOS
        			WHERE ID_CONTR_EMP_EST = c.ID
        			AND DELETADO = 0
        			GROUP BY ID_CONTR_EMP_EST
        		)
        	),d.QTD_DIAS_FERIAS_PROPORCIONAL
        ) as saldo_proporcional
    from CONTRATOS_ESTUDANTES_EMPRESA c
        inner join  V_DIAS_DISPONIVEIS_RECESSO d on c.ID = d.CONTRATO;