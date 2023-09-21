create or replace FUNCTION FUNC_VERIFICAR_CLASSIFICACAO_ANALITICO 
(p_id_consolidado IN NUMBER, p_id_item IN NUMBER) RETURN NUMBER AS 
    v_id_analitico NUMBER;
BEGIN
    SELECT id
        INTO v_id_analitico
        FROM classificacoes_estudantes_analitico 
        WHERE id_classificacao_estudante_consolidado = p_id_consolidado
        AND id_classificacao_parametros_iten = p_id_item;
    RETURN v_id_analitico;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_id_analitico := 0;
        RETURN v_id_analitico;
END FUNC_VERIFICAR_CLASSIFICACAO_ANALITICO;