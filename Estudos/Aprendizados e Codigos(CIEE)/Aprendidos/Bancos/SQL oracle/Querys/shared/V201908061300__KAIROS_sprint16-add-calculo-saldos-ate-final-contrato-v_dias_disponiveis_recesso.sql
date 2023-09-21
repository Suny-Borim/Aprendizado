-- Cria a view com informações de dias disponíveis de recesso

create or replace view SERVICE_VAGAS_DEV.V_DIAS_DISPONIVEIS_RECESSO as
    select ID as CONTRATO,
        --to_char(DATA_INICIO_ESTAGIO,'DD/MM/YYYY')as DATA_INICIO_ESTAGIO,
        --trunc(months_between(sysdate, DATA_INICIO_ESTAGIO))as qtd_meses_contrato,
        --(round(months_between(sysdate, DATA_INICIO_ESTAGIO)-trunc(months_between(sysdate, DATA_INICIO_ESTAGIO)),2)*30) as qtd_dias_resto,
        --CASE WHEN (round(months_between(sysdate, DATA_INICIO_ESTAGIO)-trunc(months_between(sysdate, DATA_INICIO_ESTAGIO)))*30) >= 15 THEN 1 ELSE 0 END  fracao_14_dias,
        round(
            (
                (
                    trunc(
                        months_between(sysdate, DATA_INICIO_ESTAGIO)
                    )*2.5
                )
                +
                (
                    round(
                        months_between(sysdate, DATA_INICIO_ESTAGIO)-trunc(months_between(sysdate, DATA_INICIO_ESTAGIO)),3
                    )*2.5
                )
            ),1
        ) as qtd_dias_ferias_proporcional,
        (
            (
                trunc(
                    months_between(sysdate, DATA_INICIO_ESTAGIO)
                )*2.5
            )
            +
            (
                CASE WHEN
                    (
                        round(
                            months_between(sysdate, DATA_INICIO_ESTAGIO)-trunc(months_between(sysdate, DATA_INICIO_ESTAGIO))
                        )*30
                    ) >= 15
                 THEN
                    1
                 ELSE
                    0
                 END
            )*2.5
        ) as qtd_dias_ferias_clt,
        round(
            (
                (
                    trunc(
                        months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO)
                    )*2.5
                )
                +
                (
                    round(
                        months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO)-trunc(months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO)),3
                    )*2.5
                )
            ),1
        ) as qtd_dias_ferias_proporcional_ate_final,
        (
            (
                trunc(
                    months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO)
                )*2.5
            )
            +
            (
                CASE WHEN
                    (
                        round(
                            months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO)-trunc(months_between(DATA_FINAL_ESTAGIO, DATA_INICIO_ESTAGIO))
                        )*30
                    ) >= 15
                 THEN
                    1
                 ELSE
                    0
                 END
            )*2.5
        ) as qtd_dias_ferias_clt_ate_final
    from service_vagas_dev.contratos_estudantes_empresa
    where tipo_contrato='E'
    order by id;