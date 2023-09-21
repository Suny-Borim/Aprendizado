--**************************************************************
--Adiciona campos de distancias as tabelas de abertura de vagas*
--**************************************************************

ALTER TABLE vagas_estagio
    ADD valor_raio NUMBER(3);

ALTER TABLE vagas_aprendiz
    ADD valor_raio NUMBER(3);

--**********************************************
--Remove campo de distancia da tabela de cursos*
--Ele pertence a abertura da vaga              *
--**********************************************
ALTER TABLE vagas_estagio
    DROP COLUMN tipo_distancia_raio;

