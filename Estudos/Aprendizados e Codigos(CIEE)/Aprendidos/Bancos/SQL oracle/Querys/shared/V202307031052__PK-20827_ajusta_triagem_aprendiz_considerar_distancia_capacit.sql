create or replace PROCEDURE proc_triagem_aprendiz(V_CODIGO_DA_VAGA NUMBER DEFAULT NULL,
                                       V_ID_ESTUDANTE NUMBER DEFAULT NULL,
                                       V_OFFSET NUMBER DEFAULT 0,
                                       V_NEXT NUMBER DEFAULT 50,
                                       V_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query                  CLOB;
    l_query_tmp              CLOB := '';
    l_query_tmp_where        CLOB := '';
    V_IDADE_MINIMA           DATE := NULL;
    V_IDADE_MAXIMA           DATE := NULL;
    V_STATUS_ESCOLARIDADE    NUMBER(1, 0);
    V_ESCOLARIDADE           NUMBER(1, 0);
    V_PCD                    NUMBER(1, 0);
    V_MODALIDADE_CAPACITACAO NUMBER(1, 0);
    V_GEOHASHS               SERVICE_VAGAS_DEV.GEOHASHS_TYP;
    V_CAPACITACAO_GEOHASHS   SERVICE_VAGAS_DEV.GEOHASHS_TYP;
BEGIN

    --- ### REALIZA A ATUALIZACAO DA VAGA PARA TABELAS DE TRIAGEM CASO JA NAO ESTEJA ### ---
    PROC_VERIFICACAO_CRIACAO_DEFENSIVA_VAGA_TRIAGEM(V_CODIGO_DA_VAGA);
    --### CASO SEJA FILTRO POR VAGA, APLICA AS REGRAS PARA FILTRO  ###
    IF V_CODIGO_DA_VAGA IS NOT NULL THEN
        --Busca a idade
        SELECT add_months(sysdate, (12 * (-1) * V.IDADE_MINIMA)) as IDADE_MINIMA,
               add_months(sysdate, (12 * (-1) * V.IDADE_MAXIMA)) as IDADE_MAXIMA,
               CASE COALESCE(SITUACAO_ESCOLARIDADE, 0)
                   WHEN 0 THEN -1
                   WHEN 1 THEN 1
                   WHEN 2 THEN 0
                   ELSE -1
                   END                                           as STATUS_ESCOLARIDADE,
               ESCOLARIDADE,
               COALESCE(V.POSSUI_PCD, 0),
               COALESCE(V.MODALIDADE_CAPACITACAO, 0),
               COALESCE(V.ENDERECO_GEOHASHS, SERVICE_VAGAS_DEV.GEOHASHS_TYP()),
               COALESCE(V.CAPACITACAO_GEOHASHS, SERVICE_VAGAS_DEV.GEOHASHS_TYP())
        INTO
            V_IDADE_MINIMA, V_IDADE_MAXIMA, V_STATUS_ESCOLARIDADE, V_ESCOLARIDADE,
            V_PCD, V_MODALIDADE_CAPACITACAO, V_GEOHASHS, V_CAPACITACAO_GEOHASHS
        FROM SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V
        WHERE V.CODIGO_DA_VAGA = V_CODIGO_DA_VAGA;

        IF (V_MODALIDADE_CAPACITACAO = 1 AND V_CAPACITACAO_GEOHASHS is not null) THEN
            V_GEOHASHS := V_GEOHASHS MULTISET UNION DISTINCT V_CAPACITACAO_GEOHASHS;
        END IF;

        -- Para forcar o índice, use: /*+ index(F,IDX_TRIAGENS_ESTUDANTES_FILTRO_ESTUDANTE) */
        l_query := l_query || '
            WITH TEMP_ESTUDANTES AS (
                SELECT ID_ESTUDANTE,COUNT(*)
                    FROM(
                        SELECT
                            --DISTINCT
                            F.ID_ESTUDANTE
                        from
                            TRIAGENS_ESTUDANTES_FILTRO F
                        WHERE
                            -- REGRAS DE ENDERECO - DISTANCIA ONDE MORA OU ESTUDA (CAMPUS)
                            EXISTS (SELECT 1 from TABLE (:V_GEOHASHS) CC WHERE CC.COLUMN_VALUE = F.ENDERECO_GEOHASH)
                            AND F.PCD = :V_PCD
                       ';

        IF (V_ESCOLARIDADE = 0) THEN
            l_query := l_query || ' AND F.NIVEL_ENSINO NOT IN (''SU'', ''TE'') ';
        ELSIF (V_ESCOLARIDADE = 1) THEN
            l_query := l_query || ' AND F.NIVEL_ENSINO = ''EF'' ';
        ELSIF (V_ESCOLARIDADE = 2) THEN
            l_query := l_query || ' AND F.NIVEL_ENSINO = ''EM'' ';
        END IF;

        IF (V_STATUS_ESCOLARIDADE > -1) THEN
            l_query := l_query || ' AND F.STATUS_ESCOLARIDADE = :V_STATUS_ESCOLARIDADE
                )
                GROUP BY ID_ESTUDANTE
                )
                ';
        ELSE
            l_query := l_query || ' AND (1=1 OR :V_STATUS_ESCOLARIDADE = -1)
                )
                GROUP BY ID_ESTUDANTE
                )
                ';
        END IF;

        l_query_tmp := 'TEMP_ESTUDANTES TE, ';
        l_query_tmp_where := 'E.ID_ESTUDANTE = TE.ID_ESTUDANTE AND';
    END IF;


    l_query := l_query || '
    SELECT /*+ parallel 4 */
        V.CODIGO_DA_VAGA,
        E.ID_ESTUDANTE,

        -- [I] SE A VAGA EXIGE GENERO BIOLOGICO ESPECIFICO, VALIDAR O PERFIL DO ESTUDANTE
        CASE WHEN V.SEXO IS NULL OR V.SEXO = ''I'' OR V.SEXO = E.SEXO THEN 1 ELSE 0 END SEXO,

        -- TODO para os calculos de distancia, considerar o tipo de localização pedido pela vaga
        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (2, 5, 6) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 1, 3, 4)
                AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE
                            E.COLUMN_VALUE = CASE WHEN V.VALOR_RAIO <= 50 THEN E.ENDERECO_GEOHASH ELSE SUBSTR(E.ENDERECO_GEOHASH,1,4) END)
                --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CASA,

        -- [I] CIRCULO DE DISTANCIA ENTRE O LOCAL DE ESTAGIO E O ENDEREÇO DO CAMPUS DO ALUNO
        CASE WHEN
            NVL(V.LOCALIZACAO, 5) IN (1, 4, 5) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (0, 2, 3, 6) AND
                (
                    E.CURSO_EAD = 1 OR E.status_escolaridade = 1 OR NOT EXISTS(select 1 from table(e.escolas)) OR (
                        (
                            E.ENDERECO_CAMPUS_GEOHASH IS NOT NULL AND V.ENDERECO_GEOHASHS IS NOT NULL
                            AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE
                                        E.COLUMN_VALUE = CASE WHEN V.VALOR_RAIO <= 50 THEN E.ENDERECO_CAMPUS_GEOHASH ELSE SUBSTR(E.ENDERECO_CAMPUS_GEOHASH,1,4) END)
                        )
                        --AND SDO_GEOM.SDO_DISTANCE(V.ENDERECO, E.ENDERECO_CAMPUS, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
                    )
                )
            ) THEN 1 ELSE 0 END as DISTANCIA_CAMPUS,

        -- [A] CIRCULO DE DISTANCIA ENTRE O LOCAL DE CAPACITACAO (SOMENTE APRENDIZ) E O ENDERECO DO ALUNO
        CASE WHEN
        --  verificar distancia entra casa e local de contrato
            (V.MODALIDADE_CAPACITACAO = 1 AND EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) E WHERE E.COLUMN_VALUE = E.ENDERECO_GEOHASH))
            OR
             (V.MODALIDADE_CAPACITACAO = 0 and NVL(V.LOCALIZACAO, 5) IN (0, 1, 2, 3) ) OR
            (
                NVL(V.LOCALIZACAO, 1) IN (4, 5, 6)
                AND EXISTS (SELECT 1 from TABLE (V.CAPACITACAO_GEOHASHS) E WHERE
                            E.COLUMN_VALUE = CASE WHEN V.VALOR_RAIO <= 50 THEN E.ENDERECO_GEOHASH ELSE SUBSTR(E.ENDERECO_GEOHASH,1,4) END)
                --AND SDO_GEOM.SDO_DISTANCE(V.CAPACITACAO, E.ENDERECO, 0.005, ''unit=km'') < NVL(V.VALOR_RAIO, 20)
            ) THEN 1 ELSE 0 END as DISTANCIA_CAPACITACAO,

        -- [I] VALIDA A IDADE DO ESTUDANTE
        /*CASE WHEN
             V.POSSUI_PCD = 1 OR
             ((V.IDADE_MINIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) >= V.IDADE_MINIMA)
             AND
             (V.IDADE_MAXIMA IS NULL OR TRUNC(MONTHS_BETWEEN(SYSDATE, E.DATA_NASCIMENTO) / 12) <= V.IDADE_MAXIMA))
         THEN 1 ELSE 0 END*/ 1 AS RANGE_IDADE,

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

        -- [I] Validar regra de qualificação restritiva
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
                    AND EQ.SITUACAO = 1
                    AND (
                    	EQ.TIPO = 0
                    	OR
                    	(
                    		EQ.RESULTADO = 0
                    		AND EQ.DATA_VALIDADE >= SYSDATE
                   			AND EQ.TIPO = 1
                   		)
                    )
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

        -- [I] Validar Regra de cota PCD valida
        CASE WHEN
            V.POSSUI_PCD = 0 OR V.VALIDO_COTA <= E.ELEGIVEL_PCD
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

        E.QTD_CONVOCACOES,
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
    FROM
        SERVICE_VAGAS_DEV."TRIAGENS_VAGAS" V,
        ' || l_query_tmp || '
        SERVICE_VAGAS_DEV."TRIAGENS_ESTUDANTES" E
    WHERE
      ' || l_query_tmp_where || '
      V.TIPO_VAGA = ''A''
      AND V.ID_SITUACAO_VAGA = 1
      AND 
        (
            not exists (select 1 from table(E.CONTRATOS_EMPRESA) X WHERE X.TIPO_CONTRATO=''A'')
        
            and 

            not exists (select 1 from table(E.CONTRATOS_EMPRESA) X WHERE x.ID_EMPRESA = V.ID_EMPRESA)
            
            and

            not exists (select 1 from table(E.CONTRATOS_EMPRESA) X WHERE x.SITUACAO in (0,3,4,5))
            
            and
            
            not exists (select 1 from table (E.CONTRATOS_CURSOS_CAPACITACAO) ECC, TABLE(V.CURSOS_CAPACITACAO) VCC where ECC.COLUMN_VALUE = VCC.COLUMN_VALUE)
            
        ) 
      AND NOT EXISTS (SELECT 1 from TABLE(E.VINCULOS) EV where V.CODIGO_DA_VAGA = EV.ID)
      AND E.TIPO_PROGRAMA IN (1, 2)
      AND E.APTO_TRIAGEM = 1
