
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."V_DESTAQUES_AREAS_PROFISSIONAIS" ("ID", "ID_AREA_PROFISSIONAL", "DESCRICAO_AREA_PROFISSIONAL", "ID_EMPRESA", "UF", "CIDADE", "ID_NIVEL_EDUCACIONAL", "ORDEM", "SITUACAO") AS 
  (
    SELECT CONCAT(ID_AREA_PROFISSIONAL, 1) AS ID,
    
           ID_AREA_PROFISSIONAL,
           DESCRICAO_AREA_PROFISSIONAL,
           ID_EMPRESA,
           UF,
           CIDADE,
           ID_NIVEL_EDUCACIONAL,
           1                               AS ORDEM,
           NULL                        AS SITUACAO
           
    FROM DESTAQUES_AREAS_PROF_TCE_EMP
    UNION ALL
    SELECT CONCAT(ID_AREA_PROFISSIONAL, 2) AS ID,
           
           ID_AREA_PROFISSIONAL,
           DESCRICAO_AREA_PROFISSIONAL,
           NULL                            AS ID_EMPRESA,
           UF,
           CIDADE,
           ID_NIVEL_EDUCACIONAL,
           2                               AS ORDEM,
           NULL                        AS SITUACAO
           
    FROM DESTAQUES_AREAS_PROF_TCE
    UNION ALL
    SELECT CONCAT(CODIGO_AREA_PROFISSIONAL, 3) AS ID,
           
           CODIGO_AREA_PROFISSIONAL,
           DESCRICAO_AREA_PROFISSIONAL,
           NULL                                AS ID_EMPRESA,
           NULL                                AS UF,
           NULL                                AS CIDADE,
           ID_NIVEL_EDUCACIONAL,
           3                                       AS ORDEM,
           ATIVO                              AS SITUACAO
           
           FROM REP_AREAS_PROFISSIONAIS
);