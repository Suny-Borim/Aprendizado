CREATE OR REPLACE VIEW V_ACOMPANHAMENTOS_GMC 
(CONTRATO, EMPRESA, PERIODO, TIPO_ACOMPANHAMENTO, QTD_PRORROGADOS_TRATADOS, QTD_PRORROGADOS_NAO_TRATADOS, QTD_REPOSTOS_TRATADOS, QTD_REPOSTOS_NAO_TRATADOS, QTD_RESCINDIDOS_TRATADOS, QTD_RESCINDIDOS_NAO_TRATADOS, QTD_VENCIDOS) 
AS(   
    select DISTINCT gmc.id_contrato CONTRATO, gmc.NOME_EMPRESA EMPRESA, gmc.tipo_periodo PERIODO, gmc.tipo_acompanhamento TIPO_ACOMPANHAMENTO,
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id   
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id     
            WHERE                 
                EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                                WHERE acomp.ID_CONTR_EMP_EST = cee.id   
                                AND acomp.TIPO_PROCESSO = 1
                                AND acomp.TIPO_REGISTRO = 0)
                AND acomp_gmc.tipo_acompanhamento = 0) AS QTD_PRORROGADOS_TRATADOS,                 
                
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id    
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id  
            WHERE  
                NOT EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                            WHERE acomp.ID_CONTR_EMP_EST = cee.id  
                            AND acomp.TIPO_PROCESSO = 1
                            AND acomp.TIPO_REGISTRO = 0)
            AND acomp_gmc.tipo_acompanhamento = 0) AS QTD_PRORROGADOS_NAO_TRATADOS,             
            
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id     
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id     
            WHERE                 
                EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                                WHERE acomp.ID_CONTR_EMP_EST = cee.id    
                                AND acomp.TIPO_PROCESSO = 1
                                AND acomp.TIPO_REGISTRO = 0)
                AND acomp_gmc.tipo_acompanhamento = 1) AS QTD_REPOSTOS_TRATADOS,
                
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id   
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id  
            WHERE  
                NOT EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                            WHERE acomp.ID_CONTR_EMP_EST = cee.id  
                            AND acomp.TIPO_PROCESSO = 1
                            AND acomp.TIPO_REGISTRO = 0)
            AND acomp_gmc.tipo_acompanhamento = 1) AS QTD_REPOSTOS_NAO_TRATADOS,   
                
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id   
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id     
            WHERE                 
                EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                                WHERE acomp.ID_CONTR_EMP_EST = cee.id    
                                AND acomp.TIPO_PROCESSO = 1
                                AND acomp.TIPO_REGISTRO = 0)
                AND acomp_gmc.tipo_acompanhamento = 2) AS QTD_RESCINDIDOS_TRATADOS,
                
        (SELECT COUNT(*)     
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id    
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id  
            WHERE  
                NOT EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp
                            WHERE acomp.ID_CONTR_EMP_EST = cee.id  
                            AND acomp.TIPO_PROCESSO = 1
                            AND acomp.TIPO_REGISTRO = 0)
            AND acomp_gmc.tipo_acompanhamento = 2) AS QTD_RESCINDIDOS_NAO_TRATADOS, 
        
        (SELECT COUNT(*)   
            FROM ACOMPANHAMENTOS_GMC acomp_gmc 
            INNER JOIN CONTRATOS_ESTUDANTES_EMPRESA cee ON acomp_gmc.ID_CONTR_EMP_EST = cee.id 
            INNER JOIN REP_CONTRATOS contrato ON acomp_gmc.id_contrato = contrato.id 
            WHERE  
                NOT EXISTS (SELECT acomp.ID_CONTR_EMP_EST FROM ACOMPANHAMENTOS_VAGAS acomp                 
                            WHERE acomp.ID_CONTR_EMP_EST = cee.id
                            AND acomp.TIPO_PROCESSO = 1
                            AND acomp.TIPO_REGISTRO = 0)   
            AND acomp_gmc.tipo_periodo = 4) as QTD_VENCIDOS
        from ACOMPANHAMENTOS_GMC gmc          
);