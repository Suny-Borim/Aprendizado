-- Rodar o bloco comentado abaixo como owner dos objetos ----- IMPORTANTE ----
-- SET DEFINE OFF;
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('TRIAGENS_ESTUDANTES','ENDERECO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('REP_ENDERECOS','GEO_POINT',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('TRIAGENS_VAGAS','CAPACITACAO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('LOCAIS_CAPACITACAO','GEO_POINT',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('TRIAGENS_VAGAS','ENDERECO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('REP_ENDERECOS_ESCOLAS','GEO_POINT',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('REP_ESCOLARIDADES_ESTUDANTES','GEO_POINT',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('TRIAGENS_ESTUDANTES','ENDERECO_CAMPUS',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
-- Insert into user_sdo_geom_metadata (TABLE_NAME,COLUMN_NAME,DIMINFO,SRID) values ('REP_ENDERECOS_ESTUDANTES','GEO_POINT',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
declare
    v_count INTEGER;
BEGIN

    select count(1) into v_count from all_tables where owner = '{{user}}' and table_name = 'TRIAGENS_ESTUDANTES';

    if (v_count < 1) THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {{user}}."TRIAGENS_ESTUDANTES"
                           (
                               "ID_ESTUDANTE"                 NUMBER(20,0),
                               "ENDERECO" 			           SDO_GEOMETRY,
                               "ENDERECO_GEOHASH"             VARCHAR2(20),
                               "ENDERECO_CAMPUS" 			   SDO_GEOMETRY,
                               "ENDERECO_CAMPUS_GEOHASH"      VARCHAR2(20),
                               "DATA_NASCIMENTO"              TIMESTAMP(6),
                               "ESTADO_CIVIL"                 NUMBER(1,0),
                               "SEXO"				           VARCHAR2(1 BYTE) NOT NULL,
                               "USA_RECURSOS_ACESSIBILIDADE"  NUMBER(1,0) NOT NULL,
                               "ELEGIVEL_PCD"                 NUMBER(1,0) NOT NULL,
                               "RESERVISTA"                   NUMBER(1,0) NOT NULL,
                               "FUMANTE"                      NUMBER(1,0) NOT NULL,
                               "CNH"                          NUMBER(1,0) NOT NULL,
                               "TIPO_DURACAO_CURSO"           VARCHAR2(20 BYTE),
                               "SEMESTRE"       	           NUMBER(4,0),
                               "DATA_CONCLUSAO_CURSO"         DATE,
                               "DURACAO_CURSO"                NUMBER(10,0),
                               "PERIODO_ATUAL"                NUMBER(2,0),
                               "TIPO_PERIODO_CURSO"           VARCHAR2(20 BYTE),
                               "MODALIDADE"	               VARCHAR2(1 BYTE),
                               "HORARIO_ENTRADA"              DATE,
                               "HORARIO_SAIDA"                DATE,
                               "ESCOLAS"			           {{user}}.IDS_TYP,
                               "CURSOS"			           {{user}}.IDS_TYP,
                               "VINCULOS"			           {{user}}.VINCULOS_TYP,
                               "IDIOMAS" 				       {{user}}.IDIOMAS_TYP,
                               "CONHECIMENTOS"		           {{user}}.CONHECIMENTOS_TYP,
                               "RECURSOS_ACESSIBILIDADE"      {{user}}.IDS_TYP,
                               "USA_RECURSO_ACESSIBILIDADE"   NUMBER(1,0),
                               "PCDS"					       {{user}}.PCDS_TYP,
                               "VENCIMENTO_LAUDO"	           TIMESTAMP(6),
                               "QUALIFICACAO_VULNERAVEL"      NUMBER(1,0) NOT NULL,
                               "TIPO_PROGRAMA"                NUMBER(1,0) NOT NULL,
                               "STATUS_ESCOLARIDADE"          NUMBER(1,0) NOT NULL,
                               "CURSO_EAD"                    NUMBER(1,0),
                               "QUALIFICACOES"			       {{user}}.QUALIFICACOES_TYP,
                               "NIVEL_ENSINO"                 VARCHAR2(2 CHAR),
                               "CONTRATOS_EMPRESA"            {{user}}.CONTRATOS_EMP_TYP,
                               "QTD_CONVOCACOES"              NUMBER(4,0) NOT NULL,
                               "DATA_ALTERACAO"               TIMESTAMP(6)
                           )
            nested table escolas store as n_escolas_estud,
                nested table CURSOS store as n_cursos_estud,
                nested table idiomas store as n_idiomas_estud,
                nested table CONHECIMENTOS store as n_conhecimentos_estud,
                nested table PCDS store as n_pcds_estud,
                nested table QUALIFICACOES store as n_qualificacoes_estud,
                nested table VINCULOS store as n_vinculos_estud,
                nested table RECURSOS_ACESSIBILIDADE store as n_recursos_estud,
                nested table CONTRATOS_EMPRESA store as n_contratos_estud_emp';


        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX {{user}}.PK_TRIAGENS_ESTUDANTES ON {{user}}.TRIAGENS_ESTUDANTES (ID_ESTUDANTE ASC)';

        EXECUTE IMMEDIATE 'ALTER TABLE {{user}}.TRIAGENS_ESTUDANTES
            ADD CONSTRAINT PK_TRIAGENS_ESTUDANTES PRIMARY KEY
                (
                 ID_ESTUDANTE
                    )
                USING INDEX PK_TRIAGENS_ESTUDANTES
                ENABLE';


        MDSYS.SDO_META.change_all_sdo_geom_metadata('{{user}}', 'TRIAGENS_ESTUDANTES','ENDERECO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
        MDSYS.SDO_META.change_all_sdo_geom_metadata('{{user}}', 'TRIAGENS_ESTUDANTES','ENDERECO_CAMPUS',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
        commit;


        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_endereco ON {{user}}.TRIAGENS_ESTUDANTES(ENDERECO) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_endereco_campus ON {{user}}.TRIAGENS_ESTUDANTES(ENDERECO_CAMPUS) INDEXTYPE IS MDSYS.SPATIAL_INDEX';

        EXECUTE IMMEDIATE 'create index idx_TRIAGENS_ESTUDANTES_ENDERECO_GEOHASH on {{user}}."TRIAGENS_ESTUDANTES"(ENDERECO_GEOHASH)';
        EXECUTE IMMEDIATE 'create index idx_TRIAGENS_ESTUDANTES_ENDERECO_CAMPUS_GEOHASH on {{user}}."TRIAGENS_ESTUDANTES"(ENDERECO_CAMPUS_GEOHASH)';

        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_escolas ON {{user}}.n_escolas_estud(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_cursos ON {{user}}.n_cursos_estud(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_idiomas ON {{user}}.n_idiomas_estud(nome, nivel)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_conhecimentos ON {{user}}.n_conhecimentos_estud(descricao, nivel)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_pcds ON {{user}}.n_pcds_estud(ID_CID_AGRUPADO, VALIDADE_MINIMA_LAUDO)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_qualificacoes ON {{user}}.n_qualificacoes_estud(ID_QUALIFICACAO, DATA_VALIDADE, RESULTADO)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_vinculos ON {{user}}.n_vinculos_estud(SITUACAO_VINCULO)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_recursos ON {{user}}.n_recursos_estud(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_estudante_contratos ON {{user}}.n_contratos_estud_emp(ID_EMPRESA, SITUACAO)';
    END IF;

    select count(1) into v_count from all_tables where owner = '{{user}}' and table_name = 'TRIAGENS_VAGAS';

    if (v_count < 1) THEN
        EXECUTE IMMEDIATE 'CREATE TABLE {{user}}."TRIAGENS_VAGAS"
                           (
                               "ID_UNIDADE_CIEE"               NUMBER(20,0) NOT NULL,
                               "ID_EMPRESA"                    NUMBER(20,0) NOT NULL,
                               "CODIGO_DA_VAGA"		        NUMBER(20,0) NOT NULL,
                               "NOME_RAZAO_EMPRESA"        VARCHAR2(150 CHAR),
                               "ID_LOCAL_CONTRATO"         NUMBER(20,0),
                               "DATA_ABERTURA"             TIMESTAMP(6),
                               "DESCRICAO_VAGA"            VARCHAR2(150 CHAR),
                               "SEMESTRE_INICIAL"	            NUMBER(4,0),
                               "SEMESTRE_FINAL"	            NUMBER(4,0),
                               "SEXO"				            VARCHAR2(1 BYTE) NOT NULL,
                               "RESERVISTA"			        NUMBER(1,0) NOT NULL,
                               "FUMANTE"				        NUMBER(1,0) NOT NULL,
                               "POSSUI_CNH"			        NUMBER(1,0) NOT NULL,
                               "EMPRESA_COM_ACESSIBILIDADE"	NUMBER(1,0) NOT NULL,
                               "VALIDO_COTA"			        NUMBER(1,0) NOT NULL,
                               "ESTADO_CIVIL"		            {{user}}.IDS_TYP,
                               "IDIOMAS" 				        {{user}}.IDIOMAS_TYP,
                               "ESCOLAS"			            {{user}}.IDS_TYP,
                               "PCDS"					        {{user}}.PCDS_TYP,
                               "POSSUI_PCD"                    NUMBER(1,0) NOT NULL,
                               "RECURSOS_ACESSIBILIDADE"       {{user}}.IDS_TYP,
                               "PRIORIZA_VULNERAVEL"           NUMBER(1,0),
                               "QUALIFICACOES"			        {{user}}.IDS_TYP,
                               "CONHECIMENTOS"		            {{user}}.CONHECIMENTOS_TYP,
                               "CURSOS"	    	            {{user}}.IDS_TYP,
                               "ENDERECO" 			            SDO_GEOMETRY,
                               "ENDERECO_GEOHASHS"             {{user}}.GEOHASHS_TYP,
                               "CAPACITACAO"                   SDO_GEOMETRY,
                               "CAPACITACAO_GEOHASHS"          {{user}}.GEOHASHS_TYP,
                               "TIPO_HORARIO_ESTAGIO"          NUMBER(1),
                               "HORARIO_ENTRADA"		        TIMESTAMP(6),
                               "HORARIO_SAIDA"		            TIMESTAMP(6),
                               "VALOR_RAIO"                    NUMBER(20),
                               "LOCALIZACAO"                   NUMBER(1),
                               "IDADE_MINIMA"                  NUMBER(3),
                               "IDADE_MAXIMA"                  NUMBER(3),
                               "SITUACAO_ESCOLARIDADE"         NUMBER(1),
                               "ESCOLARIDADE"                  NUMBER(1),
                               "DATA_CONCLUSAO"                DATE,
                               "TIPO_VAGA"                     VARCHAR2(1 CHAR),
                               "CODIGO_AREA_PROFISSIONAL"      NUMBER(20),
                               "VALOR_BOLSA_FIXO"              NUMBER(10,2),
                               "VALOR_BOLSA_DE"                NUMBER(10,2),
                               "VALOR_BOLSA_ATE"               NUMBER(10,2),
                               "VALOR_SALARIO"                 NUMBER(10,2),
                               "VALOR_SALARIO_DE"              NUMBER(10,2),
                               "VALOR_SALARIO_ATE"             NUMBER(10,2),
                               "ID_AREA_ATUACAO_APRENDIZ"      NUMBER(20),
                               "ID_SITUACAO_VAGA"              NUMBER(20),
                               "AREAS_ATUACAO_ESTAGIO"         {{user}}.IDS_TYP,
                               "CURSOS_CAPACITACAO"            {{user}}.IDS_TYP,
                               "QTD_CONVOCADOS"                NUMBER(20),
                               "POSSUI_OCORRENCIAS"            NUMBER(1),
                               "DATA_ALTERACAO"                TIMESTAMP(6)
                           )
            nested table ESTADO_CIVIL store as n_estadocivil_vagas,
            nested table IDIOMAS store as n_idiomas_vagas,
            nested table ESCOLAS store as n_escolas_vagas,
            nested table PCDS store as n_pcds_vagas,
            nested table RECURSOS_ACESSIBILIDADE store as n_acessibilidade_vagas,
            nested table QUALIFICACOES store as n_qualificacoes_vagas,
            nested table CONHECIMENTOS store as n_conhecimentos_vagas,
            nested table CURSOS store as n_cursos_vagas,
            nested table ENDERECO_GEOHASHS store as n_enderecogeohashs_vagas,
            nested table CAPACITACAO_GEOHASHS store as n_capacitacaogeohashs_vagas,
            nested table AREAS_ATUACAO_ESTAGIO store as n_areas_atuacao_estagio_vagas,
            nested table CURSOS_CAPACITACAO store as n_cursos_capacitacao_vagas';

        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX {{user}}.PK_TRIAGENS_VAGAS ON {{user}}.TRIAGENS_VAGAS (CODIGO_DA_VAGA ASC)';

        EXECUTE IMMEDIATE 'ALTER TABLE {{user}}.TRIAGENS_VAGAS
            ADD CONSTRAINT PK_TRIAGENS_VAGAS PRIMARY KEY
                (
                 CODIGO_DA_VAGA
                    )
                USING INDEX PK_TRIAGENS_VAGAS
                ENABLE';

        EXECUTE IMMEDIATE 'CREATE INDEX IDX_TRIAGENS_VAGAS_CODIGO_VAGA ON {{user}}.TRIAGENS_VAGAS (CODIGO_DA_VAGA ASC, TIPO_VAGA ASC)';


        MDSYS.SDO_META.change_all_sdo_geom_metadata('{{user}}', 'TRIAGENS_VAGAS','ENDERECO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
        MDSYS.SDO_META.change_all_sdo_geom_metadata('{{user}}', 'TRIAGENS_VAGAS','CAPACITACAO',MDSYS.SDO_DIM_ARRAY(MDSYS.SDO_DIM_ELEMENT('Longitude', -180, 180, 0.005), MDSYS.SDO_DIM_ELEMENT('Latitude', -90, 90, 0.005)),'8307');
        commit;

        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vaga_endereco ON {{user}}.TRIAGENS_VAGAS(ENDERECO) INDEXTYPE IS MDSYS.SPATIAL_INDEX';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vaga_endereco_cap ON {{user}}.TRIAGENS_VAGAS(CAPACITACAO) INDEXTYPE IS MDSYS.SPATIAL_INDEX';


        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_estado_civil ON {{user}}.n_estadocivil_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_idiomas ON {{user}}.n_idiomas_vagas(nome, nivel)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_escolas ON {{user}}.n_escolas_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_pcds ON {{user}}.n_pcds_vagas(ID_CID_AGRUPADO, VALIDADE_MINIMA_LAUDO)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_recursos ON {{user}}.n_acessibilidade_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_qualificacoes ON {{user}}.n_qualificacoes_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_conhecimentos ON {{user}}.n_conhecimentos_vagas(descricao, nivel)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_cursos ON {{user}}.n_cursos_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_enderecogeohashs ON {{user}}.n_enderecogeohashs_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_capacitacaogeohashs ON {{user}}.n_capacitacaogeohashs_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_areas_atuacao ON {{user}}.n_areas_atuacao_estagio_vagas(column_value)';
        EXECUTE IMMEDIATE 'CREATE INDEX idx_triagem_vagas_cursos_capacitacao ON {{user}}.n_cursos_capacitacao_vagas(column_value)';
    END IF;

end;
/
