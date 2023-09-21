-- Adicionando coluna pcd em view V_FOLLOWUP_EMPRESA
CREATE OR REPLACE VIEW V_FOLLOWUP_EMPRESA as
    (
        SELECT
            RLC.ID_CONTRATO AS ID_CONTRATO,
            cee.id_local_contrato AS ID_LOCAL_CONTRATO,
            cee.codigo_estudante AS CODIGO_ESTUDANTE,
            cee.nome_estudante AS NOME_ESTUDANTE,
            cee.cpf_estudante AS CPF_ESTUDANTE,
            cee.id AS ID_CONTRATO_ESTUDANTE,
            RU.id  as ID_AGENTE,
            ru.nome AS NOME_AGENTE,
            cee.data_criacao AS DATA_CRIACAO,
            cee.id_estudante AS ID_ESTUDANTE,
            CEE.TIPO_CONTRATO AS TIPO_CONTRATO,
            cee.data_inicio_estagio AS DATA_INICIO_ESTAGIO,
            cee.data_final_estagio AS DATA_FINAL_ESTAGIO,
            ccc.data_inicio AS DATA_INICIO_APRENDIZ,
            cee.data_final_aprendiz AS DATA_FINAL_APRENDIZ,
            cee.pcd as PCD
        FROM acompanhamentos_contratados AC
                 INNER JOIN contratos_estudantes_empresa CEE ON CEE.ID = ac.id_contr_emp_est
                 LEFT JOIN contratos_cursos_capacitacao CCC ON CEE.ID = CCC.id_contr_emp_est
                 INNER JOIN rep_locais_contrato RLC ON RLC.ID = CEE.id_local_contrato
                 INNER JOIN rep_usuarios RU ON ru.id = ac.id_usuario
        GROUP BY
            RLC.ID_CONTRATO,
            cee.id_local_contrato,
            cee.codigo_estudante,
            cee.nome_estudante,
            cee.cpf_estudante,
            cee.id,
            RU.id,
            ru.nome,
            cee.data_criacao,
            cee.id_estudante,
            CEE.TIPO_CONTRATO,
            cee.data_inicio_estagio,
            cee.data_final_estagio,
            ccc.data_inicio,
            cee.data_final_aprendiz,
            cee.pcd
    );