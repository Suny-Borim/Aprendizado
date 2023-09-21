CREATE OR REPLACE PROCEDURE PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA_SEM_VER_ESCOL
(
    PARAM_ID_ESTUDANTE IN NUMBER,
    PARAM_INDICADOR IN VARCHAR2 := null
) AS
    V_INICIO_PROCESSO TIMESTAMP;
    V_MENSAGEM VARCHAR2(4000 CHAR);
    V_PROCEDURE VARCHAR2(255 CHAR) := $$plsql_unit;
    /*
        - Jorge Tomé - 17/08/21
        - Essa proc foi criada como uma copia da PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA,
        sem o teste de escolariadade, a mesma será utilizada apenas pela trigger na tabela
        vinculos_vagas, o entendimento aqui é que o estudante que já passou por uma triagem
        e esta na vinculos_vagas, já tem escolariadade valida.
        - O objetivo é melhorar a performance da trigger na vinculos_vagas.
    */
BEGIN
    v_inicio_processo := current_timestamp;

    -- ADICIONA O ESTUDANTE NA FILA
    FOR item IN (SELECT ID FROM SERVICE_VAGAS_DEV.CLASSIFICACOES_PARAMETROS_ITENS WHERE INDICADOR = PARAM_INDICADOR)
        LOOP
            INSERT INTO SERVICE_VAGAS_DEV.ESTUDANTES_PASSIVEIS_CLASSIFICACOES (ID, ID_ESTUDANTE, ID_CLASSIFICACOES_PARAMETROS_ITENS,
                                                                               DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO)
            VALUES(SEQ_ESTUDANTES_PASSIVEIS_CLASSIFICACOES.NEXTVAL, PARAM_ID_ESTUDANTE, item.id,
                   CURRENT_DATE, CURRENT_DATE, V_PROCEDURE, V_PROCEDURE, 0);
        END LOOP;


EXCEPTION
    WHEN OTHERS THEN
        v_mensagem := sqlerrm;

        INSERT INTO SERVICE_VAGAS_DEV.classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                                                                     ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp,
                v_procedure, v_procedure, 0, null, null, v_inicio_processo, current_timestamp, v_mensagem);

END PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA_SEM_VER_ESCOL;