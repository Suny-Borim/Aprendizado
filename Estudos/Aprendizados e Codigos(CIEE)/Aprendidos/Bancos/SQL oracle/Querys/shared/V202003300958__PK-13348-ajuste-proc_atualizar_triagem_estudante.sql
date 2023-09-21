create or replace PROCEDURE {{user}}.proc_atualizar_triagem_estudante
    (
    V_ID_ESTUDANTE IN NUMBER DEFAULT NULL
    )
AS
BEGIN
    IF (V_ID_ESTUDANTE IS NULL) THEN
        {{user}}.proc_atualizar_triagem_estudante_lista({{user}}.IDS_TYP(V_ID_ESTUDANTE));
    ELSE
        {{user}}.proc_atualizar_triagem_estudante_lista(NULL);
    END IF;
END;
/