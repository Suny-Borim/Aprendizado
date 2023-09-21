
CREATE OR REPLACE FORCE EDITIONABLE VIEW "SERVICE_VAGAS_DEV"."V_SUPERVISORES_COM_TCES" ("ID", "ID_CONTRATO", "ID_CONSELHO_CLASSE", "CPF", "NOME", "DDD_FONE", "FONE", "EMAIL", "CARGO", "FORMACAO", "ATIVO", "TEMPO_EXPERIENCIA", "CODIGO_CONSELHO_CLASSE", "REGISTRO_FUNCIONAL", "TOTAL_TCE") AS 
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
    s.tempo_experiencia,
    s.codigo_conselho_classe,
    s.registro_funcional,
    COUNT(cee.id) AS total_tce
FROM
    supervisores s
        LEFT JOIN contratos_estudantes_empresa cee ON cee.id_supervisor = s.id
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
    s.ativo,
    s.tempo_experiencia,
    s.codigo_conselho_classe,
    s.registro_funcional;
