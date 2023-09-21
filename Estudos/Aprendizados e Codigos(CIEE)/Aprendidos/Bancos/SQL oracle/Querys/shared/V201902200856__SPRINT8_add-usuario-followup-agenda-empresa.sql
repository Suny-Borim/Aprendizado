ALTER TABLE agenda_empresa_vaga ADD ID_USUARIO NUMBER(19) NOT NULL;

ALTER TABLE acompanhamentos_vagas ADD ID_USUARIO NUMBER(19) NOT NULL;

ALTER TABLE agenda_empresa_vaga
  ADD CONSTRAINT krs_indice_01823 FOREIGN KEY ( id_usuario )
REFERENCES rep_usuarios ( id );

ALTER TABLE acompanhamentos_vagas
  ADD CONSTRAINT krs_indice_01824 FOREIGN KEY ( id_usuario )
REFERENCES rep_usuarios ( id );