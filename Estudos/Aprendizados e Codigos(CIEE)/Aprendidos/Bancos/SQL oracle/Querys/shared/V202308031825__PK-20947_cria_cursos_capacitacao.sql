------ Cursos Capacitação

insert into cursos_capacitacao (id, descricao, modalidade, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, id_secretaria, id_area_atuacao, id_legado) 
  select SEQ_CURSOS_CAPACITACAO.nextval, 'EAD - Aprendiz na Colheita Frutífera', 1, 1, 0, sysdate, sysdate, 'PK-20947', 'PK-20947', 113, (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria EAD'), null
from dual
  where not exists(SELECT 1 from cursos_capacitacao where descricao = 'EAD - Aprendiz na Colheita Frutífera');
  
insert into cursos_capacitacao (id, descricao, modalidade, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, id_secretaria, id_area_atuacao, id_legado) 
  select SEQ_CURSOS_CAPACITACAO.nextval, 'Aprendiz na Colheita Frutífera', 0, 1, 0, sysdate, sysdate, 'PK-20947', 'PK-20947', 114, (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria'), null
from dual
  where not exists(SELECT 1 from cursos_capacitacao where descricao = 'Aprendiz na Colheita Frutífera');
