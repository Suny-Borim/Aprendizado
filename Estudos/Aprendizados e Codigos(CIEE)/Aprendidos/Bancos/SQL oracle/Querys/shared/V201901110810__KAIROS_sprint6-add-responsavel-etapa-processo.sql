alter table tipo_presencial drop column id_responsavel_processo;
alter table tipo_conferencia drop column id_responsavel_processo;
alter table tipo_upload drop column id_responsavel_processo;
alter table tipo_prova drop column id_responsavel_processo;
alter table tipo_ligacao_tef drop column id_responsavel_processo;

alter table etapas_processo_seletivo add id_responsavel_processo number(20);

ALTER TABLE etapas_processo_seletivo
  ADD CONSTRAINT KRS_INDICE_01202 FOREIGN KEY ( id_responsavel_processo )
REFERENCES rep_representantes ( id );

