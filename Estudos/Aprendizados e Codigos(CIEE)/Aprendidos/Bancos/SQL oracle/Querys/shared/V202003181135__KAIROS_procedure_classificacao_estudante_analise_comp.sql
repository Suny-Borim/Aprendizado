create or replace PROCEDURE proc_classificacoes_estudantes_analise_comportamental (
    p_id_estudante in number, 
    p_id_item in number, 
    p_id_consolidado number,
    p_faixa in varchar2, 
    p_periodo in number, 
    p_pontos in number,
    p_erro out number)
AS
    v_data_criacao TIMESTAMP;
    v_retorno NUMBER;
    v_ret_expr NUMBER;
    v_id_existente NUMBER;
BEGIN

    SELECT a.data_criacao, count(a.id_estudante)
        INTO v_data_criacao, v_retorno
        FROM REP_ESTUDANTES e
        INNER JOIN AVALIACOES_COMPORTAMENTAIS_STATUS a on (a.id_estudante = e.id )
        WHERE e.id = p_id_estudante
        AND e.situacao = 'ATIVO'
        AND a.status = 1
        AND ( datediff('DD', a.data_criacao, sysdate) <= p_periodo )
        AND e.deletado = 0
        AND a.deletado = 0
        GROUP BY a.data_criacao, a.id_estudante;
        
    v_id_existente := func_verificar_classificacao_analitico(p_id_consolidado, p_id_item);
    
    v_ret_expr := func_interpretar_expressao(replace(p_faixa, '$', v_retorno));
    
    IF v_ret_expr = 1 THEN
        
        IF v_id_existente != 0 THEN
        
            UPDATE classificacoes_estudantes_analitico 
            SET data_alteracao = CURRENT_TIMESTAMP,
                pontuacao_atual = p_pontos
            WHERE id = v_id_existente;
        ELSE

            INSERT INTO classificacoes_estudantes_analitico (id, 
                data_criacao, data_alteracao, id_classificacao_estudante_consolidado, 
                pontuacao_atual, id_classificacao_parametros_iten)
            VALUES (SEQ_CLASSIFICACOES_ESTUDANTES_ANALITICO.nextval, 
                CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, p_id_consolidado,
                p_pontos, p_id_item);
        END IF;
    END IF;

EXCEPTION 
    WHEN OTHERS THEN
    
        p_erro := 1;
        
END proc_classificacoes_estudantes_analise_comportamental;