--Ajusta dados que são usados na view

CREATE TABLE REP_INFORMACOES_NACIONALIDADE
(
    ID NUMBER NOT NULL DISABLE,
    CODIGO_NACIONALIDADE NUMBER NOT NULL DISABLE,
    BRASILEIRO NUMBER NOT NULL DISABLE,
    INFORMACOES_BRASILEIROS_ID NUMBER,
    INFORMACOES_ESTRANGEIROS_ID NUMBER,
    DATA_CRIACAO TIMESTAMP (6) NOT NULL ENABLE,
    DATA_ALTERACAO TIMESTAMP (6) NOT NULL ENABLE,
    CRIADO_POR VARCHAR2(255 BYTE),
    MODIFICADO_POR VARCHAR2(255 BYTE),
    DELETADO NUMBER(1,0)
);

ALTER TABLE REP_INFORMACOES_NACIONALIDADE ADD CONSTRAINT KRS_INDICE_01863 PRIMARY KEY (ID);


ALTER TABLE REP_ESTUDANTES DROP COLUMN ID_INFORMACOES_BRASILEIROS;

ALTER TABLE REP_ESTUDANTES ADD ID_NACIONALIDADE NUMBER(20);

ALTER TABLE REP_INFORMACOES_BRASILEIROS MODIFY ID NUMBER(20);

ALTER TABLE rep_estudantes ADD CONSTRAINT krs_indice_01865 FOREIGN KEY ( id_nacionalidade ) REFERENCES rep_informacoes_nacionalidade ( id ) NOT DEFERRABLE;

ALTER TABLE rep_informacoes_nacionalidade ADD CONSTRAINT krs_indice_01868 FOREIGN KEY ( informacoes_brasileiros_id ) REFERENCES rep_informacoes_brasileiros ( id ) NOT DEFERRABLE;


CREATE OR REPLACE VIEW V_DADOS_ESTUDANTES AS
  SELECT a.id,
    a.nome,
    a.nome_social,
    h.rg,
    a.cpf,
    a.data_nascimento,
    a.sexo,
    c.endereco,
    c.numero,
    c.bairro,
    c.cidade,
    c.uf,
    c.cep,
    a.pcd,
    CASE WHEN a.pcd = 1 THEN f.nome_responsavel_legal ELSE null END AS contato_pcd

FROM rep_estudantes a
    JOIN rep_enderecos_estudantes c ON c.id_estudante = a.id
    LEFT JOIN rep_responsaveis f ON f.id = a.id_responsavel
    LEFT JOIN rep_informacoes_nacionalidade g ON g.id = a.id_nacionalidade
    LEFT JOIN rep_informacoes_brasileiros h ON h.id = g.informacoes_brasileiros_id

WHERE a.id=c.id_estudante and c.principal=1;


CREATE INDEX {{user}}.KRS_INDICE_01870 ON {{user}}.rep_campus_cursos_periodos(id_campus_curso);
CREATE INDEX {{user}}.KRS_INDICE_01871 ON {{user}}.rep_campus_cursos(id_curso);
CREATE INDEX {{user}}.KRS_INDICE_01872 ON {{user}}.rep_campus_cursos(id_campus);
