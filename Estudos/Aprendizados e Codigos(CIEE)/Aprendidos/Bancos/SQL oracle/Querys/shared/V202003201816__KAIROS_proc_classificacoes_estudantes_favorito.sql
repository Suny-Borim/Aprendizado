create or replace PROCEDURE proc_classificacoes_estudantes_favorito (
    p_lista_estudante IN ids_typ,
    p_id_item IN NUMBER,
    p_faixa IN VARCHAR2,
    p_periodo IN NUMBER,
    p_pontos IN NUMBER,
    p_erro OUT NUMBER)
AS
    v_inicio_processo TIMESTAMP;
    v_id_estudante NUMBER;
    v_pontos NUMBER;
    v_ret_qtd NUMBER;
    v_ret_expr NUMBER;
    v_mensagem VARCHAR2(4000 CHAR);
    v_procedure VARCHAR2(255 CHAR) := $$plsql_unit;
BEGIN
    v_pontos := p_pontos;
    v_inicio_processo := current_timestamp;
    dbms_output.put_line(v_procedure);

    MERGE INTO classificacoes_estudantes_analitico cea
       USING (SELECT E.ID, func_interpretar_expressao(REPLACE(p_faixa, '$', COUNT(1)))
                FROM rep_estudantes E
                INNER JOIN favoritos F ON (F.id_candidato = E.ID)
                WHERE E.ID IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND E.situacao = 'ATIVO'
                    AND E.deletado = 0
                GROUP BY E.ID) ceas
            ON (cea.id_estudante = ceas.ID AND cea.id_classificacao_parametros_iten = p_id_item)
       WHEN MATCHED THEN
            UPDATE SET data_alteracao = current_timestamp, pontuacao_atual = v_pontos
       WHEN NOT MATCHED THEN
            INSERT (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                    id_estudante, pontuacao_atual, id_classificacao_parametros_iten)
            VALUES (seq_classificacoes_estudantes_analitico.NEXTVAL, current_timestamp, current_timestamp, 
                    v_procedure,v_procedure,0,
                    ceas.ID, v_pontos, p_id_item);

    INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
        ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo)
    VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp, 
            v_procedure,v_procedure,0, 
            p_lista_estudante, p_id_item, v_inicio_processo, current_timestamp);

EXCEPTION
    WHEN OTHERS THEN
        p_erro := 1;
        v_mensagem := sqlerrm;

        INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
            ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp, 
                v_procedure,v_procedure,0, 
                p_lista_estudante, p_id_item, v_inicio_processo, current_timestamp, v_mensagem);

END proc_classificacoes_estudantes_favorito;