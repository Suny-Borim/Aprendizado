create or replace FUNCTION                   distance (Lat1 IN NUMBER,
                          Lon1 IN NUMBER,
                          Lat2 IN NUMBER,
                          Lon2 IN NUMBER,
                          Radius IN NUMBER DEFAULT 3963) RETURN NUMBER DETERMINISTIC IS
    -- Convert degrees to radians
    DegToRad NUMBER := 57.29577951;

BEGIN
    if(lat2 is null or Lon2 is null)then
        return 0;
    end if;

    RETURN (NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) +
                                 (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) *
                                  COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad)))) ;
    exception 
      WHEN others then
        return null;
END;