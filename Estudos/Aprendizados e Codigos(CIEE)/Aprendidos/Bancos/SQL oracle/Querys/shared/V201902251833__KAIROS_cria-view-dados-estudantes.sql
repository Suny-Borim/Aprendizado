--Cria view de dados de estudante

create or replace view v_dados_estudantes as
select a.id,
       a.nome,
       a.nome_social,
       b.rg,
       a.cpf,
       a.data_nascimento,
       a.sexo,
       c.endereco,
       c.numero,
       c.bairro,
       c.cidade,
       c.uf,
       c.cep,
       d.email,
       e.telefone,
       a.pcd,
       CASE WHEN a.pcd = 1 THEN f.nome_responsavel_legal else null END as contato_pcd

from rep_estudantes a left outer join rep_informacoes_brasileiros b on a.id_informacoes_brasileiros=b.id,
     rep_enderecos_estudantes c,
     rep_emails d,
     rep_telefones e,
     rep_responsaveis f

where a.id=c.id_estudante and
      (a.id=d.id_estudante and d.principal=1) and
      (a.id=e.id_estudante and e.principal=1) and
      (a.id_responsavel=f.id);
