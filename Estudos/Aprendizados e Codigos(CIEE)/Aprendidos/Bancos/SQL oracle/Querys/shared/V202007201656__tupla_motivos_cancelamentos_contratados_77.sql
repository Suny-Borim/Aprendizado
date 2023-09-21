declare
    v_existe number default 0;
    v_codigo number default 77;
begin
    select count(1) into v_existe from MOTIVOS_CANCELAMENTOS_CONTRATADOS where CODIGO = v_codigo;

    if (v_existe = 1) then
        update MOTIVOS_CANCELAMENTOS_CONTRATADOS
        set TIPO_CONTRATO = 0,
            PERFIL_ACESSO = 2,
            ACESSO_CIEE = 2,
            SITUACAO = 1,
            DELETADO = 0
        where CODIGO = v_codigo;
    else
        INSERT INTO motivos_cancelamentos_contratados (ID,
                                                       CODIGO,
                                                       DESCRICAO,
                                                       DATA_CRIACAO,
                                                       DATA_ALTERACAO,
                                                       CRIADO_POR,
                                                       MODIFICADO_POR,
                                                       TIPO_CONTRATO,
                                                       PERFIL_ACESSO,
                                                       ACESSO_CIEE,
                                                       SITUACAO,
                                                       DELETADO
        )
        VALUES (SEQ_MOTIVOS_CANCELAMENTOS_CONTRATADOS.nextval,
                v_codigo,
                ' Cancelamento de Contrato',
                current_timestamp,
                current_timestamp,
                'script',
                'script',
                0,
                2,
                2,
                1,
                0);
    end if;
end;