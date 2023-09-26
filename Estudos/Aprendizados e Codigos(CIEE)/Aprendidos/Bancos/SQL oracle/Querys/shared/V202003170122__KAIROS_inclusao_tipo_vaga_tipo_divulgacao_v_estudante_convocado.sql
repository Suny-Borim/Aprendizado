  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."V_ESTUDANTE_CONVOCADO" ("CODIGO_VAGA", "NUMERO_CONTRATO", "NUMERO_LOCAL", "NUMERO_VAGAS", "RAZAO_SOCIAL", "CODIGO_UNIDADE", "NOME_UNIDADE", "HORARIO_INICIO", "HORARIO_TERMINO", "PROCESSO_PERSONALIZADO", "DATA_EMAIL", "DATA_SMS", "NUMERO_CARTEIRA", "RESPONSAVEL_CARTEIRA", "DATA_CONVOCACAO", "PRIORIZA_POM", "IDENTIFICA_POM", "ID_ESTUDANTE", "CODIGO_ESTUDANTE", "CODIGO_VINCULO", "NOME_ESTUDANTE", "TELEFONE", "CELULAR", "EMAIL", "DATA_ABERTURA", "DATA_ENVIADO_URA", "ENVIADO_URA", "TIPO_VAGA", "TIPO_DIVULGACAO") AS 
  (
    SELECT
        CODIGO_VAGA,
        NUMERO_CONTRATO,
        NUMERO_LOCAL,
        NUMERO_VAGAS,
        RAZAO_SOCIAL,
        CODIGO_UNIDADE,
        NOME_UNIDADE,
        HORARIO_INICIO,
        HORARIO_TERMINO,
        PROCESSO_PERSONALIZADO,
        DATA_EMAIL,
        DATA_SMS,
        NUMERO_CARTEIRA,
        RESPONSAVEL_CARTEIRA,
        DATA_CONVOCACAO,
        PRIORIZA_POM,
        IDENTIFICA_POM,
        ID_ESTUDANTE,
        CODIGO_ESTUDANTE,
        CODIGO_VINCULO,
        NOME_ESTUDANTE,
        TELEFONE,
        CELULAR,
        EMAIL,
        DATA_ABERTURA,
        DATA_ENVIADO_URA,
        ENVIADO_URA,
        TIPO_VAGA,
        TIPO_DIVULGACAO
    FROM (
         SELECT
             VV.CODIGO_VAGA,
             C.ID AS NUMERO_CONTRATO,
             RLC.ID AS NUMERO_LOCAL,
             VE.NUMERO_VAGAS,
             RE.RAZAO_SOCIAL,
             RLE.ID_UNIDADE_CIEE AS CODIGO_UNIDADE,
             RUC.DESCRICAO AS NOME_UNIDADE,
             VE.HORARIO_ENTRADA AS HORARIO_INICIO,
             VE.HORARIO_SAIDA AS HORARIO_TERMINO,
             VE.PROCESSO_PERSONALIZADO,
             VV.DATA_COMUNICACAO_CONVOCACAO AS DATA_EMAIL,
             VV.DATA_COMUNICACAO_CONVOCACAO AS DATA_SMS,
             RC.ID_UNIDADE_CIEE AS NUMERO_CARTEIRA,
             RP.NOME AS RESPONSAVEL_CARTEIRA,
             VV.DATA_CONVOCACAO,
             VE.PRIORIZA_POM,
             VE.IDENTIFICA_POM,
             REE.ID AS ID_ESTUDANTE,
             REE.CODIGO_ESTUDANTE,
             VV.ID AS CODIGO_VINCULO,
             REE.NOME AS NOME_ESTUDANTE,
             (select listagg(TELEFONE, '|') within group(order by PRINCIPAL desc, VERIFICADO desc, DATA_ALTERACAO desc) from REP_TELEFONES where DELETADO = 0 and ID_ESTUDANTE = REE.ID and TIPO_TELEFONE = 'FIXO') TELEFONE,
             (select listagg(TELEFONE, '|') within group(order by PRINCIPAL desc, VERIFICADO desc, DATA_ALTERACAO desc) from REP_TELEFONES where DELETADO = 0 and ID_ESTUDANTE = REE.ID and TIPO_TELEFONE = 'CELULAR') CELULAR,
             (select REEM.EMAIL from REP_EMAILS REEM inner join REP_ESTUDANTES REPE on REEM.ID_ESTUDANTE = REPE.ID where reem.PRINCIPAL = 1 and REEM.ID_ESTUDANTE = REE.ID) EMAIL,
             VE.DATA_CRIACAO AS DATA_ABERTURA,
             VV.DATA_ENVIADO_URA AS DATA_ENVIADO_URA,
             VV.ENVIADO_URA AS ENVIADO_URA,
             'ESTAGIO' AS TIPO_VAGA,
             VE.TIPO_DIVULGACAO AS TIPO_DIVULGACAO
             
         FROM VINCULOS_VAGA VV
                  INNER JOIN REP_ESTUDANTES REE on VV.ID_ESTUDANTE = REE.ID
                  INNER JOIN VAGAS_ESTAGIO VE on VV.CODIGO_VAGA = VE.CODIGO_DA_VAGA
                  LEFT JOIN VINCULOS_CONVOCACAO VC on VV.ID = VC.ID_VINCULO
                  INNER JOIN SITUACOES S on VE.ID_SITUACAO_VAGA = S.ID
                  INNER JOIN REP_LOCAIS_CONTRATO RLC on VE.ID_LOCAL_CONTRATO = RLC.ID
                  INNER JOIN REP_CONTRATOS C on RLC.ID_CONTRATO = C.ID
                  INNER JOIN REP_INFO_CONTRATO_EMPRESAS RICE on C.ID = RICE.ID_CONTRATO
                  INNER JOIN REP_EMPRESAS RE on RICE.ID_EMPRESA = RE.ID
                  INNER JOIN REP_LOCAIS_ENDERECOS RLE on RLC.ID = RLE.ID_LOCAL_CONTRATO
                  INNER JOIN REP_UNIDADES_CIEE RUC on RLE.ID_UNIDADE_CIEE = RUC.ID
                  INNER JOIN REP_CARTEIRAS RC on RUC.ID = RC.ID_UNIDADE_CIEE
                  INNER JOIN REP_ENDERECOS REE ON RLE.ID_ENDERECO = REE.ID
                  INNER JOIN REP_MAP_CARTEIRAS_TERRITORIOS RMCT ON RC.ID = RMCT.ID_CARTEIRA
             AND RMCT.CEP = REE.CEP
                  INNER JOIN REP_ASSISTENTES RA on RC.ID_ASSISTENTE = RA.ID
                  INNER JOIN REP_PESSOAS RP on RA.ID_PESSOA = RP.ID
         WHERE VV.SITUACAO_VINCULO = 0
            AND S.SIGLA = 'A'
            AND RICE.PRINCIPAL = 1
            AND VC.DATA_LIBERACAO_CONVOCACAO IS NULL
         UNION
         SELECT
             VVG.CODIGO_VAGA ,
             CA.ID AS NUMERO_CONTRATO,
             LCA.ID AS NUMERO_LOCAL,
             VA.NUMERO_VAGAS,
             REA.RAZAO_SOCIAL,
             RLEA.ID_UNIDADE_CIEE AS CODIGO_UNIDADE,
             RUCA.DESCRICAO AS NOME_UNIDADE,
             VA.HORARIO_INICIO ,
             VA.HORARIO_TERMINO,
             NULL as PROCESSO_PERSONALIZADO,
             VVG.DATA_COMUNICACAO_CONVOCACAO AS DATA_EMAIL,
             VVG.DATA_COMUNICACAO_CONVOCACAO AS DATA_SMS,
             RCA.ID_UNIDADE_CIEE AS NUMERO_CARTEIRA,
             RPA.NOME AS RESPONSAVEL_CARTEIRA,
             VVG.DATA_CONVOCACAO,
             VA.PRIORIZA_POM,
             VA.IDENTIFICA_POM,
             REEA.ID AS ID_ESTUDANTE,
             REEA.CODIGO_ESTUDANTE,
             VVG.ID AS CODIGO_VINCULO,
             REEA.NOME AS NOME_ESTUDANTE,
             (select listagg(TELEFONE, '|') within group(order by PRINCIPAL desc, VERIFICADO desc, DATA_ALTERACAO desc) from REP_TELEFONES where DELETADO = 0 and ID_ESTUDANTE = REEA.ID and TIPO_TELEFONE = 'FIXO') TELEFONE,
             (select listagg(TELEFONE, '|') within group(order by PRINCIPAL desc, VERIFICADO desc, DATA_ALTERACAO desc) from REP_TELEFONES where DELETADO = 0 and ID_ESTUDANTE = REEA.ID and TIPO_TELEFONE = 'CELULAR') CELULAR,
             (select REEMA.EMAIL from REP_EMAILS REEMA inner join REP_ESTUDANTES REPEA on REEMA.ID_ESTUDANTE = REPEA.ID where REEMA.PRINCIPAL = 1 and REEMA.ID_ESTUDANTE = REEA.ID) EMAIL,
             VA.DATA_CRIACAO AS DATA_ABERTURA,
             VVG.DATA_ENVIADO_URA AS DATA_ENVIADO_URA,
             VVG.ENVIADO_URA AS ENVIADO_URA,
             'APRENDIZ' AS TIPO_VAGA,
             VA.TIPO_DIVULGACAO AS TIPO_DIVULGACAO
         FROM VINCULOS_VAGA VVG
                  INNER JOIN REP_ESTUDANTES REEA on VVG.ID_ESTUDANTE = REEA.ID
                  INNER JOIN VAGAS_APRENDIZ VA on VVG.CODIGO_VAGA = VA.CODIGO_DA_VAGA
                  LEFT JOIN VINCULOS_CONVOCACAO VCA on VVG.ID = VCA.ID_VINCULO
                  INNER JOIN SITUACOES SS on VA.ID_SITUACAO_VAGA = SS.ID
                  INNER JOIN REP_LOCAIS_CONTRATO LCA on VA.ID_LOCAL_CONTRATO = LCA.ID
                  INNER JOIN REP_CONTRATOS CA on LCA.ID_CONTRATO = CA.ID
                  INNER JOIN REP_INFO_CONTRATO_EMPRESAS RICEA on CA.ID = RICEA.ID_CONTRATO
                  INNER JOIN REP_EMPRESAS REA on RICEA.ID_EMPRESA = REA.ID
                  INNER JOIN REP_LOCAIS_ENDERECOS RLEA on LCA.ID = RLEA.ID_LOCAL_CONTRATO
                  INNER JOIN REP_UNIDADES_CIEE RUCA on RLEA.ID_UNIDADE_CIEE = RUCA.ID
                  INNER JOIN REP_CARTEIRAS RCA on RUCA.ID = RCA.ID_UNIDADE_CIEE
                  INNER JOIN REP_ENDERECOS REE ON RLEA.ID_ENDERECO = REE.ID
                  INNER JOIN REP_MAP_CARTEIRAS_TERRITORIOS RMCT ON RCA.ID = RMCT.ID_CARTEIRA
             AND RMCT.CEP = REE.CEP
                  INNER JOIN REP_ASSISTENTES RAA on RCA.ID_ASSISTENTE = RAA.ID
                  INNER JOIN REP_PESSOAS RPA on RAA.ID_PESSOA = RPA.ID

         WHERE VVG.SITUACAO_VINCULO = 0
            AND SS.SIGLA = 'A'
            AND RICEA.PRINCIPAL = 1
            AND VCA.DATA_LIBERACAO_CONVOCACAO IS NULL
    )
    
);