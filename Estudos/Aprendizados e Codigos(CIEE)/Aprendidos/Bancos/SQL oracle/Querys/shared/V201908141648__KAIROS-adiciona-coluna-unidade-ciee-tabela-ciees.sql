ALTER TABLE REP_CIEES
    ADD ID_UNIDADE_CIEE NUMBER(19);

ALTER TABLE rep_ciees
    ADD CONSTRAINT krs_indice_04211 FOREIGN KEY (id_unidade_ciee)
        REFERENCES rep_unidades_ciee (id);

