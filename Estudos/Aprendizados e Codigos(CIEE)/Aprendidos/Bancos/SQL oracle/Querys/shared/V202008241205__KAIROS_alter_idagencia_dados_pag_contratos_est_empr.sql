-- Ajusta tamanho id_agencia
ALTER TABLE dados_pagamentos_contratos_estudantes_empresas MODIFY ID_AGENCIA NUMBER(20,0);
ALTER TABLE pre_contratos_estudantes_empresa MODIFY ID_AGENCIA NUMBER(20,0);
ALTER TABLE contratos_estudantes_empresa MODIFY ID_AGENCIA NUMBER(20,0);