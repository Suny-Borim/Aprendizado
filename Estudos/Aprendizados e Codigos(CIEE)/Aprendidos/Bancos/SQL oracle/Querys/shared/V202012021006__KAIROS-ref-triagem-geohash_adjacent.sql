create or replace FUNCTION                   "GEOHASH_ADJACENT"
(
    geohash in varchar2,
    direction in varchar2
)
    RETURN
        VARCHAR2
AS
    --based on github.com/davetroy/geohash-js
    TYPE varchar2_table IS TABLE OF VARCHAR2(12);
    Base32 varchar2_table;

    v_neig varchar2(100);
    v_border varchar2(100);

    lastCh   varchar2(100);
    parentCh varchar2(100);
    typeCh number(2);
BEGIN

    if (geohash is null or length(geohash) = 0) then
        RETURN '';
    end if;

    if (instr('nsew', direction) = 0) THEN
        RETURN '';
    end if;

    typeCh    := MOD(length(geohash), 2);
    Base32    := varchar2_table('0','1','2','3','4','5','6','7','8','9','b','c','d','e','f','g','h','j','k','m','n','p','q','r','s','t','u','v','w','x','y','z');

    CASE
        WHEN direction = 'n' and typeCh = '0' THEN v_neig := 'p0r21436x8zb9dcf5h7kjnmqesgutwvy';
        WHEN direction = 'n' and typeCh = '1' THEN v_neig := 'bc01fg45238967deuvhjyznpkmstqrwx';
        WHEN direction = 's' and typeCh = '0' THEN v_neig := '14365h7k9dcfesgujnmqp0r2twvyx8zb';
        WHEN direction = 's' and typeCh = '1' THEN v_neig := '238967debc01fg45kmstqrwxuvhjyznp';
        WHEN direction = 'e' and typeCh = '0' THEN v_neig := 'bc01fg45238967deuvhjyznpkmstqrwx';
        WHEN direction = 'e' and typeCh = '1' THEN v_neig := 'p0r21436x8zb9dcf5h7kjnmqesgutwvy';
        WHEN direction = 'w' and typeCh = '0' THEN v_neig := '238967debc01fg45kmstqrwxuvhjyznp';
        WHEN direction = 'w' and typeCh = '1' THEN v_neig := '14365h7k9dcfesgujnmqp0r2twvyx8zb';
        END CASE;

    CASE
        WHEN direction = 'n' and typeCh = '0' THEN v_border := 'prxz';
        WHEN direction = 'n' and typeCh = '1' THEN v_border := 'bcfguvyz';
        WHEN direction = 's' and typeCh = '0' THEN v_border := '028b';
        WHEN direction = 's' and typeCh = '1' THEN v_border := '0145hjnp';
        WHEN direction = 'e' and typeCh = '0' THEN v_border := 'bcfguvyz';
        WHEN direction = 'e' and typeCh = '1' THEN v_border := 'prxz';
        WHEN direction = 'w' and typeCh = '0' THEN v_border := '0145hjnp';
        WHEN direction = 'w' and typeCh = '1' THEN v_border := '028b';
        END CASE;

    lastCh := Substr(geohash, -1, 1);                    -- last character of hash
    parentCh := SUBSTR(geohash, 1, length(geohash)-1);   -- hash without last character

    -- check for edge-cases which don't share common prefix
    if (instr(v_border, lastCh) != 0 and parentCh is not null) then
        parentCh := SERVICE_VAGAS_DEV."GEOHASH_ADJACENT"(parentCh, direction);
    end if;

    --append letter for direction to parent
    return parentCh || Base32(instr(v_neig,lastCh));
END;