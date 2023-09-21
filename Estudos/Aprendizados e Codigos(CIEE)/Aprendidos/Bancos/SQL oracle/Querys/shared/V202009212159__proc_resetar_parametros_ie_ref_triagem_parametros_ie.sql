create or replace procedure proc_resetar_parametros_ie(V_IDS_ESTUDANTES IN IDS_TYP DEFAULT NULL)
as
begin
    update TRIAGENS_ESTUDANTES
    set EXISTE_PAR_ESCOLA        = null,
        PAR_AREAS_ATUACAO        = null,
        PAR_SEMESTRE_INICIO      = null,
        PAR_SEMESTRE_FIM         = null,
        PAR_SEMESTRE_MAXIMO      = null,
        PAR_CARGA_HORARIA_DIARIA = null,
        PAR_NIVEL_NAO_PERMITIDO  = null
    where ID_ESTUDANTE member of V_IDS_ESTUDANTES;

    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_lista_carga_horaria_diaria(V_IDS_ESTUDANTES);
    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_lista_permissao_estagio(V_IDS_ESTUDANTES);
    SERVICE_VAGAS_DEV.proc_atualizar_triagem_estudante_lista_area_atuacao(V_IDS_ESTUDANTES);

end;