create or replace function stage_objetivo_vaga(p_codigo_da_vaga INT) RETURN INT
AS
    qtdPosicoesVaga     INT;
    qtdEncaminhadosVaga INT;
    Contratados         INT;
    Encaminhados        INT;
    Convocados          INT;
    parametroConvocados INT;
    objetivo            INT;
BEGIN

    SELECT
        Numero_vagas             AS qtdPosicoesVaga
         ,Num_encaminhamento_vaga AS qtdEncaminhadosVaga
    INTO qtdPosicoesVaga, qtdEncaminhadosVaga
    FROM
        SERVICE_VAGAS_DEV.vagas_estagio
    WHERE codigo_da_vaga = p_codigo_da_vaga;

    SELECT COUNT(1) INTO Contratados FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO = 1;

    SELECT COUNT(1) INTO Encaminhados FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO IN (2,4,5);

    SELECT COUNT(1) INTO Convocados FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA v WHERE v.codigo_vaga = p_codigo_da_vaga AND v.deletado = 0 AND v.SITUACAO_VINCULO = 0;

    SELECT
        num_convocados_encaminhamento as parametroConvocados
    INTO parametroConvocados
    FROM
        SERVICE_VAGAS_DEV.TRIAGENS_VAGAS t0
            INNER JOIN SERVICE_VAGAS_DEV.REP_LOCAIS_ENDERECOS  t1 ON t0.ID_LOCAL_CONTRATO = t1.ID_LOCAL_CONTRATO
            INNER JOIN SERVICE_VAGAS_DEV.REP_PARAMETROS_UNIDADES_CIEE t2 ON t1.ID_UNIDADE_CIEE = t2.ID_UNIDADE_CIEE
    WHERE t0.CODIGO_DA_VAGA = p_codigo_da_vaga;

    objetivo := ((((qtdPosicoesVaga - contratados) * qtdEncaminhadosVaga) - encaminhados) * parametroConvocados) - convocados;

    RETURN objetivo;

END;
/