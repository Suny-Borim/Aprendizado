declare
  v_count INTEGER;
  PROCEDURE safe_create_type(typename IN varchar2, typedef IN VARCHAR2) IS
  BEGIN
    select count(1) into v_count from all_types where owner = '{{user}}' and type_name = typename;

    if (v_count < 1) THEN
        EXECUTE IMMEDIATE typedef;
    end if;    
  END safe_create_type;
BEGIN
    safe_create_type('GEOHASHS_TYP', 'CREATE TYPE {{user}}."GEOHASHS_TYP" AS TABLE OF VARCHAR2(20)');
    safe_create_type('IDS_TYP', 'CREATE TYPE {{user}}."IDS_TYP" AS TABLE OF NUMBER(20,0)');
    safe_create_type('IDIOMA_TYP', 'CREATE TYPE {{user}}."IDIOMA_TYP" AS OBJECT (
                                       "ID"        NUMBER(20,0),
                                       "NOME"      VARCHAR2(20 BYTE),
                                       "NIVEL"     NUMBER(2,0))');
    safe_create_type('QUALIFICACAO_TYP', 'CREATE TYPE {{user}}."QUALIFICACAO_TYP" AS OBJECT (
                                             "ID_QUALIFICACAO"         NUMBER(20,0),
                                             "RESULTADO"               NUMBER(1,0),
                                             "DATA_VALIDADE"           DATE)');
    safe_create_type('CONHECIMENTO_TYP', 'CREATE TYPE {{user}}."CONHECIMENTO_TYP" AS OBJECT (
                                             "DESCRICAO"               VARCHAR2(50 BYTE),
                                             "NIVEL"                   VARCHAR2(20 BYTE))');
    safe_create_type('VINCULO_TYP', 'CREATE TYPE {{user}}."VINCULO_TYP" AS OBJECT (
                                        "ID"                    NUMBER(20,0),
                                        "SITUACAO_VINCULO"      NUMBER(1))');
    safe_create_type('CONTRATO_EMP_TYP', 'CREATE TYPE {{user}}."CONTRATO_EMP_TYP" AS OBJECT (
                                             "ID_CONTR_EST_EMPR"    NUMBER(20,0),
                                             "ID_EMPRESA"           NUMBER(20,0),
                                             "SITUACAO"             NUMBER(1),
                                             "TIPO_CONTRATO"        VARCHAR2(1 CHAR))');
    safe_create_type('PCD_TYP', 'CREATE TYPE {{user}}."PCD_TYP" AS OBJECT (
                                    "ID_CID_AGRUPADO"         NUMBER(20,0),
                                    "VALIDADE_MINIMA_LAUDO"    TIMESTAMP(6))');
    safe_create_type('PCDS_TYP', 'CREATE TYPE {{user}}."PCDS_TYP" AS TABLE OF "PCD_TYP"');
    safe_create_type('IDIOMAS_TYP', 'CREATE TYPE {{user}}."IDIOMAS_TYP" AS TABLE OF "IDIOMA_TYP"');
    safe_create_type('QUALIFICACOES_TYP', 'CREATE TYPE {{user}}."QUALIFICACOES_TYP" AS TABLE OF "QUALIFICACAO_TYP"');
    safe_create_type('VINCULOS_TYP', 'CREATE TYPE {{user}}."VINCULOS_TYP" AS TABLE OF "VINCULO_TYP"');
    safe_create_type('CONHECIMENTOS_TYP', 'CREATE TYPE {{user}}."CONHECIMENTOS_TYP" AS TABLE OF "CONHECIMENTO_TYP"');
    safe_create_type('CONTRATOS_EMP_TYP', 'CREATE TYPE {{user}}."CONTRATOS_EMP_TYP" AS TABLE OF "CONTRATO_EMP_TYP"');
END;
/