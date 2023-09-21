--
--Ajusta a view V_VAGAS_APRENDIZ alterando o mapeamento com Curso Capacitação, já que os Ids de Cursos em TURMAS são ids dos Programas na secretaria
--Ajuste para trazer somente informações das Turmas Regulares
--
 CREATE OR REPLACE VIEW V_VAGAS_APRENDIZ AS
    SELECT
    v.ID,
    CASE WHEN (NVL(V.EMPRESA_COM_ACESSIBILIDADE,0) = 0) THEN 'NORMAL' ELSE 'PCD' END AS TIPO,
    v.codigo_da_vaga,
    v.data_criacao,
    s.id as ID_SITUACAO,
    s.sigla,
    s.DESCRICAO,
    T.CARGA_HORARIA_DIARIA,
    TO_CHAR (T.CARGA_HORARIA_DIARIA, 'HH24:MI') as CARGA_HORARIA,
    cc.ID as ID_CURSO,
    cc.DESCRICAO as NOME_CURSO,
    RLC.ID as ID_LOCAL_CONTRATO,
    RLE.ID as ID_LOCAL_ENDERECO,
    RE.iD as ID_ENDERECO,
    RE.ENDERECO||' '||RE.BAIRRO||' '||RE.CIDADE||' '||RE.UF||' '||RE.CEP as ENDERECO,
    v.IDADE_MINIMA,
    v.IDADE_MAXIMA
FROM
    vagas_aprendiz v
    JOIN situacoes s ON v.id_situacao_vaga = s.id
    JOIN REP_LOCAIS_CONTRATO RLC ON V.ID_LOCAL_CONTRATO = RLC.ID
    JOIN REP_LOCAIS_ENDERECOS RLE ON RLC.ID = RLE.ID_LOCAL_CONTRATO
    JOIN REP_ENDERECOS RE ON RLE.ID_ENDERECO = RE.ID
    JOIN TURMAS T ON t.id_vaga_aprendiz = v.ID
    JOIN CURSOS_CAPACITACAO CC ON v.id_curso_capacitacao = CC.ID
WHERE
    CC.SITUACAO = 1 AND T.TURMA = 0;