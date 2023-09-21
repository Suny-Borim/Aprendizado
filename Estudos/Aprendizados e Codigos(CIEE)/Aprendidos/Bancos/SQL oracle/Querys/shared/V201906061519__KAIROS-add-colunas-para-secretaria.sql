ALTER TABLE duracoes_capacitacao ADD carga_horaria_basica NUMBER(20) DEFAULT 0 NOT NULL;
ALTER TABLE duracoes_capacitacao ADD carga_horaria_especifica NUMBER(20) DEFAULT 0 NOT NULL;
ALTER TABLE duracoes_capacitacao ADD carga_horaria_pratica NUMBER(20) DEFAULT 0 NOT NULL;

ALTER TABLE duracoes_capacitacao ADD id_secretaria NUMBER(20);
ALTER TABLE salas_capacitacao ADD id_secretaria NUMBER(20);
ALTER TABLE locais_capacitacao ADD id_secretaria NUMBER(20);
ALTER TABLE REP_UNIDADES_CIEE ADD id_secretaria NUMBER(20);
