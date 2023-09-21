--
--Ajusta tamanho das colunas de descrição nas tabelas de vagas
--


ALTER TABLE vagas_aprendiz MODIFY (
    descricao                  VARCHAR2(150),
    descricao_empresa          VARCHAR2(150)
);


ALTER TABLE vagas_estagio MODIFY (
    descricao                  VARCHAR2(150),
    descricao_empresa          VARCHAR2(150)
);
