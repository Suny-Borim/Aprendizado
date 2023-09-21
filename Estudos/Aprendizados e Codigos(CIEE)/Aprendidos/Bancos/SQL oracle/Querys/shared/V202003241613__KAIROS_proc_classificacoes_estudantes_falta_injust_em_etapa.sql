create or replace PROCEDURE PROC_CLASSIFICACOES_ESTUDANTES_FALTA_INJUST_EM_ETAPA
(
    P_LISTA_ESTUDANTE IN IDS_TYP,
    P_ID_ITEM IN NUMBER,
    P_FAIXA IN VARCHAR2,
    P_PERIODO IN NUMBER,
    P_PONTOS IN NUMBER,
    P_ERRO OUT NUMBER
) AS

    V_RETORNO NUMBER;
    V_DATA TIMESTAMP;
    V_DATA_INICIAL TIMESTAMP;
    V_INICIO_PROCESSO TIMESTAMP;
    V_PROCEDURE VARCHAR2(255 CHAR) := $$PLSQL_UNIT;
    V_MENSAGEM VARCHAR2(4000 CHAR);
BEGIN
    V_DATA := SYSDATE - 10;
    V_DATA_INICIAL := SYSDATE - P_PERIODO;
    V_INICIO_PROCESSO := CURRENT_TIMESTAMP;

    MERGE INTO CLASSIFICACOES_ESTUDANTES_ANALITICO A
        USING (SELECT T.ID_ESTUDANTE FROM (SELECT
    
                VV.ID_ESTUDANTE AS ID_ESTUDANTE,
                COUNT(VV.ID_ESTUDANTE) AS QTD_FALTA
    
            FROM RESULTADOS_PROCESSO_SELETIVO R
    
            INNER JOIN ESTUDANTES_AGENDA EA ON (EA.ID = R.ID_ESTUDANTE_AGENDA)
            INNER JOIN VINCULOS_VAGA VV ON (VV.ID = EA.ID_VINCULO_VAGA)
    
            WHERE R.SITUACAO = 2
                AND (R.AUSENCIA_JUSTIFICADA IS NULL OR R.AUSENCIA_JUSTIFICADA = 0)
                AND VV.ID_ESTUDANTE IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(P_LISTA_ESTUDANTE)) )
                AND SITUACAO = 2
                AND R.DATA_ALTERACAO BETWEEN V_DATA_INICIAL AND V_DATA
    
            GROUP BY VV.ID_ESTUDANTE
            HAVING FUNC_INTERPRETAR_EXPRESSAO(REPLACE(P_FAIXA, '$', COUNT(VV.ID_ESTUDANTE))) = 1) T
        ) B
        ON (A.ID_ESTUDANTE = B.ID_ESTUDANTE AND A.ID_CLASSIFICACAO_PARAMETROS_ITEN IN( 
                SELECT ID FROM CLASSIFICACOES_PARAMETROS_ITENS WHERE INDICADOR = 'FALTA_INJUSTIFICADA_ETAPA'
            ))
    WHEN MATCHED THEN 
        UPDATE SET A.PONTUACAO_ATUAL = P_PONTOS, 
            A.DATA_ALTERACAO = CURRENT_TIMESTAMP, 
            ID_CLASSIFICACAO_PARAMETROS_ITEN = P_ID_ITEM
    WHEN NOT MATCHED THEN 
        INSERT (
            A.ID,
            A.DATA_CRIACAO,
            A.DATA_ALTERACAO,
            A.CRIADO_POR,
            A.MODIFICADO_POR,
            A.DELETADO,
            A.PONTUACAO_ATUAL,
            A.ID_CLASSIFICACAO_PARAMETROS_ITEN,
            A.ID_ESTUDANTE
        )
        VALUES (
            SEQ_CLASSIFICACOES_ESTUDANTES_ANALITICO.NEXTVAL,
            CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP,
            V_PROCEDURE,
            V_PROCEDURE,
            0,
            P_PONTOS,
            P_ID_ITEM,
            B.ID_ESTUDANTE
        );

    INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
        ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo)
    VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp, 
        v_procedure, v_procedure, 0, p_lista_estudante, p_id_item, v_inicio_processo, current_timestamp);

EXCEPTION
    WHEN OTHERS THEN
        p_erro := 1;
        v_mensagem := sqlerrm;

        INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
            ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp, 
            v_procedure, v_procedure,0, p_lista_estudante, p_id_item, v_inicio_processo, current_timestamp, v_mensagem);

END PROC_CLASSIFICACOES_ESTUDANTES_FALTA_INJUST_EM_ETAPA;