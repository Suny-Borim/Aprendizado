--pk 14889
DECLARE
    v_existe    NUMBER;
BEGIN
    SELECT
        COUNT(1)
    INTO v_existe
    FROM
        motivos_rescisao_contratados m
    WHERE
        m.codigo = 55;

    IF v_existe = 0 THEN
        INSERT INTO motivos_rescisao_contratados (
        ID,
        CODIGO,
        DESCRICAO,
        DATA_CRIACAO,
        DATA_ALTERACAO,
        CRIADO_POR,
        MODIFICADO_POR
        ) VALUES (
        SEQ_MOTIVOS_RESCISAO_CONTRATADOS.nextval,
        55,
        'DESLIG. ENVIADO PELO AUTONOMO(ICN)',
        current_timestamp,
        current_timestamp,
        'script',
        'script');
    END IF;
END;
