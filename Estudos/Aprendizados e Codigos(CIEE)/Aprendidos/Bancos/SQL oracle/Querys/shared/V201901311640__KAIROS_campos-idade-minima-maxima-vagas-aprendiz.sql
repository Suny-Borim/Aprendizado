--
--Campos de idade para vaga aprendiz
--


ALTER TABLE {{user}}.VAGAS_APRENDIZ
    ADD (
        idade_minima NUMBER(2),
        idade_maxima NUMBER(2)
    );
