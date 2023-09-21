create or replace view V_SUPERVISORES_COM_TCES
as
SELECT
    s.id,
    s.id_contrato,
    s.id_conselho_classe,
    s.cpf,
    s.nome,
    s.ddd_fone,
    s.fone,
    s.email,
    s.cargo,
    s.formacao,
    s.ativo,
    COUNT(*) AS total_tce
FROM
    supervisores s
    JOIN contratos_estudantes_empresa cee ON s.id = cee.id_supervisor
GROUP BY
    s.id,
    s.id_contrato,
    s.id_conselho_classe,
    s.cpf,
    s.nome,
    s.ddd_fone,
    s.fone,
    s.email,
    s.cargo,
    s.formacao,
    s.ativo;