create or replace PROCEDURE                   "PROC_TRIAGEM_VAGAS_FILTRO"(v_id_estudante NUMBER,
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
    l_query := 'SELECT
        codigo_da_vaga,
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
             EXISTS (SELECT 1 from TABLE (V.ESTADO_CIVIL) EC WHERE EC.COLUMN_VALUE = E.ESTADO_CIVIL)
         THEN 1 ELSE 0 END ESTADO_CIVIL,

        -- [E] SE A VAGA ESPECIFICOU UMA ESCOLA, O ESTUDANTE DEVE CONSTAR NELA
        --PARA JOVEM APRENDIZ, DEVE SER REVISTA A REGRA POIS:
        --  SE O ALUNO JÁ FOI CADASTRADO COM ENSINO SUPERIOR, NÃO PODE PARTICIPAR PARA VAGA DE APRENDIZ
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.ESCOLAS IS NULL OR
             V.ESCOLAS IS EMPTY OR
             EXISTS (SELECT 1 from TABLE (V.ESCOLAS) EC WHERE EC.COLUMN_VALUE = E.ESCOLA)
            THEN 1 ELSE 0 END ESCOLA,

        -- [E] SE A VAGA ESPECIFICAR SEMESTRE, O ESTUDANTE DEVE POSSUIR
        CASE WHEN V.TIPO_VAGA = ''A'' OR ((V.SEMESTRE_INICIAL IS NULL OR E.SEMESTRE >= V.SEMESTRE_INICIAL) AND (V.SEMESTRE_FINAL IS NULL OR E.SEMESTRE <= V.SEMESTRE_FINAL)) THEN 1 ELSE 0 END SEMESTRE,

        -- [E] EFETUA O BATIMENTO DE CONHECIMENTOS, LEVANDO EM CONSIDERACAO O NÍVEL
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.CONHECIMENTOS IS NULL OR
             V.CONHECIMENTOS IS EMPTY OR
             (
                 SELECT COUNT(1)
                 FROM
                     TABLE(V.CONHECIMENTOS) CV,
                     TABLE(E.CONHECIMENTOS) CE
                 WHERE
                    CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                ) = CARDINALITY(V.CONHECIMENTOS)
             THEN 1 ELSE 0 END CONHECIMENTO,

        -- [E] REALIZA A COMPARACAO POR IDIOMA
        CASE WHEN
             V.TIPO_VAGA = ''A'' OR
             V.IDIOMAS IS NULL OR
             V.IDIOMAS IS EMPTY OR
             (
                 SELECT COUNT(1)
                 FROM
                     TABLE(V.IDIOMAS) IDV,
                     TABLE(E.IDIOMAS) IDE
                 WHERE
                    IDE.NOME = IDV.NOME AND IDE.NIVEL >= IDV.NIVEL
             ) = CARDINALITY(V.IDIOMAS)
            THEN 1 ELSE 0 END IDIOMA,

        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDERECO DO ALUNO
        CASE WHEN
            ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) = 2) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 5) IN (2, 5, 6))) OR
            (
               ((V.TIPO_VAGA = ''E'' AND NVL(V.LOCALIZACAO, 1) IN (0, 1, 3)) OR (V.TIPO_VAGA = ''A'' AND NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4)))
                AND EXISTS (SELECT 1 from TABLE(V.ENDERECO_GEOHASHS) CC, TABLE(E.ENDERECO_GEOHASHS) EEG WHERE CC.COLUMN_VALUE = EEG.COLUMN_VALUE or (CC.COLUMN_VALUE = substr(EEG.COLUMN_VALUE,1,4) and NVL(V.VALOR_RAIO, 20) > 50))
                -- AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
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
                        AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH OR (E.COLUMN_VALUE = substr(E.ENDERECO_CAMPUS_GEOHASH,1,4) and NVL(V.VALOR_RAIO, 20) > 50))
                    ) --AND
                    --SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        CASE WHEN
            V.TIPO_VAGA = ''E'' OR (
            NVL(V.LOCALIZACAO, 5) IN (1, 2, 3) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 4, 5, 6)
                AND EXISTS (SELECT 1 from TABLE (V.CAPACITACAO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_GEOHASH OR (E.COLUMN_VALUE = SUBSTR(E.ENDERECO_GEOHASH,1,4) AND NVL(V.VALOR_RAIO, 20) > 50 ))
                --SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
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
                SELECT COUNT(1)
                FROM
                     TABLE(E.PCDS) PE,
                     TABLE(V.PCDS) PV
                 WHERE
                    PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                    AND
                    (
                        PV.VALIDADE_MINIMA_LAUDO is null
                        OR (PE.VALIDADE_MINIMA_LAUDO is null and PV.VALIDADE_MINIMA_LAUDO is null)
                        OR TRUNC(PE.VALIDADE_MINIMA_LAUDO) >= TRUNC(PV.VALIDADE_MINIMA_LAUDO)
                    )
             ) > 0
            THEN 1 ELSE 0 END AS VALIDADE_LAUDO,

        -- [I] Validar regra de tipos de deficiencia
        CASE WHEN
                 V.PCDS IS NULL OR
                 V.PCDS IS EMPTY OR
                 (
                    SELECT COUNT(1)
                    FROM
                         TABLE(E.PCDS) PE,
                         TABLE(V.PCDS) PV
                     WHERE
                        PE.ID_CID_AGRUPADO = PV.ID_CID_AGRUPADO
                    ) > 0
                THEN 1 ELSE 0
            END AS TIPO_DEFICIENCIA,

        -- [I] Validar regra de qualificacao restritiva
        CASE WHEN
            V.QUALIFICACOES IS NULL OR
            V.QUALIFICACOES IS EMPTY OR
            (
                SELECT COUNT(1)
                FROM
                     TABLE(V.QUALIFICACOES) VQ,
                     TABLE(E.QUALIFICACOES) EQ
                 WHERE
                    VQ.COLUMN_VALUE = EQ.ID_QUALIFICACAO
                    AND EQ.RESULTADO = 0
                    AND EQ.DATA_VALIDADE >= SYSDATE
                ) = CARDINALITY(V.QUALIFICACOES)
            THEN 1 ELSE 0 END QUALIFICACAO,

        -- [I] Validar regra de Reservista
        CASE WHEN V.RESERVISTA = 0 OR V.RESERVISTA = E.RESERVISTA THEN 1 ELSE 0 END RESERVISTA,

        -- [I] Validar regra de recurso de acessibilidade
        CASE WHEN
                V.RECURSOS_ACESSIBILIDADE IS NULL OR
                V.RECURSOS_ACESSIBILIDADE IS EMPTY OR
                EXISTS
                (
                    SELECT 1
                    FROM
                        TABLE(E.RECURSOS_ACESSIBILIDADE) ERA, TABLE(V.RECURSOS_ACESSIBILIDADE) VRA
                    WHERE
                        ERA.COLUMN_VALUE = VRA.COLUMN_VALUE
                )
            THEN 1 ELSE 0 END RECURSO_ACESSIBILIDADE,

        -- [I] Validar Regra de cota PCD válida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA <= E.ELEGIVEL_PCD
        THEN 1 ELSE 0 END VALIDO_COTA,

        -- [E] Validar data de conclusão
        CASE WHEN V.TIPO_VAGA = ''A'' OR V.DATA_CONCLUSAO IS NULL OR E.DATA_CONCLUSAO_CURSO = V.DATA_CONCLUSAO THEN 1 ELSE 0 END DATA_CONCLUSAO,

        -- [I] Validar regra de horário da vaga
        CASE WHEN
            (V.TIPO_VAGA = ''E'' OR (TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= 18 OR (extract(hour from V.HORARIO_ENTRADA) < 22 AND extract(hour from V.HORARIO_SAIDA) <= 22 AND extract(hour from V.HORARIO_ENTRADA) >= 5)))
            AND
            (
                V.TIPO_HORARIO_ESTAGIO = 0 OR
                (
                    (       E.MODALIDADE = ''E''
                        OR
                           (E.MODALIDADE = ''P'' --OR (V.TIPO_VAGA = ''A'' AND E.STATUS_ESCOLARIDADE = 1)
                    )
                        AND
                        (
                            E.TIPO_PERIODO_CURSO = ''Variável''
                            OR E.TIPO_PERIODO_CURSO IN (''Manhã'', ''Integral'') AND V.HORARIO_ENTRADA > E.HORARIO_SAIDA
                            OR E.TIPO_PERIODO_CURSO = ''Tarde'' AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA OR V.HORARIO_ENTRADA > E.HORARIO_SAIDA)
                            OR E.TIPO_PERIODO_CURSO IN (''Noite'', ''Vespertino'') AND (V.HORARIO_SAIDA < E.HORARIO_ENTRADA)
                            or (V.TIPO_VAGA = ''A'' AND E.STATUS_ESCOLARIDADE = 1)
                        )
                    )
                )
            )
        THEN 1 ELSE 0 END HORARIO,

        -- ## Parâmetros escolares: Somente para vaga estágio e somente dos tipos "areaAtuacao", "permiteEstagio" e "cargaHorariaDiaria"
        CASE WHEN
         ---------------------------
         -- EXISTE_PAR_ESCOLA = 1 --
         ---------------------------
            EXISTE_PAR_ESCOLA = 0 or
                 (
                     -- Parametro Area atuação: Caso alguma área de atuação da vaga estiver contida nas áreas de atuação do parâmetro, estudante deverá estar cursando semestre dentro do intervalo especificado no parâmetro
                         NVL(case when v.areas_atuacao_estagio multiset intersect e.par_areas_atuacao is empty or v.areas_atuacao_estagio multiset intersect e.par_areas_atuacao is null or e.semestre between e.par_semestre_inicio
                             and e.par_semestre_fim then 1 else 0 end, 1)

                         -- Parâmetro permissão estágio. Caso houver, semestre atual do estudante não deve ultrapassar semestre indicado no parâmetro
                         + NVL(case when e.par_semestre_maximo >= e.semestre or e.par_semestre_maximo is null then 1 else 0 end, 1)

                         -- Parâmetro Carga horária diária: Caso vaga for a combinar ou nível da vaga for igual ao indicado no parâmetro, jornada diária da vaga não deve exceder o indicado no parâmetro
                         + NVL(case when v.tipo_horario_estagio = 0 OR e.nivel_ensino <> e.par_nivel_nao_permitido
                         OR v.jornada_minutos <= e.par_carga_horaria_diaria * 60 or e.par_carga_horaria_diaria is null then 1 else 0 end, 1)
                     ) = 3
         THEN 1 ELSE 0 END  parametro_escolar,

        -- valida se estudante não tem contratos ativos para poder se candidatar a vagas de aprendiz
        case
               when
                    V.TIPO_VAGA = ''E''
                        OR
                    NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.SITUACAO in (0,3,4,5))
               then 1 else 0
               END  CONTRATO_ATIVO,
        -- Aprendiz Paulista
        CASE WHEN
            (
                 (v.tipo_documento is null or v.tipo_documento != ''Aprendiz Paulista'')
                OR 
                (
                    v.tipo_documento = ''Aprendiz Paulista'' 
                    AND (
	                            (
	                                (
	                                	e.NIVEL_ENSINO in (''EM'') and 
	                                	(
	                                		e.TIPO_ESCOLA in (SELECT RTE.ID FROM REP_TIPOS_ESCOLAS_UNIT RTE WHERE RTE.SIGLA IN(''M'',''E'',''F'')	)
	                                	)
	                            	) OR 
	                            		(	e.NIVEL_ENSINO in (''EF'')	)
	                        	)
	                    	) ) )
        THEN 1 ELSE 0 END APTO_APRENDIZ_PAULISTA            
    from
        SERVICE_VAGAS_DEV.triagens_estudantes e,
        SERVICE_VAGAS_DEV.triagens_vagas v
    where
        e.id_estudante = :V_ID_ESTUDANTE

        -- Validar idade do candidato de acordo com a vaga
        and (v.possui_pcd = 1 OR (TRUNC(MONTHS_BETWEEN(SYSDATE, e.DATA_NASCIMENTO) / 12) BETWEEN v.idade_minima and v.idade_maxima))

        -- Validar situação da vaga (aberta ou bloqueada sem ocorrências)
        and (v.id_situacao_vaga = 1 or (v.id_situacao_vaga = 2 and v.possui_ocorrencias = 0))

        -- Validar aderência da regra de PCD
        --and (v.possui_pcd = 0 OR (e.pcds IS NOT NULL AND e.pcds IS NOT EMPTY))
        AND ((V.POSSUI_PCD = 0 AND CARDINALITY(E.PCDS) = 0) OR (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0))

    -- Validar regra de distância
    AND (
        EXISTS (SELECT 1 from TABLE(V.ENDERECO_GEOHASHS) CC, TABLE(E.ENDERECO_GEOHASHS) EEG WHERE CC.COLUMN_VALUE = EEG.COLUMN_VALUE)
        OR EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
        OR (V.TIPO_VAGA = ''A'' AND EXISTS (SELECT 1 from TABLE (V.CAPACITACAO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_GEOHASH))
    )

    -- Validar regra de contratos empresa
    AND NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA)

    -- Validar filtro de vagas PCD
    AND (nvl(:V_PCD, 0) = v.possui_pcd)';

    IF (v_valida_vinculo = 1) then
        l_query := l_query || '-- Validar regra de estudante liberado da vaga
        AND NOT EXISTS(select 1 from TABLE(e.VINCULOS) ev where v.codigo_da_vaga = ev.ID and ev.situacao_vinculo = 3) ';
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
/*
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
*/
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

        l_query := l_query || '
                -- Regra de Jovem Talento
                AND (
                    v.CONTRATACAO_JOVEM_TALENTO = 0
                    OR
                    (
                        v.CONTRATACAO_JOVEM_TALENTO = 1
                        AND
                        (
                          e.CONTRATOS_EMPRESA IS EMPTY
                          OR e.CONTRATOS_EMPRESA IS NULL
                          OR NOT (v.CODIGO_AREA_PROFISSIONAL member of e.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO)
                        )
                    )
                )
        ';


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
            AND (E.NIVEL_ENSINO <> ''SU'' AND E.NIVEL_ENSINO <> ''TE'' )
            AND (E.CONTRATOS_EMPRESA IS EMPTY OR E.CONTRATOS_EMPRESA IS NULL OR NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA OR (exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) where COLUMN_VALUE MEMBER OF V.CURSOS_CAPACITACAO)) ))
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
                -- Filtro por Aprendiz Paulista
                AND (
	                    (v.tipo_documento is null or v.tipo_documento != ''Aprendiz Paulista'')
	                    OR
	                    (
	                        v.tipo_documento = ''Aprendiz Paulista''
	                        AND
	                        (
	                            (
	                                (
	                                	e.NIVEL_ENSINO in (''EM'') and 
	                                	(
	                                		e.TIPO_ESCOLA in (SELECT RTE.ID FROM REP_TIPOS_ESCOLAS_UNIT RTE WHERE RTE.SIGLA IN(''M'',''E'',''F'')	)
	                                	)
	                            	) OR 
	                            		(	e.NIVEL_ENSINO in (''EF'')	)
	                        	)
	                    	)
	                	)
                	)
        ';


        l_query := l_query || '
        ))';
    END IF;
    l_query := l_query ||
               ') ORDER BY (DISTANCIA_CASA + DISTANCIA_CAMPUS + IDIOMA + CONHECIMENTO) desc OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY';

    dbms_output.put_line(l_query);

    IF (V_TIPO_VAGA = 'AE') THEN
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_ID_AREA_PROFISSIONAL, V_ID_AREA_ATUACAO_ESTAGIO, V_NIVEL_ESCOLARIDADE,
            V_SEMESTRE_INICIAL, V_SEMESTRE_FINAL, V_DATA_CONCLUSAO, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE,
            V_VALOR_REMUNERACAO_ATE, V_ID_AREA_ATUACAO_APRENDIZ, V_ID_CURSO_CAPACITACAO, V_ESCOLARIDADE_APRENDIZ, V_VALOR_REMUNERACAO_DE,
            V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE, V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    ELSIF (V_TIPO_VAGA = 'A') THEN
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_ID_AREA_ATUACAO_APRENDIZ, V_ID_CURSO_CAPACITACAO, V_ESCOLARIDADE_APRENDIZ,
            V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE, V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    ELSE
        OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, V_PCD, V_CODIGO_DA_VAGA, V_NOME_RAZAO_EMPRESA, V_ID_LOCAL_CONTRATO, V_DESCRICAO,
            V_DATA_CRIACAO, V_HORARIO_ENTRADA, V_HORARIO_SAIDA, V_ID_AREA_PROFISSIONAL, V_ID_AREA_ATUACAO_ESTAGIO, V_NIVEL_ESCOLARIDADE,
            V_SEMESTRE_INICIAL, V_SEMESTRE_FINAL, V_DATA_CONCLUSAO, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE,
            V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
    END IF;
end;