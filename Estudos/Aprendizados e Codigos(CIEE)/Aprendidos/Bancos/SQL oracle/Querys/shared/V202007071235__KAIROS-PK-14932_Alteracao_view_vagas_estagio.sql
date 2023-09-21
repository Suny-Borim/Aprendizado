--*************************************************************************
--PK-14932 - Alteração da view de consulta de vagas estágio para trazer Logradouro e número do endereço
--*************************************************************************

CREATE OR REPLACE FORCE VIEW V_VAGAS_ESTAGIO AS
SELECT
    v.ID,
    CASE WHEN (V.EMPRESA_COM_ACESSIBILIDADE = 0) THEN 'NORMAL' ELSE 'PCD' END AS TIPO,
    v.codigo_da_vaga,
    v.data_criacao,
    s.id as ID_SITUACAO,
    s.sigla,
    s.DESCRICAO,
    RAP.CODIGO_AREA_PROFISSIONAL,
    RAP.DESCRICAO_AREA_PROFISSIONAL,
    RLC.ID as ID_LOCAL_CONTRATO,
    RLE.ID as ID_LOCAL_ENDERECO,
    RE.iD as ID_ENDERECO,
    RE.TIPO_LOGRADOURO || ' ' || RE.ENDERECO || ', ' || RE.NUMERO || ' - ' || RE.BAIRRO || ' - ' || RE.CIDADE || ', ' || RE.UF || ' - ' || (regexp_replace(RE.CEP, '([[:digit:]]{5})([[:digit:]]{3})', '\1-\2')) as ENDERECO,
    v.IDADE_MINIMA,
    v.IDADE_MAXIMA
FROM
    VAGAS_ESTAGIO v
    JOIN situacoes s ON v.id_situacao_vaga = s.id
    JOIN REP_LOCAIS_CONTRATO RLC ON V.ID_LOCAL_CONTRATO = RLC.ID
    JOIN REP_LOCAIS_ENDERECOS RLE ON RLC.ID = RLE.ID_LOCAL_CONTRATO
    JOIN REP_ENDERECOS RE ON RLE.ID_ENDERECO = RE.ID
    JOIN REP_AREAS_PROFISSIONAIS RAP  ON RAP.CODIGO_AREA_PROFISSIONAL = V.CODIGO_AREA_PROFISSIONAL;