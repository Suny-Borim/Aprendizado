-- Atualiza view V_VAGAS_PRIORIZACAO_SISTEMA_POM    
 CREATE OR REPLACE VIEW V_VAGAS_PRIORIZACAO_SISTEMA_POM AS
    (
        (
            SELECT DISTINCT RC.ID                      ID_CONTRATO,
                            VE.CODIGO_DA_VAGA          CODIGO_DA_VAGA,
                            VE.PROCESSO_PERSONALIZADO  VAGA_PP,
                            'E'                        TIPO_VAGA,
                            VE.DATA_CRIACAO            DATA_ABERTURA,
                            VE.NUMERO_VAGAS            NUMERO_VAGAS,
                            PCD.ID                     ID_PCD,
                            (SELECT COUNT(VV.ID) FROM VINCULOS_VAGA VV WHERE VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA AND VV.DELETADO = 0) TRIADOS,
                            VE.PRIORIZA_POM            PRIORIZA_POM,
                            RLE.ID_CARTEIRA			   ID_CARTEIRA,
                            RLE.ID_CARTEIRA_LOCAL      ID_CARTEIRA_LOCAL,
                            RLE.ID_UNIDADE_CIEE 	   ID_UNIDADE_CIEE,
                            RLE.ID_UNIDADE_CIEE_LOCAL  ID_UNIDADE_CIEE_LOCAL
            FROM VAGAS_ESTAGIO VE
                     JOIN REP_LOCAIS_CONTRATO  LC   ON      (VE.ID_LOCAL_CONTRATO = LC.ID)
                     JOIN REP_CONTRATOS        RC   ON      (LC.ID_CONTRATO = RC.ID)
                     LEFT JOIN PCD_ESTAGIO     PCD  ON      (VE.ID = PCD.ID_VAGA_ESTAGIO)
                     LEFT JOIN REP_LOCAIS_ENDERECOS RLE ON  (LC.ID = RLE.ID_LOCAL_CONTRATO)
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
                            PCD.ID             ID_PCD,
                            (SELECT COUNT(VV.ID)   FROM VINCULOS_VAGA VV   WHERE VV.CODIGO_VAGA = VA.CODIGO_DA_VAGA AND VV.DELETADO = 0) TRIADOS,
                            VA.PRIORIZA_POM    PRIORIZA_POM,
                            RLE.ID_CARTEIRA			   ID_CARTEIRA,
                            RLE.ID_CARTEIRA_LOCAL      ID_CARTEIRA_LOCAL,
                            RLE.ID_UNIDADE_CIEE 	   ID_UNIDADE_CIEE,
                            RLE.ID_UNIDADE_CIEE_LOCAL  ID_UNIDADE_CIEE_LOCAL
            FROM VAGAS_APRENDIZ VA
                     JOIN REP_LOCAIS_CONTRATO  LC  ON (VA.ID_LOCAL_CONTRATO = LC.ID)
                     JOIN REP_CONTRATOS        RC  ON (LC.ID_CONTRATO = RC.ID)
                     LEFT JOIN PCD_APRENDIZ    PCD ON (PCD.ID_VAGA_APRENDIZ = VA.ID)
                     LEFT JOIN REP_LOCAIS_ENDERECOS RLE ON  (LC.ID = RLE.ID_LOCAL_CONTRATO)
            WHERE   VA.ID_SITUACAO_VAGA = (SELECT ID FROM SITUACOES WHERE SIGLA = 'A')
              AND     VA.DELETADO = 0)
    );
 