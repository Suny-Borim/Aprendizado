Insert into conhecimentos (ID,CONHECIMENTO) 
select SEQ_CONHECIMENTOS.nextval,'APRESENTACAO' from dual
where not exists (select id from conhecimentos where CONHECIMENTO = 'APRESENTACAO');

Insert into conhecimentos (ID,CONHECIMENTO) 
select SEQ_CONHECIMENTOS.nextval,'PLANILHA' from dual
where not exists (select id from conhecimentos where CONHECIMENTO = 'PLANILHA');

Insert into conhecimentos (ID,CONHECIMENTO)
select SEQ_CONHECIMENTOS.nextval,'TEXTO' from dual
where not exists (select id from conhecimentos where CONHECIMENTO = 'TEXTO');