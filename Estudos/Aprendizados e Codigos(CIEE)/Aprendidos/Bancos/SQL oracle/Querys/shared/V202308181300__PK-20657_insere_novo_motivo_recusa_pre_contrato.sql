Insert into recusa (ID, DESCRICAO_MOTIVO, DESCRICAO_EXTERNA, ENVIA_COMUNICACAO, DISPONIVEL_ESTUDANTE, DISPONIVEL_EMPRESA, SITUACAO_MOTIVO, DELETADO, DATA_CRIACAO, DATA_ALTERACAO, CRIADO_POR, MODIFICADO_POR) 
select SEQ_recusa.nextval, 'contratação cancelada', 'contratação cancelada', 0, 0, 0, 1, 0, SYSDATE, SYSDATE, 'PK-20657', 'PK-20657'
 from dual
where not exists (select 1 from recusa  where DESCRICAO_MOTIVO = 'contratação cancelada');
