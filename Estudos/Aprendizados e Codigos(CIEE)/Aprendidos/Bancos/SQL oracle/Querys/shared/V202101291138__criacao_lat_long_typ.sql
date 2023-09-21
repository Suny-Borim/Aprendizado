declare
    type_exists number(1,0) default 0;
begin
    SELECT count(1) into type_exists FROM ALL_TYPES WHERE UPPER(ALL_TYPES.TYPE_NAME) = 'LAT_LON_TYP';

    if type_exists = 0 then
        execute immediate '
        create TYPE lat_lon_typ AS OBJECT
        (
            x_cen FLOAT,
            y_cen FLOAT
        )
        ';
    end if;
end;

