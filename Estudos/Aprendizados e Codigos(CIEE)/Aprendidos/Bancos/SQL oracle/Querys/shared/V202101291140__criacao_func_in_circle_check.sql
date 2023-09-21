create or replace FUNCTION in_circle_check(latitude NUMBER, longitude NUMBER, centre_lat NUMBER, centre_lon NUMBER,     radius INT) RETURN INT
    IS
    x_diff NUMBER;
    y_diff NUMBER;

BEGIN

    x_diff := longitude - centre_lon;
    y_diff := latitude - centre_lat;

    if (power(x_diff, 2) + power(y_diff, 2) <= power(radius, 2)) THEN
        return 1;
    ELSE
        return 0;
    END IF;

END;
/

