create or replace PROCEDURE "PROC_TRIAGEM_VAGAS_APP_ESTAGIO"(v_id_estudante NUMBER,
                                                    v_pcd NUMBER DEFAULT 0,
                                                    v_idade_estudante NUMBER,
                                                    v_valor_remuneracao_de NUMBER,
                                                    v_valor_remuneracao_ate NUMBER,
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
        codigo_da_vaga

    from
        SERVICE_VAGAS_DEV.triagens_estudantes e,
        SERVICE_VAGAS_DEV.triagens_vagas v
    where
        e.id_estudante = :V_ID_ESTUDANTE

        and v.tipo_vaga = ''E''

        -- Validar situação da vaga (aberta ou bloqueada sem ocorrências)
        and (v.id_situacao_vaga = 1 or (v.id_situacao_vaga = 2 and v.possui_ocorrencias = 0))

     AND NOT EXISTS (SELECT 1 from TABLE (E.CONTRATOS_EMPRESA) EC_EMP WHERE EC_EMP.ID_EMPRESA = V.ID_EMPRESA) ';

    IF (v_pcd = 0) then
        l_query := l_query || 'AND V.POSSUI_PCD = 0 and (:v_idade_estudante between v.idade_minima and v.idade_maxima) ';
    ELSE
        l_query := l_query || 'AND (V.POSSUI_PCD = 1 AND CARDINALITY(E.PCDS) > 0) ';
    END IF;

    IF (v_valida_vinculo = 1) then
        l_query := l_query || '-- Validar regra de estudante liberado da vaga
        AND NOT EXISTS(select 1 from TABLE(e.VINCULOS) ev where v.codigo_da_vaga = ev.ID and ev.situacao_vinculo = 3) ';
    end if;


    IF (v_tipo_referencia IS NOT NULL AND (v_raio_mora IS NOT NULL OR v_raio_estuda IS NOT NULL)) THEN

        IF (v_tipo_referencia = 0) THEN
            l_query := l_query || '
            AND (E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS) ';
        END IF;

        IF (v_tipo_referencia = 1) THEN
            l_query := l_query || '
            AND (E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS) ';
        END IF;

        IF (v_tipo_referencia = 2) THEN
            l_query := l_query || '
            AND ((E.ENDERECO_CAMPUS_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS) OR (E.ENDERECO_GEOHASH MEMBER OF V.ENDERECO_GEOHASHS)) ';
        END IF;

    ELSE
        l_query := l_query || '
            AND (
        EXISTS (SELECT 1 from TABLE(V.ENDERECO_GEOHASHS) CC, TABLE(E.ENDERECO_GEOHASHS) EEG WHERE CC.COLUMN_VALUE = EEG.COLUMN_VALUE)
        OR EXISTS (SELECT 1 from TABLE (V.ENDERECO_GEOHASHS) CC WHERE CC.COLUMN_VALUE = E.ENDERECO_CAMPUS_GEOHASH)
    )';
    END IF;

    -- Regras específicas
    l_query := l_query || '
               AND (
                    -- Para estágio, candidato sempre tem que estar cursando
                    EXISTS(SELECT 1 FROM TABLE(E.CURSOS) WHERE COLUMN_VALUE MEMBER OF (V.CURSOS))

                    and (
                        e.status_escolaridade = 0
                        and (
                            e.nivel_ensino IN (''EM'', ''TE'', ''SU'')
                        )))';

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
                          OR NOT (v.CODIGO_AREA_PROFISSIONAL member of e.AREAS_PROFISSIONAIS_JOVEM_TALENTO_CONTRATADO)
                        )
                    )
                )
        ';

    IF (v_valor_remuneracao_de IS NOT NULL OR v_valor_remuneracao_ate IS NOT NULL) THEN
        IF (v_valor_remuneracao_de IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por valor bolsa (mínimo)
                and (v.valor_bolsa_fixo >= :V_VALOR_REMUNERACAO_DE OR v.valor_bolsa_de >= :V_VALOR_REMUNERACAO_DE)';
        ELSE
            l_query := l_query || '
                AND :V_VALOR_REMUNERACAO_DE IS NULL';
        END IF;

        IF (v_valor_remuneracao_ate IS NOT NULL) THEN
            l_query := l_query || '
                -- Filtro por valor bolsa (máximo)
                and (v.valor_bolsa_fixo <= :V_VALOR_REMUNERACAO_ATE OR v.valor_bolsa_ate <= :V_VALOR_REMUNERACAO_ATE)';
        ELSE
            l_query := l_query || '
                AND :V_VALOR_REMUNERACAO_ATE IS NULL';
        END IF;
    ELSE
        l_query := l_query || '
            AND (:V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_DE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL OR :V_VALOR_REMUNERACAO_ATE IS NULL)';
    END IF;

    l_query := l_query || '
        AND (
             V.CONHECIMENTOS IS EMPTY OR
             (
                 SELECT COUNT(1)
                 FROM
                     TABLE(V.CONHECIMENTOS) CV,
                     TABLE(E.CONHECIMENTOS) CE
                 WHERE
                    CE.DESCRICAO = CV.DESCRICAO AND CE.NIVEL >= CV.NIVEL
                ) = CARDINALITY(V.CONHECIMENTOS) )

        AND (
             V.IDIOMAS IS EMPTY OR
             (
                 SELECT COUNT(1)
                 FROM
                     TABLE(V.IDIOMAS) IDV,
                     TABLE(E.IDIOMAS) IDE
                 WHERE
                    IDE.NOME = IDV.NOME AND IDE.NIVEL >= IDV.NIVEL
             ) = CARDINALITY(V.IDIOMAS) ) ';


    l_query := l_query ||
               ' OFFSET :V_OFFSET ROWS FETCH NEXT :V_NEXT ROWS ONLY';

    dbms_output.put_line(l_query);

    OPEN V_RESULTSET FOR L_QUERY USING V_ID_ESTUDANTE, v_idade_estudante, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_DE, V_VALOR_REMUNERACAO_ATE,
        V_VALOR_REMUNERACAO_ATE, V_OFFSET, V_NEXT;
end;