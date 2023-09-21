--*****************************************************************************
--Tabela de vaga estagio sem campos de valor para tipo bolsa e tipo transporte*
--*****************************************************************************

ALTER TABLE {{user}}.VAGAS_ESTAGIO
    ADD (
        tipo_valor_auxilio_transporte NUMBER,
        tipo_valor_bolsa NUMBER
    );

COMMENT ON COLUMN {{user}}.VAGAS_ESTAGIO.tipo_valor_auxilio_transporte IS
    'Flag 0 ou 1

0 - Fixo
1 - A combinar';

COMMENT ON COLUMN {{user}}.VAGAS_ESTAGIO.tipo_valor_bolsa IS
    'Flag 0 ou 1

0 - Fixo
1 - A combinar';
