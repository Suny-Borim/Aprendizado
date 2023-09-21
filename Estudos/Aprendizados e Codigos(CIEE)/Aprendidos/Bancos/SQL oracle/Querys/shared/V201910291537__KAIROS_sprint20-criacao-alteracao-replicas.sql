CREATE TABLE rep_dependentes_student (
                                         id                            NUMBER NOT NULL,
                                         id_estudante                  NUMBER(19) NOT NULL,
                                         tipo_dependente               NUMBER(19),
                                         nome                          VARCHAR2(200 BYTE) NOT NULL,
                                         data_nascimento               DATE NOT NULL,
                                         cpf                           VARCHAR2(11 BYTE),
                                         incluso_irpf                  NUMBER(1),
                                         pode_trabalhar                NUMBER(1),
                                         salario_familia               NUMBER(1),
                                         data_criacao                  TIMESTAMP NOT NULL,
                                         data_alteracao                TIMESTAMP NOT NULL,
                                         criado_por                    VARCHAR2(255 BYTE),
                                         modificado_por                VARCHAR2(255 BYTE),
                                         deletado                      NUMBER(1),
                                         pensao_alimenticia            NUMBER(1) DEFAULT 0 NOT NULL,
                                         tipo_pensao                   NUMBER(1) NOT NULL,
                                         valor_percentual              NUMBER(2),
                                         valor_fixo                    NUMBER(10, 2),
                                         id_agencia                    NUMBER(4) NOT NULL,
                                         id_banco                      NUMBER(20) NOT NULL,
                                         nome_responsavel_dependente   VARCHAR2(150 CHAR) NOT NULL,
                                         cpf_responsavel_dependente    VARCHAR2(11 CHAR) NOT NULL,
                                         tipo_conta                    NUMBER(1) NOT NULL,
                                         conta_corrente                NUMBER(15) NOT NULL,
                                         codigo_operacao               NUMBER(10)
);

COMMENT ON COLUMN rep_dependentes_student.pensao_alimenticia IS
    'ENUM:
0-Não (default)
1-Sim';

COMMENT ON COLUMN rep_dependentes_student.tipo_pensao IS
    'ENUM:
1-Percentual
2-Fixo';

COMMENT ON COLUMN rep_dependentes_student.tipo_conta IS
    'ENUM:
1-Conta Poupança
2-Conta corrente';

ALTER TABLE rep_dependentes_student ADD CONSTRAINT krs_indice_04880 PRIMARY KEY ( id );


-- Gerar Certificado da Apólice de Seguros do Estagiário

ALTER TABLE rep_contratos ADD id_apolices_ciee NUMBER;
ALTER TABLE rep_contratos ADD id_apolices_empresas NUMBER;

ALTER TABLE rep_contratos
    ADD CONSTRAINT krs_indice_04900 FOREIGN KEY ( id_apolices_ciee )
        REFERENCES rep_apolices_ciee ( id );

ALTER TABLE rep_contratos
    ADD CONSTRAINT krs_indice_04900v2 FOREIGN KEY ( id_apolices_empresas )
        REFERENCES rep_apolices_empresas ( id );


-- Alterar APOLICES, implementando SURCUSAL
ALTER TABLE rep_apolices_ciee ADD sucursal_seguradora VARCHAR2(6 CHAR);
ALTER TABLE REP_APOLICES_EMPRESAS ADD sucursal_seguradora VARCHAR2(6 CHAR);
