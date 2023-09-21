declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_ESTUDANTES_PCD_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_ESTUDANTES_PCD_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_VIDEO_APRESENTACAO_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_VIDEO_APRESENTACAO_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_ESCOLA_NAO_IDENTIFICADA_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_ESCOLA_NAO_IDENTIFICADA_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_ESCOLARIDADES_ESTUDANTES_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_ESCOLARIDADES_ESTUDANTES_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_IDIOMAS_NIVEIS_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_IDIOMAS_NIVEIS_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_LAUDOS_MEDICOS_DOCUMENTOS_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_LAUDOS_MEDICOS_DOCUMENTOS_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_PROVAS_ONLINE_CURRICULOS_EST_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_PROVAS_ONLINE_CURRICULOS_EST_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_CONHECIMENTOS_INFORMATICA_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_CONHECIMENTOS_INFORMATICA_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_CONHECIMENTOS_DIVERSOS_STUDENT_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_CONHECIMENTOS_DIVERSOS_STUDENT_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_EMAILS_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_EMAILS_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REDACAO_ESTUDANTE_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REDACAO_ESTUDANTE_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_VIDEOS_CURRICULOS_ESTUDANTES_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_VIDEOS_CURRICULOS_ESTUDANTES_INSERT_UPDATE';
    end if;

end;
/

declare
    l_count integer;
begin

    select count(*)
    into l_count
    from ALL_TRIGGERS
    where trigger_name = 'TRIGGER_REP_TELEFONES_INSERT_UPDATE';

    if l_count > 0 then
        execute immediate 'drop trigger TRIGGER_REP_TELEFONES_INSERT_UPDATE';
    end if;

end;