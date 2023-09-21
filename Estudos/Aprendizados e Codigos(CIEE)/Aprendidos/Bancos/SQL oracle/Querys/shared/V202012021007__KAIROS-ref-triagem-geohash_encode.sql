create or replace FUNCTION                   "GEOHASH_ENCODE"
(
    latitude in number,
    longitude in number,
    precision in number:=5
)
    RETURN VARCHAR2
AS
    even    boolean := true;
    bit     number  := 0;
    ch      number  := 0;
    mid     number  := 0.0;
    geohash varchar2(20)  := '';

    TYPE varchar2_table IS TABLE OF VARCHAR2(12);
    Base32 varchar2_table;

    TYPE number_table IS TABLE OF NUMBER;
    lat number_table;
    lon number_table;
    Bits number_table;

    FUNCTION bitor( x IN NUMBER, y IN NUMBER ) RETURN NUMBER  AS
    BEGIN
        RETURN x + y - bitand(x,y);
    END;

BEGIN
    lat     := number_table(-90.0, 90.0);
    lon     := number_table(-180.0, 180.0);
    Bits    := number_table(16, 8, 4, 2, 1);
    Base32  := varchar2_table('0','1','2','3','4','5','6','7','8','9','b','c','d','e','f','g','h','j','k','m','n','p','q','r','s','t','u','v','w','x','y','z');

    while (nvl(length(geohash),0) < precision) loop
            if (even) then
                mid := (lon(0+1) + lon(1+1)) / 2;
                if (longitude > mid) then
                    ch := bitor(ch, Bits(bit+1));
                    lon(0+1) := mid;
                else
                    lon(1+1) := mid;
                end if;
            else
                mid := (lat(0+1) + lat(1+1)) / 2;
                if (latitude > mid) then
                    ch := bitor(ch, Bits(bit+1));
                    lat(0+1) := mid;
                else
                    lat(1+1) := mid;
                end if;
            end if;

            even:=not even;

            if (bit<4) then
                bit:=bit+1;
            else
                geohash:=geohash||Base32(ch+1);
                bit:=0;
                ch:=0;
            end if;

        end loop;

    RETURN geohash;
END GEOHASH_ENCODE;