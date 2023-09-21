create or replace PROCEDURE PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA
(
    PARAM_ID_ESTUDANTE IN NUMBER,
    PARAM_INDICADOR IN VARCHAR2 := null
) AS
    V_QTD_ESTUDANTE NUMBER;
    V_INICIO_PROCESSO TIMESTAMP;
    V_MENSAGEM VARCHAR2(4000 CHAR);
    V_PROCEDURE VARCHAR2(255 CHAR) := $$plsql_unit;
BEGIN
    v_inicio_processo := current_timestamp;
    
    -- VERIFICA SE EXISTE O ESTUDANTE ESTÁ ATIVO E CUSTANDO SU || TE
    SELECT COUNT(E.ID) 
        INTO V_QTD_ESTUDANTE 
        FROM REP_ESCOLARIDADES_ESTUDANTES EE
        INNER JOIN REP_ESTUDANTES E ON E.ID = EE.ID_ESTUDANTE
        WHERE E.DELETADO = 0
            AND EE.DELETADO = 0
            AND E.SITUACAO = 'ATIVO'
            AND SIGLA_NIVEL_EDUCACAO IN('SU', 'TE')
            AND STATUS_ESCOLARIDADE IN('CURSANDO')
            AND E.ID = PARAM_ID_ESTUDANTE;

    -- ADICIONA O ESTUDANTE NA FILA
    IF (V_QTD_ESTUDANTE > 0) THEN
        FOR item IN
          (Select id
            from classificacoes_parametros_itens
            where indicador = PARAM_INDICADOR)
        LOOP
            INSERT INTO ESTUDANTES_PASSIVEIS_CLASSIFICACOES (ID, ID_ESTUDANTE, ID_CLASSIFICACOES_PARAMETROS_ITENS, 
                DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO)
            VALUES(SEQ_ESTUDANTES_PASSIVEIS_CLASSIFICACOES.NEXTVAL, PARAM_ID_ESTUDANTE, item.id,
                CURRENT_DATE, CURRENT_DATE, V_PROCEDURE, V_PROCEDURE, 0);
        END LOOP;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        v_mensagem := sqlerrm;

        INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
            ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp, 
            v_procedure, v_procedure, 0, null, null, v_inicio_processo, current_timestamp, v_mensagem);

END PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA;