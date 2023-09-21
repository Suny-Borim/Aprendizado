CREATE TABLE vaga_aprendiz_reserva (
    id NUMBER(20) NOT NULL,
    id_vaga_aprendiz NUMBER(20) NOT NULL,
    id_secretaria NUMBER(20) NOT NULL,
    ativo NUMBER(1,0)
);

ALTER TABLE vaga_aprendiz_reserva ADD CONSTRAINT KRS_INDICE_07241 PRIMARY KEY ( id );

ALTER TABLE vaga_aprendiz_reserva
    ADD CONSTRAINT KRS_INDICE_07242 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id );