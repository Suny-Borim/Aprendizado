
ALTER TABLE SERVICE_VAGAS_DEV.CLASSIFICACOES_ESTUDANTES_ANALITICO DROP CONSTRAINT KRS_INDICE_07360;
ALTER TABLE SERVICE_VAGAS_DEV.CLASSIFICACOES_ESTUDANTES_CONSOLIDADO DROP CONSTRAINT KRS_INDICE_07289;

create or replace PROCEDURE gravar_fila_estudante_lista (V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL)
IS
BEGIN
     FOR i IN 1..V_IDS_ESTUDANTES.COUNT 
     LOOP 
        EXECUTE IMMEDIATE 'INSERT  /*+ APPEND */ INTO SERVICE_VAGAS_DEV.FILA_TRIAGEM_ESTUDANTE(ID_ESTUDANTE) VALUES(:1)' USING V_IDS_ESTUDANTES(i);
        COMMIT WORK WRITE WAIT IMMEDIATE;
     END LOOP;
     EXCEPTION WHEN OTHERS THEN NULL;
END;
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

    --PROC_ATUALIZAR_TRIAGEM_ESTUDANTE_LISTA(v_lista_estudante);
    gravar_fila_estudante_lista(v_lista_estudante);

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

create or replace PROCEDURE                                                                                           PROC_CLASSIFICACOES_ESTUDANTES_CONSUMIR_FILA
AS
    VAR_TEMP_EST IDS_TYP := IDS_TYP();
    VAR_TEMP_FILA IDS_TYP := IDS_TYP();
    VAR_ERRO NUMBER;
    VAR_INICIO_PROCESSO TIMESTAMP;
    VAR_MENSAGEM VARCHAR2(4000 CHAR);
    VAR_PROCEDURE VARCHAR2(255 CHAR) := $$plsql_unit;
BEGIN
    VAR_INICIO_PROCESSO := current_timestamp;

    FOR ITEM_FILA IN (
        SELECT
            REGRA.ID AS ID_REGRA,
            REGRA.PONTO AS PONTO,
            REGRA.FAIXA AS FAIXA,
            REGRA.PERIODO AS PERIODO,
            REGRA.INDICADOR AS INDICADOR,
            CAST(COLLECT(FILA.ID_ESTUDANTE) AS IDS_TYP) AS ID_ESTUDANTES,
            CAST(COLLECT(FILA.ID) AS IDS_TYP) AS ID_ITENS_FILA

        FROM ESTUDANTES_PASSIVEIS_CLASSIFICACOES FILA
        INNER JOIN CLASSIFICACOES_PARAMETROS_ITENS REGRA ON REGRA.ID = FILA.ID_CLASSIFICACOES_PARAMETROS_ITENS

        WHERE (FILA.DELETADO IS NULL OR FILA.DELETADO = 0)
        AND (REGRA.DELETADO IS NULL OR REGRA.DELETADO = 0)

        GROUP BY REGRA.ID, REGRA.INDICADOR, REGRA.PONTO, REGRA.FAIXA, REGRA.PERIODO
    ) LOOP

        VAR_TEMP_EST := VAR_TEMP_EST MULTISET UNION DISTINCT ITEM_FILA.ID_ESTUDANTES;
        VAR_TEMP_FILA := VAR_TEMP_FILA MULTISET UNION DISTINCT ITEM_FILA.ID_ITENS_FILA;

        DELETE
            FROM CLASSIFICACOES_ESTUDANTES_ANALITICO
            WHERE ID IN(SELECT ANALITICO.ID
                            FROM CLASSIFICACOES_ESTUDANTES_ANALITICO ANALITICO
                            INNER JOIN CLASSIFICACOES_PARAMETROS_ITENS ITENS
                            ON ITENS.ID = ANALITICO.ID_CLASSIFICACAO_PARAMETROS_ITEN
                            WHERE ID_ESTUDANTE IN((SELECT COLUMN_VALUE ID_ESTUDANTE
                                                        FROM TABLE(ITEM_FILA.ID_ESTUDANTES)))
                                                        AND ITENS.ID = ITEM_FILA.ID_REGRA);

        DELETE
            FROM CLASSIFICACOES_ESTUDANTES_CONSOLIDADO CONSOLIDADO
            WHERE CONSOLIDADO.ID_ESTUDANTE IN((SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(ITEM_FILA.ID_ESTUDANTES)) );

        IF (ITEM_FILA.INDICADOR = 'ANALISE_COMPORTAMENTAL') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_ANALISE_COMPORTAMENTAL(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'REDACAO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_REDACAO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'VIDEO_APRESENTACAO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_VIDEO_APRESENTACAO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'CURSOS_CERTIFICACAO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_CURSOS_CERTIFICACAO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'FAVORITO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_FAVORITO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'TESTES_CIEE') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_TESTES_CIEE(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'VIDEO_CURRICULO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_VIDEO_CURRICULO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF(ITEM_FILA.INDICADOR = 'ESCOLA_CLASSIFICACAO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_CLAS_ESCO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF(ITEM_FILA.INDICADOR = 'FALTA_INJUSTIFICADA_ETAPA') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_FALTA_INJUST_EM_ETAPA(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF(ITEM_FILA.INDICADOR = 'SEM_RETORNO_PENDENTE') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_SEM_RET_CONVOC(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'MODULO_ESCOLA_NAO_IDENTIFICADA') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_MODULO_ESCOLA_NAO_IDENTIFICADA(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'MODULO_CAMPUS_INATIVO') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_MODULO_CAMPUS_INATIVO(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'MODULO_CONTATO_SEM_EMAIL') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_MODULO_CONTATO_SEM_EMAIL(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        ELSIF (ITEM_FILA.INDICADOR = 'MODULO_PCD_PENDENTE') THEN
            PROC_CLASSIFICACOES_ESTUDANTES_MODULO_PCD_PENDENTE(
                ITEM_FILA.ID_ESTUDANTES, ITEM_FILA.ID_REGRA, ITEM_FILA.FAIXA, ITEM_FILA.PERIODO, ITEM_FILA.PONTO, VAR_ERRO);
        END IF;

    END LOOP;

    DELETE FROM ESTUDANTES_PASSIVEIS_CLASSIFICACOES WHERE ID IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(VAR_TEMP_FILA)) );

    -- EXECUTA CALCULO CONSOLIDADO
    MERGE INTO CLASSIFICACOES_ESTUDANTES_CONSOLIDADO CONSOLIDADO
    USING (
        SELECT
            T.ID_ESTUDANTE,
            T.TOTAL,
            P.DESCRICAO AS CLASSIFICACAO
        FROM (
            SELECT ANALITICO.ID_ESTUDANTE, SUM(ANALITICO.PONTUACAO_ATUAL) AS TOTAL
            FROM CLASSIFICACOES_ESTUDANTES_ANALITICO ANALITICO
            WHERE
            (ANALITICO.DELETADO IS NOT NULL OR ANALITICO.DELETADO = 0)
            AND ANALITICO.ID_ESTUDANTE IN( (SELECT COLUMN_VALUE ID_ESTUDANTE FROM TABLE(VAR_TEMP_EST)) )
            GROUP BY ANALITICO.ID_ESTUDANTE
        ) T
        LEFT JOIN CLASSIFICACOES_PARAMETROS_PONTOS P ON P.PONTO_DE <= T.TOTAL AND P.PONTO_ATE >= T.TOTAL
    ) ANALITICO
    ON(CONSOLIDADO.ID_ESTUDANTE = ANALITICO.ID_ESTUDANTE)
    WHEN MATCHED THEN
        UPDATE SET CONSOLIDADO.PONTUACAO_OBTIDA = ANALITICO.TOTAL, CONSOLIDADO.CLASSIFICACAO_OBTIDA = ANALITICO.CLASSIFICACAO
    WHEN NOT MATCHED THEN
        INSERT(
        ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO,
        ID_ESTUDANTE, PONTUACAO_OBTIDA, CLASSIFICACAO_OBTIDA, DATA_CALCULO_PONTUACAO)
        VALUES(
            SEQ_CLASSIFICACOES_ESTUDANTES_CONSOLIDADO.NEXTVAL,
            CURRENT_TIMESTAMP,
            CURRENT_TIMESTAMP,
            VAR_PROCEDURE,
            VAR_PROCEDURE,
            0,
            ANALITICO.ID_ESTUDANTE,
            ANALITICO.TOTAL,
            ANALITICO.CLASSIFICACAO,
            CURRENT_TIMESTAMP
        );

    --PROC_ATUALIZAR_TRIAGEM_ESTUDANTE_LISTA(VAR_TEMP_EST);
    gravar_fila_estudante_lista(VAR_TEMP_EST);

    INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
        ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo)
    VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp,
        VAR_PROCEDURE, VAR_PROCEDURE, 0, var_temp_est, null, var_inicio_processo, current_timestamp);

