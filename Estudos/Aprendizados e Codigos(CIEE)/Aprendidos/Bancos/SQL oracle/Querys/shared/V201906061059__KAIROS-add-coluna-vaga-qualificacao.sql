--

DROP TABLE VINCULO_QUALIFICACAO_VAGA cascade constraints;

--

CREATE TABLE vinculo_quali_vaga_aprendiz (
    id_vaga_aprendiz   NUMBER(20) NOT NULL,
    id_qualificacao    NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_quali_vaga_aprendiz
    ADD CONSTRAINT krs_indice_03714 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id );

ALTER TABLE vinculo_quali_vaga_aprendiz
    ADD CONSTRAINT krs_indice_03715 FOREIGN KEY ( id_qualificacao )
        REFERENCES qualificacao ( id );

--

CREATE TABLE vinculo_quali_vaga_estagio (
    id_vaga_estagio   NUMBER(20) NOT NULL,
    id_qualificacao   NUMBER(20) NOT NULL
);

ALTER TABLE vinculo_quali_vaga_estagio
    ADD CONSTRAINT krs_indice_03716 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id );

ALTER TABLE vinculo_quali_vaga_estagio
    ADD CONSTRAINT krs_indice_03717 FOREIGN KEY ( id_qualificacao )
        REFERENCES qualificacao ( id );
