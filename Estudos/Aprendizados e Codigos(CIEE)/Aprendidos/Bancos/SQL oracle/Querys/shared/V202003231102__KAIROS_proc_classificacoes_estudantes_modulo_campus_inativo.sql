create or replace PROCEDURE proc_classificacoes_estudantes_modulo_campus_inativo (
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
       USING (SELECT ee.id_estudante, COUNT(ee.ID)
                FROM rep_escolaridades_estudantes ee
                INNER JOIN rep_campus_cursos_periodos P ON (P.ID = ee.id_periodo_curso)
                INNER JOIN rep_campus_cursos cc ON (cc.ID = P.id_campus_curso)
                INNER JOIN rep_campus C ON (C.ID = cc.id_campus)
                WHERE ee.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND (C.ativo = 0 OR cc.bloqueado = 1 OR P.bloqueado = 1)
                    AND ( datediff('DD', ee.data_alteracao, sysdate) >= 0 )
                    AND ( datediff('DD', ee.data_alteracao, sysdate) <= p_periodo )
                GROUP BY ee.id_estudante) ceas
            ON (cea.id_estudante = ceas.id_estudante AND cea.id_classificacao_parametros_iten = p_id_item)
       WHEN MATCHED THEN
            UPDATE SET data_alteracao = current_timestamp, pontuacao_atual = v_pontos
       WHEN NOT MATCHED THEN
            INSERT (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                    id_estudante, pontuacao_atual, id_classificacao_parametros_iten)
            VALUES (seq_classificacoes_estudantes_analitico.NEXTVAL, current_timestamp, current_timestamp, 
                    v_procedure,v_procedure,0,
                    ceas.id_estudante, v_pontos, p_id_item);

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

END proc_classificacoes_estudantes_modulo_campus_inativo;