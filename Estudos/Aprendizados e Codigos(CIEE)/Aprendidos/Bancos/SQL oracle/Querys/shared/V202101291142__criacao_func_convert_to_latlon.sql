create or replace FUNCTION convert_to_latlon(y FLOAT, x FLOAT, latitude FLOAT, longitude FLOAT) RETURN lat_lon_typ
    IS

    pi        FLOAT;
    r_earth   FLOAT;
    final_lat FLOAT;
    final_lon FLOAT;
    lat_diff  FLOAT;
    lon_diff  FLOAT;

BEGIN

    pi := 3.14159265359;

    r_earth := 6371000;

    lat_diff := (y / r_earth) * (180 / pi);
    lon_diff := (x / r_earth) * (180 / pi) / cos(latitude * pi / 180);

    final_lat := latitude + lat_diff;
    final_lon := longitude + lon_diff;

    return lat_lon_typ(final_lat, final_lon);

END;

