--**************************************************
--Criação da tabela de situações para vaga aprendiz*
--**************************************************

CREATE TABLE situacoes_aprendiz (
    id               NUMBER(20) NOT NULL,
    sigla            VARCHAR2(1) NOT NULL,
    descricao        VARCHAR2(40) NOT NULL,
    deletado         NUMBER(1),
    data_criacao     TIMESTAMP NOT NULL,
    data_alteracao   TIMESTAMP NOT NULL,
    criado_por       VARCHAR2(255),
    modificado_por   VARCHAR2(255)
);

COMMENT ON COLUMN situacoes_aprendiz.sigla IS
    '- A operação usa sigla que são letras, a intenção aqui é facilitar para o usuario final.
- Ex.:
ID-SIGLA-DESCRICAO
1     A        Aberta
2     B         Bloqueada
3     C        Cancelada
4     E         Processo Seletivo Empresa
5     I          Visita do Assistente
6     K        Marcação de Contrato
7     P        Preenchida
8     S        Processo Seletivo CIEE'
    ;

COMMENT ON COLUMN situacoes_aprendiz.descricao IS
    '- Descricao da situação da vaga';

ALTER TABLE situacoes_aprendiz ADD CONSTRAINT krs_indice_01319 PRIMARY KEY ( id );

--*********************************************************************
--Cria sequence para ser utilizada na tabela de situacao vaga aprendiz*
--*********************************************************************

CREATE SEQUENCE seq_situacoes_aprendiz MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 ORDER NOCYCLE;
