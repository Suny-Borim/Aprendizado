CREATE OR REPLACE VIEW v_sintetico_raca_genero_curso AS
    SELECT
        cee.id,
        cee.id_estudante,
        cee.codigo_curso_estudante,
        cee.nome_curso_estudante,
        re.sexo,
        ria.id_etnia,
        cee.id_local_contrato,
        rlc.id_contrato,
        rlc.nome           AS nome_local_contrato,
        rlc.razao_social   AS razao_social_local_contrato,
        cee.tipo_contrato,
        rd.cidade,
        rd.uf,
        cee.data_final_aprendiz,
        cee.data_final_estagio,
        cee.data_rescisao,
        cee.situacao,
        cee.deletado,
        rlc.situacao       AS situacao_local_contrato,
        rlc.deletado       AS deletado_local_contrato
    FROM
        contratos_estudantes_empresa              cee
        INNER JOIN rep_locais_contrato            rlc ON  rlc.id = cee.id_local_contrato
        INNER JOIN rep_estudantes                 re  ON  re.id = cee.id_estudante
        LEFT  JOIN rep_informacoes_adicionais     ria ON  ria.id = re.id_informacoes_adicionais
        INNER JOIN rep_locais_enderecos           rle ON  (rle.id_local_contrato = rlc.id
                                                      AND rle.endereco_principal = 1 )
        INNER JOIN rep_enderecos                  rd  ON  rd.id = rle.id_endereco
    GROUP BY
        cee.id,
        cee.id_estudante,
        cee.codigo_curso_estudante,
        cee.nome_curso_estudante,
        re.sexo,
        ria.id_etnia,
        cee.id_local_contrato,
        rlc.id_contrato,
        rlc.nome,
        rlc.razao_social,
        cee.tipo_contrato,
        rd.cidade,
        rd.uf,
        cee.data_final_aprendiz,
        cee.data_final_estagio,
        cee.data_rescisao,
        cee.situacao,
        cee.deletado,
        rlc.situacao,
        rlc.deletado;