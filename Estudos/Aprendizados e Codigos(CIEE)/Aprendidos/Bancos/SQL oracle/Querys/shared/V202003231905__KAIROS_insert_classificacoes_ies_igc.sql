begin

    insert into CLASSIFICACOES_IES_IGC(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, DESCRICAO, PONTO_DE, PONTO_ATE)
    values(SEQ_CLASSIFICACOES_IES_IGC.nextval,current_timestamp,current_timestamp,'teste','teste',0,'A',4,5);

    insert into CLASSIFICACOES_IES_IGC(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, DESCRICAO, PONTO_DE, PONTO_ATE)
    values(SEQ_CLASSIFICACOES_IES_IGC.nextval,current_timestamp,current_timestamp,'teste','teste',0,'B',3,3);

    insert into CLASSIFICACOES_IES_IGC(ID, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR, DELETADO, DESCRICAO, PONTO_DE, PONTO_ATE)
    values(SEQ_CLASSIFICACOES_IES_IGC.nextval,current_timestamp,current_timestamp,'teste','teste',0,'C',1,2);

end;