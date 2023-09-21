create or replace view {{user}}.v_parametros_ie_estudantes as
(
select par.id_ie id_instituicao_ensino,
       par.id_campus,
       par.id_curso,
       esc.id_estudante,
       json_value(respostas, '$.tipo') tipo_param,
       case when par.id_parametro = 2 then json_value(respostas, '$.cargaHorariaDiaria' RETURNING NUMBER(2)) else null end carga_horaria_diaria,
       case when par.id_parametro = 2 then json_value(respostas, '$.nivelEnsinoNaoPermitido' RETURNING VARCHAR2(2 CHAR)) else null end nivel_nao_permitido,
       case when par.id_parametro = 4 then
                (select cast(collect(cast(trim(regexp_substr(json_query(respostas, '$.areasAtuacao'), '\d+', 1, LEVEL)) as number)) as ids_typ)
                 FROM dual
                 CONNECT BY (cast(regexp_substr(json_query(respostas, '$.areasAtuacao'), '\d+', 1, LEVEL) as number) IS NOT NULL))
            else null end areas_atuacao,
       case when par.id_parametro = 4 then json_value(respostas, '$.semestreInicio' RETURNING NUMBER(2)) else null end semestre_inicio,
       case when par.id_parametro = 4 then json_value(respostas, '$.semestreFim' RETURNING NUMBER(2)) else null end semestre_fim,
       case when par.id_parametro = 6 then json_value(respostas, '$.semestreMaximo' RETURNING NUMBER(2)) else null end semestre_maximo,
       (
               case when par.id_campus is not null and par.id_curso is null then 1 else 0 end +
               case when par.id_curso is not null then 2 else 0 end
           ) prioridade
from {{user}}.parametros_ie par
         inner join {{user}}.rep_escolaridades_estudantes esc on esc.id_escola = par.id_ie
         left join {{user}}.rep_campus_cursos_periodos rccp on esc.id_periodo_curso = rccp.id
         left join {{user}}.rep_campus_cursos rcc on rcc.id = rccp.id_campus_curso
where
        esc.principal = 1
  and par.id_parametro in (2, 4, 6)
  and par.deletado = 0
  and par.situacao = 1
  AND (par.id_campus is null OR par.id_campus = rcc.id_campus)
  AND (par.id_curso is null OR par.id_curso = esc.id_curso));