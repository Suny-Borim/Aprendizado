INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 1, 'RECADO', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'RECADO');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 3, 'OCUPADO', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'OCUPADO');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 5, 'LIGAR NA DATA', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'LIGAR NA DATA');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 6, 'MARCACAO DE CONTRATO ', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'MARCACAO DE CONTRATO ');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 7, 'CANCELAMENTO', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'CANCELAMENTO');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 8, 'ENTROU EM P.S.', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'ENTROU EM P.S.');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 9, 'NOVA TRIAGEM', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'NOVA TRIAGEM');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 16, 'ALTERACAO DE CURSO/PERFIL ', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'ALTERACAO DE CURSO/PERFIL ');

INSERT INTO status_acompanhamento ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 24, 'SOLICITADA VISITA DO ASSISTENTE', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamento where descricao = 'SOLICITADA VISITA DO ASSISTENTE');

INSERT INTO status_acompanhamentos_contratados ( id, descricao, gera_agenda, deletado,data_criacao, data_alteracao, criado_por,modificado_por )
select 1, 'Renovação padrão', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from status_acompanhamentos_contratados where descricao = 'Renovação padrão');