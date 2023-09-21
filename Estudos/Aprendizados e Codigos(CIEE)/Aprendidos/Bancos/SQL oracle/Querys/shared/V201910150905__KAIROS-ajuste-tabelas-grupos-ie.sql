CREATE SEQUENCE SEQ_GRUPOS_IE MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;

---

ALTER TABLE grupos_ie ADD id_unidade_ciee NUMBER(19);

ALTER TABLE grupos_ie
ADD CONSTRAINT krs_indice_04725 FOREIGN KEY ( id_unidade_ciee )
REFERENCES rep_unidades_ciee ( id );

---

ALTER TABLE vinculos_grupos_ie_instituicoes_ensinos ADD CONSTRAINT krs_indice_04780 UNIQUE ( id_grupo_ie, id_instituicao_ensino );
