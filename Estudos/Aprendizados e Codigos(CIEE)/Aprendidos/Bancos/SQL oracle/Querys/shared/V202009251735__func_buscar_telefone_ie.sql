create or replace function buscar_telefone_ie(p_id_ie number) return varchar2
as
    telefone varchar2(20);
begin
    select telefone
    into telefone
    from (
             SELECT distinct t.TELEFONE,
                             CONT.ID_INSTITUICAO_ENSINO,
                             0 prioridade
             FROM REP_CONTATO_IE_TIPO_PROCESSO CONT
                      INNER JOIN REP_PESSOAS_TELEFONES PET ON PET.ID_PESSOA = CONT.ID_PESSOA
                      INNER JOIN REP_TELEFONES T ON T.ID = PET.ID_TELEFONE
             where CONT.DIRECTOR = 1
               and ACTIVE = 1
             union all
             select distinct concat(concat(concat('(', RTE.DDD), ') '), RTE.NUMERO),
                             REP_INSTITUICOES_ENSINOS.id,
                             1 prioridade
             from REP_INSTITUICOES_ENSINOS
                      inner join REP_IES_TELEFONES RIT on REP_INSTITUICOES_ENSINOS.ID = RIT.ID_IE
                      inner join REP_TELEFONES_ESCOLA RTE on RIT.ID_TELEFONE = RTE.ID
         )
    where ID_INSTITUICAO_ENSINO = p_id_ie
    order by prioridade
        OFFSET 0 ROWS
    FETCH NEXT 1 ROWS ONLY;

    return telefone;
end;