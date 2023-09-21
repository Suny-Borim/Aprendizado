create or replace PROCEDURE proc_classificacoes_estudantes_analise_comportamental (
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
                FROM rep_class_estudantes E
                INNER JOIN avaliacoes_comportamentais_status A ON (A.id_estudante = E.ID )
                WHERE A.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND A.status = 1
                    AND ( (CAST(sysdate AS DATE) - CAST(A.data_alteracao AS DATE)) >= 0 )
                    AND ( (CAST(sysdate AS DATE) - CAST(A.data_alteracao AS DATE)) <= p_periodo )
                    AND A.deletado = 0
                    AND E.deletado = 0
                    AND E.situacao = 'ATIVO'
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

END proc_classificacoes_estudantes_analise_comportamental;
/


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

        FROM REP_CLASS_ESTUDANTES E

        INNER JOIN REP_CLASS_ESCOLARIDADES_ESTUDANTES EE ON (E.ID = EE.ID_ESTUDANTE)
        INNER JOIN REP_CLASS_IE_ACORDOS_COOPERACAO AC ON (AC.ID_INSTITUICAO_ENSINO = EE.ID_ESCOLA)
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
/


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
                    FROM rep_class_idiomas_niveis ni
                    WHERE ni.estudante_id IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                        AND ni.documento_id IS NOT NULL
                        AND ( (CAST(sysdate AS DATE) - CAST(ni.data_alteracao AS DATE)) >= 0 )
                        AND ( (CAST(sysdate AS DATE) - CAST(ni.data_alteracao AS DATE)) <= p_periodo )
                        AND ni.deletado = 0
                    GROUP BY ni.estudante_id
                UNION ALL
                SELECT ci.id_estudante AS ID, COUNT(ci.id_estudante) AS qtd_certificado
                    FROM rep_class_conhecimentos_informatica ci
                    WHERE ci.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                        AND ci.id_documento IS NOT NULL
                        AND ( (CAST(sysdate AS DATE) - CAST(ci.data_alteracao AS DATE)) >= 0 )
                        AND ( (CAST(sysdate AS DATE) - CAST(ci.data_alteracao AS DATE)) <= p_periodo )
                        AND ci.deletado = 0
                    GROUP BY ci.id_estudante
                UNION ALL
                SELECT cd.id_estudante AS ID, COUNT(cd.id_estudante) AS qtd_certificado
                    FROM rep_class_conhecimentos_diversos_student cd
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
/


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
                FROM rep_class_estudantes E
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
/



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
    v_lista_estudante IDS_TYP;
BEGIN
    v_pontos := p_pontos;
    v_inicio_processo := current_timestamp;
    v_lista_estudante := p_lista_estudante;
    dbms_output.put_line(v_procedure);

    IF (p_lista_estudante IS NULL OR p_lista_estudante IS EMPTY) THEN
        SELECT CAST(COLLECT(ee.id_estudante) AS IDS_TYP)
        INTO v_lista_estudante
        FROM rep_class_escolaridades_estudantes ee
                 INNER JOIN rep_class_campus_cursos_periodos P ON (P.ID = ee.id_periodo_curso)
                 INNER JOIN rep_class_campus_cursos cc ON (cc.ID = P.id_campus_curso)
                 INNER JOIN rep_class_campus C ON (C.ID = cc.id_campus)
        WHERE (C.ativo = 0 OR cc.bloqueado = 1 OR P.bloqueado = 1)
          AND ( datediff('DD', ee.data_alteracao, sysdate) >= 0 )
          AND ( datediff('DD', ee.data_alteracao, sysdate) <= p_periodo )
        ;

        DELETE
        FROM CLASSIFICACOES_ESTUDANTES_ANALITICO
        WHERE ID IN(SELECT ANALITICO.ID
                    FROM CLASSIFICACOES_ESTUDANTES_ANALITICO ANALITICO
                             INNER JOIN CLASSIFICACOES_PARAMETROS_ITENS ITENS
                                        ON ITENS.ID = ANALITICO.ID_CLASSIFICACAO_PARAMETROS_ITEN
                    WHERE ID_ESTUDANTE IN((SELECT COLUMN_VALUE ID_ESTUDANTE
                                           FROM TABLE(v_lista_estudante)))
                      AND ITENS.ID = p_id_item);
    end if;


    MERGE INTO classificacoes_estudantes_analitico cea
    USING (SELECT ee.id_estudante, COUNT(ee.ID)
           FROM rep_class_escolaridades_estudantes ee
                    INNER JOIN rep_class_campus_cursos_periodos P ON (P.ID = ee.id_periodo_curso)
                    INNER JOIN rep_class_campus_cursos cc ON (cc.ID = P.id_campus_curso)
                    INNER JOIN rep_class_campus C ON (C.ID = cc.id_campus)
           WHERE (ee.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(v_lista_estudante)))
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

    MERGE INTO classificacoes_estudantes_consolidado consolidado
    USING (
        SELECT
            T.ID_ESTUDANTE,
            T.TOTAL,
            P.DESCRICAO AS CLASSIFICACAO
        FROM (
                 SELECT ANALITICO.ID_ESTUDANTE, SUM(ANALITICO.PONTUACAO_ATUAL) AS TOTAL
                 FROM classificacoes_estudantes_analitico ANALITICO
                 WHERE
                     (ANALITICO.DELETADO IS NOT NULL OR ANALITICO.DELETADO = 0)
                   AND ANALITICO.ID_ESTUDANTE IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(v_lista_estudante)) )
                 GROUP BY ANALITICO.ID_ESTUDANTE
             ) T
                 LEFT JOIN classificacoes_parametros_pontos P ON P.PONTO_DE <= T.TOTAL AND P.PONTO_ATE >= T.TOTAL
    ) ANALITICO
    ON(CONSOLIDADO.ID_ESTUDANTE = ANALITICO.ID_ESTUDANTE)
    WHEN MATCHED THEN
        UPDATE SET CONSOLIDADO.PONTUACAO_OBTIDA = ANALITICO.TOTAL, CONSOLIDADO.CLASSIFICACAO_OBTIDA = ANALITICO.CLASSIFICACAO
    WHEN NOT MATCHED THEN
        INSERT(
            ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO,
            ID_ESTUDANTE, PONTUACAO_OBTIDA, CLASSIFICACAO_OBTIDA, DATA_CALCULO_PONTUACAO)
        VALUES(
                  seq_classificacoes_estudantes_consolidado.NEXTVAL,
                  CURRENT_TIMESTAMP,
                  CURRENT_TIMESTAMP,
                  v_procedure,
                  v_procedure,
                  0,
                  ANALITICO.ID_ESTUDANTE,
                  ANALITICO.TOTAL,
                  ANALITICO.CLASSIFICACAO,
                  CURRENT_TIMESTAMP
              );

    PROC_ATUALIZAR_TRIAGEM_ESTUDANTE_LISTA(v_lista_estudante);

    INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                                               ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo)
    VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp,
            v_procedure,v_procedure,0,
            v_lista_estudante, p_id_item, v_inicio_processo, current_timestamp);

