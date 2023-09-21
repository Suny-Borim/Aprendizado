create or replace TYPE {{user}}.CLASSIFICACAO_SCORE_TYP AS OBJECT
(
    "SIGLA"     	       VARCHAR2(15 CHAR),
    "PONTO_DE"  	       NUMBER(3),
    "PONTO_ATE" 	       NUMBER(3),
    "MODO_ORDENAR"         VARCHAR2(20 CHAR),
    "ATENDE_PRECONDICAO"   NUMBER(1)   --(1) Se atende a pré-condicao para a regra de scrore
);