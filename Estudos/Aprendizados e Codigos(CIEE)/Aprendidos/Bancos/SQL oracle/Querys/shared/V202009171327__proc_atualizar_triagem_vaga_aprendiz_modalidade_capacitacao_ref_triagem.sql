create or replace PROCEDURE                   proc_atualizar_triagem_vaga_aprendiz(
    V_ID_VAGA_APRENDIZ NUMBER DEFAULT NULL
)
AS
BEGIN

    MERGE INTO SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" D
    USING
        (SELECT LOC_END.ID_UNIDADE_CIEE,
                V.CODIGO_DA_VAGA,
                NULL                                                                                AS SEMESTRE_INICIAL,
                NULL                                                                                AS SEMESTRE_FINAL,
                NVL(V.SEXO, 'I')                                                                    as SEXO,
                NVL(V.RESERVISTA, 0)                                                                as RESERVISTA,
                0                                                                                   as FUMANTE,
                0                                                                                   as POSSUI_CNH,
                NVL(V.EMPRESA_COM_ACESSIBILIDADE, 0)                                                as EMPRESA_COM_ACESSIBILIDADE,
                NVL(V.VALIDO_COTA, 0)                                                               as VALIDO_COTA,

                -- ### ESTADO CIVIL ###
                NULL                                                                                as ESTADO_CIVIL,


                -- ### IDIOMAS ###
                NULL                                                                                as idiomas,

                -- ### Escolas ###
                NULL                                                                                as escolas,

                -- ### PCD ###
                (
                    SELECT cast(collect(
                            SERVICE_VAGAS_DEV.PCD_VAGA_TYP(
                                    PCD.ID_CID_AGRUPADO,
                                    PCD.VALIDADE_MINMA_LAUDO
                                )
                        ) as SERVICE_VAGAS_DEV.PCDS_VAGA_TYP)
                    FROM SERVICE_VAGAS_DEV.PCD_APRENDIZ PCD
                    WHERE PCD.ID_VAGA_APRENDIZ = V.ID
                      AND PCD.deletado = 0
                )                                                                                   as pcds,

                -- ### POSSUI PCD ###
                NVL(V.PCD, 0)                                                                          POSSUI_PCD,
                (
                    SELECT CAST(COLLECT(APARELHO.ID_APARELHO) AS SERVICE_VAGAS_DEV.IDS_TYP)
                    from SERVICE_VAGAS_DEV.APARELHOS_PCD_APRENDIZ APARELHO
                             INNER JOIN SERVICE_VAGAS_DEV.PCD_APRENDIZ PA on APARELHO.ID_PCD = PA.ID
                    WHERE PA.ID_VAGA_APRENDIZ = V.ID
                      AND PA.deletado = 0
                )                                                                                      RECURSOS_ACESSIBILIDADE,

                V.PRIORIZA_VULNERAVEL,

                -- ### Qualificacao estagio ###
                (
                    SELECT cast(collect(
                            VQVE.ID_QUALIFICACAO
                        ) as SERVICE_VAGAS_DEV.IDS_TYP)
                    FROM SERVICE_VAGAS_DEV.VINCULO_QUALI_VAGA_APRENDIZ VQVE
                    WHERE V.ID = VQVE.ID_VAGA_APRENDIZ
                )                                                                                   as QUALIFICACOES,

                -- ### Conhecimento ###
                NULL                                                                                as conhecimentos,

                -- ### Cursos ###
                NULL                                                                                as cursos,

                END_EMP.GEO_POINT                                                                   as ENDERECO,

                --A Funcao do Oracle esta retornando nulo em alguns momentos
             /*"SDO_CS.TO_GEOHASH(END_EMP.GEO_POINT, 4) */
                SERVICE_VAGAS_DEV.geohash_neighbors_landscape(
                        SERVICE_VAGAS_DEV.GEOHASH_ENCODE(SDO_GEOM.SDO_CENTROID(END_EMP.GEO_POINT, 0.05).sdo_point.y,
                                                         SDO_GEOM.SDO_CENTROID(END_EMP.GEO_POINT, 0.05).sdo_point.x, 5)
                    )                                                                               AS ENDERECO_GEOHASHS,

                SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(T.LONGITUDE, T.LATITUDE, null), null, null)    CAPACITACAO,

                --A Funcao do Oracle esta retornando nulo em alguns momentos
                --SDO_CS.TO_GEOHASH(SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(T.LONGITUDE, T.LATITUDE, null), null, null), 4)
                SERVICE_VAGAS_DEV.geohash_neighbors_landscape(
                        SERVICE_VAGAS_DEV.GEOHASH_ENCODE(T.LATITUDE, T.LONGITUDE, 5)
                    )                                                                               AS CAPACITACAO_GEOHASHS,

                v.HORARIO_INICIO                                                                       HORARIO_ENTRADA,
                v.HORARIO_TERMINO                                                                      HORARIO_SAIDA,
                V.VALOR_RAIO                                                                           "VALOR_RAIO",
                V.LOCALIZACAO                                                                          "LOCALIZACAO",

                COALESCE(V.IDADE_MINIMA, (SELECT PPE.IDADE_MINIMA
                                          FROM SERVICE_VAGAS_DEV.REP_PARAMETROS_PROGRAMA_EST PPE
                                                   INNER JOIN SERVICE_VAGAS_DEV.REP_PARAMETROS_UNIDADES_CIEE PUC
                                                              ON PPE.CODIGO_CIEE = PUC.ID_CIEE
                                          WHERE PUC.ID_UNIDADE_CIEE = LOC_END.ID_UNIDADE_CIEE), 16) as IDADE_MINIMA,

                COALESCE(V.IDADE_MAXIMA, (SELECT PPE.IDADE_MAXIMA
                                          FROM SERVICE_VAGAS_DEV.REP_PARAMETROS_PROGRAMA_EST PPE
                                                   INNER JOIN SERVICE_VAGAS_DEV.REP_PARAMETROS_UNIDADES_CIEE PUC
                                                              ON PPE.CODIGO_CIEE = PUC.ID_CIEE
                                          WHERE PUC.ID_UNIDADE_CIEE = LOC_END.ID_UNIDADE_CIEE), 99) as IDADE_MAXIMA,

                V.SITUACAO_ESCOLARIDADE,
                V.ESCOLARIDADE,
                NULL                                                                                   DATA_CONCLUSAO,
                NULL                                                                                   TIPO_HORARIO_ESTAGIO,
                'A'                                                                                    tipo_vaga,
                INF_EMP.ID_EMPRESA,
                CC.ID_AREA_ATUACAO,
                CC.MODALIDADE                                                                           MODALIDADE_CAPACITACAO,
                V.VALOR_SALARIO,
                V.VALOR_SALARIO_DE,
                V.VALOR_SALARIO_ATE,

                -- ### Cursos de capacitacao ###
                (
                    SELECT cast(collect(
                            turmas.ID_CURSO
                        ) as SERVICE_VAGAS_DEV.IDS_TYP)
                    FROM SERVICE_VAGAS_DEV.Turmas turmas
                    WHERE turmas.ID_VAGA_APRENDIZ = V.ID
                      AND (turmas.TURMA IS NULL OR turmas.TURMA = 0)
                      AND turmas.Deletado = 0
                )                                                                                   as CURSOS_CAPACITACAO,

                -- ### Quantidade de convocacoes ###
                (
                    SELECT COUNT(1)
                    FROM SERVICE_VAGAS_DEV.VINCULOS_VAGA vinculos
                    WHERE vinculos.codigo_vaga = V.codigo_da_vaga
                      AND vinculos.deletado = 0
                      AND vinculos.SITUACAO_VINCULO <> 3
                )                                                                                   as QTD_CONVOCADOS,

                -- ### Quantidade de ocorrencias ###
                CASE
                    WHEN EXISTS(
                            SELECT 1
                            FROM SERVICE_VAGAS_DEV.OCORRENCIAS_APRENDIZ OCORRENCIA
                            WHERE OCORRENCIA.ID_VAGA_APRENDIZ = V.ID
                              AND OCORRENCIA.deletado = 0
                        ) THEN 1
                    ELSE 0 END                                                                      as POSSUI_OCORRENCIAS,

                case
                    when V.DIVULGAR_NOME_EMPRESA = 1 then
                        CASE
                            WHEN (INF_EMP.TIPO_EMPRESA IS NOT NULL AND INF_EMP.TIPO_EMPRESA = 'EMPRESA JURIDICA') OR
                                 INF_EMP.NOME IS NULL THEN INF_EMP.RAZAO_SOCIAL
                            ELSE INF_EMP.NOME END
                    else V.DESCRICAO_EMPRESA END                                                       "NOME_RAZAO_EMPRESA",
                V.ID_LOCAL_CONTRATO,
                V.DATA_CRIACAO                                                                         "DATA_ABERTURA",
                V.DESCRICAO                                                                            "DESCRICAO_VAGA",
                V.ID_SITUACAO_VAGA
         FROM SERVICE_VAGAS_DEV."VAGAS_APRENDIZ" V
                  INNER JOIN SERVICE_VAGAS_DEV."REP_LOCAIS_CONTRATO" LOC ON LOC.ID = V.ID_LOCAL_CONTRATO
                  INNER JOIN SERVICE_VAGAS_DEV."REP_LOCAIS_ENDERECOS" LOC_END ON LOC_END.ID_LOCAL_CONTRATO = LOC.ID
                  INNER JOIN SERVICE_VAGAS_DEV."REP_ENDERECOS" END_EMP ON END_EMP.ID = LOC_END.ID_ENDERECO
                  INNER JOIN SERVICE_VAGAS_DEV.REP_INFO_CONTRATO_EMPRESAS INF_EMP
                             ON LOC.ID_CONTRATO = INF_EMP.ID_CONTRATO
                  INNER JOIN SERVICE_VAGAS_DEV.TURMAS T ON T.ID_VAGA_APRENDIZ = V.ID
                  INNER JOIN SERVICE_VAGAS_DEV.CURSOS_CAPACITACAO CC on V.ID_CURSO_CAPACITACAO = CC.ID
         WHERE (V_ID_VAGA_APRENDIZ IS NULL OR V.ID = V_ID_VAGA_APRENDIZ)
           AND INF_EMP.PRINCIPAL = 1
           AND (T.TURMA IS NULL OR T.TURMA = 0)
           AND (V.CONTRATACAO_DIRETA is null or V.CONTRATACAO_DIRETA = 0)
           AND v.deletado = 0
           AND LOC.deletado = 0
           AND LOC_END.deletado = 0
           AND LOC_END.DATA_ALTERACAO = (select max(data_alteracao) from REP_LOCAIS_ENDERECOS LOC_END where LOC_END.DELETADO = 0 and ID_LOCAL_CONTRATO = LOC.ID)
           AND END_EMP.deletado = 0
           AND T.DELETADO = 0
        ) S
    ON (D.CODIGO_DA_VAGA = S.CODIGO_DA_VAGA AND D.TIPO_VAGA = 'A')
    WHEN MATCHED THEN
        UPDATE
        SET D.ID_UNIDADE_CIEE            = S.ID_UNIDADE_CIEE
          , D.SEMESTRE_INICIAL           = S.SEMESTRE_INICIAL
          , D.SEMESTRE_FINAL             = S.SEMESTRE_FINAL
          , D.SEXO                       = S.SEXO
          , D.RESERVISTA                 = S.RESERVISTA
          , D.FUMANTE                    = S.FUMANTE
          , D.POSSUI_CNH                 = S.POSSUI_CNH
          , D.EMPRESA_COM_ACESSIBILIDADE = S.EMPRESA_COM_ACESSIBILIDADE
          , D.VALIDO_COTA                = S.VALIDO_COTA
          , D.ESTADO_CIVIL               = S.ESTADO_CIVIL
          , D.IDIOMAS                    = S.IDIOMAS
          , D.ESCOLAS                    = S.ESCOLAS
          , D.PCDS                       = S.PCDS
          , D.POSSUI_PCD                 = S.POSSUI_PCD
          , D.RECURSOS_ACESSIBILIDADE    = S.RECURSOS_ACESSIBILIDADE
          , D.PRIORIZA_VULNERAVEL        = S.PRIORIZA_VULNERAVEL
          , D.QUALIFICACOES              = S.QUALIFICACOES
          , D.CONHECIMENTOS              = S.CONHECIMENTOS
          , D.CURSOS                     = S.CURSOS
          , D.ENDERECO                   = S.ENDERECO
          , D.ENDERECO_GEOHASHS          = S.ENDERECO_GEOHASHS
          , D.CAPACITACAO                = S.CAPACITACAO
          , D.CAPACITACAO_GEOHASHS       = S.CAPACITACAO_GEOHASHS
          , D.TIPO_HORARIO_ESTAGIO       = S.TIPO_HORARIO_ESTAGIO
          , D.HORARIO_ENTRADA            = S.HORARIO_ENTRADA
          , D.HORARIO_SAIDA              = S.HORARIO_SAIDA
          , D.VALOR_RAIO                 = S.VALOR_RAIO
          , D.LOCALIZACAO                = S.LOCALIZACAO
          , D.IDADE_MINIMA               = S.IDADE_MINIMA
          , D.IDADE_MAXIMA               = S.IDADE_MAXIMA
          , D.SITUACAO_ESCOLARIDADE      = S.SITUACAO_ESCOLARIDADE
          , D.ESCOLARIDADE               = S.ESCOLARIDADE
          , D.DATA_CONCLUSAO             = S.DATA_CONCLUSAO
          --,D.TIPO_VAGA = S.TIPO_VAGA
          , D.ID_SITUACAO_VAGA           = S.ID_SITUACAO_VAGA
          , D.ID_EMPRESA                 = S.ID_EMPRESA
          , D.ID_AREA_ATUACAO_APRENDIZ   = S.ID_AREA_ATUACAO
          , D.MODALIDADE_CAPACITACAO     = S.MODALIDADE_CAPACITACAO
          , D.VALOR_SALARIO              = S.VALOR_SALARIO
          , D.VALOR_SALARIO_DE           = S.VALOR_SALARIO_DE
          , D.VALOR_SALARIO_ATE          = S.VALOR_SALARIO_ATE
          , D.CURSOS_CAPACITACAO         = S.CURSOS_CAPACITACAO
          , D.QTD_CONVOCADOS             = S.QTD_CONVOCADOS
          , D.POSSUI_OCORRENCIAS         = S.POSSUI_OCORRENCIAS
          , D.NOME_RAZAO_EMPRESA         = S.NOME_RAZAO_EMPRESA
          , D.ID_LOCAL_CONTRATO          = S.ID_LOCAL_CONTRATO
          , D.DATA_ABERTURA              = S.DATA_ABERTURA
          , D.DESCRICAO_VAGA             = S.DESCRICAO_VAGA
          , D.DATA_ALTERACAO             = sysdate
          ,d.data_triagem                = NULL
    WHEN NOT MATCHED THEN
        INSERT
        ( ID_UNIDADE_CIEE
        , CODIGO_DA_VAGA
        , SEMESTRE_INICIAL
        , SEMESTRE_FINAL
        , SEXO
        , RESERVISTA
        , FUMANTE
        , POSSUI_CNH
        , EMPRESA_COM_ACESSIBILIDADE
        , VALIDO_COTA
        , ESTADO_CIVIL
        , IDIOMAS
        , ESCOLAS
        , PCDS
        , POSSUI_PCD
        , RECURSOS_ACESSIBILIDADE
        , PRIORIZA_VULNERAVEL
        , QUALIFICACOES
        , CONHECIMENTOS
        , CURSOS
        , ENDERECO
        , ENDERECO_GEOHASHS
        , CAPACITACAO
        , CAPACITACAO_GEOHASHS
        , TIPO_HORARIO_ESTAGIO
        , HORARIO_ENTRADA
        , HORARIO_SAIDA
        , VALOR_RAIO
        , LOCALIZACAO
        , IDADE_MINIMA
        , IDADE_MAXIMA
        , SITUACAO_ESCOLARIDADE
        , ESCOLARIDADE
        , DATA_CONCLUSAO
        , TIPO_VAGA
        , ID_EMPRESA
        , ID_AREA_ATUACAO_APRENDIZ
        , VALOR_SALARIO
        , VALOR_SALARIO_DE
        , VALOR_SALARIO_ATE
        , CURSOS_CAPACITACAO
        , QTD_CONVOCADOS
        , POSSUI_OCORRENCIAS
        , NOME_RAZAO_EMPRESA
        , ID_LOCAL_CONTRATO
        , DATA_ABERTURA
        , DESCRICAO_VAGA
        , DATA_ALTERACAO
        , ID_SITUACAO_VAGA)
        VALUES ( S.ID_UNIDADE_CIEE
               , S.CODIGO_DA_VAGA
               , S.SEMESTRE_INICIAL
               , S.SEMESTRE_FINAL
               , S.SEXO
               , S.RESERVISTA
               , S.FUMANTE
               , S.POSSUI_CNH
               , S.EMPRESA_COM_ACESSIBILIDADE
               , S.VALIDO_COTA
               , S.ESTADO_CIVIL
               , S.IDIOMAS
               , S.ESCOLAS
               , S.PCDS
               , S.POSSUI_PCD
               , S.RECURSOS_ACESSIBILIDADE
               , S.PRIORIZA_VULNERAVEL
               , S.QUALIFICACOES
               , S.CONHECIMENTOS
               , S.CURSOS
               , S.ENDERECO
               , S.ENDERECO_GEOHASHS
               , S.CAPACITACAO
               , S.CAPACITACAO_GEOHASHS
               , S.TIPO_HORARIO_ESTAGIO
               , S.HORARIO_ENTRADA
               , S.HORARIO_SAIDA
               , S.VALOR_RAIO
               , S.LOCALIZACAO
               , S.IDADE_MINIMA
               , S.IDADE_MAXIMA
               , S.SITUACAO_ESCOLARIDADE
               , S.ESCOLARIDADE
               , S.DATA_CONCLUSAO
               , S.TIPO_VAGA
               , S.ID_EMPRESA
               , S.ID_AREA_ATUACAO
               , S.VALOR_SALARIO
               , S.VALOR_SALARIO_DE
               , S.VALOR_SALARIO_ATE
               , S.CURSOS_CAPACITACAO
               , S.QTD_CONVOCADOS
               , S.POSSUI_OCORRENCIAS
               , S.NOME_RAZAO_EMPRESA
               , S.ID_LOCAL_CONTRATO
               , S.DATA_ABERTURA
               , S.DESCRICAO_VAGA
               , sysdate /*DATA ALTERACAO*/
               , S.ID_SITUACAO_VAGA);
END;