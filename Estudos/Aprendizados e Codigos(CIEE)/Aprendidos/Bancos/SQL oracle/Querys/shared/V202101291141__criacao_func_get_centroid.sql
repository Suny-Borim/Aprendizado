create or replace FUNCTION get_centroid(latitude FLOAT, longitude FLOAT, height FLOAT, width FLOAT) RETURN centroid_typ
    IS
    y_cen FLOAT;
    x_cen FLOAT;
BEGIN

    y_cen := latitude + (height / 2);
    x_cen := longitude + (width / 2);

    RETURN centroid_typ(x_cen, y_cen);

END;


