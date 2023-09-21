create or replace PROCEDURE PROC_CLASSIFICACOES_ESTUDANTES_CLAS_ESCO 
(
    P_LISTA_ESTUDANTE IN IDS_TYP,
    P_ID_ITEM IN NUMBER,
    P_FAIXA IN VARCHAR2,
    P_PERIODO IN NUMBER,
    P_PONTOS IN NUMBER,
    P_ERRO OUT NUMBER
) AS
    v_inicio_processo TIMESTAMP;
    v_mensagem VARCHAR2(4000 CHAR);
    v_procedure VARCHAR2(255 CHAR) := $$plsql_unit;
BEGIN
    v_inicio_processo := current_timestamp;
    dbms_output.put_line(v_procedure);
    
    MERGE INTO CLASSIFICACOES_ESTUDANTES_ANALITICO A
    USING (
        SELECT

        E.ID AS ID_ESTUDANTE, 
        CASE WHEN EN.CLASSIFICACAO IS NULL THEN 'C' ELSE EN.CLASSIFICACAO END AS LETRA

        FROM REP_ESTUDANTES E

        INNER JOIN REP_ESCOLARIDADES_ESTUDANTES EE ON (E.ID = EE.ID_ESTUDANTE)
        INNER JOIN REP_IE_ACORDOS_COOPERACAO AC ON (AC.ID_INSTITUICAO_ENSINO = EE.ID_ESCOLA)
        LEFT JOIN CLASSIFICACOES_IES_ENAD EN ON (EN.CONVENIO_IE_KAIROS = AC.CODIGO_CONVENIO)

        WHERE
            E.DELETADO = 0
            AND EE.DELETADO = 0
            AND E.SITUACAO = 'ATIVO'
            AND EE.SIGLA_NIVEL_EDUCACAO IN('SU', 'TE')
            AND EE.STATUS_ESCOLARIDADE IN('CURSANDO')
            AND EE.ID_ESTUDANTE IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(P_LISTA_ESTUDANTE)) )
            AND FUNC_INTERPRETAR_EXPRESSAO(REPLACE(P_FAIXA, '$', CASE WHEN EN.CLASSIFICACAO IS NULL THEN 'C' ELSE EN.CLASSIFICACAO END)) = 1

    ) B
    ON (A.ID_ESTUDANTE = B.ID_ESTUDANTE AND A.ID_CLASSIFICACAO_PARAMETROS_ITEN IN(
        SELECT ID FROM CLASSIFICACOES_PARAMETROS_ITENS WHERE INDICADOR = 'CURSOS_CERTIFICACAO'
    ))
    WHEN MATCHED THEN UPDATE SET A.PONTUACAO_ATUAL = P_PONTOS,
    A.ID_CLASSIFICACAO_PARAMETROS_ITEN = P_ID_ITEM
    WHEN NOT MATCHED THEN INSERT (
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
            'PROC_CLASSIFICACOES_ESTUDANTES_CLAS_ESCO',
            'PROC_CLASSIFICACOES_ESTUDANTES_CLAS_ESCO',
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

END PROC_CLASSIFICACOES_ESTUDANTES_CLAS_ESCO;