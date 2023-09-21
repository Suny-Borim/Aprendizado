declare
    type_exists number(1,0) default 0;
begin
    SELECT count(1) into type_exists FROM ALL_TYPES WHERE UPPER(ALL_TYPES.TYPE_NAME) = 'CENTROID_TYP';

    if type_exists = 0 then
        execute immediate '
        create TYPE centroid_typ AS OBJECT
        (
            x_cen NUMBER,
            y_cen NUMBER
        )
        ';
    end if;
end;