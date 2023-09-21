create or replace PROCEDURE                   GRAVAR_FILA_TRIAGEM_ESTUDANTE(id_est IN NUMBER)
IS
    testa_acao number := 0;
BEGIN
    --EXECUTE IMMEDIATE 'INSERT  /*+ APPEND */ INTO SERVICE_VAGAS_DEV.FILA_TRIAGEM_ESTUDANTE(ID_ESTUDANTE) VALUES(:1)' USING id_estudante;
    --COMMIT WORK WRITE WAIT IMMEDIATE;
    --EXCEPTION WHEN OTHERS THEN NULL;
    
    -- Testo se o cadastro existe na triagens_estudantes
    begin
        execute immediate 'select id_estudante from service_vagas_dev.triagens_estudantes where id_estudante = :1' into testa_acao using id_est;
        exception when others then null;
    end;
    
    dbms_output.put_line(testa_acao);

    if (testa_acao = 0) then 
        -- acao inclusao
        execute immediate 'INSERT  /*+ APPEND */ INTO SERVICE_VAGAS_DEV.FILA_TRIAGEM_ESTUDANTE(ID_ESTUDANTE,ACAO) VALUES(:1,:2)' using id_est,'I';
    else
        -- acao alteracao
        execute immediate 'INSERT  /*+ APPEND */ INTO SERVICE_VAGAS_DEV.FILA_TRIAGEM_ESTUDANTE(ID_ESTUDANTE,ACAO) VALUES(:1,:2)' using id_est,'A';
    end if;

    commit work write wait immediate;
    exception when others then null;
END;