EXCEPTION
    WHEN OTHERS THEN
        var_mensagem := sqlerrm;

        INSERT INTO classificacoes_estudantes_log (ID, data_criacao, data_alteracao, criado_por, modificado_por, deletado,
            ids_estudantes, id_classificacoes_parametros_itens, inicio_processo, fim_processo, mensagem)
        VALUES (seq_classificacoes_estudantes_log.NEXTVAL, current_timestamp, current_timestamp,
            VAR_PROCEDURE, VAR_PROCEDURE, 0, var_temp_est, null, var_inicio_processo, current_timestamp, var_mensagem);

END PROC_CLASSIFICACOES_ESTUDANTES_CONSUMIR_FILA;
/



-- TRIGGERS
ALTER TRIGGER SERVICE_VAGAS_DEV.TRIGGER_02_REP_LAUDOS_MEDICOS_INSERT_UPDATE  DISABLE;
ALTER TRIGGER SERVICE_VAGAS_DEV.TRIGGER_REP_CAMPUS_CURSO_PERIODO_BLOQUEADO_INSERT_UPDATE  DISABLE;


CREATE OR REPLACE EDITIONABLE TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_02_REP_LAUDOS_MEDICOS_INSERT_UPDATE_CLASS" 
AFTER insert ON service_vagas_dev.REP_CLASS_LAUDOS_MEDICOS
FOR EACH ROW
DECLARE
	pragma autonomous_transaction;
    v_estudante_id number := 0;
BEGIN

    DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_PCD_INC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.estudante_id||', ''MODULO_PCD_PENDENTE'');
                    END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => true,
        comments => '');
END;
/


CREATE OR REPLACE EDITIONABLE TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_REP_CAMPUS_CURSO_PERIODO_BLOQUEADO_INSERT_UPDATE_CLASS" 
    AFTER INSERT or update of bloqueado ON REP_CLASS_CAMPUS_CURSOS_PERIODOS
    FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''MODULO_CAMPUS_INATIVO'');
                    END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
END;
/


