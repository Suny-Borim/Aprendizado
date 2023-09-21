CREATE TABLE vinculos_contratacao
(
  id                         NUMBER(20) NOT NULL,
  id_vinculo                 NUMBER(20) NOT NULL,
  id_recusa                  NUMBER(20) NOT NULL,
  data_liberacao_contratacao TIMESTAMP,
  login_usuario              VARCHAR2(50)
);

ALTER TABLE vinculos_contratacao
  ADD CONSTRAINT KRS_INDICE_02023 PRIMARY KEY (id);

ALTER TABLE vinculos_contratacao
  ADD CONSTRAINT KRS_INDICE_02024 FOREIGN KEY (id_vinculo)
    REFERENCES vinculos_vaga (id)
      NOT DEFERRABLE;

ALTER TABLE vinculos_contratacao
  ADD CONSTRAINT KRS_INDICE_02025 FOREIGN KEY (id_recusa)
    REFERENCES recusa (id)
      NOT DEFERRABLE;