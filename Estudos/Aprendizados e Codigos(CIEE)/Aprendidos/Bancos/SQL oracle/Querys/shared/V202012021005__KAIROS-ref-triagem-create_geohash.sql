create or replace FUNCTION create_geohash(latitude FLOAT, longitude FLOAT, radius INT, precision INT) RETURN geohash_t
    IS

    x FLOAT := 0.0 ;
    y FLOAT := 0.0 ;

    TYPE points_t  IS TABLE OF FLOAT;
    points points_t := points_t();

    TYPE geohashes IS TABLE OF VARCHAR(10);

    TYPE grid_width_t IS TABLE OF FLOAT;
    grid_width grid_width_t := grid_width_t(5009400.0, 1252300.0, 156500.0, 39100.0, 4900.0, 1200.0, 152.9, 38.2, 4.8, 1.2, 0.149, 0.0370);

    TYPE grid_height_t IS TABLE OF FLOAT;
    grid_height grid_height_t := grid_height_t(4992600.0, 624100.0, 156000.0, 19500.0, 4900.0, 609.4, 152.4, 19.0, 4.8, 0.595, 0.149, 0.0199);

    height FLOAT;
    width FLOAT;

    lat_moves INT;
    lon_moves INT;

    lat_lon  lat_lon_typ;

    temp_lat FLOAT;
    temp_lon FLOAT;

    c centroid_typ;

    geohash geohash_t := geohash_t();

BEGIN

    x := 0.0;
    y := 0.0;

    height := (grid_height(precision)) / 2;
    width  := (grid_width (precision)) / 2;

    lat_moves := (CEIL(radius / height)); --#4 TO INT()
    lon_moves := (CEIL(radius / width)); --#2  TO INT()

    FOR i IN 0..lat_moves
        LOOP

            DBMS_OUTPUT.put_line('i => ' || i);

            temp_lat := y + height * i;

            FOR j IN 0..lon_moves
                LOOP

                    DBMS_OUTPUT.put_line('j => ' || j);

                    temp_lon := x + width*j;

                    IF in_circle_check(temp_lat, temp_lon, y, x, radius) = 1 THEN

                        c := get_centroid(temp_lat, temp_lon, height, width);

                        lat_lon := convert_to_latlon(c.y_cen , c.x_cen, latitude, longitude);
                        points.EXTEND;
                        points(points.LAST) := lat_lon.x_cen;
                        points.EXTEND;
                        points(points.LAST) := lat_lon.y_cen;

                        lat_lon := convert_to_latlon(-c.y_cen, c.x_cen, latitude, longitude);
                        points.EXTEND;
                        points(points.LAST) := lat_lon.x_cen;
                        points.EXTEND;
                        points(points.LAST) := lat_lon.y_cen;

                        lat_lon := convert_to_latlon(c.y_cen , -c.x_cen, latitude, longitude);
                        points.EXTEND;
                        points(points.LAST) := lat_lon.x_cen;
                        points.EXTEND;
                        points(points.LAST) := lat_lon.y_cen;

                        lat_lon := convert_to_latlon(-c.y_cen, -c.x_cen, latitude, longitude);
                        points.EXTEND;
                        points(points.LAST) := lat_lon.x_cen;
                        points.EXTEND;
                        points(points.LAST) := lat_lon.y_cen;

                    END IF;

                END LOOP;

        END LOOP;

    FOR i in points.FIRST..(points.LAST)
        LOOP
            IF MOD(i, 2) = 0 THEN
                geohash.EXTEND;
                geohash(geohash.LAST) := geohash_encode(points(i-1), points(i), precision);
            END IF;
        END LOOP;

    --geohash := SET(geohash); -- retorno

    RETURN geohash;

END;