EXCEPTION
    WHEN OTHERS THEN
        p_erro := 1;
        v_mensagem := sqlerrm;

        INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
                                                   ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp,
                v_procedure,v_procedure,0,
                v_lista_estudante, p_id_item, v_inicio_processo, current_timestamp, v_mensagem);

END proc_classificacoes_estudantes_modulo_campus_inativo;
/


create or replace PROCEDURE proc_classificacoes_estudantes_modulo_contato_sem_email (
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
       USING (SELECT e.id as id, SUM(qtd) AS qtd 
                FROM (
                SELECT id_estudante as id, COUNT(ID) AS qtd 
                    FROM rep_class_emails
                    WHERE verificado = 0
                        AND email IS NOT NULL
                        AND id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    GROUP BY id_estudante
                UNION ALL
                SELECT id_estudante as id, COUNT(id_estudante) AS qtd 
                    FROM rep_class_telefones R
                    WHERE((R.verificado = 0 AND R.tipo_telefone = 'CELULAR')
                            OR R.telefone = '(11) 11111111')
                        AND EXISTS (
                            SELECT id_estudante FROM rep_class_telefones T
                            WHERE T.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                            AND T.id_estudante = R.id_estudante
                            GROUP BY T.id_estudante 
                            HAVING COUNT(T.id_estudante) = 1)
                    GROUP BY id_estudante) e
                GROUP BY e.id) ceas
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

END proc_classificacoes_estudantes_modulo_contato_sem_email;
/



create or replace PROCEDURE proc_classificacoes_estudantes_modulo_escola_nao_identificada (
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
       USING (SELECT ee.id_estudante, nvl(COUNT(ee.ID),0)
                FROM rep_class_escolaridades_estudantes ee
                WHERE ee.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND (ee.id_periodo_curso IS NULL OR ee.id_escola IS NULL)
                    AND ee.deletado = 0
                    AND ( datediff('DD', ee.data_criacao, sysdate) >= 0 )
                    AND ( datediff('DD', ee.data_criacao, sysdate) <= p_periodo )
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

END proc_classificacoes_estudantes_modulo_escola_nao_identificada;
/


create or replace PROCEDURE proc_classificacoes_estudantes_modulo_pcd_pendente (
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
       USING (SELECT E.ID, COUNT(1) 
                FROM rep_class_estudantes E
                LEFT JOIN rep_class_laudos_medicos L ON (L.estudante_id = E.ID)
                LEFT JOIN rep_class_laudos_medicos_documentos D ON (D.laudo_medico_id = L.ID)
                WHERE E.ID IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND E.pcd = 1
                    AND (D.documento_id IS NULL OR D.data_vencimento < sysdate OR D.status = 'REPROVADO')
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

END proc_classificacoes_estudantes_modulo_pcd_pendente;
/



create or replace PROCEDURE proc_classificacoes_estudantes_redacao(
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
       USING (SELECT e.ID, func_interpretar_expressao(REPLACE(p_faixa, '$', COUNT(1)))
                FROM REP_CLASS_ESTUDANTES e
                INNER JOIN rep_class_redacoes_student rd ON (rd.id_estudante = E.ID )
                WHERE rd.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND E.situacao = 'ATIVO'
                    AND rd.conteudo IS NOT NULL
                    AND rd.data_termino IS NOT NULL
                    AND ((CAST(sysdate AS DATE) - CAST(rd.data_termino AS DATE)) >= 0 )
                    AND ((CAST(sysdate AS DATE) - CAST(rd.data_termino AS DATE)) <= 365 )
                    AND E.deletado = 0
                    AND rd.deletado = 0
                GROUP BY e.ID) ceas
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

END proc_classificacoes_estudantes_redacao;
/



create or replace PROCEDURE proc_classificacoes_estudantes_testes_ciee (
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
       USING (SELECT E.ID
                FROM rep_class_estudantes E
                INNER JOIN rep_class_provas_online_curriculos_estudantes_student P ON (P.id_estudante = E.ID)
                WHERE P.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND P.data_conclusao_prova IS NOT NULL
                    AND P.status = 1
                    AND ( (CAST(sysdate AS DATE) - CAST(P.data_conclusao_prova AS DATE)) >= 0 )
                    AND ( (CAST(sysdate AS DATE) - CAST(P.data_conclusao_prova AS DATE)) <= p_periodo )
                    AND P.deletado = 0
                    AND E.deletado = 0
                    AND E.situacao = 'ATIVO'
                GROUP BY e.ID
                HAVING func_interpretar_expressao(REPLACE(p_faixa, '$', COUNT(1))) = 1) ceas
            ON (cea.id_estudante = ceas.ID AND cea.id_classificacao_parametros_iten IN( 
                SELECT ID FROM CLASSIFICACOES_PARAMETROS_ITENS WHERE INDICADOR = 'TESTES_CIEE'
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

END proc_classificacoes_estudantes_testes_ciee;
/



create or replace PROCEDURE proc_classificacoes_estudantes_video_apresentacao (
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
       USING (SELECT e.ID, func_interpretar_expressao(REPLACE(p_faixa, '$', COUNT(1)))
                FROM rep_class_estudantes e
                WHERE e.id IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND e.video_url IS NOT NULL
                    AND ( (CAST(sysdate AS DATE) - CAST(e.data_alteracao AS DATE)) >= 0 )
                    AND ( (CAST(sysdate AS DATE) - CAST(e.data_alteracao AS DATE)) <= p_periodo )
                    AND e.deletado = 0
                    AND e.situacao = 'ATIVO'
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

END proc_classificacoes_estudantes_video_apresentacao;
/



create or replace PROCEDURE proc_classificacoes_estudantes_video_curriculo (
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
       USING (SELECT e.ID, func_interpretar_expressao(REPLACE(p_faixa, '$', COUNT(1)))
                FROM rep_class_estudantes e
                INNER JOIN rep_class_videos_curriculos_estudantes_student v ON ( v.id_estudante = e.id )
                WHERE
                    v.id_estudante IN (SELECT COLUMN_VALUE FROM TABLE(p_lista_estudante))
                    AND v.url_videos_curriculos IS NOT NULL
                    AND ( (CAST(sysdate AS DATE) - CAST(v.data_alteracao AS DATE)) >= 0 )
                    AND ( (CAST(sysdate AS DATE) - CAST(v.data_alteracao AS DATE)) <= p_periodo )
                    AND v.deletado = 0
                    AND e.deletado = 0
                    AND e.situacao = 'ATIVO'
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

END proc_classificacoes_estudantes_video_curriculo;
/