/*
 ##### PK-15614: Implementar - Jovem Talento em Triagem
 ########## PK-16064: Atualizar procedures de triagens
 ############### Campo de UTILIZACAO_DA_AREA  é necessário para triagem
 */

ALTER TABLE REP_AREAS_PROFISSIONAIS
    ADD UTILIZACAO_DA_AREA NUMBER(1) DEFAULT 0 NOT NULL;

COMMENT ON COLUMN REP_AREAS_PROFISSIONAIS.UTILIZACAO_DA_AREA is 'Enum:
0 - Estágio
1 - Uso interno
2 - Jovem talento';
