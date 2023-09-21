--PK-13206 - Vincular Componentes Contrato Aprendiz a Municipio
CREATE TABLE componenetes_templates_municipios (
    id                     NUMBER(20) NOT NULL,
    id_template_municipio  NUMBER(20) NOT NULL,
    id_componente          NUMBER(20) NOT NULL,
    tipo_componente        NUMBER(1),
    data_criacao           TIMESTAMP NOT NULL,
    data_alteracao         TIMESTAMP NOT NULL,
    criado_por             VARCHAR2(255 CHAR),
    modificado_por         VARCHAR2(255 CHAR),
    deletado               NUMBER(1) DEFAULT 0
);
COMMENT ON COLUMN componenetes_templates_municipios.tipo_componente IS
    'ENUM:
0 - Cabecalho
1 - Dados da IE
2 - Dados da Empresa
3 - Dados de Estudante
4 - Dados da Unidade CIEE
5 - Corpo
6 - Rodape';
ALTER TABLE componenetes_templates_municipios ADD CONSTRAINT krs_indice_07422 PRIMARY KEY ( id );
CREATE TABLE templates_municipios (
    id              NUMBER(20) NOT NULL,
    id_municipio    NUMBER(19) NOT NULL,
    tipo_template   NUMBER(1) NOT NULL,
    data_criacao    TIMESTAMP NOT NULL,
    data_alteracao  TIMESTAMP NOT NULL,
    criado_por      VARCHAR2(255 CHAR),
    modificado_por  VARCHAR2(255 CHAR),
    deletado        NUMBER(1) DEFAULT 0
);
COMMENT ON COLUMN templates_municipios.tipo_template IS
    'ENUM:
0 - Estagio
1 - Aprendiz';
ALTER TABLE templates_municipios ADD CONSTRAINT krs_indice_07420 PRIMARY KEY ( id );
ALTER TABLE templates_municipios
    ADD CONSTRAINT krs_indice_07421 FOREIGN KEY ( id_municipio )
        REFERENCES rep_municipios ( codigo_municipio )
    NOT DEFERRABLE;
ALTER TABLE componenetes_templates_municipios
    ADD CONSTRAINT krs_indice_07423 FOREIGN KEY ( id_template_municipio )
        REFERENCES templates_municipios ( id )
    NOT DEFERRABLE;
CREATE SEQUENCE SEQ_componenetes_templates_municipios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
CREATE SEQUENCE SEQ_templates_municipios MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL;
ALTER TABLE templates_municipios ADD CONSTRAINT krs_indice_07448 UNIQUE ( id_municipio );