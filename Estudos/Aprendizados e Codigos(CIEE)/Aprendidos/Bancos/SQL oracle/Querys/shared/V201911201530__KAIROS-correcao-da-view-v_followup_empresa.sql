CREATE OR REPLACE VIEW "SERVICE_VAGAS_DEV"."V_FOLLOWUP_EMPRESA" ("ID_CONTRATO", "ID_LOCAL_CONTRATO", "CODIGO_ESTUDANTE", "NOME_ESTUDANTE", "CPF_ESTUDANTE", "ID_CONTRATO_ESTUDANTE", "ID_AGENTE", "NOME_AGENTE", "DATA_CRIACAO", "ID_ESTUDANTE", "TIPO_CONTRATO", "DATA_INICIO_ESTAGIO", "DATA_FINAL_ESTAGIO", "DATA_INICIO_APRENDIZ", "DATA_FINAL_APRENDIZ", "PCD") AS 
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
            ac.data_criacao AS DATA_CRIACAO,
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
            and ac.DATA_CRIACAO in (select max(ac1.DATA_CRIACAO) from ACOMPANHAMENTOS_CONTRATADOS ac1
                                    where ac1.ID_CONTR_EMP_EST = cee.ID)
    );