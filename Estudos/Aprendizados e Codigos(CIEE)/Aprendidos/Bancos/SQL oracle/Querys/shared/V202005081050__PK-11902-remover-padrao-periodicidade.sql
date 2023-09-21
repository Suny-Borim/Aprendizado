--- Remover PADRAO das respostas e trocar por SEMESTRAL
update PARAMETROS_EMPRESA_CONTRATO
set respostas = REPLACE(respostas, 'PADRAO', 'SEMESTRAL')
where respostas like '%PADRAO%';