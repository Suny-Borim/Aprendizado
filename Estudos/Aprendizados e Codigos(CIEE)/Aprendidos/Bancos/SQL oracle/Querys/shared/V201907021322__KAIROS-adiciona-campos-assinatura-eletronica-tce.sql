-- Adiciona campos que são utilizados para assinatura eletrônica

ALTER TABLE contratos_estudantes_empresa ADD email_contato_responsavel VARCHAR2(100);
ALTER TABLE PRE_contratos_estudantes_empresa ADD email_contato_responsavel VARCHAR2(100);
ALTER TABLE hist_contratos_estudantes_empresa ADD email_contato_responsavel VARCHAR2(100);

ALTER TABLE contratos_estudantes_empresa ADD fone_contato_responsavel VARCHAR2(100);
ALTER TABLE PRE_contratos_estudantes_empresa ADD fone_contato_responsavel VARCHAR2(100);
ALTER TABLE hist_contratos_estudantes_empresa ADD fone_contato_responsavel VARCHAR2(100);
