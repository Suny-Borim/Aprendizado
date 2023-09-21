INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 6, 'Redução de custo/pessoal', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Redução de custo/pessoal');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 7, 'Estudante encontrou melhor Oportunidade', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Estudante encontrou melhor Oportunidade');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 8, 'Contrato marcado para o convenio errado', 2, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Contrato marcado para o convenio errado');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 15, 'Estudante não iniciou o estágio', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Estudante não iniciou o estágio');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 17, 'Empresa não autorizou a contratação', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Empresa não autorizou a contratação');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 18, 'IE não autorizou contrato-Atividades', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'IE não autorizou contrato-Atividades');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 20, 'Contrato marcado para estudante errado', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Contrato marcado para estudante errado');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 36, 'Contrato cancelado pendência de 4a via', 0, 0, 1, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Contrato cancelado pendência de 4a via');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 39, 'Contrato não retirado', 0, 0, 1, 10, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Contrato não retirado');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 44, 'Cancelamento de convênio', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Cancelamento de convênio');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 45, 'Contratos não autorizados pelo tj', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Contratos não autorizados pelo tj');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 46, 'Tce canc. 4a via - Acompanhado Opex', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Tce canc. 4a via - Acompanhado Opex');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 57, 'Bloqueio de BA - TJ', 0, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Bloqueio de BA - TJ');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 62, 'Alteração contratual - RJ', 0, 0, 1, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'Alteração contratual - RJ');

INSERT INTO motivos_cancelamentos_contratados (ID, CODIGO, DESCRICAO, TIPO_CONTRATO, PERFIL_ACESSO, ACESSO_CIEE, TEMPO_REVERSAO, SITUACAO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR)
select SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval, 79, 'COVID-19', 2, 0, 2, 0, 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'carga', 'carga' from dual
where not exists(select 1 from motivos_cancelamentos_contratados where descricao = 'COVID-19');