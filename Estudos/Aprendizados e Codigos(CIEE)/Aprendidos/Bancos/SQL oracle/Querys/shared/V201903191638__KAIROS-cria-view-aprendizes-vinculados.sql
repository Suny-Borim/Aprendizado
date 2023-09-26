--Cria view de vagas aprendiz com estudantes vinculados

CREATE OR REPLACE VIEW
    V_APRENDIZES_VINCULADOS
AS
SELECT
    VAGAS_APRENDIZ.id, VAGAS_APRENDIZ.id_local_contrato, VAGAS_APRENDIZ.codigo_da_vaga, VAGAS_APRENDIZ.DATA_CRIACAO,
    SITUACOES.descricao AS SITUACAO, SITUACOES.sigla AS SIGLA_SITUACAO,
    AREAS_ATUACAO_APRENDIZ.descricao_area_atuacao,
    COUNT(VINCULOS_VAGA.id) AS CANDIDATOS_VINCULADOS
FROM VAGAS_APRENDIZ
    JOIN SITUACOES ON VAGAS_APRENDIZ.ID_SITUACAO_VAGA = SITUACOES.id
    JOIN AREAS_ATUACAO_APRENDIZ ON VAGAS_APRENDIZ.id_area_atuacao_aprendiz = AREAS_ATUACAO_APRENDIZ.id
    LEFT JOIN VINCULOS_VAGA on VAGAS_APRENDIZ.CODIGO_DA_VAGA = VINCULOS_VAGA.CODIGO_VAGA
    GROUP BY
        VAGAS_APRENDIZ.id, VAGAS_APRENDIZ.id_local_contrato, VAGAS_APRENDIZ.codigo_da_vaga, VAGAS_APRENDIZ.DATA_CRIACAO,
        SITUACOES.descricao, SITUACOES.sigla,
        AREAS_ATUACAO_APRENDIZ.descricao_area_atuacao
