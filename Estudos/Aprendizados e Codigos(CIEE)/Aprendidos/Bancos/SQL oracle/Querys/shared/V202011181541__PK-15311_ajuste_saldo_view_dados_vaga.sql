create or replace view V_ACOMPANHAMENTO_VAGAS_EMPRESA as
    (
        SELECT DISTINCT VE.ID_LOCAL_CONTRATO                        ID_LOCAL_CONTRATO,
                        VE.CODIGO_DA_VAGA                           CODIGO_VAGA,
                        'ESTAGIO'                                   TIPO_VAGA,
                        VE.DATA_CRIACAO                             DATA_ABERTURA,
                        S.ID                                        ID_SITUACAO_VAGA,
                        S.DESCRICAO                                 DESCRICAO_SITUACAO,
                        VE.NUMERO_VAGAS,
                        VE.CONTRATACAO_DIRETA,
                        RAP.DESCRICAO_AREA_PROFISSIONAL             AREA_PROFISSIONAL,
                        null                                        CURSO_CAPACITACAO,
                        (VE.NUMERO_VAGAS - (SELECT COUNT(VV.ID)
                                            FROM VINCULOS_VAGA VV
                                            WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA
                                              AND VV.SITUACAO_VINCULO IN (2, 4, 5)
                                              AND VV.DELETADO = 0)) SALDO_VAGAS,
                        (SELECT COUNT(VV.ID)
                         FROM VINCULOS_VAGA VV
                         WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA
                           AND VV.SITUACAO_VINCULO = 0
                           AND VV.DELETADO = 0)                     CONVOCADOS,
                        (SELECT COUNT(VV.ID)
                         FROM VINCULOS_VAGA VV
                         WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA
                           AND VV.SITUACAO_VINCULO = 1
                           AND VV.DELETADO = 0)                     ENCAMINHADOS,
                        VE.PCD
        FROM VAGAS_ESTAGIO VE
                 JOIN SITUACOES S ON VE.ID_SITUACAO_VAGA = S.ID
                 left join REP_AREAS_PROFISSIONAIS RAP on VE.CODIGO_AREA_PROFISSIONAL = RAP.CODIGO_AREA_PROFISSIONAL
        UNION
        SELECT DISTINCT VA.ID_LOCAL_CONTRATO                        ID_LOCAL_CONTRATO,
                        VA.CODIGO_DA_VAGA                           CODIGO_VAGA,
                        'APRENDIZ'                                  TIPO_VAGA,
                        VA.DATA_CRIACAO                             DATA_ABERTURA,
                        S.ID                                        ID_SITUACAO_VAGA,
                        S.DESCRICAO                                 DESCRICAO_SITUACAO,
                        VA.NUMERO_VAGAS,
                        VA.CONTRATACAO_DIRETA,
                        null                                        AREA_PROFISSIONAL,
                        CC.DESCRICAO                                CURSO_CAPACITACAO,
                        (VA.NUMERO_VAGAS - (SELECT COUNT(VV.ID)
                                            FROM VINCULOS_VAGA VV
                                            WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA
                                              AND VV.SITUACAO_VINCULO IN (2, 4, 5)
                                              AND VV.DELETADO = 0)) SALDO_VAGAS,
                        (SELECT COUNT(VV.ID)
                         FROM VINCULOS_VAGA VV
                         WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA
                           AND VV.SITUACAO_VINCULO = 0
                           AND VV.DELETADO = 0)                     CONVOCADOS,
                        (SELECT COUNT(VV.ID)
                         FROM VINCULOS_VAGA VV
                         WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA
                           AND VV.SITUACAO_VINCULO = 1
                           AND VV.DELETADO = 0)                     ENCAMINHADOS,
                        VA.PCD
        FROM VAGAS_APRENDIZ VA
                 JOIN SITUACOES S ON VA.ID_SITUACAO_VAGA = S.ID
                 left join CURSOS_CAPACITACAO CC on VA.ID_CURSO_CAPACITACAO = CC.ID
    )
;

