create or replace PROCEDURE proc_atualizar_triagem_estudante_filtro (
    V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL
)
    IS
BEGIN

    -- EXCLUI OS ESTUDANTES DO FILTRO
    DELETE FROM SERVICE_VAGAS_DEV.TRIAGENS_ESTUDANTES_FILTRO WHERE
        EXISTS(SELECT 1 FROM TABLE(V_IDS_ESTUDANTES) t WHERE ID_ESTUDANTE = t.column_value);


    -- INCLUI OS ESTUDANTES NO FILTRO COM OS DADOS ATUALIZADOS
    INSERT INTO SERVICE_VAGAS_DEV.TRIAGENS_ESTUDANTES_FILTRO (
        id_estudante,
        endereco_geohash,
        codigo_curso_principal,
        status_escolaridade,
        pontuacao_obtida,
        pcd,
        NIVEL_ENSINO,
        DATA_ALTERACAO
    )
    WITH TEMP_ESTUDANTES AS (
        SELECT
            ID_ESTUDANTE,
            endereco_geohash,
            endereco_campus_geohash,
            CODIGO_CURSO_PRINCIPAL,
            STATUS_ESCOLARIDADE,
            PONTUACAO_OBTIDA,
            CASE WHEN CARDINALITY(E.PCDS) > 0 THEN 1 ELSE 0 END as PCD,
            NIVEL_ENSINO,
            DATA_ALTERACAO,
            CURSO_EAD
        FROM
            TRIAGENS_ESTUDANTES E
        WHERE
            EXISTS(SELECT 1 FROM TABLE(V_IDS_ESTUDANTES) t WHERE E.ID_ESTUDANTE = t.column_value)
          AND E.APTO_TRIAGEM = 1
    )
         -- ENDERECO CASA 5 POSICOES
    SELECT ID_ESTUDANTE, endereco_geohash, CODIGO_CURSO_PRINCIPAL, STATUS_ESCOLARIDADE, PONTUACAO_OBTIDA, PCD, NIVEL_ENSINO, DATA_ALTERACAO FROM TEMP_ESTUDANTES
    WHERE endereco_geohash is not null and endereco_geohash != '00000'
    UNION
    -- ENDERECO CASA 4 POSICOES
    SELECT ID_ESTUDANTE, substr(endereco_geohash,1,4), CODIGO_CURSO_PRINCIPAL, STATUS_ESCOLARIDADE, PONTUACAO_OBTIDA, PCD, NIVEL_ENSINO, DATA_ALTERACAO FROM TEMP_ESTUDANTES
    WHERE endereco_geohash is not null and endereco_geohash != '00000'
    UNION
    -- ENDERECO CAMPUS 5 POSICOES
    SELECT ID_ESTUDANTE, endereco_campus_geohash, CODIGO_CURSO_PRINCIPAL, STATUS_ESCOLARIDADE, PONTUACAO_OBTIDA, PCD, NIVEL_ENSINO, DATA_ALTERACAO FROM TEMP_ESTUDANTES
    WHERE endereco_campus_geohash is not null and endereco_campus_geohash != '00000' AND CURSO_EAD = 0
    UNION
    -- ENDERECO CAMPUS 4 POSICOES
    SELECT ID_ESTUDANTE, substr(endereco_campus_geohash,1,4), CODIGO_CURSO_PRINCIPAL, STATUS_ESCOLARIDADE, PONTUACAO_OBTIDA, PCD, NIVEL_ENSINO, DATA_ALTERACAO FROM TEMP_ESTUDANTES
    WHERE endereco_campus_geohash is not null and endereco_campus_geohash != '00000' AND CURSO_EAD = 0
    ;

END;