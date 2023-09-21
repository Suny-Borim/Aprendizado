create or replace PROCEDURE proc_classificacoes_estudantes_cursos_certificacao (
    p_lista_estudante IN ids_typ,
    p_id_item IN NUMBER,
    p_faixa IN VARCHAR2,
    p_periodo IN NUMBER,
    p_pontos IN NUMBER,
    p_erro OUT NUMBER)
AS
    v_inicio_processo TIMESTAMP;
    v_pontos NUMBER;
    v_mensagem VARCHAR2(4000 CHAR);
    v_procedure VARCHAR2(255 CHAR) := $$plsql_unit;
BEGIN
    v_pontos := p_pontos;
    v_inicio_processo := current_timestamp;
    dbms_output.put_line(v_procedure);

    MERGE INTO classificacoes_estudantes_analitico cea
       USING (SELECT id
                FROM ( 
                SELECT ni.estudante_id AS ID, COUNT(ni.estudante_id) AS qtd_certificado  
                    FROM rep_idiomas_niveis ni
                    WHERE ni.estudante_id IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                        AND ni.documento_id IS NOT NULL
                        AND ( (CAST(sysdate AS DATE) - CAST(ni.data_alteracao AS DATE)) >= 0 )
                        AND ( (CAST(sysdate AS DATE) - CAST(ni.data_alteracao AS DATE)) <= p_periodo )
                        AND ni.deletado = 0
                    GROUP BY ni.estudante_id
                UNION ALL
                SELECT ci.id_estudante AS ID, COUNT(ci.id_estudante) AS qtd_certificado
                    FROM rep_conhecimentos_informatica ci
                    WHERE ci.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                        AND ci.id_documento IS NOT NULL
                        AND ( (CAST(sysdate AS DATE) - CAST(ci.data_alteracao AS DATE)) >= 0 )
                        AND ( (CAST(sysdate AS DATE) - CAST(ci.data_alteracao AS DATE)) <= p_periodo )
                        AND ci.deletado = 0
                    GROUP BY ci.id_estudante
                UNION ALL
                SELECT cd.id_estudante AS ID, COUNT(cd.id_estudante) AS qtd_certificado
                    FROM rep_conhecimentos_diversos_student cd
                    WHERE cd.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                        AND cd.id_documento IS NOT NULL
                        AND cd.data_termino IS NOT NULL
                        AND ( (CAST(sysdate AS DATE) - CAST(cd.data_alteracao AS DATE)) >= 0 )
                        AND ( (CAST(sysdate AS DATE) - CAST(cd.data_alteracao AS DATE)) <= p_periodo )
                        AND cd.deletado = 0
                    GROUP BY cd.id_estudante) e
                GROUP BY e.id
                HAVING func_interpretar_expressao(REPLACE(p_faixa, '$', SUM(qtd_certificado))) = 1) ceas
            ON (cea.id_estudante = ceas.ID AND cea.id_classificacao_parametros_iten IN( 
                SELECT ID FROM CLASSIFICACOES_PARAMETROS_ITENS WHERE INDICADOR = 'CURSOS_CERTIFICACAO'
            ))
       WHEN MATCHED THEN
            UPDATE SET data_alteracao = current_timestamp, 
                pontuacao_atual = v_pontos, 
                id_classificacao_parametros_iten = p_id_item
       WHEN NOT MATCHED THEN
            INSERT (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                id_estudante, pontuacao_atual, id_classificacao_parametros_iten)
            VALUES (seq_classificacoes_estudantes_analitico.NEXTVAL, current_timestamp, current_timestamp, 
                v_procedure, v_procedure, 0, ceas.ID, v_pontos, p_id_item);

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
            v_procedure, v_procedure, 0, p_lista_estudante, p_id_item, v_inicio_processo, current_timestamp, v_mensagem);

END proc_classificacoes_estudantes_cursos_certificacao;