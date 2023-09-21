create or replace procedure {{user}}.PROC_BUSCA_CANDIDATOS(P_STATUS_ESCOLARIDADE {{user}}.IDS_TYP,
                                                                    P_AREA_PROFISSIONAL NUMBER,
                                                                    P_START_SEMESTRE NUMBER,
                                                                    P_END_SEMESTRE NUMBER,
                                                                    P_DATA_CONCLUSAO TIMESTAMP,
                                                                    P_NIVEL_ENSINO {{user}}.NAMELIST,
                                                                    P_ESTADO_CIVIL {{user}}.IDS_TYP,
                                                                    P_START_IDADE NUMBER,
                                                                    P_END_IDADE NUMBER,
                                                                    P_USUARIO number,
                                                                    P_TIPO_PERFIL VARCHAR2,
                                                                    P_LATITUDE NUMBER,
                                                                    P_LONGITUDE NUMBER,
                                                                    P_VALOR_RAIO NUMBER DEFAULT 20,
                                                                    P_REFERENCIA_DISTANCIA NUMBER,
                                                                    P_TIPO_PERIODO_CURSO {{user}}.NAMELIST,
                                                                    P_SEXO VARCHAR2 DEFAULT 'I',
                                                                    P_POSSUI_VIDEO NUMBER,
                                                                    P_POSSUI_REDACAO NUMBER,
                                                                    P_CURSOS {{user}}.IDS_TYP,
                                                                    P_ESCOLAS {{user}}.IDS_TYP,
                                                                    P_RESERVISTA NUMBER,
                                                                    P_CAPACITACAO {{user}}.CANDIDATO_CAPACITACAO_TYP,
                                                                    P_PCD NUMBER,
                                                                    P_CLASSIFICACAO VARCHAR2,
                                                                    P_IDIOMAS {{user}}.IDIOMAS_TYP,
                                                                    P_CONHECIMENTOS {{user}}.CONHECIMENTOS_TYP,
                                                                    P_VIDEO NUMBER,
                                                                    P_PERIODOS {{user}}.NAMELIST,
                                                                    P_OFFSET NUMBER DEFAULT 0,
                                                                    P_NEXT NUMBER DEFAULT 50,
                                                                    P_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query                   CLOB;
    v_referencia              SDO_GEOMETRY;
    v_cap1_referencia         SDO_GEOMETRY;
    v_cap2_referencia         SDO_GEOMETRY;
    v_cap3_referencia         SDO_GEOMETRY;
    v_max_pontuacao           NUMBER;
    v_ordenacao_classificacao VARCHAR2(5);
begin

    v_referencia := SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(P_LONGITUDE, P_LATITUDE, NULL), NULL, NULL);

    IF (P_CAPACITACAO.LATITUDE1 IS NOT NULL AND P_CAPACITACAO.LONGITUDE1 IS NOT NULL AND
        P_REFERENCIA_DISTANCIA IN (2, 5, 6)) THEN
        v_cap1_referencia :=
                SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(P_CAPACITACAO.LONGITUDE1, P_CAPACITACAO.LATITUDE1, NULL), NULL,
                             NULL);
    END IF;

    IF (P_CAPACITACAO.LATITUDE2 IS NOT NULL AND P_CAPACITACAO.LONGITUDE2 IS NOT NULL AND
        P_REFERENCIA_DISTANCIA IN (2, 5, 6)) THEN
        v_cap2_referencia :=
                SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(P_CAPACITACAO.LONGITUDE2, P_CAPACITACAO.LATITUDE2, NULL), NULL,
                             NULL);
    END IF;

    IF (P_CAPACITACAO.LATITUDE3 IS NOT NULL AND P_CAPACITACAO.LONGITUDE3 IS NOT NULL AND
        P_REFERENCIA_DISTANCIA IN (2, 5, 6)) THEN
        v_cap3_referencia :=
                SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(P_CAPACITACAO.LONGITUDE3, P_CAPACITACAO.LATITUDE3, NULL), NULL,
                             NULL);
    END IF;

    select cpp.PONTO_ATE + case
                               when p_classificacao = 'C' THEN CEIL(cpp.PONTO_ATE * PTC.PERCENTUAL_FAIXA_3 / 100)
                               ELSE 0
        END        PONTUACAO_MAX,
           case
               when p_classificacao = 'C' THEN ' DESC '
               ELSE
                   'ASC'
               end ORDENACAO_CLASSIFICACAO
    INTO v_max_pontuacao, v_ordenacao_classificacao
    from classificacoes_parametros_pontos cpp
             left join percentuais_triagens_classificacoes ptc on ptc.sigla_faixa_3 = cpp.descricao
    where cpp.descricao = p_classificacao;

    l_query := l_query || '
