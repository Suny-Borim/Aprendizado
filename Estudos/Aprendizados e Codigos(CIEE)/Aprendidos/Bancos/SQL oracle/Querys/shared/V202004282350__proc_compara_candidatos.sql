create or replace PROCEDURE      SERVICE_VAGAS_DEV.PROC_COMPARA_CANDIDATOS (
    P_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL ,
    P_LONGITUDE NUMBER ,
    P_LATITUDE NUMBER ,
    P_RESULTSET OUT SYS_REFCURSOR
)
AS
    l_query  CLOB;
BEGIN

    l_query := l_query || '
SELECT substr(te.nome, 1, 1) || te.codigo_estudante         CODIGO_NOME,
       TE.ID_ESTUDANTE ID_ESTUDANTE,
       te.DATA_NASCIMENTO                                   DATA_NASCIMENTO,
       SDO_GEOM.SDO_DISTANCE((SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE((:P_LONGITUDE), (:P_LATITUDE), NULL), NULL, NULL)),
                             TE.ENDERECO, 0.005, ''unit=km'') DISTANCIA_APROXIMADA,

       TE.POSSUI_VIDEO                                      VIDEO_PUBLICADO,
       TE.POSSUI_REDACAO                                    POSSUI_REDACAO,
       (
           select count(distinct EA.id)
           from ESTUDANTES_AGENDA EA
                    inner join VINCULOS_VAGA VV on VV.ID = EA.ID_VINCULO_VAGA
           WHERE VV.ID_ESTUDANTE = TE.ID_ESTUDANTE
       )                                                    QTD_ENTREVISTAS_CHAMADAS,
       (
           select count(distinct EA.id)
           from ESTUDANTES_AGENDA EA
                    inner join VINCULOS_VAGA VV on VV.ID = EA.ID_VINCULO_VAGA
           WHERE VV.ID_ESTUDANTE = TE.ID_ESTUDANTE
             and EA.TIPO_CONFIRMACAO = 0
             and EA.DATA_CONFIRMACAO is not null
       )                                                    QTD_ENTREVISTAS_PARTICIPADAS,
       case
           when exists(
                   select *
                   from CONTRATOS_ESTUDANTES_EMPRESA CCE
                   where CCE.ID_ESTUDANTE = TE.ID_ESTUDANTE
                     and CCE.TIPO_CONTRATO = ''E''
                       offset 0 rows
                   fetch next 1 rows only
               ) then 1
           else 0 end                                       ESTAGIOU,
       case
           when exists(
                   select *
                   from CONTRATOS_ESTUDANTES_EMPRESA CCE
                   where CCE.ID_ESTUDANTE = TE.ID_ESTUDANTE
                     and CCE.TIPO_CONTRATO = ''A''
                       offset 0 rows
                   fetch next 1 rows only
               ) then 1
           else 0 end                                       FOI_APRENDIZ,
       -- verificar local para essa consulta
       0                                                    QTD_CURSOS_EAD,
       -- replicar ENEM_ESTUDANTES
       case
           when
               exists(
                       select 1 from DUAL
                   --                 select * from REP_ENEM_ESTUDANTES_STUDENTS ENEM
--                 WHERE ENEM.ID_ESTUDANTE = TE.ID_ESTUDANTE
--                     offset 0 rows
--                 fetch next 1 rows only
                   ) then 1
           else 0 end                                       RESULTADO_ENEM,
       case
           when
               exists(
                       select *
                       from REP_CONHECIMENTOS_INFORMATICA INFO
                       where INFO.ID_ESTUDANTE = TE.ID_ESTUDANTE
                           offset 0 rows
                       fetch next 1 rows only
                   )
               then 1
           else 0
           end                                              CONHECIMENTO_EXTRA,
       -- VERIFICAR NECESSIDADE DE CAMPO PARA IMPLEMENTACAO
       0                                                    QTD_TREINAMENTO,
       0                                                    VISUALIZACAO_CURRICULO,
       0                                                    CURRICULO_EXTRA,
       case
           when
               exists((select DATA_CONCLUSAO
                       from REP_ESCOLARIDADES_ESTUDANTES ESCO
                       where ESCO.ID_ESTUDANTE = TE.ID_ESTUDANTE and ESCO.PRINCIPAL = 1))
               then (select DATA_CONCLUSAO
                     from REP_ESCOLARIDADES_ESTUDANTES ESCO
                     where ESCO.ID_ESTUDANTE = TE.ID_ESTUDANTE and ESCO.PRINCIPAL = 1)
           when exists((select DATA_CONCLUSAO_CALCULADA
                        from REP_ESCOLARIDADES_ESTUDANTES ESCO
                        where ESCO.ID_ESTUDANTE = TE.ID_ESTUDANTE and ESCO.PRINCIPAL = 1))
               then (select DATA_CONCLUSAO_CALCULADA
                     from REP_ESCOLARIDADES_ESTUDANTES ESCO
                     where ESCO.ID_ESTUDANTE = TE.ID_ESTUDANTE and ESCO.PRINCIPAL = 1 )
           end                                              CONCLUSAO_CURSO,
       (select (
                   select count(INFO.ID)
                   from REP_CONHECIMENTOS_INFORMATICA INFO
                   where INFO.ID_ESTUDANTE = TE.ID_ESTUDANTE
                     and info.ID_DOCUMENTO is not null
               )
                   + (
                   select count(div.ID)
                   from REP_CONHECIMENTOS_DIVERSOS_STUDENT div
                   where div.ID_ESTUDANTE = TE.ID_ESTUDANTE
                     and div.ID_DOCUMENTO is not null
               )
                   +
               (
                   select count(idi.ID)
                   from REP_IDIOMAS_NIVEIS idi
                   where idi.ESTUDANTE_ID = TE.ID_ESTUDANTE
                     and idi.DOCUMENTO_ID is not null
               )
        from DUAL
       )
                                                            CONHECIMENTOS_GERAL,
       CASE
           WHEN
                       te.pcds IS NULL OR te.pcds IS EMPTY
               THEN 0
           ELSE 1
           END                                              PCD,

       (
--            select AVG(ENEM.PROVA_I, ENEM.PROVA_II, ENEM.PROVA_III, ENEM.PROVA_IV, ENEM.PROVA_V)
--            from ESTUDANTES_ENEM ENEM
--            WHERE ENEM.PARTICIPOU = 1
--              and ENEM.ID_ESTUDANTE = TE.ID_ESTUDANTE
--                offset 0 rows
--            fetch next 1 rows only
           5
           )                                                ENEM_MEDIA,
       (2020)                                               ENEM_ANO,
       te.VENCIMENTO_LAUDO                                  VALIDADE_LAUDO,
       case
           when
               EXISTS(
                       select dock.DOCUMENTO_ID from REP_LAUDOS_MEDICOS_DOCUMENTOS dock
                                                         inner join REP_LAUDOS_MEDICOS laudos on laudos.ID = dock.LAUDO_MEDICO_ID
                       where laudos.ESTUDANTE_ID = TE.ID_ESTUDANTE
                   ) THEN 1
           ELSE 0 END LAUDO_VALIDO,
       te.ELEGIVEL_PCD                                      VALIDO_COTA,
       te.USA_RECURSO_ACESSIBILIDADE ACESSIBILIDADE_LOCAL

from TRIAGENS_ESTUDANTES TE
WHERE TE.ID_ESTUDANTE MEMBER OF :P_IDS_ESTUDANTES
               ';


    dbms_output.put_line(l_query);

    OPEN P_RESULTSET
        FOR l_query
        USING
        P_LONGITUDE,
        P_LATITUDE,
        P_IDS_ESTUDANTES
        ;
END;
/