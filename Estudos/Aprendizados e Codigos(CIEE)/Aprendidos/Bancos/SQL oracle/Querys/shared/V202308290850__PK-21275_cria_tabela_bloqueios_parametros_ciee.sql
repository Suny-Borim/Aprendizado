DECLARE
    tabela_existente   NUMBER := 0;
    sequence_existente NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO tabela_existente
    FROM
        all_tables
    WHERE
        upper(table_name) = 'BLOQUEIOS_PARAMETROS_CIEE';

    IF tabela_existente <= 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE BLOQUEIOS_PARAMETROS_CIEE (
            ID			            NUMBER(20,0)            NOT NULL,
            TIPO			        NUMBER(1,0)            	NOT NULL,
            TIPO_PROGRAMA_APRENDIZ  NUMBER(1,0),
            TIPO_FLUXO              NUMBER(1,0)             NOT NULL,
            VALIDA_IE		        NUMBER(1,0)            	NOT NULL,
            VALIDA_EMPRESA		    NUMBER(1,0)            	NOT NULL,
            VALIDA_ESTUDANTE	    NUMBER(1,0)            	NOT NULL,
            CRIADO_POR		        VARCHAR2(255 CHAR)   	NOT NULL,
            DATA_CRIACAO	        TIMESTAMP            	NOT NULL,
            MODIFICADO_POR		    VARCHAR2(255 CHAR)   	NOT NULL,
            DATA_ALTERACAO		    TIMESTAMP            	NOT NULL,
            DELETADO		        NUMBER(1)            	NOT NULL,
            MENSAGEM                VARCHAR2(255 CHAR)      NOT NULL,
            NIVEIS_ENSINO		    CLOB,
            CURSOS			        CLOB,
            MUNICIPIOS		        CLOB,
            UNIDADES_CIEE		    CLOB,
            FAIXA_ETARIA            CLOB)';
        EXECUTE IMMEDIATE 'ALTER TABLE BLOQUEIOS_PARAMETROS_CIEE ADD CONSTRAINT KRS_INDICE_12478 PRIMARY KEY ( ID )';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN BLOQUEIOS_PARAMETROS_CIEE.TIPO IS ''Enum: 0 - ESTAGIO; 1 - APRENDIZ;''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN BLOQUEIOS_PARAMETROS_CIEE.TIPO_PROGRAMA_APRENDIZ IS ''Enum: 0 - Capacitador; 1 - Empregador;''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN BLOQUEIOS_PARAMETROS_CIEE.TIPO_FLUXO IS ''Enum: 0 - Contratação; 1 - Vagas;''';
    END IF;

    SELECT
        COUNT(*)
    INTO sequence_existente
    FROM
        all_sequences
    WHERE
        upper(sequence_name) = 'SEQ_BLOQUEIOS_PARAMETROS_CIEE';

    IF ( sequence_existente <= 0 ) THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_BLOQUEIOS_PARAMETROS_CIEE MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE'
        ;
    END IF;
END;
