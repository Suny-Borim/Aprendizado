/*
 ##### PK-15614: Implementar - Jovem Talento em Triagem
 ########## PK-16064: Atualizar procedures de triagens
 */

create or replace function stage_objetivo_vaga(p_codigo_da_vaga NUMBER, tipo varchar2, P_ID_UNIDADE_CIEE NUMBER) RETURN INT
AS
    qtdPosicoesVaga         INT;
    qtdEncaminhadosVaga     INT;
    Contratados             INT;
    Encaminhados            INT;
    Convocados              INT;
    parametroConvocados     INT;
    objetivo                INT;
BEGIN
    if tipo = 'E' then
        SELECT
            nvl(Numero_vagas,0)              AS qtdPosicoesVaga
             ,nvl(Num_encaminhamento_vaga,0) AS qtdEncaminhadosVaga
        INTO qtdPosicoesVaga, qtdEncaminhadosVaga
        FROM
            SERVICE_VAGAS_DEV.vagas_estagio
        WHERE
                codigo_da_vaga = p_codigo_da_vaga;
    else
        SELECT
            nvl(Numero_vagas,0)              AS qtdPosicoesVaga
             ,nvl(Num_encaminhamento_vaga,0) AS qtdEncaminhadosVaga
        INTO qtdPosicoesVaga, qtdEncaminhadosVaga
        FROM
            SERVICE_VAGAS_DEV.VAGAS_APRENDIZ
        WHERE
                codigo_da_vaga = p_codigo_da_vaga;
    end if;
    SELECT
        nvl(SUM(CASE WHEN v.SITUACAO_VINCULO IN (2,4,5) THEN 1 ELSE 0 END), 0) Contratados,
        nvl(SUM(CASE WHEN v.SITUACAO_VINCULO = 1 THEN 1 ELSE 0 END), 0) Encaminhados,
        nvl(SUM(CASE WHEN v.SITUACAO_VINCULO = 0 THEN 1 ELSE 0 END),0) Convocados
    INTO Contratados, Encaminhados, Convocados
    FROM
        SERVICE_VAGAS_DEV.VINCULOS_VAGA v
    WHERE
            v.codigo_vaga = p_codigo_da_vaga
      AND v.deletado = 0 ;
    SELECT
        nvl(num_convocados_encaminhamento,0) as parametroConvocados
    INTO parametroConvocados
    FROM
        --SERVICE_VAGAS_DEV.TRIAGENS_VAGAS V
        --INNER JOIN SERVICE_VAGAS_DEV.REP_PARAMETROS_UNIDADES_CIEE P ON V.ID_UNIDADE_CIEE = P.ID_UNIDADE_CIEE
        SERVICE_VAGAS_DEV.REP_PARAMETROS_UNIDADES_CIEE P
    WHERE
            ID_UNIDADE_CIEE = P_ID_UNIDADE_CIEE;
    --V.codigo_da_vaga = p_codigo_da_vaga;
    objetivo := ((((qtdPosicoesVaga - contratados) * qtdEncaminhadosVaga) - encaminhados) * parametroConvocados) - convocados;
    RETURN objetivo;
EXCEPTION
    WHEN OTHERS THEN RETURN 0;
END;
/
