DECLARE
    coluna_existente NUMBER := 0;
    coluna_existente_2 NUMBER := 0;
    tabela_existente                               NUMBER := 0;
BEGIN
    SELECT
        COUNT(*)
    INTO coluna_existente
    FROM
        all_tab_columns
    WHERE
            upper(column_name) = 'ID_FORM_EST_AGRUPAMENTOS'
        AND upper(table_name) = 'FORMULARIOS_ESTUDANTES';
        
    SELECT
        COUNT(*)
    INTO coluna_existente_2
    FROM
        all_tab_columns
    WHERE
            upper(column_name) = 'PESSOA_RESPONSAVEL'
        AND upper(table_name) = 'FORMULARIOS_ESTUDANTES';

    SELECT
        COUNT(*)
    INTO tabela_existente
    FROM
        all_tables
    WHERE
        upper(table_name) = 'FORM_EST_AGRUPAMENTOS';

    IF ( tabela_existente = 0 ) THEN
        EXECUTE IMMEDIATE 'CREATE TABLE FORM_EST_AGRUPAMENTOS (
                            ID NUMBER(20,0)     NOT NULL,
                            DESCRICAO VARCHAR2(255 CHAR) NOT NULL,
                            CRIADO_POR		    VARCHAR2(255 CHAR) NOT NULL,
                            DATA_CRIACAO		TIMESTAMP NOT NULL,
                            MODIFICADO_POR		VARCHAR2(255 CHAR),
                            DATA_ALTERACAO		TIMESTAMP,
                            DELETADO		    NUMBER(1) NOT NULL
        )';
        EXECUTE IMMEDIATE 'ALTER TABLE FORM_EST_AGRUPAMENTOS ADD CONSTRAINT KRS_INDICE_12109 PRIMARY KEY ( ID )';
        EXECUTE IMMEDIATE 'CREATE SEQUENCE SEQ_FORM_EST_AGRUPAMENTOS MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';
    END IF;

    IF ( coluna_existente = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE FORMULARIOS_ESTUDANTES ADD (ID_FORM_EST_AGRUPAMENTOS NUMBER(20,0) NULL)';
        EXECUTE IMMEDIATE 'ALTER TABLE FORMULARIOS_ESTUDANTES ADD CONSTRAINT KRS_INDICE_12108 FOREIGN KEY ( ID_FORM_EST_AGRUPAMENTOS ) REFERENCES FORM_EST_AGRUPAMENTOS( ID ) NOT DEFERRABLE';
    END IF;
    
    IF ( coluna_existente_2 = 0 ) THEN
        EXECUTE IMMEDIATE 'ALTER TABLE FORMULARIOS_ESTUDANTES ADD (PESSOA_RESPONSAVEL NUMBER(1,0) NULL)';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN FORMULARIOS_ESTUDANTES.PESSOA_RESPONSAVEL IS ''Enum: 0 - APRENDIZ; 1 - INSTRUTOR; 2 - MONITOR; ''' ;
    END IF;
END;

