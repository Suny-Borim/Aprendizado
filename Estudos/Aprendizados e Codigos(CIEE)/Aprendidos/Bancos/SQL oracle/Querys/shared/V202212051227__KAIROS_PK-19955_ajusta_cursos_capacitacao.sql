------ Áreas Atuação Aprendiz
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Administrador de Banco de Dados EAD', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Administrador de Banco de Dados EAD');
  
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Agroindústria EAD', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria EAD');
  
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Agrícolas Polivalente EAD', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agrícolas Polivalente EAD');
  
 
------ Cursos Capacitação
update cursos_capacitacao set id_area_atuacao = (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Administrador de Banco de Dados EAD') where 
descricao = 'EAD - Múltiplas Ocupações em Administrador de Banco de Dados';

update cursos_capacitacao set id_area_atuacao = (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria EAD') where 
descricao = 'EAD - Múltiplas Ocupações em Agroindústria';

update cursos_capacitacao set id_area_atuacao = (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agrícolas Polivalente EAD') where 
descricao = 'EAD - Arco em Ocupações Agrícolas Polivalente';