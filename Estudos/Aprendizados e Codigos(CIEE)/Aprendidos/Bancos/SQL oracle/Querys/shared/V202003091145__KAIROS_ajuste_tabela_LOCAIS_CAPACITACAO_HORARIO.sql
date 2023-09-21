--Alteração para manter o padrão CIEE
ALTER TABLE locais_capacitacao_horario RENAME TO locais_capacitacoes_horarios;
ALTER TABLE locais_capacitacoes_horarios RENAME COLUMN id_local_capacitacao_horario to id;