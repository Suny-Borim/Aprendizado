CREATE OR REPLACE function {{user}}.calculo_saldo_vaga(p_codigo_da_vaga INT, p_tipo_vaga VARCHAR2) RETURN INT
AS
    qtdPosicoesVaga     INT;
    qtdEncaminhadosVaga INT;
    Contratados         INT;
    Encaminhados        INT;
    Convocados          INT;
    parametroConvocados INT;
    saldo               INT;
BEGIN

    IF (p_tipo_vaga = 'E') THEN
        SELECT
            Numero_vagas             AS qtdPosicoesVaga
             ,Num_encaminhamento_vaga AS qtdEncaminhadosVaga
        INTO qtdPosicoesVaga, qtdEncaminhadosVaga
        FROM
            {{user}}.vagas_estagio
        WHERE codigo_da_vaga = p_codigo_da_vaga;
    ELSE
        SELECT
            Numero_vagas             AS qtdPosicoesVaga
             ,Num_encaminhamento_vaga AS qtdEncaminhadosVaga
        INTO qtdPosicoesVaga, qtdEncaminhadosVaga
        FROM
            {{user}}.vagas_aprendiz
        WHERE codigo_da_vaga = p_codigo_da_vaga;
    END IF;

    SELECT COUNT(1) INTO Contratados FROM {{user}}.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO IN (2,4,5);

    SELECT COUNT(1) INTO Encaminhados FROM {{user}}.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO = 1;

    SELECT COUNT(1) INTO Convocados FROM {{user}}.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO = 0;

    SELECT
        num_convocados_encaminhamento as parametroConvocados
    INTO parametroConvocados
    FROM
        {{user}}.TRIAGENS_VAGAS t0
            INNER JOIN {{user}}.REP_LOCAIS_ENDERECOS  t1 ON t0.ID_LOCAL_CONTRATO = t1.ID_LOCAL_CONTRATO
            INNER JOIN {{user}}.REP_PARAMETROS_UNIDADES_CIEE t2 ON t1.ID_UNIDADE_CIEE = t2.ID_UNIDADE_CIEE
    WHERE t0.CODIGO_DA_VAGA = p_codigo_da_vaga;

    saldo := ((((qtdPosicoesVaga - contratados) * qtdEncaminhadosVaga) - encaminhados) * parametroConvocados) - convocados;

    RETURN saldo;

END;
/