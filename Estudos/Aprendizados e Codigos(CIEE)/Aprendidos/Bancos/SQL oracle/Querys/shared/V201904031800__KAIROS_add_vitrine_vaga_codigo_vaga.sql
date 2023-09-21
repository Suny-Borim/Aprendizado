ALTER TABLE VITRINE_VAGAS ADD CODIGO_VAGA NUMBER(20) NULL;

comment on column VITRINE_VAGAS.SITUACAO is 'Flag:

 0 - Expirada
 1 - Publicada
 2 - Não Publicada
 3 - Não Disponivel'
;