SELECT te.id_estudante,
       substr(te.nome, 1, 1) || te.codigo_estudante                                                       codigo_nome,
       te.nome nome_estudante,
       te.data_nascimento,
       te.codigo_curso_principal,
       rc.descricao_curso,
       escol.id_escola,
       escol.nome_escola,
       te.duracao_curso,
       te.status_escolaridade,
       te.tipo_duracao_curso,
       te.tipo_periodo_curso,
       te.periodo_atual,
       escol.data_prevista_conclusao,
       escol.data_conclusao,
       te.nivel_ensino,
       ender.cidade,
       ender.uf,
       te.data_alteracao,
       CASE
           WHEN te.pcds IS NULL OR te.pcds IS EMPTY THEN 0
           ELSE 1
           END                                                                                            pcd,
       (SELECT CAST(COLLECT(id_cid_agrupado) AS {{user}}.IDS_TYP) FROM TABLE (pcds))                      ids_cid_agrupado,
       (SELECT CAST(COLLECT(agrupamento) AS {{user}}.NAMELIST)
        FROM TABLE (pcds) p
                 INNER JOIN rep_agrupamento_cid_pcd acd
                            ON acd.codigo_agrupamento = p.id_cid_agrupado)                                descricao_cid_pcd,
       SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'')                          DISTANCIA,
       NVL((SELECT 1 FROM FAVORITOS WHERE id_candidato = te.id_estudante AND id_usuario = :P_USUARIO), 0) favorito ,
       te.possui_video ,
       te.video_url ,
       te.possui_redacao    ';

    IF
        (P_AREA_PROFISSIONAL IS NOT NULL)
    THEN
        l_query := l_query || '
               , ap.descricao_area_profissional
               , ap.codigo_area_profissional
               , ap.desc_reduz_area_profissional
               , ap.codigo_icone';
    END IF;

    l_query := l_query || '
            from triagens_estudantes te
                 inner join rep_escolaridades_estudantes escol on te.id_estudante = escol.id_estudante
                 inner join rep_cursos rc on rc.codigo_curso = escol.id_curso
                 cross join table (te.enderecos) ender';

    IF
        (P_AREA_PROFISSIONAL IS NOT NULL)
    THEN
        l_query := l_query || '
                 cross join rep_areas_profissionais ap';

    END IF;

    l_query := l_query || '
       where
            escol.principal = 1 and escol.deletado = 0
            and ender.principal = 1
                ';

    if
        (P_STATUS_ESCOLARIDADE IS NOT NULL AND P_STATUS_ESCOLARIDADE IS NOT EMPTY)
    then
        l_query := l_query || '
                   and te.STATUS_ESCOLARIDADE in (SELECT COLUMN_VALUE FROM TABLE(:P_STATUS_ESCOLARIDADE)) ';
    else
        l_query := l_query || '
                    and (:P_STATUS_ESCOLARIDADE is null)';
    end if;

    if
        (P_START_SEMESTRE is not null)
    then
        l_query := l_query || '
                       and (te.SEMESTRE >= :P_START_SEMESTRE)';
    else
        l_query := l_query || '
                       and (:P_START_SEMESTRE is null)';
    end if;

    if
        (P_END_SEMESTRE is not null)
    then
        l_query := l_query || '
                       and (te.SEMESTRE <= :P_END_SEMESTRE)';
    else
        l_query := l_query || '
                       and (:P_END_SEMESTRE is null)';
    end if;

    if
        (P_NIVEL_ENSINO is not null and P_NIVEL_ENSINO is not empty)
    then
        l_query := l_query || '
                       and (te.NIVEL_ENSINO in (SELECT COLUMN_VALUE FROM TABLE (:P_NIVEL_ENSINO)))';
    else
        l_query := l_query || '
                       and (:P_NIVEL_ENSINO IS NULL) ';
    end if;

    if
        (P_ESTADO_CIVIL is not null and P_ESTADO_CIVIL is not empty)
    then
        l_query := l_query || '
                       and te.ESTADO_CIVIL in (SELECT COLUMN_VALUE FROM TABLE (:P_ESTADO_CIVIL))';
    else
        l_query := l_query || '
                       and (:P_ESTADO_CIVIL IS NULL) ';
    end if;

    if
        (P_START_IDADE is not null)
    then
        l_query := l_query || '
                       and (TRUNC(MONTHS_BETWEEN(SYSDATE, te.DATA_NASCIMENTO) / 12) >= :P_START_IDADE)';
    else
        l_query := l_query || '
                       and (:P_START_IDADE IS NULL) ';
    end if;

    if
        (P_END_IDADE is not null)
    then
        l_query := l_query || '
                       and (TRUNC(MONTHS_BETWEEN(SYSDATE, te.DATA_NASCIMENTO) / 12) <= :P_END_IDADE) ';
    else
        l_query := l_query || '
                       and (:P_END_IDADE IS NULL) ';
    end if;

    if
        (P_DATA_CONCLUSAO is not null)
    then
        l_query := l_query || '
                       and (TE.DATA_CONCLUSAO_CURSO = :P_DATA_CONCLUSAO) ';
    else
        l_query := l_query || '
                       and (:P_DATA_CONCLUSAO IS NULL) ';
    end if;

    if
        (P_TIPO_PERIODO_CURSO is not null AND P_TIPO_PERIODO_CURSO IS NOT EMPTY)
    then
        l_query := l_query || '
                       and (TE.TIPO_PERIODO_CURSO = (SELECT COLUMN_VALUE FROM TABLE (:P_TIPO_PERIODO_CURSO))) ';
    else
        l_query := l_query || '
                       and (:P_TIPO_PERIODO_CURSO IS NULL) ';
    end if;

    if
        (P_SEXO is not null AND P_SEXO <> ' I ')
    then
        l_query := l_query || '
                       and (TE.SEXO = :P_SEXO) ';
    else
        l_query := l_query || '
                       and (:P_SEXO IS NULL OR 1 = 1) ';
    end if;

    if
        (P_TIPO_PERFIL = ' E ')
    THEN
        l_query := l_query || '
            AND (
        ';

        -- Ref distância estágio = 0: Mora. 1: Estuda. 2: Mora e estuda. 3: Mora ou estuda
        l_query := l_query || CASE P_REFERENCIA_DISTANCIA
                                  WHEN 0
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio and (:p_referencia is not null and :p_valor_raio is not null))'
                                  WHEN 1
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio and (:p_referencia is not null and :p_valor_raio is not null))'
                                  WHEN 2
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio) AND (SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio)'
                                  ELSE '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio) OR (SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio)'
            end;

        if (P_AREA_PROFISSIONAL IS NOT NULL) then
            l_query := l_query || '
                   and (ap.codigo_area_profissional = :P_AREA_PROFISSIONAL)
                   ';
        else
            l_query := l_query || '
                   and (:P_AREA_PROFISSIONAL is null) ';
        end if;

        IF (P_POSSUI_VIDEO = 1) THEN
            l_query := l_query || '
                AND TE.POSSUI_VIDEO = 1';
        END IF;

        IF (P_POSSUI_REDACAO = 1) THEN
            l_query := l_query || '
                AND TE.POSSUI_REDACAO = 1';
        END IF;

        IF (P_CURSOS IS NOT NULL AND P_CURSOS IS NOT EMPTY) THEN
            l_query := l_query || '
                AND (TE.CODIGO_CURSO_PRINCIPAL IS MEMBER OF :P_CURSOS)';
        ELSE
            l_query := l_query || '
                AND (:P_CURSOS IS NULL)';
        END IF;

        IF (P_ESCOLAS IS NOT NULL AND P_ESCOLAS IS NOT EMPTY) THEN
            l_query := l_query || '
                AND (EXISTS(SELECT 1 FROM TABLE(TE.ESCOLAS) WHERE COLUMN_VALUE MEMBER OF (:P_ESCOLAS)))';
        ELSE
            l_query := l_query || '
                AND (:P_ESCOLAS IS NULL)';
        END IF;

        IF (P_IDIOMAS IS NOT NULL AND P_IDIOMAS IS NOT EMPTY) THEN
            l_query := l_query || '
                and (
                    select count(1) from table(idiomas) te_id cross join table(:P_IDIOMAS) p_id
                    where p_id.nome = te_id.nome and te_id.nivel >= p_id.nivel
                    and (p_id.possui_certificado IS NULL OR p_id.possui_certificado = 0 or te_id.possui_certificado = 1)
                ) = cardinality(:P_IDIOMAS)
            ';
        ELSE
            l_query := l_query || '
                AND (:P_IDIOMAS IS NULL AND :P_IDIOMAS IS NULL)
            ';
        END IF;

        IF (P_CONHECIMENTOS IS NOT NULL AND P_CONHECIMENTOS IS NOT EMPTY) THEN
            l_query := l_query || '
                and (
                    select count(1) from table(conhecimentos) te_ci cross join table(:P_CONHECIMENTOS) p_ci
                    where p_ci.descricao = te_ci.descricao and te_ci.nivel >= p_ci.nivel
                    and (p_ci.possui_certificado IS NULL OR p_ci.possui_certificado = 0 or te_ci.possui_certificado = 1)
                ) = cardinality(:P_CONHECIMENTOS)
            ';
        ELSE
            l_query := l_query || '
                AND (:P_CONHECIMENTOS IS NULL AND :P_CONHECIMENTOS IS NULL)
            ';
        END IF;

        l_query := l_query || '
            AND (TE.TIPO_PROGRAMA IN (0, 2))';

        l_query := l_query || '
            )';
    ELSE

        l_query := l_query || '
            AND (
        ';
        -- Ref distância aprendiz = 0: Mora. 1: Estuda. 2: Capacita. 3: Mora e estuda. 4: Mora ou estuda. 5: Mora e capacita. 6: Estuda ou capacita
        l_query := l_query || CASE
                                  WHEN P_REFERENCIA_DISTANCIA IN (0, 5)
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio and (:p_referencia is not null and :p_valor_raio is not null))'
                                  WHEN P_REFERENCIA_DISTANCIA IN (1, 6)
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio and (:p_referencia is not null and :p_valor_raio is not null))'
                                  WHEN P_REFERENCIA_DISTANCIA = 3
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio) AND (SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio)'
                                  WHEN P_REFERENCIA_DISTANCIA = 4
                                      THEN '(SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio) OR (SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO_CAMPUS, 0.005, ''unit=km'') < :p_valor_raio)'
                                  ELSE ''
            end;

        IF (P_REFERENCIA_DISTANCIA IN (2, 5, 6)) THEN
            l_query := l_query || '
                AND (';

            IF (v_cap1_referencia IS NOT NULL) THEN
                l_query := l_query || '
                    ((SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA_CAP1, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio)';

                if (v_cap2_referencia IS NOT NULL OR v_cap3_referencia IS NOT NULL) THEN
                    l_query := l_query || ' OR ';
                END IF;
            ELSE
                l_query := l_query || '(:p_referencia_cap1 is null and :p_valor_raio is not null))';
            END IF;

            IF (v_cap2_referencia IS NOT NULL) THEN
                l_query := l_query || '
                    ((SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA_CAP2, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio)';

                if (v_cap3_referencia IS NOT NULL) THEN
                    l_query := l_query || ' OR ';
                END IF;
            ELSE
                l_query := l_query || '(:p_referencia_cap2 is null and :p_valor_raio is not null))';
            END IF;

            IF (v_cap3_referencia IS NOT NULL) THEN
                l_query := l_query || '
                    ((SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA_CAP3, TE.ENDERECO, 0.005, ''unit=km'') < :p_valor_raio)';
            ELSE
                l_query := l_query || '(:p_referencia_cap3 is null and :p_valor_raio is not null))';
            END IF;

            l_query := l_query || '
                )';
        ELSE
            l_query := l_query || '
                 AND (:p_referencia_cap1 is null and :p_valor_raio is not null and :p_referencia_cap2 is null and :p_valor_raio is not null and :p_referencia_cap3 is null and :p_valor_raio is not null)';
        END IF;

        IF (P_RESERVISTA = 1) THEN
            l_query := l_query || '
                AND TE.RESERVISTA = 1';
        END IF;

        l_query := l_query || '
            AND (TE.TIPO_PROGRAMA IN (1, 2))';

        l_query := l_query || '
            )';
    END IF;

    if
        (P_PCD = 1)
    THEN
        l_query := l_query || '
            AND (TE.PCDS IS NOT NULL AND TE.PCDS IS NOT EMPTY)';
    ELSE
        l_query := l_query || '
            AND (TE.PCDS IS NULL OR TE.PCDS IS EMPTY)';
    END IF;

    IF
        (P_VIDEO IS NOT NULL AND P_VIDEO = 1)
    THEN
        l_query := l_query || '
                   AND (te.POSSUI_VIDEO is not null) ';
    end if;

    if (P_PERIODOS is not null and P_PERIODOS is not empty) then
        l_query := '
            and (te.tipo_periodo_curso member of (select COLUMN_VALUE FROM TABLE(:P_PERIODOS))) ';
    ELSE
        l_query := '
            and (1 = 1 OR :P_PERIODOS IS NULL) ';
    end if;

    l_query := l_query || '
        AND TE.PONTUACAO_OBTIDA <= :P_PONTUACAO_MAXIMA
        ORDER BY TE.CLASSIFICACAO_OBTIDA ' || v_ordenacao_classificacao || ', TE.PONTUACAO_OBTIDA
        OFFSET :P_OFFSET ROWS FETCH NEXT :P_NEXT ROWS ONLY';

    --dbms_output.put_line(l_query);

    IF
        (P_TIPO_PERFIL = ' E ')
    THEN
        OPEN P_RESULTSET
            FOR l_query
            USING
            V_REFERENCIA
            , P_USUARIO
            , P_STATUS_ESCOLARIDADE
            , P_START_SEMESTRE
            , P_END_SEMESTRE
            , P_NIVEL_ENSINO
            , P_ESTADO_CIVIL
            , P_START_IDADE
            , P_END_IDADE
            , P_DATA_CONCLUSAO
            , P_TIPO_PERIODO_CURSO
            , P_SEXO
            , V_REFERENCIA
            , P_VALOR_RAIO
            , V_REFERENCIA
            , P_VALOR_RAIO
            , P_AREA_PROFISSIONAL
            , P_CURSOS
            , P_ESCOLAS
            , P_IDIOMAS
            , P_IDIOMAS
            , P_CONHECIMENTOS
            , P_CONHECIMENTOS
            , P_PERIODOS
            , v_max_pontuacao
            , P_OFFSET
            , P_NEXT;
    ELSE
        OPEN P_RESULTSET
            FOR l_query
            USING
            V_REFERENCIA
            , P_USUARIO
            , P_STATUS_ESCOLARIDADE
            , P_START_SEMESTRE
            , P_END_SEMESTRE
            , P_NIVEL_ENSINO
            , P_ESTADO_CIVIL
            , P_START_IDADE
            , P_END_IDADE
            , P_DATA_CONCLUSAO
            , P_TIPO_PERIODO_CURSO
            , P_SEXO
            , V_REFERENCIA
            , P_VALOR_RAIO
            , V_REFERENCIA
            , P_VALOR_RAIO
            , v_cap1_referencia
            , p_valor_raio
            , v_cap2_referencia
            , p_valor_raio
            , v_cap3_referencia
            , p_valor_raio
            , P_PERIODOS
            , v_max_pontuacao
            , P_OFFSET
            , P_NEXT;
    END IF;
end;