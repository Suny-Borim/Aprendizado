create or replace function service_vagas_dev.converte_id_lista(id_estudante number) return service_vagas_dev.IDS_TYP
as
    id_estudante_lista service_vagas_dev.IDS_TYP:=IDS_TYP();
begin
    id_estudante_lista.extend;
    id_estudante_lista(id_estudante_lista.count):=id_estudante;

    return id_estudante_lista;
end;