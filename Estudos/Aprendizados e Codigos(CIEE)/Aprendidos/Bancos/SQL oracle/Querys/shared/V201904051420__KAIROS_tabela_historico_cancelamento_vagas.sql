CREATE TABLE historico_cancelamento_vaga
(
    id                            NUMBER(20) NOT NULL,
    id_vinculo_vaga               NUMBER(20) NOT NULL,
    codigo_vaga                   NUMBER(20),
    tipo_vaga                     VARCHAR2(1),
    numero_posicoes_vagas         NUMBER(5),
    numero_contratacoes_vagas     NUMBER(5),
    numero_posicoes_nao_atendidas NUMBER(5),
    deletado                      NUMBER(1),
    data_criacao                  TIMESTAMP,
    data_alteracao                TIMESTAMP,
    criado_por                    VARCHAR2(255),
    modificado_por                VARCHAR2(255)
);

COMMENT ON COLUMN historico_cancelamento_vaga.tipo_vaga IS
    '- Esse campo determina se a vaga é de estagio ou de aprendiz

Enum:

 A - Aprendiz
 E  - Estagio';

ALTER TABLE historico_cancelamento_vaga
    ADD CONSTRAINT krs_indice_02355 PRIMARY KEY (id);

ALTER TABLE historico_cancelamento_vaga
    ADD CONSTRAINT krs_indice_02363 FOREIGN KEY (id_vinculo_vaga) REFERENCES vinculos_vaga (id);