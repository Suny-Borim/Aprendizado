---
--- VIEW VAGAS_PRIORIZACAO_SISTEMA_POM
---
CREATE OR REPLACE VIEW V_VAGAS_PRIORIZACAO_SISTEMA_POM AS
    (
        (
            SELECT DISTINCT RC.ID                      ID_CONTRATO,
                            VE.CODIGO_DA_VAGA          CODIGO_DA_VAGA,
                            VE.PROCESSO_PERSONALIZADO  VAGA_PP,
                            'E'                        TIPO_VAGA,
                            VE.DATA_CRIACAO            DATA_ABERTURA,
                            VE.NUMERO_VAGAS            NUMERO_VAGAS,
                            P.ID                       ID_PCD,
                            (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.DELETADO = 0) TRIADOS,
                            VE.PRIORIZA_POM            PRIORIZA_POM
            FROM VAGAS_ESTAGIO VE
                     JOIN REP_LOCAIS_CONTRATO  LC   ON      (VE.ID_LOCAL_CONTRATO = LC.ID)
                     JOIN REP_CONTRATOS        RC   ON      (LC.ID_CONTRATO = RC.ID)
                     LEFT JOIN PCD             P    ON      (VE.ID = P.ID_VAGA_ESTAGIO)
            WHERE   VE.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'A')
            AND     VE.DELETADO = 0
        )

        UNION

        (
            SELECT DISTINCT RC.ID              ID_CONTRATO,
                            VA.CODIGO_DA_VAGA  CODIGO_DA_VAGA,
                            NULL               VAGA_PP,
                            'A'                TIPO_VAGA,
                            VA.DATA_CRIACAO    DATA_ABERTURA,
                            VA.NUMERO_VAGAS    NUMERO_VAGAS,
                            P.ID               ID_PCD,
                            (SELECT COUNT(VV.ID)   FROM VINCULOS_VAGA VV   WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.DELETADO = 0) TRIADOS,
                            VA.PRIORIZA_POM    PRIORIZA_POM
            FROM VAGAS_APRENDIZ VA
                     JOIN REP_LOCAIS_CONTRATO  LC  ON (VA.ID_LOCAL_CONTRATO = LC.ID)
                     JOIN REP_CONTRATOS        RC  ON (LC.ID_CONTRATO = RC.ID)
                     LEFT JOIN PCD_APRENDIZ    P   ON (P.ID_VAGA_APENDIZ = VA.ID)
            WHERE   VA.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'A')
            AND     VA.DELETADO = 0)
    );

-- Atualizando todos os campos para 0 pois define que não estão priorizados
UPDATE VAGAS_ESTAGIO SET PRIORIZA_POM = 0;
UPDATE VAGAS_APRENDIZ SET PRIORIZA_POM = 0;

-- Adiciona valor padrão 0 pois define que registros novos não estão priorizados
ALTER TABLE VAGAS_ESTAGIO  MODIFY( PRIORIZA_POM DEFAULT 0);
ALTER TABLE VAGAS_APRENDIZ MODIFY( PRIORIZA_POM DEFAULT 0);
