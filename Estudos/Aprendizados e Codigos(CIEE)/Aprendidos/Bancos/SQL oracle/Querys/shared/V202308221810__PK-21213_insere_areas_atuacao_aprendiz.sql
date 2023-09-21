
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'Colheita Frutífera', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-21213', 'PK-21213', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Colheita Frutífera');
  
  
insert into areas_atuacao_aprendiz (id, id_grupo_empresa, descricao_Area_atuacao, nivel_area_Atuacao, tipo_programa, identificador, situacao, deletado, data_criacao, data_alteracao, criado_por, modificado_por, codigo_icone, id_legado) 
  select SEQ_AREAS_ATUACAO_APRENDIZ.nextval, null, 'EAD - Colheita Frutífera', 3, 'Aprendiz', 0, 1, 0, sysdate, sysdate, 'PK-21213', 'PK-21213', null, null
from dual
  where not exists(SELECT 1 from areas_atuacao_aprendiz where descricao_Area_atuacao = 'EAD - Colheita Frutífera');
  
  

UPDATE cursos_capacitacao set id_area_atuacao = (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'Colheita Frutífera'), modificado_por = 'PK-21213', data_alteracao = sysdate where descricao = 'Aprendiz na Colheita Frutífera';
  
UPDATE cursos_capacitacao set id_area_atuacao = (SELECT id from areas_atuacao_aprendiz where descricao_Area_atuacao = 'EAD - Colheita Frutífera'), modificado_por = 'PK-21213', data_alteracao = sysdate where descricao = 'EAD - Aprendiz na Colheita Frutífera';