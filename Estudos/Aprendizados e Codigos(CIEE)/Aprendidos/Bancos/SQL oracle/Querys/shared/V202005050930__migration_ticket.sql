CREATE TABLE tickets (
    id                                                   NUMBER(20) NOT NULL,
    id_contr_emp_est                                     NUMBER(20),
    id_local_contrato                                    NUMBER(20),
    id_contrato                                          NUMBER(20),
    id_vaga_estagio                                      NUMBER(20),
    id_vaga_aprendiz                                     NUMBER(20),
    id_area_profissional                                 NUMBER(20),
    id_curso_capacitacao                                 NUMBER(20),
    numero_ticket                                        NUMBER(5),
    quantidade_ticket_contrato                           NUMBER(10) NOT NULL,
    distribuir_ticket_local_contrato                     NUMBER(1) DEFAULT 0 NOT NULL,
    quantidade_ticket_local_contrato                     NUMBER(10),
    distribuir_ticket_curso_capacitacao                  NUMBER(1) DEFAULT 0,
    quantidade_ticket_curso_capacitacao                  NUMBER(10),
    distribuir_ticket_nivel_ensino                       NUMBER(1) DEFAULT 0,
    quantidade_ticket_nivel_ensino                       NUMBER(10),
    distribuir_ticket_area_profissional                  NUMBER(1) DEFAULT 0,
    quantidade_ticket_area_profissional_superior         NUMBER(10),
    quantidade_ticket_area_profissional_tecnico_medio    NUMBER(10),
    quantidade_ticket_area_profissional_especial_basica  NUMBER(10),
    status                                               NUMBER(1),
    reposicao                                            NUMBER(1),
    data_criacao                                         TIMESTAMP NOT NULL,
    data_alteracao                                       TIMESTAMP NOT NULL,
    criado_por                                           VARCHAR2(255 CHAR),
    modificado_por                                       VARCHAR2(255 CHAR),
    deletado                                             NUMBER(1) DEFAULT 0
);
COMMENT ON COLUMN tickets.distribuir_ticket_local_contrato IS
    'NÃO - (DEFAULT)
SIM';
COMMENT ON COLUMN tickets.distribuir_ticket_curso_capacitacao IS
    'NÃO - (DEFAULT)
SIM';
COMMENT ON COLUMN tickets.distribuir_ticket_nivel_ensino IS
    'NÃO - (DEFAULT)
SIM';
COMMENT ON COLUMN tickets.distribuir_ticket_area_profissional IS
    'NÃO - (DEFAULT)
SIM';
COMMENT ON COLUMN tickets.status IS
    '0-Aberto - Quando não esta vinculado a uma vaga ou contrato (TCA/TCE)
1-Vinculado - Quando está vinculado a uma vaga ou contrato (TCA/TCE)
2-Cancelado - Quando ocorre uma redução do número de tickets';
COMMENT ON COLUMN tickets.reposicao IS
    'NÃO - Quando não está em processo de reposição
SIM - Quando está em processo de reposição';
ALTER TABLE tickets ADD CONSTRAINT krs_indice_07600 PRIMARY KEY ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07601 FOREIGN KEY ( id_contr_emp_est )
        REFERENCES contratos_estudantes_empresa ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07602 FOREIGN KEY ( id_local_contrato )
        REFERENCES rep_locais_contrato ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07603 FOREIGN KEY ( id_contrato )
        REFERENCES rep_contratos ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07604 FOREIGN KEY ( id_vaga_estagio )
        REFERENCES vagas_estagio ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07605 FOREIGN KEY ( id_vaga_aprendiz )
        REFERENCES vagas_aprendiz ( id );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07606 FOREIGN KEY ( id_area_profissional )
        REFERENCES rep_areas_profissionais ( codigo_area_profissional );
ALTER TABLE tickets
    ADD CONSTRAINT krs_indice_07607 FOREIGN KEY ( id_curso_capacitacao )
        REFERENCES cursos_capacitacao ( id );

CREATE SEQUENCE SEQ_tickets MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
