declare
    trig_exists integer;
begin
    select COUNT(*) into trig_exists from ALL_TRIGGERS where TRIGGER_NAME = 'TRIGGER_01_VINCULOS_VAGA_INSERT_UPDATE';
    if trig_exists = 1 then
        execute immediate 'DROP TRIGGER TRIGGER_01_VINCULOS_VAGA_INSERT_UPDATE';
    end if;
end;