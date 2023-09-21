--PK-10075 - Prorrogação Automática de Contratos de Estágio
alter table parametros_empresa_contrato drop column prorrogacao_automatica;
alter table parametros_empresa_contrato drop column prazo_antecipacao_prorrogacao;

alter table parametros_ie drop column prorrogacao_automatica;
alter table parametros_ie drop column prazo_antecipacao_prorrogacao;