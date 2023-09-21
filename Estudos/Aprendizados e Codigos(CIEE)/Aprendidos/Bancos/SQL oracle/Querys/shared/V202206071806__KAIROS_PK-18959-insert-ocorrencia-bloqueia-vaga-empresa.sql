--Insere ocorrência a partir do parametro de empresa - Vaga bloqueada por exigência da empresa .

insert into ocorrencias(id,descricao,bloqueia_vaga,bloqueia_contratacao,ativo,deletado,data_criacao,data_alteracao,criado_por,modificado_por) 
values('59','Vaga bloqueada por exigência da empresa','1','0','1', 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'FLYWAY', 'FLYWAY');
