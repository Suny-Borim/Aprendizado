ALTER TABLE areas_atuacao_aprendiz MODIFY (
    codigo_icone VARCHAR2(20)
);

ALTER TABLE pcd MODIFY (
    deletado NUMBER
);

ALTER TABLE rep_instituicoes_ensinos RENAME CONSTRAINT rep_instituicao_ensino_pk TO krs_indice_01222;

ALTER TABLE vagas_aprendiz MODIFY (
    id_situacao_vaga
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE tipo_presencial_docs MODIFY (
    documento
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE tipo_prova MODIFY (
    instrucoes_acesso
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE tipo_prova MODIFY (
    duracao_prova
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE tipo_upload_ext MODIFY (
    extensao
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE vagas_aprendiz MODIFY (
    id_local_contrato
        NOT NULL NOT DEFERRABLE ENABLE VALIDATE
);

ALTER TABLE vagas_aprendiz MODIFY (
    tipo_auxilio_transporte_valor NUMBER
); 

ALTER TABLE vagas_aprendiz MODIFY (
    reservista NUMBER
);

ALTER TABLE vagas_estagio MODIFY (
    tipo_auxilio_bolsa NUMBER
);

ALTER TABLE rep_locais_enderecos RENAME COLUMN id_unidade_ciee TO BKP_id_unidade_ciee;
ALTER TABLE rep_locais_enderecos ADD id_unidade_ciee NUMBER(20);
UPDATE rep_locais_enderecos SET id_unidade_ciee = BKP_id_unidade_ciee;
ALTER TABLE rep_locais_enderecos MODIFY (id_unidade_ciee NOT NULL NOT DEFERRABLE ENABLE VALIDATE);
ALTER TABLE rep_locais_enderecos DROP COLUMN BKP_id_unidade_ciee;

ALTER TABLE vagas_aprendiz RENAME COLUMN escolaridade TO BKP_escolaridade;
ALTER TABLE vagas_aprendiz ADD escolaridade number(1);
UPDATE vagas_aprendiz SET escolaridade = BKP_escolaridade;
ALTER TABLE vagas_aprendiz DROP COLUMN BKP_escolaridade;

ALTER TABLE vagas_aprendiz RENAME COLUMN situacao_escolaridade TO BKP_situacao_escolaridade;
ALTER TABLE vagas_aprendiz ADD situacao_escolaridade number(1);
UPDATE vagas_aprendiz SET situacao_escolaridade = BKP_situacao_escolaridade;
ALTER TABLE vagas_aprendiz DROP COLUMN BKP_situacao_escolaridade;

COMMENT ON COLUMN vagas_aprendiz.sexo IS
    'Pode ser preenchido:

Indiferente=I
Feminino   =F
Masculino =M';

COMMENT ON COLUMN vagas_aprendiz.reservista IS
    'Flag  0 ou 1';


COMMENT ON COLUMN vagas_estagio.tipo_divulgacao IS
    'Tipo de divulgação da vaga podendo ser:

Pública=0 
Confidencial=1
Restrita=2

OK';
COMMENT ON COLUMN vagas_estagio.nivel_estudante_vaga IS
    'Nivel de escolaridade para preenchimento da vaga: 
pode ser preenchida: 

Médio    =0
Técnico =1
Superior=2

OK';
COMMENT ON COLUMN vagas_estagio.tipo_horario_estagio IS
    'Tipo de horario de estagio, pode ser preenchido:

A combinar=0
Definido      =1

OK';
COMMENT ON COLUMN vagas_estagio.tipo_auxilio_bolsa IS
    'Tipo de Bolsa Auxilio pode ser preenchido:

Mensal         =0
Por Hora      =1

OK';

COMMENT ON COLUMN vagas_estagio.tipo_auxilio_transporte IS
    'Tipo de  Auxilio Transporte pode ser preenchido:

Mensal         =0
Por Hora      =1
Fixo              =2
A Combinar=3

OK';

COMMENT ON COLUMN vagas_estagio.faixa_etaria IS
    'Faixa Etária, campo normalizado preenchimento:

0-Indiferente
1-Menor de Idade
2-Maior de 18 anos
3-Especifico.

OK';

COMMENT ON COLUMN areas_atuacao_aprendiz.nivel_area_atuacao IS
    'Enum:

1 - ENSINO_MEDIO
2 - TECNICO
3 - FUNDAMENTAL
4 - NAO_INFORMADO';

COMMENT ON COLUMN estado_civil_vaga_estagio.estado_civil IS
    'Estado Civil, campo normalizado preenchimento:

1- SOLTEIRO;
2- CASADO;
3- SEPARADO;
4- DIVORCIADO;
5- VIUVO;';

COMMENT ON COLUMN vagas_aprendiz.tipo_salario_valor IS
    'Enum

0 - Fixo

1 - A combinar';

COMMENT ON COLUMN vagas_aprendiz.tipo_auxilio_transporte IS
    'Enum:

0 - Mensal

1 - Diario
';

COMMENT ON COLUMN vagas_aprendiz.tipo_auxilio_transporte_valor IS
    'Enum 

 0 - Fixo

 1 - A Combinar';