';

    IF (V_CODIGO_DA_VAGA IS NOT NULL)
    THEN
        l_query := l_query || ' AND V.CODIGO_DA_VAGA = :V_CODIGO_DA_VAGA
            AND (
                V.POSSUI_PCD = 1
                OR TRUNC(E.DATA_NASCIMENTO) BETWEEN :V_IDADE_MAXIMA AND :V_IDADE_MINIMA
            )
        ';
    ELSE
        l_query := l_query || '
            AND (1=1 or :V_GEOHASHS is null)
            AND (1=1 or :V_PCD is null)
            AND (1=1 or :V_CODIGO_DA_VAGA is null)
            AND (1=1 or :V_IDADE_MAXIMA is null)
            AND (1=1 or :V_IDADE_MINIMA is null)
            AND (1=1 OR :V_STATUS_ESCOLARIDADE = -1)


            AND (E.NIVEL_ENSINO <> ''SU'' AND E.NIVEL_ENSINO <> ''TE'' )
            AND ((V.ESCOLARIDADE = 0) OR (V.ESCOLARIDADE = 1 AND E.NIVEL_ENSINO = ''EF'') OR (V.ESCOLARIDADE = 2 AND E.NIVEL_ENSINO = ''EM''))

            AND (
                (V.SITUACAO_ESCOLARIDADE = 0)
                OR (V.SITUACAO_ESCOLARIDADE = 1 and E.STATUS_ESCOLARIDADE = 1)
                OR (V.SITUACAO_ESCOLARIDADE = 2 and E.STATUS_ESCOLARIDADE = 0)
             )
            AND E.APTO_TRIAGEM = 1
            AND (
                V.POSSUI_PCD = 1
                OR trunc(months_between(SYSDATE, E.DATA_NASCIMENTO)/12) BETWEEN V.IDADE_MINIMA AND V.IDADE_MAXIMA
            )
            --VERSÃO ANTIGA
            AND (
                (V.POSSUI_PCD = 0 AND (E.PCDS IS EMPTY OR E.PCDS IS NULL)) OR
                (V.POSSUI_PCD = 1 AND (E.PCDS IS NOT EMPTY OR E.PCDS IS NOT NULL))
            )
            -- REGRAS DE ENDERECO
            AND
            (
                -- Distancia onde mora e ou estuda
                EXISTS
                    (
                        SELECT 1
                        FROM
                            TABLE(V.ENDERECO_GEOHASHS) VEG, TABLE(E.ENDERECO_GEOHASHS) EEG
                        WHERE
                            VEG.COLUMN_VALUE = EEG.COLUMN_VALUE
                    )
                OR -- Distancia capacitação
                (
                    V.MODALIDADE_CAPACITACAO = 1 AND
                    EXISTS (
                        SELECT 1
                        FROM
                            TABLE(V.CAPACITACAO_GEOHASHS) VEG, TABLE(E.ENDERECO_GEOHASHS) EEG
                        WHERE
                            VEG.COLUMN_VALUE = EEG.COLUMN_VALUE
                    )
                )
            )
        ';
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


    --### DEBUG ###
    /*dbms_output.put_line(l_query);
    dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' - Status Escolaridade:' || V_STATUS_ESCOLARIDADE || ' - Estudante:' ||
    V_ID_ESTUDANTE || ' Idade minima:' || V_IDADE_MINIMA || ' Idade maxima:' || V_IDADE_MAXIMA || ' PCD:' || V_PCD ||
    ' MODALIDADE CAPACITACAO:' || V_MODALIDADE_CAPACITACAO || ' Escolaridade:' || V_ESCOLARIDADE);
    for i in (select column_value from table(V_GEOHASHS)) loop
        dbms_output.put_line(i.column_value);
    end loop;
    dbms_output.put_line('----------------------------------------');
    for i in (select column_value from table(V_CAPACITACAO_GEOHASHS)) loop
        dbms_output.put_line(i.column_value);
    end loop;
    
    
        dbms_output.put_line(l_query);
     
        dbms_output.put_line('Vaga:' || V_CODIGO_DA_VAGA || ' - Status Escolaridade:' || V_STATUS_ESCOLARIDADE || ' - Estudante:' ||
        V_ID_ESTUDANTE || ' Idade minima:' || V_IDADE_MINIMA || ' Idade maxima:' || V_IDADE_MAXIMA || ' PCD:' || V_PCD ||
        ' MODALIDADE CAPACITACAO:' || V_MODALIDADE_CAPACITACAO || ' Escolaridade:' || V_ESCOLARIDADE);
    */

    OPEN V_RESULTSET FOR l_query
        USING
        V_GEOHASHS, V_PCD,
        V_STATUS_ESCOLARIDADE, V_CODIGO_DA_VAGA, V_IDADE_MAXIMA, V_IDADE_MINIMA,
        V_ID_ESTUDANTE, V_OFFSET, V_NEXT;

END;