ALTER TABLE CONTRATOS_ESTUDANTES_EMPRESA ADD SITUACAO_ESCOLARIDADE NUMBER(1);
ALTER TABLE PRE_CONTRATOS_ESTUDANTES_EMPRESA ADD SITUACAO_ESCOLARIDADE NUMBER(1);

COMMENT ON COLUMN contratos_estudantes_empresa.situacao_escolaridade IS
    'Enum:

0 - Todos

1 - Cursando

2 - Concluido

Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN pre_contratos_estudantes_empresa.situacao_escolaridade IS
    'Enum:

0 - Todos

1 - Cursando

2 - Concluido

Este campo e utilizado na matricula do Aprendiz';

alter table contratos_estudantes_empresa add numero_carteira_trabalho VARCHAR2(64);
alter table contratos_estudantes_empresa add serie_carteira_trabalho VARCHAR2(32);
alter table contratos_estudantes_empresa add uf_carteira_trabalho VARCHAR2(2);
alter table contratos_estudantes_empresa add pis VARCHAR2(32);

alter table pre_contratos_estudantes_empresa add numero_carteira_trabalho VARCHAR2(64);
alter table pre_contratos_estudantes_empresa add serie_carteira_trabalho VARCHAR2(32);
alter table pre_contratos_estudantes_empresa add uf_carteira_trabalho VARCHAR2(2);
alter table pre_contratos_estudantes_empresa add pis VARCHAR2(32);