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
    safe_create_type('CANDIDATO_CAPACITACAO_TYP', 'CREATE TYPE {{user}}."CANDIDATO_CAPACITACAO_TYP" AS OBJECT (
                                       "LATITUDE1"        NUMBER(20,0),
                                       "LONGITUDE1"        NUMBER(20,0),
                                       "LATITUDE2"        NUMBER(20,0),
                                       "LONGITUDE2"        NUMBER(20,0),
                                       "LATITUDE3"        NUMBER(20,0),
                                       "LONGITUDE3"        NUMBER(20,0))');
END;
/