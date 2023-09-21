-- REMOVE REPLICA TELEFONES DO UNIT

ALTER TABLE rep_unids_ciee_tels_contato_unit DROP CONSTRAINT KRS_INDICE_04981;

DROP TABLE rep_telefones_unit;

ALTER TABLE rep_unids_ciee_tels_contato_unit
    ADD CONSTRAINT krs_indice_04981 FOREIGN KEY ( id_telefone )
        REFERENCES rep_telefones_escola ( id );