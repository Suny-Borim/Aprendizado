create or replace PROCEDURE proc_atualizar_triagem_estudante_lista_permissao_estagio (V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL)
AS
    l_query  CLOB;
    V_IDS_ESTUDANTES_INTERNO IDS_TYP;
BEGIN
    V_IDS_ESTUDANTES_INTERNO := V_IDS_ESTUDANTES ;
    l_query := 'MERGE INTO TRIAGENS_ESTUDANTES D
    USING (SELECT
            esc.id_estudante
            ,esc.id_curso
            , (CASE WHEN par.id_campus IS NOT NULL AND par.id_curso IS NULL THEN 1 ELSE 0 END + CASE WHEN par.id_curso IS NOT NULL THEN 2 ELSE 0 END) prioridade
            , case when par.id_parametro = 4 then
            (SELECT
                CAST(COLLECT(CAST(TRIM(regexp_substr(JSON_QUERY(respostas, ''$.areasAtuacao''), ''\d+'', 1, LEVEL)) AS NUMBER)) as ids_typ)
            FROM
                dual
            CONNECT BY
                (CAST(regexp_substr(JSON_QUERY(respostas, ''$.areasAtuacao''), ''\d+'', 1, LEVEL) AS NUMBER) IS NOT NULL))
            else null end areas_atuacao
            ,case when par.id_parametro = 4 then json_value(respostas, ''$.semestreInicio'' RETURNING NUMBER(2)) else null end semestre_inicio
            ,case when par.id_parametro = 4 then json_value(respostas, ''$.semestreFim'' RETURNING NUMBER(2)) else null end semestre_fim
            ,case when par.id_parametro = 6 then json_value(respostas, ''$.semestreMaximo'' RETURNING NUMBER(2)) else null end semestre_maximo
            ,case when par.id_parametro = 2 then json_value(respostas, ''$.cargaHorariaDiaria'' RETURNING NUMBER(2)) else null end carga_horaria_diaria
            ,case when par.id_parametro = 2 then json_value(respostas, ''$.nivelEnsinoNaoPermitido'' RETURNING VARCHAR2(2 CHAR)) else null end nivel_nao_permitido
        FROM
            SERVICE_VAGAS_DEV.parametros_ie par INNER JOIN SERVICE_VAGAS_DEV.rep_escolaridades_estudantes esc on esc.id_escola = par.id_ie
            left join SERVICE_VAGAS_DEV.rep_campus_cursos_periodos rccp on esc.id_periodo_curso = rccp.id
            left join SERVICE_VAGAS_DEV.rep_campus_cursos rcc on rcc.id = rccp.id_campus_curso
        WHERE
            1=1
            AND par.id_parametro in (2, 4, 6)
            AND  ';

    if (V_IDS_ESTUDANTES_INTERNO IS EMPTY OR V_IDS_ESTUDANTES_INTERNO IS NULL) THEN
        l_query := l_query || ':V_IDS_ESTUDANTES IS NULL';
    else
        l_query := l_query || 'esc.id_estudante IN (select COLUMN_VALUE from table(:V_IDS_ESTUDANTES_INTERNO))';
    end if;

    l_query := l_query || '
            AND par.deletado = 0
            AND par.situacao = 1
            AND esc.principal = 1
            AND (par.id_campus is null OR par.id_campus = rcc.id_campus)
            AND (par.id_curso is null OR par.id_curso = esc.id_curso)
            AND JSON_VALUE(respostas, ''$.tipo'') IN (''permissaoEstagio'')) S
        ON (D.ID_ESTUDANTE = S.ID_ESTUDANTE)
        WHEN MATCHED THEN
        UPDATE SET
            D.par_semestre_maximo      = S.semestre_maximo       -- permissaoEstagio
            ,D.EXISTE_PAR_ESCOLA        = 1';

    EXECUTE IMMEDIATE l_query USING V_IDS_ESTUDANTES_INTERNO;

    COMMIT;

END;
