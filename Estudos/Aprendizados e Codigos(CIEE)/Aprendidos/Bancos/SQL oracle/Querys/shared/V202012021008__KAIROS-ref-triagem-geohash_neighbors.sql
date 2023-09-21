create or replace FUNCTION                   "GEOHASH_NEIGHBORS"
(
    geohash in varchar2
)
    RETURN
        SERVICE_VAGAS_DEV."GEOHASHS_TYP"
AS
    v_neighbors SERVICE_VAGAS_DEV."GEOHASHS_TYP";
BEGIN

    if geohash is not null and geohash <> '0000' then
        v_neighbors :=
                SERVICE_VAGAS_DEV."GEOHASHS_TYP"(
                    --Inclui o geohash atual
                        geohash,

                    --Inclui os 4 pontos
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'n'),
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 's'),
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'w'),
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'e'),

                    --Diagonal duperior
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'n'), 'w'),
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 'n'), 'e'),

                    --Diagonal inferior
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 's'), 'w'),
                        SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (SERVICE_VAGAS_DEV."GEOHASH_ADJACENT" (geohash, 's'), 'e')
                    );
    else
        v_neighbors := SERVICE_VAGAS_DEV."GEOHASHS_TYP"();
    end if;

    return v_neighbors;
END;