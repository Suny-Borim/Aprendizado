create or replace FUNCTION distance (Lat1 IN NUMBER,
                          Lon1 IN NUMBER,
                          Lat2 IN NUMBER,
                          Lon2 IN NUMBER,
                          Radius IN NUMBER DEFAULT 3963) RETURN NUMBER DETERMINISTIC IS
    -- Convert degrees to radians
    DegToRad NUMBER := 57.29577951;

BEGIN
    RETURN (NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) +
                                 (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) *
                                  COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad)))) ;
END;