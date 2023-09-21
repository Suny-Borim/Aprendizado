

update beneficios set utiliza_na_contratacao = 1, data_alteracao = sysdate, modificado_por = 'PK-18458' where descricao != 'Outros';