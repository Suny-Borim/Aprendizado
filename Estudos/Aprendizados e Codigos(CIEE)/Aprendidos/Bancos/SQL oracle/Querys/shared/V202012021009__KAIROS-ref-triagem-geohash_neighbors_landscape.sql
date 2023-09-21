create or replace FUNCTION "GEOHASH_NEIGHBORS_LANDSCAPE"
(
    geohash in varchar2
)
    RETURN
        SERVICE_VAGAS_DEV."GEOHASHS_TYP"
AS
    v_landscape SERVICE_VAGAS_DEV."GEOHASHS_TYP";
BEGIN

    if geohash is not null and geohash <> '0000' then
        SELECT
            cast(collect(COLUMN_VALUE) as SERVICE_VAGAS_DEV."GEOHASHS_TYP")
        INTO
            v_landscape
        FROM
            (
                SELECT DISTINCT
                    column_value
                FROM
                    TABLE(
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'n'), 'n'))
                                                        MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'e'), 'e'), 'e'), 'n'), 'n'))
                                                    MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'w'), 'w'), 'w'), 'n'), 'n'))
                                                MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 's'), 's'))
                                            MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'e'), 'e'), 'e'), 's'), 's'))
                                        MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'w'), 'w'), 'w'), 's'), 's'))
                                    MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'e'), 'e'), 'e'))
                                MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'w'), 'w'), 'w'))
                            MULTISET UNION Distinct
                                                        GEOHASH_NEIGHBORS(geohash)
                        )
                order by column_value
            ) t;
    else
        v_landscape := SERVICE_VAGAS_DEV."GEOHASHS_TYP"();
    end if;

    return v_landscape;
END;