
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."V_ACOMPANHAMENTO_VAGAS_EMPRESA" ("ID_LOCAL_CONTRATO", "CODIGO_VAGA", "TIPO_VAGA", "DATA_ABERTURA", "ID_SITUACAO_VAGA", "DESCRICAO_SITUACAO", "NUMERO_VAGAS", "CONTRATACAO_DIRETA", "SALDO_VAGAS", "CONVOCADOS", "ENCAMINHADOS") AS
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
                     AND VV.DELETADO = 0)                     ENCAMINHADOS
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
                     AND VV.DELETADO = 0)                     ENCAMINHADOS
  FROM VAGAS_APRENDIZ VA
         JOIN SITUACOES S ON VA.ID_SITUACAO_VAGA = S.ID
);