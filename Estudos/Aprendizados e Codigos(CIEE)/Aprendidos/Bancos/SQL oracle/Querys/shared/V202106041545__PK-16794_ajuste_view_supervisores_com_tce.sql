  CREATE OR REPLACE VIEW V_SUPERVISORES_COM_TCES AS 
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
        LEFT JOIN contratos_estudantes_empresa cee ON cee.id_supervisor = s.id and cee.situacao not in(1,2)
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

