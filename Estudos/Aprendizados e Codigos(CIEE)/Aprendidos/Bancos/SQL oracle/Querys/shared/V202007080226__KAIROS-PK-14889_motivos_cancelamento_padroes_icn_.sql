DECLARE
    v_existe    NUMBER;
BEGIN
    SELECT
        COUNT(1)
    INTO v_existe
    FROM
        motivos_cancelamentos_contratados m
    WHERE
        m.codigo = 77;

    IF v_existe = 0 THEN
        INSERT INTO motivos_cancelamentos_contratados (
        ID,
        CODIGO,
        DESCRICAO,
        DATA_CRIACAO,
        DATA_ALTERACAO,
        CRIADO_POR,
        MODIFICADO_POR
        ) VALUES (
        SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval,
        77,
        ' Cancelamento de Contrato',
        current_timestamp,
        current_timestamp,
        'script',
        'script');
    END IF;
END;
