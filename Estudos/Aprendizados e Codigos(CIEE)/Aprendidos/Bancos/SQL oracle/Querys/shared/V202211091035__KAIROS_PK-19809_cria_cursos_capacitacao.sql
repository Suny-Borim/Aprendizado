------ Áreas Atuação Aprendiz

insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Administrador de Banco de Dados', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Administrador de Banco de Dados');
  
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Agroindústria', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria');
  
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Agrícolas Polivalente', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agrícolas Polivalente');

------ Cursos Capacitação

insert into cursos_capacitacao (id, descricao, modalidade, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, id_secretaria, id_area_atuacao, id_legado) 
  select SEQ_CURSOS_CAPACITACAO.nextval, 'EAD - Múltiplas Ocupações em Administrador de Banco de Dados', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', 110, (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Administrador de Banco de Dados'), null
from dual
  where not exists(SELECT 1 from cursos_capacitacao where descricao = 'EAD - Múltiplas Ocupações em Administrador de Banco de Dados');
  
insert into cursos_capacitacao (id, descricao, modalidade, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, id_secretaria, id_area_atuacao, id_legado) 
  select SEQ_CURSOS_CAPACITACAO.nextval, 'EAD - Múltiplas Ocupações em Agroindústria', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', 111, (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agroindústria'), null
from dual
  where not exists(SELECT 1 from cursos_capacitacao where descricao = 'EAD - Múltiplas Ocupações em Agroindústria');
  
  
insert into cursos_capacitacao (id, descricao, modalidade, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, id_secretaria, id_area_atuacao, id_legado) 
  select SEQ_CURSOS_CAPACITACAO.nextval, 'EAD - Arco em Ocupações Agrícolas Polivalente', 0, 1, 0, sysdate, sysdate, 'PK-19809', 'PK-19809', 112, (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Agrícolas Polivalente'), null
from dual
  where not exists(SELECT 1 from cursos_capacitacao where descricao = 'EAD - Arco em Ocupações Agrícolas Polivalente');