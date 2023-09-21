-- Adicionando coluna pcd em view V_APRENDIZES_VINCULADOS
CREATE OR REPLACE VIEW V_APRENDIZES_VINCULADOS as
SELECT
    VAGAS_APRENDIZ.id, VAGAS_APRENDIZ.id_local_contrato, VAGAS_APRENDIZ.codigo_da_vaga, VAGAS_APRENDIZ.DATA_CRIACAO, VAGAS_APRENDIZ.numero_vagas,
    SITUACOES.descricao AS SITUACAO, SITUACOES.sigla AS SIGLA_SITUACAO, SITUACOES.id as ID_SITUACAO_VAGA,
    AREAS_ATUACAO_APRENDIZ.descricao_area_atuacao,
    COUNT(VINCULOS_VAGA.id) AS CANDIDATOS_VINCULADOS,
    VAGAS_APRENDIZ.PCD
FROM VAGAS_APRENDIZ
         JOIN SITUACOES ON VAGAS_APRENDIZ.ID_SITUACAO_VAGA = SITUACOES.id
         JOIN AREAS_ATUACAO_APRENDIZ ON VAGAS_APRENDIZ.id_area_atuacao_aprendiz = AREAS_ATUACAO_APRENDIZ.id
         LEFT JOIN VINCULOS_VAGA on VAGAS_APRENDIZ.CODIGO_DA_VAGA = VINCULOS_VAGA.CODIGO_VAGA
GROUP BY
    VAGAS_APRENDIZ.id, VAGAS_APRENDIZ.id_local_contrato, VAGAS_APRENDIZ.codigo_da_vaga, VAGAS_APRENDIZ.DATA_CRIACAO, VAGAS_APRENDIZ.numero_vagas,
    SITUACOES.descricao, SITUACOES.sigla, SITUACOES.id,
    AREAS_ATUACAO_APRENDIZ.descricao_area_atuacao, VAGAS_APRENDIZ.PCD;


-- Adicionando coluna pcd em view V_ESTAGIARIOS_VINCULADOS
CREATE OR REPLACE VIEW V_ESTAGIARIOS_VINCULADOS as
SELECT
    V.ID, V.ID_LOCAL_CONTRATO, V.CODIGO_DA_VAGA, V.DATA_CRIACAO, V.ID_SITUACAO_VAGA, S.SIGLA AS SIGLA_SITUACAO,
    S.DESCRICAO AS SITUACAO, V.NUMERO_VAGAS, COUNT(VV.ID) AS CANDIDATOS_VINCULADOS, V.CODIGO_AREA_PROFISSIONAL,
    A.DESCRICAO_AREA_PROFISSIONAL,
    V.PCD
FROM
    VAGAS_ESTAGIO V
        INNER JOIN
    SITUACOES S ON V.ID_SITUACAO_VAGA = S.ID
        INNER JOIN
    REP_AREAS_PROFISSIONAIS A ON A.CODIGO_AREA_PROFISSIONAL = V.CODIGO_AREA_PROFISSIONAL
        LEFT JOIN
    VINCULOS_VAGA VV on V.CODIGO_DA_VAGA = VV.CODIGO_VAGA
GROUP BY
    V.ID, V.ID_LOCAL_CONTRATO, V.CODIGO_DA_VAGA, V.DATA_CRIACAO, V.ID_SITUACAO_VAGA, S.SIGLA, S.DESCRICAO,
    V.NUMERO_VAGAS, V.CODIGO_AREA_PROFISSIONAL, A.DESCRICAO_AREA_PROFISSIONAL, V.PCD;



-- Adicionando coluna pcd em view V_ACOMPANHAMENTO_VAGAS_EMPRESA
CREATE OR REPLACE VIEW V_ACOMPANHAMENTO_VAGAS_EMPRESA as
    (
        SELECT DISTINCT VE.ID_LOCAL_CONTRATO                        ID_LOCAL_CONTRATO,
                        VE.CODIGO_DA_VAGA                           CODIGO_VAGA,
                        'ESTAGIO'                                   TIPO_VAGA,
                        VE.DATA_CRIACAO                             DATA_ABERTURA,
                        S.ID                                        ID_SITUACAO_VAGA,
                        S.DESCRICAO                                 DESCRICAO_SITUACAO,
                        VE.NUMERO_VAGAS,
                        VE.CONTRATACAO_DIRETA,
                        (VE.NUMERO_VAGAS - (SELECT COUNT(VV.ID)
                                            FROM VINCULOS_VAGA VV
                                            WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA
                                              AND VV.SITUACAO_VINCULO IN (2, 4)
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

        UNION

        SELECT DISTINCT VA.ID_LOCAL_CONTRATO                        ID_LOCAL_CONTRATO,
                        VA.CODIGO_DA_VAGA                           CODIGO_VAGA,
                        'APRENDIZ'                                  TIPO_VAGA,
                        VA.DATA_CRIACAO                             DATA_ABERTURA,
                        S.ID                                        ID_SITUACAO_VAGA,
                        S.DESCRICAO                                 DESCRICAO_SITUACAO,
                        VA.NUMERO_VAGAS,
                        VA.CONTRATACAO_DIRETA,
                        (VA.NUMERO_VAGAS - (SELECT COUNT(VV.ID)
                                            FROM VINCULOS_VAGA VV
                                            WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA
                                              AND VV.SITUACAO_VINCULO IN (2, 4)
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
    );
