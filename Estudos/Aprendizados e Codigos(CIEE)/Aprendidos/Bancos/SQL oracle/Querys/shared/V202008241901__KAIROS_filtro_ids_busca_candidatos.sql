create or replace procedure                   PROC_BUSCA_CANDIDATOS_ESPECIFICO(P_ID_CANDIDATO IDS_TYP,
                                                                               P_USUARIO number,
                                                                               P_LATITUDE NUMBER,
                                                                               P_LONGITUDE NUMBER,
                                                                               P_RESULTSET OUT SYS_REFCURSOR)
AS
    l_query      CLOB;
    v_referencia SDO_GEOMETRY;
begin

    if (P_LATITUDE is not null AND P_LONGITUDE is not null) then
        v_referencia := SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(P_LONGITUDE, P_LATITUDE, NULL), NULL, NULL);
    else
        v_referencia := null ;
    end if;


    l_query := l_query || '
    SELECT te.id_estudante,
           te.codigo_estudante                                                                                codigo_nome,
           estud.nome                                                                                         nome_estudante,
           estud.nome_social,
           te.data_nascimento,
           te.codigo_curso_principal,
           rc.descricao_curso,
           escol.id_escola,
           escol.nome_escola,
           te.duracao_curso,
           te.status_escolaridade,
           te.tipo_duracao_curso,
           te.tipo_periodo_curso,
           te.periodo_atual,
           escol.data_prevista_conclusao,
           escol.data_conclusao,
           te.nivel_ensino,
           ender.cidade,
           ender.uf,
           ender.cep,
           endes.bairro,
           endes.endereco,
           endes.complemento,
           endes.numero,
           te.data_alteracao,
           CASE
               WHEN te.pcds IS NULL OR te.pcds IS EMPTY THEN 0
               ELSE 1
           END                                                                                            pcd,
           (SELECT CAST(COLLECT(id_cid_agrupado) AS IDS_TYP)
            FROM TABLE (pcds))                                                                                ids_cid_agrupado,
           case when te.pcds is not null and te.pcds is not empty then
                (SELECT CAST(COLLECT(agrupamento) AS NAMELIST)
                 from TRIAGENS_ESTUDANTES TEE
                          cross join table(TEE.PCDS) p
                          INNER JOIN rep_agrupamento_cid_pcd acd
                                     ON acd.codigo_agrupamento = p.id_cid_agrupado
                    where TEE.ID_ESTUDANTE = TE.ID_ESTUDANTE)
            else namelist() end                                descricao_cid_pcd,
           SDO_GEOM.SDO_DISTANCE(:P_REFERENCIA, TE.ENDERECO, 0.005, ''unit=km'')                          DISTANCIA,
           NVL((SELECT 1 FROM FAVORITOS WHERE id_candidato = te.id_estudante AND id_usuario = :P_USUARIO), 0) favorito,
           te.possui_video,
           te.video_url,
           te.possui_redacao ';


    l_query := l_query || '
                from triagens_estudantes te
                     inner join rep_escolaridades_estudantes escol on te.id_estudante = escol.id_estudante
                     inner join rep_cursos rc on rc.codigo_curso = escol.id_curso
                     inner join rep_enderecos_estudantes endes on te.id_estudante = endes.id_estudante and endes.principal = 1
                     inner join rep_estudantes estud on estud.id = te.id_estudante
                     cross join table (te.enderecos) ender';


    l_query := l_query || '
           where
                escol.principal = 1 and escol.deletado = 0
                and ender.principal = 1
                    ';


    if (P_ID_CANDIDATO is not null) then
        l_query := l_query || '
                   and TE.ID_ESTUDANTE member of  :P_ID_CANDIDATO
                   ';
    else
        l_query := l_query || '
                   and (1 = 1  or  :P_ID_CANDIDATO is null )
                   ';
    end if;

    l_query := l_query || '
            OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY  ';

    dbms_output.put_line(l_query);

    OPEN P_RESULTSET
        FOR l_query
        USING
        V_REFERENCIA
        , P_USUARIO
        ,P_ID_CANDIDATO;

end;