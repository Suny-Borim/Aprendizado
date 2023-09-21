--Ajusta rep campous para view dados escolaridade

ALTER TABLE REP_CAMPUS ADD NOME_FANTASIA VARCHAR(200);


--Cria view de dados de escolaridade

create or replace view v_dados_escolaridade as
select a.id_estudante,
       c.id_curso,
       d.descricao_curso,
       a.tipo_periodo_curso,
       a.periodo_atual,
       c.id_campus,
       e.nome_fantasia,
       a.id_escola,
       a.nome_escola

from service_vagas_dev.rep_escolaridades_estudantes a,
     service_vagas_dev.rep_campus_cursos_periodos b,
     service_vagas_dev.rep_campus_cursos c,
     service_vagas_dev.rep_cursos d,
     service_vagas_dev.rep_campus e

where a.id_periodo_curso=b.id and
      b.id_campus_curso=c.id and
      c.id_curso=d.codigo_curso and
      c.id_campus=e.id
