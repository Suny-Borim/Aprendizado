----- Tabela vinculos_contratos_atividades_aprendiz
CREATE TABLE vinculos_pre_contratos_atividades_aprendiz (
    id_pre_contrato_curso_capacitacao  NUMBER(20),
    id_atividade                       NUMBER(20) NOT NULL,
    id_cbo                             NUMBER(20) NOT NULL
);
ALTER TABLE vinculos_pre_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07385 FOREIGN KEY ( id_pre_contrato_curso_capacitacao )
        REFERENCES pre_contratos_cursos_capacitacao ( id );
ALTER TABLE vinculos_pre_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07386 FOREIGN KEY ( id_atividade )
        REFERENCES atividades_aprendiz ( id );
ALTER TABLE vinculos_pre_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07387 FOREIGN KEY ( id_cbo )
        REFERENCES cbos ( id );

----- Tabela vinculos_contratos_atividades_aprendiz
CREATE TABLE vinculos_contratos_atividades_aprendiz (
    id_contrato_curso_capacitacao      NUMBER(20) NOT NULL,
    id_atividade                       NUMBER(20) NOT NULL,
    id_cbo                             NUMBER(20) NOT NULL
);
ALTER TABLE vinculos_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07388 FOREIGN KEY ( id_contrato_curso_capacitacao )
        REFERENCES contratos_cursos_capacitacao ( id );
ALTER TABLE vinculos_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07392 FOREIGN KEY ( id_atividade )
        REFERENCES atividades_aprendiz ( id );
ALTER TABLE vinculos_contratos_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07393 FOREIGN KEY ( id_cbo )
        REFERENCES cbos ( id );


----- Tabela vinculos_vagas_atividades_aprendiz
CREATE TABLE vinculos_vagas_atividades_aprendiz (
    id_vaga_aprendiz  NUMBER(20),
    id_atividade      NUMBER(20),
    id_cbo            NUMBER(20)
);
ALTER TABLE vinculos_vagas_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07389 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id );
ALTER TABLE vinculos_vagas_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07390 FOREIGN KEY ( id_atividade )
        REFERENCES atividades_aprendiz ( id );
ALTER TABLE vinculos_vagas_atividades_aprendiz
    ADD CONSTRAINT krs_indice_07391 FOREIGN KEY ( id_cbo )
        REFERENCES cbos ( id );