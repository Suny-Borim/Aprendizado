create or REPLACE PROCEDURE         {{user}}.proc_atualizar_triagem_vaga_estagio(
    V_ID_VAGA_ESTAGIO NUMBER DEFAULT NULL
    )
AS
BEGIN

    MERGE INTO {{user}}."TRIAGENS_VAGAS" D
        USING
        (
        SELECT LOC_END.ID_UNIDADE_CIEE,
        V.CODIGO_DA_VAGA,
        V.SEMESTRE_INICIAL,
        V.SEMESTRE_FINAL,
        NVL(V.SEXO, 'I') as SEXO,
        NVL(V.RESERVISTA, 0) as RESERVISTA,
        NVL(V.FUMANTE, 0) as FUMANTE,
        NVL(V.POSSUI_CNH, 0) as POSSUI_CNH,
        NVL(V.EMPRESA_COM_ACESSIBILIDADE, 0) as EMPRESA_COM_ACESSIBILIDADE,
        NVL(V.VALIDO_COTA, 0) as VALIDO_COTA,

        -- ### ESTADO CIVIL ###
        (
        SELECT cast(
        collect (ECVE.ESTADO_CIVIL) as {{user}}.IDS_TYP
        )
        FROM {{user}}."ESTADO_CIVIL_VAGA_ESTAGIO" ECVE
        WHERE ECVE.ID_VAGA_ESTAGIO = V.ID
        ) as ESTADO_CIVIL,


        -- ### IDIOMAS ###
        (
        SELECT cast(collect (
        {{user}}.IDIOMA_TYP(
        IDIOMAS.ID,
        CASE IDIOMAS.IDIOMA
        WHEN 'Alemão' THEN 'ALEMAO'
        WHEN 'Espanhol' THEN 'ESPANHOL'
        WHEN 'Francês' THEN 'FRANCES'
        WHEN 'Inglês' THEN 'INGLES'
        WHEN 'Italiano' THEN 'ITALIANO'
        WHEN 'Japonês' THEN 'JAPONES'
        END,
        CASE VAGA_IDIOMAS.NIVEL
        WHEN 'BASICO' THEN 10
        WHEN 'INTERMEDIARIO' THEN 20
        ELSE 30 END,
        null)
        ) as {{user}}.IDIOMAS_TYP)
        FROM {{user}}.IDIOMAS_ESTAGIO VAGA_IDIOMAS
        INNER JOIN {{user}}.IDIOMAS IDIOMAS ON VAGA_IDIOMAS.id_idioma = IDIOMAS.id
        WHERE VAGA_IDIOMAS.ID_VAGA_ESTAGIO = V.ID
        AND VAGA_IDIOMAS.deletado = 0
        AND IDIOMAS.deletado = 0
        ) as idiomas,

        -- ### Escolas ###
        (
        SELECT cast(
        collect (VAG_ESC.ID_INSTITUICAO_ENSINO) as {{user}}.IDS_TYP
        )
        FROM {{user}}.VAGAS_INSTITUICOES_ENSINO VAG_ESC
        WHERE VAG_ESC.ID_VAGA_ESTAGIO = V.ID
        AND VAG_ESC.deletado = 0
        ) as escolas,

        -- ### PCD ###
        (
        SELECT cast(collect (
        {{user}}.PCD_VAGA_TYP(
        PCD.ID_CID_AGRUPADO,
        PCD.VALIDADE_MINMA_LAUDO
        )
        ) as {{user}}.PCDS_VAGA_TYP)
        FROM {{user}}.PCD_ESTAGIO PCD
        WHERE PCD.ID_VAGA_ESTAGIO = V.ID
        AND PCD.deletado = 0
        ) as pcds,

        -- ### POSSUI PCD ###
        NVL(V.PCD, 0) POSSUI_PCD,
        (
        SELECT CAST(COLLECT (APARELHO.ID_APARELHO) AS {{user}}.IDS_TYP)
        from {{user}}.APARELHOS_PCD APARELHO
        INNER JOIN {{user}}.PCD_ESTAGIO PA on APARELHO.ID_PCD = PA.ID
        WHERE PA.ID_VAGA_ESTAGIO = V.ID
        AND PA.deletado = 0
        ) RECURSOS_ACESSIBILIDADE,

        V.PRIORIZA_VULNERAVEL,

        -- ### Qualificacao estagio ###
        (
        SELECT cast(collect (
        VQVE.ID_QUALIFICACAO
        ) as {{user}}.IDS_TYP)
        FROM {{user}}.VINCULO_QUALI_VAGA_ESTAGIO VQVE
        WHERE V.ID = VQVE.ID_VAGA_ESTAGIO
        ) as QUALIFICACOES,

        -- ### Conhecimento ###
        (
        SELECT cast(collect (
        {{user}}.conhecimento_typ(
        CONHEC.CONHECIMENTO,
        CASE VAGA_CONHEC.NIVEL
        WHEN 'BASICO' THEN 10
        WHEN 'INTERMEDIARIO' THEN 20
        ELSE 30 END,
        null)
        ) as {{user}}.conhecimentos_typ)
        FROM {{user}}.CONHECIMENTOS_INF_ESTAGIO VAGA_CONHEC
        INNER JOIN {{user}}.CONHECIMENTOS CONHEC
        ON CONHEC.ID = VAGA_CONHEC.ID_CONHECIMENTO
        WHERE VAGA_CONHEC.ID_VAGA_ESTAGIO = V.ID
        AND VAGA_CONHEC.deletado = 0
        ) as conhecimentos,

        -- ### Cursos ###
        (
        SELECT cast(collect (
        VAGA_ESTAGIO.CODIGO_CURSO
        ) as {{user}}.IDS_TYP)
        FROM {{user}}.CURSOS_VAGAS_ESTAGIO VAGA_ESTAGIO
        WHERE VAGA_ESTAGIO.ID_VAGA_ESTAGIO = V.ID
        ) as cursos,

        END_EMP.GEO_POINT as ENDERECO,

        --A Funcao do Oracle esta retornando nulo em alguns momentos
        /*"SDO_CS.TO_GEOHASH(END_EMP.GEO_POINT, 4) */
        {{user}}."GEOHASH_NEIGHBORS"(
        {{user}}.GEOHASH_ENCODE(SDO_GEOM.SDO_CENTROID(END_EMP.GEO_POINT, 0.05).sdo_point.y,
        SDO_GEOM.SDO_CENTROID(END_EMP.GEO_POINT, 0.05).sdo_point.x, 4)
        ) AS ENDERECO_GEOHASHS,
        null CAPACITACAO,
        null CAPACITACAO_GEOHASHS,

        V.HORARIO_ENTRADA,
        V.HORARIO_SAIDA,
        V.VALOR_RAIO "VALOR_RAIO",
        V.LOCALIZACAO "LOCALIZACAO",
        COALESCE (
        case
        when V.IDADE_MINIMA is not null then V.IDADE_MINIMA
        when V.IDADE_MINIMA is null then
        CASE WHEN V.FAIXA_ETARIA = 2 then 18 else null end
        else null
        END,
        (
        SELECT PPE.IDADE_MINIMA
        FROM {{user}}.REP_PARAMETROS_PROGRAMA_EST PPE
        INNER JOIN {{user}}.REP_PARAMETROS_UNIDADES_CIEE PUC
        ON PPE.CODIGO_CIEE = PUC.ID_CIEE
        WHERE PUC.ID_UNIDADE_CIEE = LOC_END.ID_UNIDADE_CIEE), 16
        ) as IDADE_MINIMA,
        COALESCE (
        case
        when V.IDADE_MAXIMA is not null then V.IDADE_MAXIMA
        when V.IDADE_MAXIMA is null then
        CASE WHEN V.FAIXA_ETARIA = 1 then 18 else null end
        else null
        END,
        (
        SELECT PPE.IDADE_MAXIMA
        FROM {{user}}.REP_PARAMETROS_PROGRAMA_EST PPE
        INNER JOIN {{user}}.REP_PARAMETROS_UNIDADES_CIEE PUC
        ON PPE.CODIGO_CIEE = PUC.ID_CIEE
        WHERE PUC.ID_UNIDADE_CIEE = LOC_END.ID_UNIDADE_CIEE), 99
        ) as IDADE_MAXIMA,
        null SITUACAO_ESCOLARIDADE,
        NIVEL_ESTUDANTE_VAGA ESCOLARIDADE,
        LAST_DAY(TRUNC(V.DATA_CONCLUSAO, 'MON')) DATA_CONCLUSAO,
        V.TIPO_HORARIO_ESTAGIO TIPO_HORARIO_ESTAGIO,
        'E' tipo_vaga,
        INF_EMP.ID_EMPRESA,
        V.CODIGO_AREA_PROFISSIONAL,
        V.VALOR_BOLSA_FIXO,
        V.VALOR_BOLSA_DE,
        V.VALOR_BOLSA_ATE,

        -- ### Area atuacao estagio ###
        (
        SELECT cast(collect (
        area_atuacao.CODIGO_AREA_ATUACAO
        ) as {{user}}.IDS_TYP)
        FROM {{user}}.AREAS_ATUACAO_VAGAS_ESTAGIO area_atuacao
        WHERE area_atuacao.ID_VAGA_ESTAGIO = V.ID
        ) as AREAS_ATUACAO_ESTAGIO,

        -- ### Quantidade de ocorrencias ###
        CASE
        WHEN EXISTS (
        SELECT 1
        FROM {{user}}.OCORRENCIAS_ESTAGIO OCORRENCIA
        WHERE OCORRENCIA.ID_VAGA_ESTAGIO = V.ID
        AND OCORRENCIA.deletado = 0
        ) THEN 1
        ELSE 0 END as POSSUI_OCORRENCIAS,
        case
        when V.DIVULGAR_NOME_EMPRESA = 1 then
        CASE
        WHEN (INF_EMP.TIPO_EMPRESA IS NOT NULL AND INF_EMP.TIPO_EMPRESA = 'EMPRESA JURIDICA') OR INF_EMP.NOME IS NULL THEN INF_EMP.RAZAO_SOCIAL
        ELSE INF_EMP.NOME END
        else V.DESCRICAO_EMPRESA END "NOME_RAZAO_EMPRESA",

        -- ### Jornada em minutos ###
        CASE WHEN v.tipo_horario_estagio <> 0 THEN EXTRACT(HOUR FROM v.jornada) * 60 + EXTRACT(MINUTE FROM v.jornada) ELSE null END jornada_minutos,
        V.ID_LOCAL_CONTRATO,
        V.DATA_CRIACAO "DATA_ABERTURA",
        V.DESCRICAO "DESCRICAO_VAGA",
        (
        SELECT COUNT(1)
        FROM {{user}}.VINCULOS_VAGA vinculos
        WHERE vinculos.codigo_vaga = V.codigo_da_vaga
        AND vinculos.deletado = 0
        AND vinculos.SITUACAO_VINCULO <> 3
        ) "QTD_CONVOCADOS",
        V.ID_SITUACAO_VAGA,
        COALESCE(cec_loc.CLASSIFICACAO_OBTIDA, cec_emp.CLASSIFICACAO_OBTIDA, 'C') CLASSIFICACAO_OBTIDA,
        COALESCE(cec_loc.PONTUACAO_OBTIDA, cec_emp.PONTUACAO_OBTIDA, 0) PONTUACAO_OBTIDA
        FROM {{user}}."VAGAS_ESTAGIO" V
        INNER JOIN {{user}}."REP_LOCAIS_CONTRATO" LOC ON LOC.ID = V.ID_LOCAL_CONTRATO
        INNER JOIN {{user}}."REP_LOCAIS_ENDERECOS" LOC_END ON LOC_END.ID_LOCAL_CONTRATO = LOC.ID
        INNER JOIN {{user}}."REP_ENDERECOS" END_EMP ON END_EMP.ID = LOC_END.ID_ENDERECO
        INNER JOIN {{user}}.REP_INFO_CONTRATO_EMPRESAS INF_EMP
        ON LOC.ID_CONTRATO = INF_EMP.ID_CONTRATO
        LEFT JOIN {{user}}.qualificacoes_empresas_consolidado cec_emp on CEC_EMP.ID_EMPRESA = INF_EMP.ID_EMPRESA and CEC_EMP.ID_LOCAL_CONTRATO IS NULL
        LEFT JOIN {{user}}.qualificacoes_empresas_consolidado cec_loc on CEC_LOC.ID_EMPRESA = INF_EMP.ID_EMPRESA AND CEC_LOC.ID_LOCAL_CONTRATO = LOC.ID
        WHERE (V_ID_VAGA_ESTAGIO IS NULL OR V.ID = V_ID_VAGA_ESTAGIO)
        AND INF_EMP.PRINCIPAL = 1
        AND (V.CONTRATACAO_DIRETA is null or V.CONTRATACAO_DIRETA = 0)
        AND v.deletado = 0
        AND LOC.deletado = 0
        AND LOC_END.deletado = 0
        AND LOC_END.DATA_ALTERACAO = (select max (data_alteracao) from REP_LOCAIS_ENDERECOS LOC_END where LOC_END.DELETADO = 0 and ID_LOCAL_CONTRATO = LOC.ID)
        AND END_EMP.deletado = 0
        AND (cec_emp.deletado is null or cec_emp.deletado = 0)
        AND (cec_loc.deletado is null or cec_loc.deletado = 0)
        AND v.ID_SITUACAO_VAGA NOT IN (select id from {{user}}.situacoes where sigla in ('C', 'P'))
        ) S
        ON (D.CODIGO_DA_VAGA = S.CODIGO_DA_VAGA AND D.TIPO_VAGA = 'E')
    WHEN
    MATCHED THEN
    UPDATE
        SET D.ID_UNIDADE_CIEE = S.ID_UNIDADE_CIEE
        , D.SEMESTRE_INICIAL = S.SEMESTRE_INICIAL
        , D.SEMESTRE_FINAL = S.SEMESTRE_FINAL
        , D.SEXO = S.SEXO
        , D.RESERVISTA = S.RESERVISTA
        , D.FUMANTE = S.FUMANTE
        , D.POSSUI_CNH = S.POSSUI_CNH
        , D.EMPRESA_COM_ACESSIBILIDADE = S.EMPRESA_COM_ACESSIBILIDADE
        , D.VALIDO_COTA = S.VALIDO_COTA
        , D.ESTADO_CIVIL = S.ESTADO_CIVIL
        , D.IDIOMAS = S.IDIOMAS
        , D.ESCOLAS = S.ESCOLAS
        , D.PCDS = S.PCDS
        , D.POSSUI_PCD = S.POSSUI_PCD
        , D.RECURSOS_ACESSIBILIDADE = S.RECURSOS_ACESSIBILIDADE
        , D.PRIORIZA_VULNERAVEL = S.PRIORIZA_VULNERAVEL
        , D.QUALIFICACOES = S.QUALIFICACOES
        , D.CONHECIMENTOS = S.CONHECIMENTOS
        , D.CURSOS = S.CURSOS
        , D.ENDERECO = S.ENDERECO
        , D.ENDERECO_GEOHASHS = S.ENDERECO_GEOHASHS
        , D.CAPACITACAO = S.CAPACITACAO
        , D.CAPACITACAO_GEOHASHS = S.CAPACITACAO_GEOHASHS
        , D.TIPO_HORARIO_ESTAGIO = S.TIPO_HORARIO_ESTAGIO
        , D.HORARIO_ENTRADA = S.HORARIO_ENTRADA
        , D.HORARIO_SAIDA = S.HORARIO_SAIDA
        , D.VALOR_RAIO = S.VALOR_RAIO
        , D.LOCALIZACAO = S.LOCALIZACAO
        , D.IDADE_MINIMA = S.IDADE_MINIMA
        , D.IDADE_MAXIMA = S.IDADE_MAXIMA
        , D.SITUACAO_ESCOLARIDADE = S.SITUACAO_ESCOLARIDADE
        , D.ESCOLARIDADE = S.ESCOLARIDADE
        , D.DATA_CONCLUSAO = S.DATA_CONCLUSAO
        --,D.TIPO_VAGA = S.TIPO_VAGA
        , D.ID_EMPRESA = S.ID_EMPRESA
        , D.CODIGO_AREA_PROFISSIONAL = S.CODIGO_AREA_PROFISSIONAL
        , D.VALOR_BOLSA_FIXO = S.VALOR_BOLSA_FIXO
        , D.VALOR_BOLSA_DE = S.VALOR_BOLSA_DE
        , D.VALOR_BOLSA_ATE = S.VALOR_BOLSA_ATE
        , D.AREAS_ATUACAO_ESTAGIO = S.AREAS_ATUACAO_ESTAGIO
        , D.POSSUI_OCORRENCIAS = S.POSSUI_OCORRENCIAS
        , D.NOME_RAZAO_EMPRESA = S.NOME_RAZAO_EMPRESA
        , D.JORNADA_MINUTOS = S.JORNADA_MINUTOS
        , D.ID_LOCAL_CONTRATO = S.ID_LOCAL_CONTRATO
        , D.DATA_ABERTURA = S.DATA_ABERTURA
        , D.DESCRICAO_VAGA = S.DESCRICAO_VAGA
        , D.DATA_ALTERACAO = sysdate
        , D.QTD_CONVOCADOS = S.QTD_CONVOCADOS
        , D.ID_SITUACAO_VAGA = S.ID_SITUACAO_VAGA
        , D.CLASSIFICACAO_EMPRESA = S.CLASSIFICACAO_OBTIDA
        , D.PONTUACAO_EMPRESA = S.PONTUACAO_OBTIDA
    WHEN
    NOT
    MATCHED THEN
    INSERT
        (ID_UNIDADE_CIEE , CODIGO_DA_VAGA
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
            , CODIGO_AREA_PROFISSIONAL
            , VALOR_BOLSA_FIXO
            , VALOR_BOLSA_DE
            , VALOR_BOLSA_ATE
            , AREAS_ATUACAO_ESTAGIO
            , POSSUI_OCORRENCIAS
            , NOME_RAZAO_EMPRESA
            , JORNADA_MINUTOS
            , ID_LOCAL_CONTRATO
            , DATA_ABERTURA
            , DESCRICAO_VAGA
            , DATA_ALTERACAO
            , QTD_CONVOCADOS
            , ID_SITUACAO_VAGA
            , CLASSIFICACAO_EMPRESA
            , PONTUACAO_EMPRESA
        )
        VALUES
    (
     S.ID_UNIDADE_CIEE
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
        , S.CODIGO_AREA_PROFISSIONAL
        , S.VALOR_BOLSA_FIXO
        , S.VALOR_BOLSA_DE
        , S.VALOR_BOLSA_ATE
        , S.AREAS_ATUACAO_ESTAGIO
        , S.POSSUI_OCORRENCIAS
        , S.NOME_RAZAO_EMPRESA
        , S.JORNADA_MINUTOS
        , S.ID_LOCAL_CONTRATO
        , S.DATA_ABERTURA
        , S.DESCRICAO_VAGA
        , sysdate /*DATA_ALTERACAO*/
        , S.QTD_CONVOCADOS
        , S.ID_SITUACAO_VAGA
        , S.CLASSIFICACAO_OBTIDA
        , S.PONTUACAO_OBTIDA
        );
END;
/

