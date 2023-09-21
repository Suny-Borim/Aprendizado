UPDATE REP_PARAMETROS_ESCOLARES SET DESC_PARAMETRO_ESCOLAR = 'Assinatura Professor Orientador',
                                    MSG_BACKOFFICE='IE solicita que o Professor Orientador assine o Contrato: @SimouNão@',
                                    MSG_EMPRESA='IE solicita que o Professor Orientador assine o Contrato: @SimouNão@',
                                    MSG_ESTUDANTE='IE solicita que o Professor Orientador assine o Contrato: @SimouNão@'
WHERE COD_PARAMETRO_ESCOLAR = 18;



UPDATE REP_PARAMETROS_EMPRESA SET   MSG_BACKOFFICE='Empresa assinou a normativa 7789.2014 (Segurança do Trabalho) @SimouNão@',
                                    MSG_EMPRESA='Empresa assinou a normativa 7789.2014 (Segurança do Trabalho) @SimouNão@',
                                    MSG_ESTUDANTE='Empresa assinou a normativa 7789.2014 (Segurança do Trabalho) @SimouNão@'
WHERE ID = 17;