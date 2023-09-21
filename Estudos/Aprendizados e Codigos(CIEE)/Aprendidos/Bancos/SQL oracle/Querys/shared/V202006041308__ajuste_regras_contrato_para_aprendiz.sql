alter table TRIAGENS_ESTUDANTES
    add (CONTRATOS_CURSOS_CAPACITACAO IDS_TYP)
        NESTED TABLE CONTRATOS_CURSOS_CAPACITACAO store as n_contratos_cursos_capacitacao
;

create or replace PROCEDURE                        proc_atualizar_triagem_estudante_lista (
    V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL
)
AS
    l_query  CLOB;
    V_IDS_ESTUDANTES_INTERNO IDS_TYP;
BEGIN

    V_IDS_ESTUDANTES_INTERNO := V_IDS_ESTUDANTES;

    -- Remove os estudantes inativos ou excluidos
    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_remove_inativo(V_IDS_ESTUDANTES_INTERNO);

    l_query := 'MERGE INTO SERVICE_VAGAS_DEV.TRIAGENS_ESTUDANTES D
        USING
        (SELECT
            EST.ID "ID_ESTUDANTE",
            ENDER.GEO_POINT "ENDERECO",
            SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.y,
            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.x, 4
        ) as ENDERECO_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ENDER.GEO_POINT, 4) as "ENDERECO_GEOHASH",

        ESCOL.GEO_POINT "ENDERECO_CAMPUS",

        SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.y,
            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.x, 4
        ) as ENDERECO_CAMPUS_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ESCOL.GEO_POINT, 4) as "ENDERECO_CAMPUS_GEOHASH",

        EST.DATA_NASCIMENTO "DATA_NASCIMENTO",

        -- ### Estado Civil ###
        case
            when EST.ESTADO_CIVIL = ''SOLTEIRO'' then 1
            when EST.ESTADO_CIVIL = ''CASADO'' then 2
            when EST.ESTADO_CIVIL = ''SEPARADO'' then 3
            when EST.ESTADO_CIVIL = ''DIVORCIADO'' then 4
            when EST.ESTADO_CIVIL = ''VIUVO'' then 5
        end "ESTADO_CIVIL",
        case when EST.SEXO = ''FEMININO'' then ''F'' ELSE ''M'' end "SEXO",
        NVL(EST.USA_RECURSOS_ACESSIBILIDADE, 0) "USA_RECURSOS_ACESSIBILIDADE",
        NVL(EST.ELEGIVEL_PCD, 0) "ELEGIVEL_PCD",
        NVL(INFO.RESERVISTA, 0) "RESERVISTA",
        NVL(INFO.FUMANTE, 0) "FUMANTE",
        NVL(INFO.CNH, 0) "CNH",
        --2020-03-20
        NVL(INFO.ID_GENERO, 0) "GENERO",
        NVL(INFO.ID_ETNIA, 0) "ETNIA",
        ESCOL.TIPO_DURACAO_CURSO "TIPO_DURACAO_CURSO",

        -- ### Semestre ###
        NVL(CASE
            WHEN STATUS_ESCOLARIDADE = ''CURSANDO'' THEN CONVERSAO_SEMESTRE(PERIODO_ATUAL, TIPO_DURACAO_CURSO)
            WHEN STATUS_ESCOLARIDADE = ''INTERROMPIDO'' THEN CONVERSAO_SEMESTRE(ULTIMO_PERIODO_CURSADO, TIPO_DURACAO_CURSO)
            WHEN STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN CONVERSAO_SEMESTRE(DURACAO_CURSO, TIPO_DURACAO_CURSO, 1)
        END, -1) SEMESTRE,

        -- ### Data Conclusao ###
        LAST_DAY(TRUNC(CASE
            WHEN STATUS_ESCOLARIDADE = ''CURSANDO'' THEN ESCOL.DATA_CONCLUSAO_CALCULADA
            WHEN STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN ESCOL.DATA_CONCLUSAO
            ELSE NULL
        END, ''MON'')) "DATA_CONCLUSAO_CURSO",

        ESCOL.DURACAO_CURSO "DURACAO_CURSO",
        ESCOL.PERIODO_ATUAL "PERIODO_ATUAL",
        ESCOL.TIPO_PERIODO_CURSO "TIPO_PERIODO_CURSO",
        CURS.MODALIDADE "MODALIDADE",

        -- ### Horario Entrada ###
        case
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Manhã'' then TO_DATE(''19700101 08:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Tarde'' then TO_DATE(''19700101 13:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Noite'' then TO_DATE(''19700101 18:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Integral'' then TO_DATE(''19700101 08:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Vespertino'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
            else null
        end "HORARIO_ENTRADA",

        -- ### Horario Saida ###
        case
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Manhã'' then TO_DATE(''19700101 12:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Tarde'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Noite'' then TO_DATE(''19700101 22:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Integral'' then TO_DATE(''19700101 17:00'', ''yyyymmdd hh24:mi'')
            when CURS.MODALIDADE = ''P'' AND ESCOL.TIPO_PERIODO_CURSO = ''Vespertino'' then TO_DATE(''19700101 21:00'', ''yyyymmdd hh24:mi'')
            else null
        end "HORARIO_SAIDA",

        -- ### Escolas ###

        (
            SELECT
            cast(collect(ESC.ID_ESCOLA) as SERVICE_VAGAS_DEV.IDS_TYP)
            FROM
            SERVICE_VAGAS_DEV.REP_ESCOLARIDADES_ESTUDANTES ESC
            WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = ''0''
        ) "ESCOLAS",


        -- ### Cursos ###
        (
            SELECT
            cast(collect(CAST(ESC.ID_CURSO AS NUMBER(19,0))) as SERVICE_VAGAS_DEV.IDS_TYP)
            FROM
            SERVICE_VAGAS_DEV.REP_ESCOLARIDADES_ESTUDANTES ESC
            WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = ''0''
        ) "CURSOS",
        CAST(ESCOL.ID_CURSO AS NUMBER) CODIGO_CURSO_PRINCIPAL,

        -- ### Vinculos ###
        (
            SELECT
                CAST(COLLECT(
                SERVICE_VAGAS_DEV.VINCULO_TYP(
                VV.CODIGO_VAGA,
                VV.SITUACAO_VINCULO)
                ) AS SERVICE_VAGAS_DEV.VINCULOS_TYP)
            from SERVICE_VAGAS_DEV.VINCULOS_VAGA VV
                LEFT JOIN SERVICE_VAGAS_DEV.VINCULOS_CONVOCACAO VC on VV.ID = VC.ID_VINCULO
                WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = ''0''
                AND VC.ID IS NULL OR (VC.DATA_LIBERACAO_CONVOCACAO IS NOT NULL AND VC.ID_RECUSA IS NULL)
        ) VINCULOS,

        -- ### Idiomas ###

        (
            SELECT
            CAST(COLLECT(
            SERVICE_VAGAS_DEV.IDIOMA_TYP(
            RIN.ID,
            CASE RIN.IDIOMA
                WHEN ''ALEMÃO'' THEN ''ALEMAO''
                WHEN ''ESPANHOL'' THEN ''ESPANHOL''
                WHEN ''FRANCÊS'' THEN ''FRANCES''
                WHEN ''INGLÊS'' THEN ''INGLES''
                WHEN ''ITALIANO'' THEN ''ITALIANO''
                WHEN ''JAPONÊS'' THEN ''JAPONES''
            END,
            CASE WHEN NIVEL = ''BÁSICO'' THEN 10
                WHEN NIVEL = ''INTERMEDIÁRIO'' THEN 20
                ELSE 30
            END,
            CASE WHEN RIN.DOCUMENTO_ID IS NULL THEN 0 ELSE 1 END)
            ) AS SERVICE_VAGAS_DEV.IDIOMAS_TYP)
            from SERVICE_VAGAS_DEV.REP_IDIOMAS_NIVEIS RIN
            WHERE RIN.ESTUDANTE_ID = EST.ID AND RIN.DELETADO = ''0''
        ) "IDIOMAS",

        -- ### Conhecimentos ###
        (
            SELECT
            CAST(COLLECT(
                SERVICE_VAGAS_DEV.CONHECIMENTO_TYP(RCI.TIPO_CONHECIMENTO,
                CASE WHEN NIVEL_CONHECIMENTO = ''BASICO'' THEN 10
                WHEN NIVEL_CONHECIMENTO = ''INTERMEDIARIO'' THEN 20
                ELSE 30
                END,
                CASE WHEN RCI.ID_DOCUMENTO IS NULL THEN 0 ELSE 1 END)
            ) AS SERVICE_VAGAS_DEV.CONHECIMENTOS_TYP)
            from SERVICE_VAGAS_DEV.REP_CONHECIMENTOS_INFORMATICA RCI
            WHERE RCI.ID_ESTUDANTE = EST.ID AND RCI.DELETADO = ''0''
        ) "CONHECIMENTOS",

        -- ### Recursos Acessibilidade ###
        (SELECT
            CAST(COLLECT(REC.APARELHO_ID) AS SERVICE_VAGAS_DEV.IDS_TYP)
            from SERVICE_VAGAS_DEV.REP_RECURSOS_ACESSIBILIDADE REC
            WHERE REC.ESTUDANTE_ID = EST.ID AND REC.DELETADO = ''0'') RECURSOS_ACESSIBILIDADE,
        EST.USA_RECURSOS_ACESSIBILIDADE "USA_RECURSO_ACESSIBILIDADE",


        -- ### PCD ###
        (
            SELECT
            CAST(COLLECT(
            SERVICE_VAGAS_DEV.PCD_ESTUDANTE_TYP(
            LM.ID_CID_AGRUPADO,
            MAX(LMD.DATA_VENCIMENTO),
            CASE LMD.STATUS
                WHEN ''VALIDO'' THEN 1
                WHEN ''INVALIDO'' THEN 2
                WHEN ''VENCIDO'' THEN 3
                WHEN ''PENDENTE'' THEN 4
            END,
            LM.PRINCIPAL)
            ) AS SERVICE_VAGAS_DEV.PCDS_ESTUDANTE_TYP)
            from SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS LM
            INNER JOIN SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS LMD on LM.ID = LMD.LAUDO_MEDICO_ID
            WHERE LM.deletado = ''0'' and LMD.DELETADO = ''0'' AND LM.ESTUDANTE_ID = EST.ID
            GROUP BY LM.ID, LM.ID_CID_AGRUPADO, LMD.STATUS, LM.PRINCIPAL
        ) PCDs,


        -- ### Vencimento Laudo ###
        (
            SELECT MAX(DATA_VENCIMENTO)
            FROM SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS LMD
            INNER JOIN SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS RLM on LMD.LAUDO_MEDICO_ID = RLM.ID
            where RLM.ESTUDANTE_ID = EST.ID AND LMD.STATUS = ''VALIDO'' AND RLM.PRINCIPAL = 1
            AND RLM.DELETADO = ''0'' AND LMD.DELETADO = ''0''
        ) VENCIMENTO_LAUDO,

        -- ### Vulneravel ###
        CASE
            -- Regra 1: Possui Cad Unico com documento ou encaminhado para CIEE via CRA, CREA, orgão de encaminhamento para mercado de trabalho, entidade social ou conselho tutelar
            WHEN exists(select 1 from REP_INFORMACOES_SOCIAIS RIS where RIS.ID_ESTUDANTE = EST.ID AND ((RIS.POSSUI_CADUNICO = 1 AND RIS.DOCUMENTO_CADUNICO IS NOT NULL) OR RIS.COMO_CONHECEU_CIEE IN (1, 2, 3, 4, 5))) THEN 1

            -- Regra 2: Cursa Ensino Fundamental, ou escola é pública
            WHEN exists(select 1 from REP_INSTITUICOES_ENSINOS RIE where RIE.ID = ESCOL.ID_ESCOLA and RIE.TIPO_ESCOLA IN (SELECT ID from REP_TIPOS_ESCOLAS_UNIT where SIGLA <> ''P'')) THEN 1

            -- Regra 3: Possui qualificação de vulnerável
            WHEN exists(select 1 from qualificacoes_estudante qe inner join qualificacao q on qe.id_qualificacao = q.id where qe.id_estudante = est.id and q.nome = ''Vulnerável'') THEN 1
            ELSE 0
        END "QUALIFICACAO_VULNERAVEL",

        -- ### Tipo Programa ###
            CASE
            WHEN EST.TIPO_PROGRAMA = ''ESTAGIO'' THEN 0
            WHEN EST.TIPO_PROGRAMA = ''APRENDIZ'' THEN 1
            WHEN EST.TIPO_PROGRAMA = ''ESTAGIO+APRENDIZ'' THEN 2
            ELSE 3
        END "TIPO_PROGRAMA",

        -- ### Situacao Escolaridade ###
        CASE WHEN ESCOL.STATUS_ESCOLARIDADE = ''CURSANDO'' THEN 0
            WHEN ESCOL.STATUS_ESCOLARIDADE = ''CONCLUIDO'' THEN 1
            ELSE 2
        END "STATUS_ESCOLARIDADE",

        -- ### Qualificacoes ###
        (
        SELECT
            CAST(COLLECT(
                SERVICE_VAGAS_DEV.QUALIFICACAO_TYP(
                QE.ID_QUALIFICACAO,
                QE.RESULTADO,
                QE.DATA_VALIDADE)
            ) AS SERVICE_VAGAS_DEV.QUALIFICACOES_TYP)
            from SERVICE_VAGAS_DEV.QUALIFICACOES_ESTUDANTE QE
            WHERE QE.ID_ESTUDANTE = EST.ID AND QE.DELETADO = ''0''
        ) QUALIFICACOES,
        ESCOL.SIGLA_NIVEL_EDUCACAO "NIVEL_CURSO",


        -- ### Contratos Estudante Empresa ###
        (
            select CAST(COLLECT(SERVICE_VAGAS_DEV.CONTRATO_EMP_TYP(ID, ID_EMPRESA, SITUACAO, TIPO_CONTRATO,ID_CURSO_CAPACITACAO)) AS SERVICE_VAGAS_DEV.CONTRATOS_EMP_TYP)
            from SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA
            where ID_ESTUDANTE = EST.ID
        ) "CONTRATOS_EMPRESA",

        -- ### Contratos Estudante Empresa ###
        (
            select CAST(COLLECT(ID_CURSO_CAPACITACAO) AS SERVICE_VAGAS_DEV.IDS_TYP)
            from SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA
            where ID_ESTUDANTE = EST.ID
        ) "CONTRATOS_CURSOS_CAPACITACAO",
        CASE WHEN CURS.MODALIDADE = ''P'' THEN 0 ELSE 1 END "CURSO_EAD",
        (
            SELECT
            COUNT(1)
            from SERVICE_VAGAS_DEV.VINCULOS_VAGA VV
            LEFT JOIN SERVICE_VAGAS_DEV.VINCULOS_CONVOCACAO VC on VV.ID = VC.ID_VINCULO
            WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = ''0''
            AND VC.ID IS NULL OR (VC.DATA_LIBERACAO_CONVOCACAO IS NOT NULL AND VC.ID_RECUSA IS NULL)
        ) QTD_CONVOCACOES,
        case when EST.VIDEO_URL IS NULL THEN 0 ELSE 1 END POSSUI_VIDEO,
        EST.VIDEO_URL VIDEO_URL,
        CASE
            WHEN EST.SITUACAO = ''ATIVO'' THEN 0
            WHEN EST.SITUACAO = ''INATIVO'' THEN 1
            WHEN EST.SITUACAO = ''BLOQUEADO'' THEN 2
        END SITUACAO,
        EST.NOME,
        CODIGO_ESTUDANTE,
        CPF,
        CASE
            WHEN SITUACAO_ANALISE_PCD = ''PENDENTE'' THEN 0
            WHEN SITUACAO_ANALISE_PCD = ''ANALISANDO'' THEN 1
            WHEN SITUACAO_ANALISE_PCD = ''ANALISADO'' THEN 2
            WHEN SITUACAO_ANALISE_PCD = ''APROVADO'' THEN 3
        END SITUACAO_ANALISE_PCD,
        RESP.ID ID_RESPONSAVEL,
        RESP.NOME_MAE,
        (
            SELECT CAST(COLLECT(SERVICE_VAGAS_DEV.ENDERECO_TYP(
            UF,
            CIDADE,
            ENDERECO,
            NUMERO,
            COMPLEMENTO,
            CEP,
            PRINCIPAL
            )) AS SERVICE_VAGAS_DEV.ENDERECOS_TYP) FROM REP_ENDERECOS_ESTUDANTES where ID_ESTUDANTE = EST.ID
        ) ENDERECOS,

        -- #### Info (experiências, idiomas, conhecimentos) ####
            XmlElement("estudante",
            XmlElement("conhecimentos",(SELECT XMLAGG(XmlElement("conhecimento", RCI.FERRAMENTA)) FROM SERVICE_VAGAS_DEV.REP_CONHECIMENTOS_INFORMATICA RCI WHERE RCI.ID_ESTUDANTE = EST.ID)),
            XmlElement("diversos",(SELECT XMLAGG(XmlElement("diverso", RCD.NOME_CURSO)) FROM SERVICE_VAGAS_DEV.REP_CONHECIMENTOS_DIVERSOS_STUDENT RCD WHERE RCD.ID_ESTUDANTE = EST.ID)),
            XmlElement("idiomas",(SELECT XMLAGG(XmlElement("idioma", RIN.IDIOMA)) FROM SERVICE_VAGAS_DEV.REP_IDIOMAS_NIVEIS RIN WHERE RIN.ESTUDANTE_ID = EST.ID)),
            XmlElement("experiencias",(SELECT XMLAGG(XmlElement("experiencia", REXP.NOME_EMPRESA)) FROM SERVICE_VAGAS_DEV.REP_EXPERIENCIAS_PROFISSIONAIS_STUDENT REXP WHERE REXP.ID_ESTUDANTE = EST.ID ))
        ).getClobVal() INFO,

        CASE
            WHEN EXISTS (SELECT 1 from REP_REDACOES_STUDENT RRS WHERE RRS.ID_ESTUDANTE = EST.ID AND CONTEUDO IS NOT NULL)THEN 1
            ELSE 0
        END POSSUI_REDACAO,
        NVL(CEC.CLASSIFICACAO_OBTIDA, ''C'') CLASSIFICACAO_OBTIDA,
        NVL(CEC.PONTUACAO_OBTIDA, 0) PONTUACAO_OBTIDA,
        case when (EST.SITUACAO = ''ATIVO''
            AND ENDER.PRINCIPAL = 1
            AND ESCOL.PRINCIPAL = 1
            AND ENDER.DELETADO = ''0''
            AND ESCOL.DELETADO = ''0''
            AND (INFO.DELETADO IS NULL OR INFO.DELETADO = ''0'')
            AND CURS.DELETADO = ''0''
               ) then 1
            else 0
        end APTO_TRIAGEM
        FROM
        SERVICE_VAGAS_DEV.REP_ESTUDANTES EST
        INNER JOIN SERVICE_VAGAS_DEV.REP_ENDERECOS_ESTUDANTES ENDER on EST.ID = ENDER.ID_ESTUDANTE
        INNER JOIN SERVICE_VAGAS_DEV.REP_ESCOLARIDADES_ESTUDANTES ESCOL on EST.ID = ESCOL.ID_ESTUDANTE
        LEFT JOIN SERVICE_VAGAS_DEV.REP_INFORMACOES_ADICIONAIS INFO ON INFO.ID = EST.ID_INFORMACOES_ADICIONAIS
        INNER JOIN SERVICE_VAGAS_DEV.REP_CURSOS CURS ON ESCOL.ID_CURSO = CURS.CODIGO_CURSO
        LEFT JOIN SERVICE_VAGAS_DEV.REP_RESPONSAVEIS RESP ON EST.ID_RESPONSAVEL = RESP.ID
        LEFT JOIN SERVICE_VAGAS_DEV.CLASSIFICACOES_ESTUDANTES_CONSOLIDADO CEC ON CEC.ID_ESTUDANTE = EST.ID
        WHERE
        --Filtra pelos estudantes que devem ser atualizados
';

    if (V_IDS_ESTUDANTES_INTERNO IS EMPTY OR V_IDS_ESTUDANTES_INTERNO IS NULL) THEN
        l_query := l_query || ':V_IDS_ESTUDANTES IS NULL';
    else
        l_query := l_query || 'EST.ID IN (select COLUMN_VALUE from table(:V_IDS_ESTUDANTES_INTERNO))';
    end if;

    l_query := l_query || '
        AND ENDER.PRINCIPAL = 1
        AND ESCOL.PRINCIPAL = 1
        AND EST.DELETADO = ''0''
        AND ENDER.DELETADO = ''0''
        AND ESCOL.DELETADO = ''0''
        AND (INFO.DELETADO IS NULL OR INFO.DELETADO = ''0'')
        AND CURS.DELETADO = ''0''
        AND EST.FLAG_ATIVO = 1
        ) S
        ON (D.ID_ESTUDANTE = S.ID_ESTUDANTE)
    WHEN NOT MATCHED THEN
    INSERT
        (D.ID_ESTUDANTE
            ,D.ENDERECO
            ,D.ENDERECO_GEOHASH
            ,D.ENDERECO_CAMPUS
            ,D.ENDERECO_CAMPUS_GEOHASH
            ,D.DATA_NASCIMENTO
            ,D.ESTADO_CIVIL
            ,D.SEXO
            ,D.USA_RECURSOS_ACESSIBILIDADE
            ,D.ELEGIVEL_PCD
            ,D.RESERVISTA
            ,D.FUMANTE
            ,D.CNH
            ,D.GENERO
            ,D.ETNIA
            ,D.TIPO_DURACAO_CURSO
            ,D.SEMESTRE
            ,D.DATA_CONCLUSAO_CURSO
            ,D.DURACAO_CURSO
            ,D.PERIODO_ATUAL
            ,D.TIPO_PERIODO_CURSO
            ,D.MODALIDADE
            ,D.HORARIO_ENTRADA
            ,D.HORARIO_SAIDA
            ,D.ESCOLAS
            ,D.CURSOS
            ,D.CODIGO_CURSO_PRINCIPAL
            ,D.VINCULOS
            ,D.IDIOMAS
            ,D.CONHECIMENTOS
            ,D.RECURSOS_ACESSIBILIDADE
            ,D.USA_RECURSO_ACESSIBILIDADE
            ,D.PCDS
            ,D.VENCIMENTO_LAUDO
            ,D.QUALIFICACAO_VULNERAVEL
            ,D.TIPO_PROGRAMA
            ,D.STATUS_ESCOLARIDADE
            ,D.QUALIFICACOES
            ,D.NIVEL_ENSINO
            ,D.CONTRATOS_EMPRESA,
            ,D.CONTRATOS_CURSOS_CAPACITACAO
            ,D.QTD_CONVOCACOES
            ,D.DATA_ALTERACAO
            ,D.POSSUI_VIDEO
            ,D.VIDEO_URL
            ,D.SITUACAO
            ,D.NOME
            ,D.CODIGO_ESTUDANTE
            ,D.CPF
            ,D.SITUACAO_ANALISE_PCD
            ,D.ID_RESPONSAVEL
            ,D.NOME_MAE
            ,D.ENDERECOS
            ,D.INFO
            ,D.POSSUI_REDACAO
            ,D.CLASSIFICACAO_OBTIDA
            ,D.PONTUACAO_OBTIDA
            ,D.APTO_TRIAGEM
        )
        VALUES
    (S.ID_ESTUDANTE
        ,S.ENDERECO
        ,S.ENDERECO_GEOHASH
        ,S.ENDERECO_CAMPUS
        ,S.ENDERECO_CAMPUS_GEOHASH
        ,S.DATA_NASCIMENTO
        ,S.ESTADO_CIVIL
        ,S.SEXO
        ,S.USA_RECURSOS_ACESSIBILIDADE
        ,S.ELEGIVEL_PCD
        ,S.RESERVISTA
        ,S.FUMANTE
        ,S.CNH
        ,S.GENERO
        ,S.ETNIA
        ,S.TIPO_DURACAO_CURSO
        ,S.SEMESTRE
        ,S.DATA_CONCLUSAO_CURSO
        ,S.DURACAO_CURSO
        ,S.PERIODO_ATUAL
        ,S.TIPO_PERIODO_CURSO
        ,S.MODALIDADE
        ,S.HORARIO_ENTRADA
        ,S.HORARIO_SAIDA
        ,S.ESCOLAS
        ,S.CURSOS
        ,S.CODIGO_CURSO_PRINCIPAL
        ,S.VINCULOS
        ,S.IDIOMAS
        ,S.CONHECIMENTOS
        ,S.RECURSOS_ACESSIBILIDADE
        ,S.USA_RECURSO_ACESSIBILIDADE
        ,S.PCDS
        ,S.VENCIMENTO_LAUDO
        ,S.QUALIFICACAO_VULNERAVEL
        ,S.TIPO_PROGRAMA
        ,S.STATUS_ESCOLARIDADE
        ,S.QUALIFICACOES
        ,S.NIVEL_CURSO
        ,S.CONTRATOS_EMPRESA
        ,S.CONTRATOS_CURSOS_CAPACITACAO
        ,S.QTD_CONVOCACOES
        ,sysdate
        ,S.POSSUI_VIDEO
        ,S.VIDEO_URL
        ,S.SITUACAO
        ,S.NOME
        ,S.CODIGO_ESTUDANTE
        ,S.CPF
        ,S.SITUACAO_ANALISE_PCD
        ,S.ID_RESPONSAVEL
        ,S.NOME_MAE
        ,S.ENDERECOS
        ,S.INFO
        ,S.POSSUI_REDACAO
        ,S.CLASSIFICACAO_OBTIDA
        ,S.PONTUACAO_OBTIDA
        , S.APTO_TRIAGEM
        )
    WHEN MATCHED THEN
    UPDATE SET
        D.ENDERECO = S.ENDERECO
        , D.ENDERECO_GEOHASH = S.ENDERECO_GEOHASH
        , D.ENDERECO_CAMPUS = S.ENDERECO_CAMPUS
        , D.ENDERECO_CAMPUS_GEOHASH = S.ENDERECO_CAMPUS_GEOHASH
        , D.DATA_NASCIMENTO = S.DATA_NASCIMENTO
        , D.ESTADO_CIVIL = S.ESTADO_CIVIL
        , D.SEXO = S.SEXO
        , D.USA_RECURSOS_ACESSIBILIDADE = S.USA_RECURSOS_ACESSIBILIDADE
        , D.ELEGIVEL_PCD = S.ELEGIVEL_PCD
        , D.RESERVISTA = S.RESERVISTA
        , D.FUMANTE = S.FUMANTE
        , D.CNH = S.CNH
        , D.GENERO = S.GENERO
        , D.ETNIA = S.ETNIA
        , D.TIPO_DURACAO_CURSO = S.TIPO_DURACAO_CURSO
        , D.SEMESTRE = S.SEMESTRE
        , D.DATA_CONCLUSAO_CURSO = S.DATA_CONCLUSAO_CURSO
        , D.DURACAO_CURSO = S.DURACAO_CURSO
        , D.PERIODO_ATUAL = S.PERIODO_ATUAL
        , D.TIPO_PERIODO_CURSO = S.TIPO_PERIODO_CURSO
        , D.MODALIDADE = S.MODALIDADE
        , D.HORARIO_ENTRADA = S.HORARIO_ENTRADA
        , D.HORARIO_SAIDA = S.HORARIO_SAIDA
        , D.ESCOLAS = S.ESCOLAS
        , D.CURSOS = S.CURSOS
        , D.CODIGO_CURSO_PRINCIPAL = S.CODIGO_CURSO_PRINCIPAL
        , D.VINCULOS = S.VINCULOS
        , D.IDIOMAS = S.IDIOMAS
        , D.CONHECIMENTOS = S.CONHECIMENTOS
        , D.RECURSOS_ACESSIBILIDADE = S.RECURSOS_ACESSIBILIDADE
        , D.USA_RECURSO_ACESSIBILIDADE = S.USA_RECURSO_ACESSIBILIDADE
        , D.PCDS = S.PCDS
        , D.VENCIMENTO_LAUDO = S.VENCIMENTO_LAUDO
        , D.QUALIFICACAO_VULNERAVEL = S.QUALIFICACAO_VULNERAVEL
        , D.TIPO_PROGRAMA = S.TIPO_PROGRAMA
        , D.STATUS_ESCOLARIDADE = S.STATUS_ESCOLARIDADE
        , D.QUALIFICACOES = S.QUALIFICACOES
        , D.NIVEL_ENSINO = S.NIVEL_CURSO
        , D.CONTRATOS_EMPRESA = S.CONTRATOS_EMPRESA
        , D.CONTRATOS_CURSOS_CAPACITACAO = S.CONTRATOS_CURSOS_CAPACITACAO
        , D.QTD_CONVOCACOES = S.QTD_CONVOCACOES
        , D.DATA_ALTERACAO = sysdate
        , D.POSSUI_VIDEO = S.POSSUI_VIDEO
        , D.SITUACAO = S.SITUACAO
        , D.NOME = S.NOME
        , D.CODIGO_ESTUDANTE = S.CODIGO_ESTUDANTE
        , D.CPF = S.CPF
        , D.SITUACAO_ANALISE_PCD = S.SITUACAO_ANALISE_PCD
        , D.ID_RESPONSAVEL = S.ID_RESPONSAVEL
        , D.NOME_MAE = S.NOME_MAE
        , D.ENDERECOS = S.ENDERECOS
        , D.INFO = S.INFO
        , D.POSSUI_REDACAO = S.POSSUI_REDACAO
        , D.CLASSIFICACAO_OBTIDA = S.CLASSIFICACAO_OBTIDA
        , D.PONTUACAO_OBTIDA = S.PONTUACAO_OBTIDA
        , D.APTO_TRIAGEM = S.APTO_TRIAGEM
    ';

    EXECUTE IMMEDIATE l_query USING V_IDS_ESTUDANTES_INTERNO;
END;



create OR REPLACE PROCEDURE                   "PROC_TRIAGEM_VAGAS_FILTRO"(v_id_estudante NUMBER,
                                                               v_pcd NUMBER,
                                                               v_codigo_da_vaga NUMBER,
                                                               v_nome_razao_empresa VARCHAR2,
                                                               v_id_local_contrato NUMBER,
                                                               v_descricao VARCHAR2,
                                                               v_data_criacao TIMESTAMP,
                                                               v_valor_remuneracao_de NUMBER,
                                                               v_valor_remuneracao_ate NUMBER,
                                                               v_horario_entrada TIMESTAMP,
                                                               v_horario_saida TIMESTAMP,
                                                               v_tipo_vaga VARCHAR2,
                                                               v_id_area_profissional NUMBER,
                                                               v_id_area_atuacao_estagio NUMBER,
                                                               v_nivel_escolaridade NUMBER,
                                                               v_semestre_inicial NUMBER,
                                                               v_semestre_final NUMBER,
                                                               v_data_conclusao TIMESTAMP,
                                                               v_id_area_atuacao_aprendiz NUMBER,
                                                               v_id_curso_capacitacao NUMBER,
                                                               v_escolaridade_aprendiz NUMBER,
                                                               v_tipo_referencia NUMBER,
                                                               v_raio_mora NUMBER,
                                                               v_raio_estuda NUMBER,
                                                               v_valida_vinculo NUMBER DEFAULT 1,
                                                               V_OFFSET NUMBER DEFAULT 0,
                                                               V_NEXT NUMBER DEFAULT 50,
                                                               V_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query CLOB;
BEGIN
    l_query := 'SELECT codigo_da_vaga,
        V.TIPO_VAGA,

        -- [E] CASO A VAGA PERMITA ESTUDANTE, NAO PRECISA CHECAR NO ALUNO. CASO NAO PERMITE, DEVE SER FEITA A CHECAGEM.
        CASE WHEN V.TIPO_VAGA = ''A'' OR (V.FUMANTE = 1 OR V.FUMANTE = E.FUMANTE) THEN 1 ELSE 0 END FUMANTE,

        -- [E] SE A VAGA EXIGE CNH, O ESTUDANTE DEVE POSSUIR
        CASE WHEN V.TIPO_VAGA = ''A'' OR V.POSSUI_CNH = 0 OR V.POSSUI_CNH = E.CNH THEN 1 ELSE 0 END CNH,

        -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
        CASE WHEN V.SEXO IS NULL OR V.SEXO = ''I'' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO,

        -- [E] SE A VAGA ESPECIFICOU UM ESTADO CIVIL, O ESTUDANTE DEVE CONSTAR NELE
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.ESTADO_CIVIL IS NULL OR
             V.ESTADO_CIVIL IS EMPTY OR
             --Se o estado civil do estudante contem na lista de vagas
             E.ESTADO_CIVIL MEMBER OF V.ESTADO_CIVIL
         THEN 1 ELSE 0 END ESTADO_CIVIL,

        -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
        --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
        --  SE O ALUNO JÁ FOI CADASTRADO COM ENSINO SUPERIOR, NÃO PODE PARTICIPAR PARA VAGA DE APRENDIZ
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.ESCOLAS IS NULL OR
             V.ESCOLAS IS EMPTY OR
             (
                 E.ESCOLAS IS NOT NULL AND E.ESCOLAS IS NOT EMPTY AND
                 EXISTS(SELECT 1 FROM TABLE(E.ESCOLAS) WHERE COLUMN_VALUE MEMBER OF (V.ESCOLAS))
                 --E.ESCOLAS multiset intersect V.ESCOLAS IS NOT EMPTY
             )
            THEN 1 ELSE 0 END ESCOLA,

        -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
        CASE WHEN V.TIPO_VAGA = ''A'' OR ((V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL)) THEN 1 ELSE 0 END SEMESTRE,

        -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERACAO O NÍVEL
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.CONHECIMENTOS IS NULL OR
             V.CONHECIMENTOS IS EMPTY OR
             (
                 E.CONHECIMENTOS IS NOT NULL AND E.CONHECIMENTOS IS NOT EMPTY AND
                 EXISTS(
                         SELECT 1 FROM
                             TABLE(E.CONHECIMENTOS) CE
                                 INNER JOIN TABLE(V.CONHECIMENTOS) CV ON CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                     )
             )
             THEN 1 ELSE 0 END CONHECIMENTO,

        -- [E] REALIZA A COMPARACAO POR IDIOMA
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.IDIOMAS IS NULL OR
             V.IDIOMAS IS EMPTY OR
             (
                 E.IDIOMAS IS NOT NULL AND E.IDIOMAS IS NOT EMPTY AND
                 EXISTS(
                         SELECT 1 FROM
                             TABLE(E.IDIOMAS) IDE
                                 INNER JOIN TABLE(V.IDIOMAS) IDV ON IDE.NOME = IDV.NOME AND IDE.NIVEL >= IDV.NIVEL
                     )
             )
            THEN 1 ELSE 0 END IDIOMA,

        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO ALUNO
        CASE WHEN
            ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) = 2) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 5) IN (2, 5, 6))) OR
            (
               ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) IN (0, 1, 3)) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4))) AND
                E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CASA,

        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO CAMPUS DO ALUNO
        CASE WHEN
            ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) = 1) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 5) IN (1, 4, 5))) OR
            (
                ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) IN (0, 2, 3)) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6)))) AND
                (
                    E.CURSO_EAD = 1 OR (V.TIPO_VAGA = ''A'' AND  (E.status_escolaridade = 1 OR NOT EXISTS(select 1 from table(e.escolas))) OR
                    (
                        (E.CURSO_EAD IS NULL OR E.CURSO_EAD <> 1) AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                        AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                    ) AND
                    SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        CASE WHEN
            V.TIPO_VAGA = ''E'' OR (
            NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6) AND
                E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            )
        ) THEN 1 ELSE 0 END as DISTANCIA_CAPACITACAO,

        -- [I] VALIDA A IDADE DO ESTUDANTE
        CASE WHEN
                v.possui_pcd = 1
                OR
                (
                     (V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
                     AND
                     (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA)
                )
                 THEN 1 ELSE 0 END AS RANGE_IDADE,

        -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
        CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0 AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)) THEN 1
            WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 1) THEN 1
            ELSE 0
        END "ACESSIBILIDADE",

        -- [I] Validar regra de validade do laudo
        CASE WHEN
             V.PCDS IS NULL OR
             V.PCDS IS EMPTY OR
             (
                E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                 (
                    SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                      ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                      WHERE PV.VALIDADE_MINIMA_LAUDO IS NULL OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                 ) = CARDINALITY(V.PCDS)
            )
            THEN 1 ELSE 0 END AS VALIDADE_LAUDO,

        -- [I] Validar regra de tipos de deficiencia
        CASE WHEN
                 V.PCDS IS NULL OR
                 V.PCDS IS EMPTY OR
                 (
                    E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                     (
                        SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                          ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                     ) = CARDINALITY(V.PCDS)
                  )
                THEN 1 ELSE 0
            END AS TIPO_DEFICIENCIA,

        -- [I] Validar regra de qualificacao restritiva
        CASE WHEN
            V.QUALIFICACOES IS NULL OR
            V.QUALIFICACOES IS EMPTY OR
            (
                E.QUALIFICACOES IS NOT NULL AND E.QUALIFICACOES IS NOT EMPTY AND
                EXISTS (
                    SELECT 1 FROM TABLE(V.QUALIFICACOES) VQ
                        INNER JOIN TABLE(E.QUALIFICACOES) EQ ON VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                        WHERE EQ.RESULTADO = 0 AND EQ.DATA_VALIDADE >= SYSDATE
                )
            )
            THEN 1 ELSE 0 END QUALIFICACAO,

        -- [I] Validar regra de Reservista
        CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END RESERVISTA,

        -- [I] Validar regra de recurso de acessibilidade
        CASE WHEN
                V.RECURSOS_ACESSIBILIDADE IS NULL OR
                V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                (
                   E.RECURSOS_ACESSIBILIDADE IS NOT NULL AND E.RECURSOS_ACESSIBILIDADE IS NOT EMPTY AND
                   E.RECURSOS_ACESSIBILIDADE multiset intersect V.RECURSOS_ACESSIBILIDADE IS NOT EMPTY
                   --EXISTS(SELECT 1 FROM TABLE(E.RECURSOS_ACESSIBILIDADE) WHERE COLUMN_VALUE MEMBER OF (V.RECURSOS_ACESSIBILIDADE))
                )
            THEN 1 ELSE 0 END RECURSO_ACESSIBILIDADE,

        -- [I] Validar Regra de cota PCD válida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD
        THEN 1 ELSE 0 END VALIDO_COTA,

        -- [E] Validar data de conclusão
        CASE WHEN V.TIPO_VAGA = ''A'' OR V.DATA_CONCLUSAO IS NULL OR E.DATA_CONCLUSAO_CURSO = V.DATA_CONCLUSAO THEN 1 ELSE 0 END DATA_CONCLUSAO,

        -- [I] Validar regra de horário da vaga
        CASE WHEN
            (V.TIPO_VAGA = ''E'' OR (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR (extract(hour from V.HORARIO_ENTRADA) < 18 AND extract(hour from V.HORARIO_SAIDA) < 18)))
            AND
            (
                V.TIPO_HORARIO_ESTAGIO = 0 OR
                (
                    (       E.MODALIDADE = ''E''
                        OR
                           (E.MODALIDADE = ''P'' OR (V.TIPO_VAGA = ''A'' AND E.STATUS_ESCOLARIDADE = 1)
                    )
                        AND
                        (
                            E.TIPO_PERIODO_CURSO = ''Variável''
                            OR E.TIPO_PERIODO_CURSO IN (''Manhã'', ''Integral'') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                            OR E.TIPO_PERIODO_CURSO = ''Tarde'' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                            OR E.TIPO_PERIODO_CURSO IN (''Noite'', ''Vespertino'') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                        )
                    )
                )
            )
        THEN 1 ELSE 0 END HORARIO,
        case when v.tipo_vaga = ''E'' THEN
            case when
                -- Parametro Area atuação: Caso alguma área de atuação da vaga estiver contida nas áreas de atuação do parâmetro, estudante deverá estar cursando semestre dentro do intervalo especificado no parâmetro
                nvl((select case when e.semestre between par.semestre_inicio and par.semestre_fim and v.areas_atuacao_estagio multiset intersect par.areas_atuacao is not empty then 1 else 0 end from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''areaAtuacao'' and par.prioridade = (select max(prioridade) from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''areaAtuacao'')), 1)

                -- Parâmetro permissão estágio. Caso houver, semestre atual do estudante não deve ultrapassar semestre indicado no parâmetro
                +nvl((select case when par.semestre_maximo >= e.semestre then 1 else 0 end from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''permissaoEstagio'' and par.prioridade = (select max(prioridade) from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''permissaoEstagio'')), 1)

                -- Parâmetro Carga horária diária: Caso vaga for a combinar ou nível da vaga for igual ao indicado no parâmetro, jornada diária da vaga não deve exceder o indicado no parâmetro
                +nvl((select case when v.tipo_horario_estagio = 0 OR e.nivel_ensino <> par.nivel_nao_permitido OR v.jornada_minutos <= par.carga_horaria_diaria * 60 then 1 else 0 end from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''cargaHorariaDiaria'' and par.prioridade = (select max(prioridade) from v_parametros_ie_estudantes par where par.id_estudante = e.id_estudante and par.tipo_param = ''cargaHorariaDiaria'')), 1)
            = 3 THEN 1 else 0 end
            else 1
        end parametro_escolar
    from SERVICE_VAGAS_DEV.triagens_estudantes e
    cross join SERVICE_VAGAS_DEV.triagens_vagas v
    where e.id_estudante = :V_ID_ESTUDANTE

    -- Validar idade do candidato de acordo com a vaga
    and (v.possui_pcd = 1 OR (TRUNC(MONTHS_BETWEEN(SYSDATE, e.DATA_NASCIMENTO) / 12) BETWEEN v.idade_minima and v.idade_maxima))

    -- Validar situação da vaga (aberta ou bloqueada sem ocorrências)
    and (v.id_situacao_vaga = 1 or (v.id_situacao_vaga = 2 and v.possui_ocorrencias = 0))

    -- Validar aderência da regra de PCD
    and (v.possui_pcd = 0 OR (e.pcds IS NOT NULL AND e.pcds IS NOT EMPTY))

    -- Validar regra de distância
    AND (
        E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
        OR E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
        OR (V.TIPO_VAGA = ''A'' AND E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS)
    )

    -- Validar regra de contratos empresa
    AND (
       E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR v.ID_EMPRESA NOT IN (SELECT E_CONT.ID_EMPRESA from TABLE (E.CONTRATOS_EMPRESA) E_CONT)
    )
    -- Validar filtro de vagas PCD
    AND (nvl(:V_PCD, 0) = v.possui_pcd)';

    IF (v_valida_vinculo = 1) then
        l_query := l_query || '-- Validar regra de estudante liberado da vaga
        AND NOT EXISTS(select 1 from TABLE(e.VINCULOS) ev where v.codigo_da_vaga = ev.ID) ';
    end if;

    IF (v_codigo_da_vaga IS NOT NULL) THEN
        l_query := l_query || '-- Filtros comuns
        AND (v.codigo_da_vaga = :V_CODIGO_DA_VAGA)';
    ELSE
        l_query := l_query || '
        AND (:V_CODIGO_DA_VAGA IS NULL)';
    END IF;

    IF (v_nome_razao_empresa IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro de nome/razão social da empresa
        and (v.nome_razao_empresa LIKE ''%''||:V_NOME_RAZAO_EMPRESA||''%'')';
    ELSE
        l_query := l_query || '
        AND (:V_NOME_RAZAO_EMPRESA IS NULL)';
    END IF;

    IF (v_id_local_contrato IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro por id de local de contrato
        and (v.id_local_contrato = :V_ID_LOCAL_CONTRATO)';
    ELSE
        l_query := l_query || '
        AND (:V_ID_LOCAL_CONTRATO IS NULL)';
    END IF;

    IF (v_descricao IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro por descrição da vaga
        and (v.descricao_vaga like ''%''||:V_DESCRICAO||''%'')';
    ELSE
        l_query := l_query || '
        AND (:V_DESCRICAO IS NULL)';
    END IF;

    IF (v_data_criacao IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro por data de abertura da vaga
        and (TRUNC(v.data_abertura) = TRUNC(:V_DATA_CRIACAO))';
    ELSE
        l_query := l_query || '
        AND (:V_DATA_CRIACAO IS NULL)';
    END IF;

    IF (v_horario_entrada IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro por horário de entrada
        and (v.horario_entrada >= :V_HORARIO_ENTRADA)';
    ELSE
        l_query := l_query || '
        AND (:V_HORARIO_ENTRADA IS NULL)';
    END IF;

    IF (v_horario_saida IS NOT NULL) THEN
        l_query := l_query || '
        -- Filtro por horário de saída
        and (v.horario_saida <= :V_HORARIO_SAIDA)';
    ELSE
        l_query := l_query || '
        AND (:V_HORARIO_SAIDA IS NULL)';
    END IF;

    IF (v_tipo_referencia IS NOT NULL AND (v_raio_mora IS NOT NULL OR v_raio_estuda IS NOT NULL)) THEN
        l_query := l_query || '
        AND (';

        IF (v_tipo_referencia IN (0, 2)) THEN
            l_query := l_query || '
            (E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
            SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < :v_raio_mora)';
        ELSE
            l_query := l_query || '
            (:v_raio_mora IS NULL)';
        END IF;

        IF (v_tipo_referencia IN (1, 2)) THEN
            l_query := l_query || '
            OR (E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
            SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :v_raio_estuda)';
        ELSE
            l_query := l_query || '
            OR (:v_raio_estuda IS NULL)';
        END IF;
        l_query := l_query || '
        )';
    ELSE
        l_query := l_query || '
        AND (:v_raio_mora IS NULL OR :v_raio_estuda IS NULL)';
    END IF;

    l_query := l_query || '-- Regras específicas
            and (';

    IF (v_tipo_vaga = 'E' OR v_tipo_vaga = 'AE') THEN
        l_query := l_query || '
                (
                    v.tipo_vaga = ''E''
                    -- Para estágio, candidato sempre tem que estar cursando
                    AND EXISTS(SELECT 1 FROM TABLE(E.CURSOS) WHERE COLUMN_VALUE MEMBER OF (V.CURSOS))

                    and (
                        e.status_escolaridade = 0
                        and (
                            e.nivel_ensino IN (''EM'', ''TE'', ''SU'')
                        ))';

        IF (v_id_area_profissional IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por área profissional
                and (v.codigo_area_profissional = :V_ID_AREA_PROFISSIONAL)';
        ELSE
            l_query := l_query || '
            AND (:V_ID_AREA_PROFISSIONAL IS NULL)';
        END IF;

        IF (v_id_area_atuacao_estagio IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por área de atuação
                and (:V_ID_AREA_ATUACAO_ESTAGIO MEMBER OF v.areas_atuacao_estagio)';
        ELSE
            l_query := l_query || '
            AND (:V_ID_AREA_ATUACAO_ESTAGIO IS NULL)';
        END IF;

        IF (v_nivel_escolaridade IS NOT NULL) THEN
            l_query := l_query || '
                -- TODO implementar carga de escolaridade da vaga para estágio
                -- Filtro por nível de escolaridade
                and (v.escolaridade = :V_NIVEL_ESCOLARIDADE)';
        ELSE
            l_query := l_query || '
            AND (:V_NIVEL_ESCOLARIDADE IS NULL)';
        END IF;

        if (v_semestre_inicial IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por semestre inicial
                and (v.semestre_inicial >= :V_SEMESTRE_INICIAL)';
        ELSE
            l_query := l_query || '
            AND (:V_SEMESTRE_INICIAL IS NULL)';
        END IF;

        IF (v_semestre_final IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por semestre final
                and (v.semestre_final <= :V_SEMESTRE_FINAL)';
        ELSE
            l_query := l_query || '
            AND (:V_SEMESTRE_FINAL IS NULL)';
        END IF;

        IF (v_data_conclusao IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por data de conclusão
                and (v.data_conclusao <= :V_DATA_CONCLUSAO)';
        ELSE
            l_query := l_query || '
            AND (:V_DATA_CONCLUSAO IS NULL)';
        END IF;

        IF (v_valor_remuneracao_de IS NOT NULL OR v_valor_remuneracao_ate IS NOT NULL) THEN
            IF (v_valor_remuneracao_de IS NOT NULL) THEN
                l_query := l_query || '
                -- Filtro por valor bolsa (mínimo)
                and (v.valor_bolsa_fixo >= :V_VALOR_REMUNERACAO_DE OR v.valor_bolsa_de >= :V_VALOR_REMUNERACAO_DE)';
            ELSE
                l_query := l_query || '
                AND (:V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_DE IS NULL)';
            END IF;

            IF (v_valor_remuneracao_ate IS NOT NULL) THEN
                l_query := l_query || '
                -- Filtro por valor bolsa (máximo)
                and (v.valor_bolsa_fixo <= :V_VALOR_REMUNERACAO_ATE OR v.valor_bolsa_ate <= :V_VALOR_REMUNERACAO_ATE)';
            ELSE
                l_query := l_query || '
                AND (:V_VALOR_REMUNERACAO_ATE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL)';
            END IF;
        ELSE
            l_query := l_query || '
            AND (:V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL)';
        END IF;

        l_query := l_query || '
        )';
    END IF;

    IF (v_tipo_vaga = 'AE') THEN
        l_query := l_query || '
         OR ';
    END IF;

    IF (v_tipo_vaga = 'A' or v_tipo_vaga = 'AE') THEN
        l_query := l_query || '
        (
            v.tipo_vaga = ''A''
            AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR (EC_EMP.TIPO_CONTRATO = ''A'' AND exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO)  )))
            and
            (
                -- Valida nível de escolaridade
                (
                    (v.escolaridade is null or v.escolaridade = 0) OR
                    (v.escolaridade = 1 and e.nivel_ensino = ''EF'') OR
                    (v.escolaridade = 2 and e.nivel_ensino = ''EM'')
                )
                -- Valida situação de escolaridade
                and (
                    (v.situacao_escolaridade is null or v.situacao_escolaridade = 0) OR
                    (v.situacao_escolaridade = 1 and e.status_escolaridade = 1) OR
                    (v.situacao_escolaridade = 2 and e.status_escolaridade = 0)
                )';

        IF (v_id_area_atuacao_aprendiz IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por área de atuação aprendiz
                and (v.id_area_atuacao_aprendiz = :V_ID_AREA_ATUACAO_APRENDIZ)';
        ELSE
            l_query := l_query || '
            AND (:V_ID_AREA_ATUACAO_APRENDIZ IS NULL)';
        END IF;

        IF (v_id_curso_capacitacao IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por curso de capacitação
                and (:V_ID_CURSO_CAPACITACAO MEMBER OF v.cursos_capacitacao)';
        ELSE
            l_query := l_query || '
            AND (:V_ID_CURSO_CAPACITACAO IS NULL)';
        END IF;

        IF (v_escolaridade_aprendiz IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por escolaridade
                and (v.escolaridade = :V_ESCOLARIDADE_APRENDIZ)';
        ELSE
            l_query := l_query || '
            AND (:V_ESCOLARIDADE_APRENDIZ IS NULL)';
        END IF;

        IF (v_valor_remuneracao_de IS NOT NULL OR v_valor_remuneracao_ate IS NOT NULL) THEN
            IF (v_valor_remuneracao_de IS NOT NULL) THEN
                l_query := l_query || '
                -- Filtro por valor salario (mínimo)
                and (v.valor_salario >= :V_VALOR_REMUNERACAO_DE OR v.valor_salario_de >= :V_VALOR_REMUNERACAO_DE)';
            ELSE
                l_query := l_query || '
                AND (:V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_DE IS NULL)';
            END IF;

            IF (v_valor_remuneracao_ate IS NOT NULL) THEN
                l_query := l_query || '
                -- Filtro por valor salario (máximo)
                and (v.valor_salario <= :V_VALOR_REMUNERACAO_ATE OR v.valor_salario_ate <= :V_VALOR_REMUNERACAO_ATE)';
            ELSE
                l_query := l_query || '
                AND (:V_VALOR_REMUNERACAO_ATE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL)';
            END IF;
        ELSE
            l_query := l_query || '
            AND (:V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL)';
        END IF;

        l_query := l_query || '
        ))';
    END IF;
    l_query := l_query ||
               ') ORDER BY (DISTANCIA_CASA + DISTANCIA_CAMPUS) OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY';

    dbms_output.put_line(l_query);

    IF (V_TIPO_VAGA = 'AE') THEN
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_RAIO_MORA, V_RAIO_ESTUDA, V_ID_AREA_PROFISSIONAL, V_ID_AREA_ATUACAO_ESTAGIO, V_NIVEL_ESCOLARIDADE,
            V_SEMESTRE_INICIAL, V_SEMESTRE_FINAL, V_DATA_CONCLUSAO, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE,
            V_VALOR_REMUNERACAO_ATE, V_ID_AREA_ATUACAO_APRENDIZ, V_ID_CURSO_CAPACITACAO, V_ESCOLARIDADE_APRENDIZ, V_VALOR_REMUNERACAO_DE,
            V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE, V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    ELSIF (V_TIPO_VAGA = 'A') THEN
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_RAIO_MORA, V_RAIO_ESTUDA, V_ID_AREA_ATUACAO_APRENDIZ, V_ID_CURSO_CAPACITACAO, V_ESCOLARIDADE_APRENDIZ,
            V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE, V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    ELSE
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_RAIO_MORA, V_RAIO_ESTUDA, V_ID_AREA_PROFISSIONAL, V_ID_AREA_ATUACAO_ESTAGIO, V_NIVEL_ESCOLARIDADE,
            V_SEMESTRE_INICIAL, V_SEMESTRE_FINAL, V_DATA_CONCLUSAO, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE,
            V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    END IF;
end;
/


create OR REPLACE PROCEDURE proc_triagem_aprendiz(V_CODIGO_DA_VAGA NUMBER DEFAULT NULL,
                                       V_ID_ESTUDANTE NUMBER DEFAULT NULL,
                                       V_OFFSET NUMBER DEFAULT 0,
                                       V_NEXT NUMBER DEFAULT 50,
                                       V_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query CLOB;
BEGIN

    l_query := l_query || '
    SELECT /*+ PARALLEL(8) */
        V.CODIGO_DA_VAGA,
        E.ID_ESTUDANTE,

        -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
        CASE WHEN V.SEXO IS NULL OR V.SEXO = ''I'' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO,

        -- TODO para os calculos de distancia, considerar o tipo de localização pedido pela vaga
        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4) AND
                E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CASA,

        -- [I] CIRCULO DE DISTÂNCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO CAMPUS DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6) AND
                (
                    E.CURSO_EAD = 1 OR E.status_escolaridade = 1 OR NOT EXISTS(select 1 from table(e.escolas)) OR (
                        (
                            E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                            AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
                        )
                        AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                    )
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        -- [A] CIRCULO DE DISTANCIA ENTRE O LOCAL DE CAPACITACAO (SOMENTE APRENDIZ) E O ENDERECO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6) AND
                E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS AND
                SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CAPACITACAO,

        -- [I] VALIDA A IDADE DO ESTUDANTE
        CASE WHEN
             V.POSSUI_PCD = 1 OR
             ((V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
             AND
             (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA))
         THEN 1 ELSE 0 END AS RANGE_IDADE,

        -- [I] VALIDA REGRA DE ACESSIBILIDADE: SOMENTE ENCAMINHAR ESTUDANTES COM NECESSIDADES DE ACESSIBILIDADE PARA VAGAS QUE OFERECAM ACESSIBILIDADE
        CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0 AND (E.USA_RECURSOS_ACESSIBILIDADE IS NULL OR E.USA_RECURSOS_ACESSIBILIDADE = 0)) THEN 1
            WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 1) THEN 1
            ELSE 0
        END "ACESSIBILIDADE",

        -- [I] Validar regra de validade do laudo
        -- TODO validar se estudante deve ter laudo para todos os CIDs indicados na vaga ou somente um deles
        -- TODO remover duplicatas de PCD em vagas
        CASE WHEN
             V.PCDS IS NULL OR
             V.PCDS IS EMPTY OR
             (
                E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                 (
                    SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                      ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                      WHERE PV.VALIDADE_MINIMA_LAUDO IS NULL OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                 ) = CARDINALITY(V.PCDS)
            )
            THEN 1 ELSE 0 END AS VALIDADE_LAUDO,

        -- [I] Validar regra de tipos de deficiencia
        CASE WHEN
                 V.PCDS IS NULL OR
                 V.PCDS IS EMPTY OR
                 (
                    E.PCDS IS NOT NULL AND E.PCDS IS NOT EMPTY AND
                     (
                        SELECT COUNT(1) FROM TABLE (E.PCDS) PE INNER JOIN TABLE (V.PCDS) PV
                          ON PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                     ) = CARDINALITY(V.PCDS)
                  )
                THEN 1 ELSE 0
            END AS TIPO_DEFICIENCIA,

        -- [I] Validar regra de qualificação restritiva
        CASE WHEN
                V.QUALIFICACOES IS NULL OR
                V.QUALIFICACOES IS EMPTY OR
                (
                    E.QUALIFICACOES IS NOT NULL AND E.QUALIFICACOES IS NOT EMPTY AND
                    EXISTS (
                        SELECT 1 FROM TABLE(V.QUALIFICACOES) VQ
                            INNER JOIN TABLE(E.QUALIFICACOES) EQ ON VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                            WHERE EQ.RESULTADO = 0 AND EQ.DATA_VALIDADE >= SYSDATE
                )
            ) THEN 1 ELSE 0 END QUALIFICACAO,

        -- [I] Validar regra de Reservista
        CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END RESERVISTA,

        -- [I] Validar regra de recurso de acessibilidade
        CASE WHEN
             V.RECURSOS_ACESSIBILIDADE IS NULL OR
             V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
             (
                E.RECURSOS_ACESSIBILIDADE IS NOT NULL AND E.RECURSOS_ACESSIBILIDADE IS NOT EMPTY AND
                --E.RECURSOS_ACESSIBILIDADE multiset intersect V.RECURSOS_ACESSIBILIDADE IS NOT EMPTY
                EXISTS(SELECT 1 FROM TABLE(E.RECURSOS_ACESSIBILIDADE) WHERE COLUMN_VALUE MEMBER OF (V.RECURSOS_ACESSIBILIDADE)
             )
         ) THEN 1 ELSE 0 END RECURSO_ACESSIBILIDADE,

        -- [I] Validar Regra de cota PCD valida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA = E.ELEGIVEL_PCD
        THEN 1 ELSE 0 END VALIDO_COTA,
        -- [I] Validar Horario
        CASE WHEN
           (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR (extract(hour from V.HORARIO_ENTRADA) < 18 AND extract(hour from V.HORARIO_SAIDA) < 18))
           AND (
             E.MODALIDADE = ''E'' OR E.STATUS_ESCOLARIDADE = 1
             OR (
                 E.MODALIDADE = ''P''
                 AND
                 (
                     E.TIPO_PERIODO_CURSO = ''Variável''
                     OR E.TIPO_PERIODO_CURSO IN (''Manhã'', ''Integral'') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                     OR E.TIPO_PERIODO_CURSO = ''Tarde'' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                     OR E.TIPO_PERIODO_CURSO IN (''Noite'', ''Vespertino'') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                 )
             )
           )
        THEN 1 ELSE 0 END HORARIO,

        e.QUALIFICACAO_VULNERAVEL,

        E.QTD_CONVOCACOES
    FROM
        SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
        CROSS JOIN SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
    WHERE
      V.TIPO_VAGA = ''A''
      AND E.ENDERECO IS NOT NULL
      AND ((V.SITUACAO_ESCOLARIDADE = 0) OR (V.SITUACAO_ESCOLARIDADE = 1 and E.STATUS_ESCOLARIDADE = 1) OR (V.SITUACAO_ESCOLARIDADE = 2 and E.STATUS_ESCOLARIDADE = 0))
      AND E.NIVEL_ENSINO <> ''SU''
      AND ((V.ESCOLARIDADE = 0) OR (V.ESCOLARIDADE = 1 AND E.NIVEL_ENSINO = ''EF'') OR (V.ESCOLARIDADE = 2 AND E.NIVEL_ENSINO = ''EM''))
      AND (V.POSSUI_PCD = 1 OR trunc(months_between(SYSDATE, E.DATA_NASCIMENTO)/12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA)
      AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR (EC_EMP.TIPO_CONTRATO = ''A'' AND exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO) ))
      AND (E.VINCULOS IS EMPTY OR E.VINCULOS IS NULL OR NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID))
      AND ((V.POSSUI_PCD = 0 AND CARDINALITY(E.PCDS) = 0) OR (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0))
      -- REGRAS DE ENDERECO
      AND
      (
        -- Distancia onde mora
        E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
        OR -- Distancia estuda
        (
            E.CURSO_EAD = 0 AND E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
            AND E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS
        )
        OR -- Distancia capacitação
        (
            E.ENDERECO_GEOHASH MEMBER OF V.CAPACITACAO_GEOHASHS
        )
      )
      AND E.TIPO_PROGRAMA IN (1, 2)
      AND E.APTO_TRIAGEM = 1
';

    IF (V_CODIGO_DA_VAGA IS NOT NULL)
    THEN
        l_query := l_query || ' AND V.CODIGO_DA_VAGA = :V_CODIGO_DA_VAGA ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_CODIGO_DA_VAGA is null) ';
    END IF;

    IF (V_ID_ESTUDANTE IS NOT NULL)
    THEN
        l_query := l_query || ' AND E.ID_ESTUDANTE = :V_ID_ESTUDANTE ';
    ELSE
        l_query := l_query || ' AND (1=1 or :V_ID_ESTUDANTE is null) ';
    END IF;


    l_query := l_query || '
ORDER BY
    (
        SEXO + RANGE_IDADE + ACESSIBILIDADE +
        DISTANCIA_CASA + DISTANCIA_CAMPUS + DISTANCIA_CAPACITACAO +
        VALIDADE_LAUDO + TIPO_DEFICIENCIA + QUALIFICACAO + RESERVISTA +
        RECURSO_ACESSIBILIDADE + VALIDO_COTA + HORARIO
    ) DESC,
    E.QUALIFICACAO_VULNERAVEL DESC,
    E.QTD_CONVOCACOES
   -- DISTANCIA
OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY
';

--dbms_output.put_line(l_query);

    OPEN V_RESULTSET FOR l_query
        USING V_CODIGO_DA_VAGA, V_ID_ESTUDANTE, V_OFFSET, V_NEXT;

END;
/



