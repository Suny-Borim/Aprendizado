-- Altera o tipo
-- Comentado pois será necessário rodar manualmente devido ao tempo de execução
-- alter type QUALIFICACAO_TYP add attribute SITUACAO NUMBER(1,0) cascade;
-- alter type QUALIFICACAO_TYP add attribute TIPO NUMBER(1,0) cascade;
-- /
-- Altera a proc de atualizacao triagem estudante

CREATE OR REPLACE PROCEDURE SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_lista (
    V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL
)
AS
    l_query  CLOB;
    V_IDS_ESTUDANTES_INTERNO IDS_TYP;
BEGIN

    V_IDS_ESTUDANTES_INTERNO := V_IDS_ESTUDANTES;

    -- Remove os estudantes inativos ou excluidos
    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_remove_inativo(V_IDS_ESTUDANTES_INTERNO);

    SERVICE_VAGAS_DEV.proc_resetar_parametros_ie(V_IDS_ESTUDANTES_INTERNO);

    l_query := 'MERGE INTO SERVICE_VAGAS_DEV.TRIAGENS_ESTUDANTES D
        USING
        (
        SELECT
            EST.ID "ID_ESTUDANTE",
            ENDER.GEO_POINT "ENDERECO",
            SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
                SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.y,
                SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.x, 5
            ) as ENDERECO_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ENDER.GEO_POINT, 4) as "ENDERECO_GEOHASH",

        ESCOL.GEO_POINT "ENDERECO_CAMPUS",

        SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.y,
            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.x, 5
        ) as ENDERECO_CAMPUS_GEOHASH,
        --A funcao nativa retorna nulo em alguns momentos
        --SDO_CS.TO_GEOHASH(ESCOL.GEO_POINT, 4) as "ENDERECO_CAMPUS_GEOHASH",

        (
            select
                SET(CAST(COLLECT(column_value) AS SERVICE_VAGAS_DEV.GEOHASHS_TYP))
            from
                table(SERVICE_VAGAS_DEV.GEOHASHS_TYP(
                        SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
                            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.y,
                            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.x, 5
                        ),
                        substr(SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
                            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.y,
                            SDO_GEOM.SDO_CENTROID(ENDER.GEO_POINT, 0.05).sdo_point.x, 5
                        ), 1,4),
                        case when CURS.MODALIDADE = ''P'' then SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
                            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.y,
                            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.x, 5
                        ) ELSE NULL end,
                        case when CURS.MODALIDADE = ''P'' then substr(SERVICE_VAGAS_DEV.GEOHASH_ENCODE(
                            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.y,
                            SDO_GEOM.SDO_CENTROID(ESCOL.GEO_POINT, 0.05).sdo_point.x, 5
                        ),1,4) ELSE NULL end
                ))
            where
                column_value is not null
                AND column_value != ''00000''
                AND column_value != ''0000''
        ) as "ENDERECO_GEOHASHS",

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
                ESC.ID_ESCOLA
            FROM
            SERVICE_VAGAS_DEV.REP_ESCOLARIDADES_ESTUDANTES ESC
            WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = 0 and ESC.PRINCIPAL = 1
        ) "ESCOLAS",


        -- ### Cursos ###
        (
            SELECT
            cast(collect(CAST(ESC.ID_CURSO AS NUMBER(19,0))) as SERVICE_VAGAS_DEV.IDS_TYP)
            FROM
            SERVICE_VAGAS_DEV.REP_ESCOLARIDADES_ESTUDANTES ESC
            WHERE ESC.ID_ESTUDANTE = EST.ID AND ESC.DELETADO = 0
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
                WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = 0
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
                WHEN ''LIBRAS'' THEN ''LIBRAS''
            END,
            CASE WHEN NIVEL = ''BÁSICO'' THEN 10
                WHEN NIVEL = ''INTERMEDIÁRIO'' THEN 20
                ELSE 30
            END,
            CASE WHEN RIN.DOCUMENTO_ID IS NULL THEN 0 ELSE 1 END)
            ) AS SERVICE_VAGAS_DEV.IDIOMAS_TYP)
            from SERVICE_VAGAS_DEV.REP_IDIOMAS_NIVEIS RIN
            WHERE RIN.ESTUDANTE_ID = EST.ID AND RIN.DELETADO = 0
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
            WHERE RCI.ID_ESTUDANTE = EST.ID AND RCI.DELETADO = 0
        ) "CONHECIMENTOS",

        -- ### Recursos Acessibilidade ###
        (SELECT
            CAST(COLLECT(REC.APARELHO_ID) AS SERVICE_VAGAS_DEV.IDS_TYP)
            from SERVICE_VAGAS_DEV.REP_RECURSOS_ACESSIBILIDADE REC
            WHERE REC.ESTUDANTE_ID = EST.ID AND REC.DELETADO = 0) RECURSOS_ACESSIBILIDADE,
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
            WHERE LM.DELETADO = 0 and LMD.DELETADO = 0 AND LM.ESTUDANTE_ID = EST.ID
            GROUP BY LM.ID, LM.ID_CID_AGRUPADO, LMD.STATUS, LM.PRINCIPAL
        ) PCDs,


        -- ### Vencimento Laudo ###
        (
            SELECT MAX(DATA_VENCIMENTO)
            FROM SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS_DOCUMENTOS LMD
            INNER JOIN SERVICE_VAGAS_DEV.REP_LAUDOS_MEDICOS RLM on LMD.LAUDO_MEDICO_ID = RLM.ID
            where RLM.ESTUDANTE_ID = EST.ID AND LMD.STATUS = ''VALIDO'' AND RLM.PRINCIPAL = 1
            AND RLM.DELETADO = 0 AND LMD.DELETADO = 0
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
                QE.DATA_VALIDADE,
                QE.SITUACAO,
                QUALIF.TIPO)
            ) AS SERVICE_VAGAS_DEV.QUALIFICACOES_TYP)
            from SERVICE_VAGAS_DEV.QUALIFICACOES_ESTUDANTE QE
            INNER JOIN SERVICE_VAGAS_DEV.QUALIFICACOES QUALIF
            ON QE.ID_QUALIFICACAO = QUALIF.ID
            WHERE QE.ID_ESTUDANTE = EST.ID AND QE.DELETADO = 0
        ) QUALIFICACOES,
        ESCOL.SIGLA_NIVEL_EDUCACAO "NIVEL_CURSO",


        -- ### Contratos Estudante Empresa ###
        (
            select CAST(COLLECT(SERVICE_VAGAS_DEV.CONTRATO_EMP_TYP(ID, ID_EMPRESA, SITUACAO, TIPO_CONTRATO)) AS SERVICE_VAGAS_DEV.CONTRATOS_EMP_TYP)
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
            WHERE VV.ID_ESTUDANTE = EST.ID AND VV.DELETADO = 0
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
            AND ENDER.DELETADO = 0
            AND ESCOL.DELETADO = 0
            AND (INFO.DELETADO IS NULL OR INFO.DELETADO = 0)
            AND CURS.DELETADO = 0
               ) then 1
            else 0
        end APTO_TRIAGEM,

        -- #### Areas profissionais de jovem talento que o estudante atuou (contrato estudante não foi cancelado) ####
        (
            select CAST(COLLECT(ID_AREA_PROFISSIONAL) AS SERVICE_VAGAS_DEV.IDS_TYP)
            from SERVICE_VAGAS_DEV.CONTRATOS_ESTUDANTES_EMPRESA cee
            inner join SERVICE_VAGAS_DEV.REP_AREAS_PROFISSIONAIS rap
                on cee.ID_AREA_PROFISSIONAL = rap.CODIGO_AREA_PROFISSIONAL AND rap.UTILIZACAO_DA_AREA = 2 -- utilização da área = 2 (jovem talento)
            where ID_ESTUDANTE = EST.ID AND cee.SITUACAO <> 2
        ) "AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO"

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
        AND EST.DELETADO = 0
        AND ENDER.DELETADO = 0
        AND ESCOL.DELETADO = 0
        AND (INFO.DELETADO IS NULL OR INFO.DELETADO = 0)
        AND CURS.DELETADO = 0
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
            ,D.ENDERECO_GEOHASHS
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
            ,D.ESCOLA
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
            ,D.CONTRATOS_EMPRESA
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
            ,D.CURSO_EAD
            ,D.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO
        )
        VALUES
    (S.ID_ESTUDANTE
        ,S.ENDERECO
        ,S.ENDERECO_GEOHASH
        ,S.ENDERECO_CAMPUS
        ,S.ENDERECO_CAMPUS_GEOHASH
        ,S.ENDERECO_GEOHASHS
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
        ,S.APTO_TRIAGEM
        ,S.CURSO_EAD
        ,S.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO
        )
    WHEN MATCHED THEN
    UPDATE SET
        D.ENDERECO = S.ENDERECO
        , D.ENDERECO_GEOHASH = S.ENDERECO_GEOHASH
        , D.ENDERECO_CAMPUS = S.ENDERECO_CAMPUS
        , D.ENDERECO_CAMPUS_GEOHASH = S.ENDERECO_CAMPUS_GEOHASH
        , D.ENDERECO_GEOHASHS = S.ENDERECO_GEOHASHS
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
        , D.ESCOLA = S.ESCOLAS
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
        , D.VIDEO_URL = S.VIDEO_URL
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
        , D.CURSO_EAD = S.CURSO_EAD
        , D.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO = S.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO
    ';

    EXECUTE IMMEDIATE l_query USING V_IDS_ESTUDANTES_INTERNO;

    -- ATUALIZA OS DADOS DO ESTUDANTE NA TABELA DE FILTRO
    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_FILTRO(V_IDS_ESTUDANTES_INTERNO);
END;
