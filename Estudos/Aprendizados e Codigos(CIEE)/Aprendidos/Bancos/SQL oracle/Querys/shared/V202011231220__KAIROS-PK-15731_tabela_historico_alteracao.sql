-- SERVICE_VAGAS_DEV.CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO
CREATE TABLE "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO" (
	"ID" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_LOCAL_CONTRATO" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_ESTUDANTE" NUMBER(20, 0) NOT NULL ENABLE,
	"TIPO_CONTRATO" VARCHAR2(1),
	"ID_CURSO_CAPACITACAO" NUMBER(20, 0),
	"CARGA_HORARIA" TIMESTAMP (6),
	"FAIXA_ETARIA_INICIAL" NUMBER(2, 0),
	"FAIXA_ETARIA_FINAL" NUMBER(2, 0),
	"ID_AREA_PROFISSIONAL" NUMBER(20, 0),
	"PCD" NUMBER,
	"CPF_ESTUDANTE" VARCHAR2(11) NOT NULL ENABLE,
	"NOME_ESTUDANTE" VARCHAR2(255) NOT NULL ENABLE,
	"NOME_SOCIAL_ESTUDANTE" VARCHAR2(255),
	"NOME_MAE_ESTUDANTE" VARCHAR2(150),
	"EMAIL_ESTUDANTE" VARCHAR2(100) NOT NULL ENABLE,
	"TELEFONE_ESTUDANTE" VARCHAR2(60) NOT NULL ENABLE,
	"ENDERECO_ESTUDANTE" VARCHAR2(150) NOT NULL ENABLE,
	"NUMERO_END_ESTUDANTE" VARCHAR2(10) NOT NULL ENABLE,
	"COMPLEMENTO_END_ESTUDANTE" VARCHAR2(200),
	"BAIRRO_END_ESTUDANTE" VARCHAR2(100) NOT NULL ENABLE,
	"CEP_END_ESTUDANTE" VARCHAR2(8) NOT NULL ENABLE,
	"CIDADE_END_ESTUDANTE" VARCHAR2(100) NOT NULL ENABLE,
	"UF_END_ESTUDANTE" VARCHAR2(2) NOT NULL ENABLE,
	"CODIGO_CURSO_ESTUDANTE" NUMBER(20, 0),
	"NOME_CURSO_ESTUDANTE" VARCHAR2(200),
	"PERIODO_ATUAL" NUMBER(2, 0),
	"TIPO_DURACAO_CURSO" NUMBER(2, 0),
	"PERIODO_CURSO_ESTUDANTE" VARCHAR2(20),
	"PREVISAO_CONCL_CURSO_ESTUDANTE" TIMESTAMP (6),
	"ID_IE" NUMBER(20, 0),
	"NOME_IE" VARCHAR2(200),
	"ID_CAMPUS" NUMBER(20, 0),
	"NOME_CAMPUS" VARCHAR2(200),
	"ENDERECO_CAMPUS" VARCHAR2(150),
	"NUMERO_CAMPUS" VARCHAR2(10),
	"COMPLEMENTO_CAMPUS" VARCHAR2(50),
	"BAIRRO_CAMPUS" VARCHAR2(100),
	"CEP_CAMPUS" VARCHAR2(8),
	"CIDADE_CAMPUS" VARCHAR2(100),
	"UF_CAMPUS" VARCHAR2(2),
	"ID_EMPRESA" NUMBER(20, 0),
	"NOME_EMPRESA" VARCHAR2(150),
	"ENDERECO_EMPRESA" VARCHAR2(150),
	"NUMERO_EMPRESA" VARCHAR2(10),
	"COMPLEMENTO_EMPRESA" VARCHAR2(50),
	"BAIRRO_EMPRESA" VARCHAR2(100),
	"CEP_EMPRESA" VARCHAR2(8),
	"CIDADE_EMPRESA" VARCHAR2(100),
	"UF_EMPRESA" VARCHAR2(2),
	"CODIGO_DA_VAGA" NUMBER(20, 0) NOT NULL ENABLE,
	"DESCRICAO_VAGA" VARCHAR2(150),
	"CONDICAO_ESTAGIO" NUMBER,
	"DATA_INICIO_ESTAGIO" TIMESTAMP (6),
	"DATA_FINAL_ESTAGIO" TIMESTAMP (6),
	"DURACAO_ESTAGIO" NUMBER(5, 0),
	"TIPO_AUXILIO_BOLSA" NUMBER,
	"TIPO_VALOR_BOLSA" NUMBER,
	"VALOR_BOLSA" NUMBER(10, 2),
	"TIPO_AUXILIO_TRANSPORTE" NUMBER,
	"TIPO_VALOR_AUXILIO_TRANSPORTE" NUMBER,
	"VALOR_TRANSPORTE_FIXO" NUMBER(10, 2),
	"ID_BANCO" NUMBER(3, 0),
	"ID_AGENCIA" NUMBER(20, 0),
	"CONTA_CORRENTE" VARCHAR2(50),
	"BENEFICIOS_ADICIONAIS_ESTAGIO" NUMBER,
	"ID_SUPERVISOR" NUMBER(20, 0),
	"NOME_SUPERVISOR" VARCHAR2(150),
	"CPF_SUPERVISOR" VARCHAR2(11),
	"CARGO_SUPERVISOR" VARCHAR2(150),
	"FORMACAO_SUPERVISOR" VARCHAR2(150),
	"ID_CONSELHO_CLASSE_SUPERVISOR" NUMBER(20, 0),
	"DESCRICAO_CONSELHO_SUPERVISOR" VARCHAR2(100),
	"CONTRATACAO_DIRETA" NUMBER,
	"DELETADO" NUMBER,
	"DATA_CRIACAO" TIMESTAMP (6),
	"DATA_ALTERACAO" TIMESTAMP (6) NOT NULL ENABLE,
	"CRIADO_POR" VARCHAR2(255),
	"MODIFICADO_POR" VARCHAR2(255),
	"CONTA_CORRENTE_DIGITO" VARCHAR2(2),
	"SITUACAO" NUMBER(1, 0),
	"CODIGO_ESTUDANTE" VARCHAR2(20) NOT NULL ENABLE,
	"SIGLA_NIVEL_EDUCACAO_ESTUDANTE" VARCHAR2(2),
	"DATA_SOLICITACAO_RESCISAO" TIMESTAMP (6),
	"DATA_RESCISAO" TIMESTAMP (6),
	"MATRICULA_RH" NUMBER(20, 0),
	"CONTRAPARTIDA_AUX_TRANSPORTE" VARCHAR2(100),
	"CONDICOES_ESPECIAIS" NUMBER(1, 0),
	"ID_VINCULO_VAGA" NUMBER(20, 0),
	"TIPO_CALCULO_SALARIO_APRENDIZ" NUMBER(1, 0),
	"RG_ESTUDANTE" VARCHAR2(20),
	"DATA_NASCIMENTO" TIMESTAMP (6),
	"RESPONSAVEL_LEGAL" VARCHAR2(255),
	"NIVEL_ESCOLARIDADE" VARCHAR2(2),
	"CPF_MONITOR" VARCHAR2(11),
	"NOME_MONITOR" VARCHAR2(255),
	"EMAIL_MONITOR" VARCHAR2(100),
	"TELEFONE_MONITOR" VARCHAR2(60),
	"NOME_CONTATO" VARCHAR2(255),
	"EMAIL_CONTATO" VARCHAR2(100),
	"TELEFONE_CONTATO" VARCHAR2(60),
	"TIPO_SALARIO_APRENDIZ" NUMBER(1, 0),
	"VALOR_SALARIO_APRENDIZ" NUMBER(10, 2),
	"TIPO_AUXILIO_TRANSPORTE_APRENDIZ" NUMBER(1, 0),
	"TIPO_AUXILIO_TRANSPORTE_VALOR_APRENDIZ" NUMBER,
	"VALOR_TRANSPORTE_FIXO_APRENDIZ" NUMBER(10, 2),
	"VALOR_SALARIO_APRENDIZ_DE" NUMBER(10, 2),
	"VALOR_SALARIO_APRENDIZ_ATE" NUMBER(10, 2),
	"SITUACAO_ESCOLARIDADE" NUMBER(1, 0),
	"NUMERO_CARTEIRA_TRABALHO" VARCHAR2(64),
	"SERIE_CARTEIRA_TRABALHO" VARCHAR2(32),
	"UF_CARTEIRA_TRABALHO" VARCHAR2(2),
	"PIS" VARCHAR2(32),
	"HORARIO_INICIO_EXPDIENTE_APRENDIZ" TIMESTAMP (6),
	"HORARIO_TERMINO_EXPDIENTE_APRENDIZ" TIMESTAMP (6),
	"CONTRAPARTIDA_AUX_TRANSPORTE_APRENDIZ" VARCHAR2(100),
	"DATA_FINAL_APRENDIZ" TIMESTAMP (6),
	"TIPO_APRENDIZ" NUMBER(1, 0),
	"DATA_ORIGINAL" TIMESTAMP (6),
	"SEQ_TA" NUMBER(20, 0) DEFAULT 0,
	"PENDENCIA_TA" NUMBER(1, 0) DEFAULT 0,
	"DATA_VIGENCIA_TA" TIMESTAMP (6),
	"ESTAGIO_OBRIGATORIO" NUMBER DEFAULT 0 NOT NULL ENABLE,
	"USA_HORARIO_VARIAVEL" NUMBER DEFAULT 0 NOT NULL ENABLE,
	"ID_MOTIVO_RESCISAO_CONTRATADO" NUMBER(20, 0),
	"ID_MOTIVO_CANCELAMENTO_CONTRATADO" NUMBER(20, 0),
	"EMISSAO_DOCUMENTO_PENDENTE" NUMBER,
	"RESCINDIDO_POR" VARCHAR2(150),
	"EMAIL_CONTATO_RESPONSAVEL" VARCHAR2(100),
	"FONE_CONTATO_RESPONSAVEL" VARCHAR2(100),
	"STATUS_TRE" NUMBER(1, 0) DEFAULT 0,
	"CHAVE_DOCUMENTO_ASSINADO" VARCHAR2(255),
	"FORMACAO_RESPONSAVEL_LEGAL" VARCHAR2(255),
	"DATA_PREVISTA_PRORROGACAO" TIMESTAMP (6),
	"EMAIL_SUPERVISOR" VARCHAR2(100),
	"CARGO_MONITOR" VARCHAR2(255),
	"DATA_CANCELAMENTO" TIMESTAMP (6),
	"ORDEM_PAGAMENTO" NUMBER(1, 0) DEFAULT 0,
	"SITUACAO_DADOS_BANCARIOS" NUMBER(1, 0) DEFAULT 0,
	"DATA_BAIXA" TIMESTAMP (6),
	"ID_RESERVA_SECRETARIA" NUMBER(20, 0),
	"PRORROGACAO_AUTOMATICA" NUMBER(1, 0) DEFAULT 0,
	"INTEGRACAO_TOTVS" NUMBER(1, 0) DEFAULT 0,
	"CODIGO_OPERACAO" VARCHAR2(5),
	"TIPO_CONTA" VARCHAR2(1) DEFAULT 'C',
	"VALIDA_DADO_BANCARIO" NUMBER(1, 0),
	"TIPO_CARTEIRA_TRABALHO" NUMBER(1, 0),
	"MOTIVO_DADOS_BANCARIOS" VARCHAR2(255 CHAR),
	"OBSERVACAO_CANCELAMENTO_RESCISAO" VARCHAR2(300 CHAR)
);

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_CONTRATO" IS 'Flag:
A - Aprendiz
E - Estagio';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."ID_CURSO_CAPACITACAO" IS 'Obs:
Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CARGA_HORARIA" IS 'Obs:
Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."FAIXA_ETARIA_INICIAL" IS 'Obs:
Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."FAIXA_ETARIA_FINAL" IS 'Obs:
Este campo é preenchido quando o tipo do contrato for: A ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."ID_AREA_PROFISSIONAL" IS 'Obs:
Este campo é preenchido quando o tipo do contrato for: E';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."PCD" IS 'Flag 0 ou 1:
0 - Normal
1 - PCD';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."PERIODO_CURSO_ESTUDANTE" IS '-
Esse campo é preencho com dados do campo tipo_perido_curso da tabela:
REP_ESCOLARIDADES_ESTUDANTES.
EX: Manhã, Tarde, Noite, Integral, Variavel...';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."ENDERECO_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."NUMERO_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."COMPLEMENTO_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."BAIRRO_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CEP_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CIDADE_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."UF_EMPRESA" IS 'OBS:
Esse dado vem da tabela de enderecos, vinculada a locais_enderecos';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CONDICAO_ESTAGIO" IS 'Enum:
0 - Obrigatório
1 - Não Obrigatório';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."DURACAO_ESTAGIO" IS 'OBS:
Campo Calculado ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_AUXILIO_BOLSA" IS 'Enum:
0 - Mensal
1 - Por Hora';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_VALOR_BOLSA" IS 'Enum:
0 - Fixo
1 - A combinar';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_AUXILIO_TRANSPORTE" IS 'Enum:
0 - Mensal
1 - Por Hora';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_VALOR_AUXILIO_TRANSPORTE" IS 'Enum:
0 - Fixo
1 - A combinar';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."BENEFICIOS_ADICIONAIS_ESTAGIO" IS 'Flag  0 ou 1';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CONTRATACAO_DIRETA" IS 'Enum:
0 - Contrataçao Normal
1 - Contratação Direta';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."SITUACAO" IS 'Eum:
0-Efetivado
1-Encerrado
2-Cancelado
3-Preenchido
4-Manual
5-Emitido';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CONDICOES_ESPECIAIS" IS 'Enum:
0 - sem ressalva
1 - com inconsistencias';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_CALCULO_SALARIO_APRENDIZ" IS 'Enum:
0 - Federal
1 - Estadual
2 - Convencao
Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."RG_ESTUDANTE" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."DATA_NASCIMENTO" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."RESPONSAVEL_LEGAL" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."NIVEL_ESCOLARIDADE" IS 'Este campo e utilizado na matricula do Aprendiz
Opcoes:
SU - Superior
TE - Técnico
EE - Educação Especial
HB - Habilitação Básica
EM - Ensino Médio
EF - Ensino Fundamental
Obs. vem do campo sigla_nivel_educacao da tabela rep_escolaridades_estudantes';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."CPF_MONITOR" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."NOME_MONITOR" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."EMAIL_MONITOR" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TELEFONE_MONITOR" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."NOME_CONTATO" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."EMAIL_CONTATO" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TELEFONE_CONTATO" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_SALARIO_APRENDIZ" IS 'Enum:
0 - Mensal
1 - Por Hora
Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."VALOR_SALARIO_APRENDIZ" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_AUXILIO_TRANSPORTE_APRENDIZ" IS 'Enum:
0 - Mensal
1 - Diario
Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_AUXILIO_TRANSPORTE_VALOR_APRENDIZ" IS 'Enum
0 - Fixo
1 - A Combinar
Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."VALOR_TRANSPORTE_FIXO_APRENDIZ" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."VALOR_SALARIO_APRENDIZ_DE" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."VALOR_SALARIO_APRENDIZ_ATE" IS 'Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."SITUACAO_ESCOLARIDADE" IS 'Enum:
0 - Todos
1 - Cursando
2 - Concluido
Este campo e utilizado na matricula do Aprendiz';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."TIPO_APRENDIZ" IS 'Flag:
0 - Capacitador
1 - Empregador';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."ESTAGIO_OBRIGATORIO" IS 'sim=1';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."USA_HORARIO_VARIAVEL" IS 'sim=1';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."EMISSAO_DOCUMENTO_PENDENTE" IS 'Flag para identificar pendência de emissão de documento.';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."STATUS_TRE" IS 'Flag:
0 - Não
1 - Sim';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."ORDEM_PAGAMENTO" IS 'Enum: 0 - Não    1 - Sim';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."SITUACAO_DADOS_BANCARIOS" IS 'Enum:
0 - Não validado
1 - Válido
2 - Inválido';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."PRORROGACAO_AUTOMATICA" IS '0 - NAO - DEFAULT
1 - SIM ';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."CONTRATO_ESTUDANTES_EMPRESAS_ALTERADO"."INTEGRACAO_TOTVS" IS 'Flag 0 ou 1
0 - Contrato estudante empresa não integrado
1 - Contrato estudante empresa integrado';

-- SERVICE_VAGAS_DEV.BENEFICIOS_CONTR_EMP_ALTERADO
CREATE TABLE "SERVICE_VAGAS_DEV"."BENEFICIOS_CONTR_EMP_ALTERADO" (
	"ID" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_CONTR_EMP_EST" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_BENEFICIO" NUMBER(20, 0) NOT NULL ENABLE,
	"VALOR" NUMBER(10, 2),
	"DELETADO" NUMBER,
	"DATA_CRIACAO" TIMESTAMP (6),
	"DATA_ALTERACAO" TIMESTAMP (6),
	"CRIADO_POR" VARCHAR2(255),
	"MODIFICADO_POR" VARCHAR2(255)
);

-- SERVICE_VAGAS_DEV.CONTRATOS_CURSOS_CAPACITACAO_ALTERADO
CREATE TABLE "SERVICE_VAGAS_DEV"."CONTRATOS_CURSOS_CAPACITACAO_ALTERADO" (
	"ID" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_CONTR_EMP_EST" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_CURSO_CAPACITACAO" NUMBER(20, 0) NOT NULL ENABLE,
	"NOME_CURSO" VARCHAR2(255) NOT NULL ENABLE,
	"DESCRICAO_AREA_ATUACAO" VARCHAR2(255) NOT NULL ENABLE,
	"ID_TURMA_REGULAR" NUMBER(20, 0) NOT NULL ENABLE,
	"SALA_REGULAR" VARCHAR2(300) NOT NULL ENABLE,
	"ID_LOCAL" NUMBER(20, 0) NOT NULL ENABLE,
	"DESCRICAO_LOCAL" VARCHAR2(150) NOT NULL ENABLE,
	"ENDERECO" VARCHAR2(255) NOT NULL ENABLE,
	"NUMERO" VARCHAR2(10) NOT NULL ENABLE,
	"COMPLEMENTO" VARCHAR2(50),
	"BAIRRO" VARCHAR2(100) NOT NULL ENABLE,
	"CEP" VARCHAR2(8) NOT NULL ENABLE,
	"CIDADE" VARCHAR2(100) NOT NULL ENABLE,
	"UF" VARCHAR2(2) NOT NULL ENABLE,
	"DELETADO" NUMBER DEFAULT 0,
	"DATA_CRIACAO" TIMESTAMP (6) NOT NULL ENABLE,
	"DATA_ALTERACAO" TIMESTAMP (6),
	"CRIADO_POR" VARCHAR2(255) NOT NULL ENABLE,
	"MODIFICADO_POR" VARCHAR2(255),
	"DATA_INICIO" TIMESTAMP (6),
	"DATA_INICIO_PERSONALIZADA" TIMESTAMP (6),
	"USA_DATA_PERSONALIZADA" NUMBER(1, 0) NOT NULL ENABLE,
	"HORARIO_CURSO" VARCHAR2(20) NOT NULL ENABLE,
	"DIA_CAPACITACAO" VARCHAR2(50) NOT NULL ENABLE,
	"CARGA_HORARIA_TEORICA" NUMBER(5, 0) NOT NULL ENABLE,
	"CARGA_HORARIA_PRATICA" NUMBER(5, 0) NOT NULL ENABLE,
	"TIPO_TURMA_REGULAR" VARCHAR2(10) NOT NULL ENABLE,
	"ID_TURMA_COMPLEMENTAR" NUMBER(20, 0) NOT NULL ENABLE,
	"TIPO_TURMA_COMPLEMENTAR" VARCHAR2(10) NOT NULL ENABLE,
	"SALA_COMPLEMENTAR" VARCHAR2(300) NOT NULL ENABLE
);

-- SERVICE_VAGAS_DEV.HORARIOS_CONTRATO_JORNADA_ALTERADO
CREATE TABLE "SERVICE_VAGAS_DEV"."HORARIOS_CONTRATO_JORNADA_ALTERADO" (
	"ID" NUMBER(20, 0) NOT NULL ENABLE,
	"ID_CONTR_EMP_EST" NUMBER(20, 0) NOT NULL ENABLE,
	"DIA_SEMANA" VARCHAR2(7),
	"HORA_ENTRADA" TIMESTAMP (6),
	"HORA_SAIDA" TIMESTAMP (6),
	"JORNADA" TIMESTAMP (6),
	"INTERVALO" TIMESTAMP (6),
	"TIPO_HORARIO" NUMBER,
	"DELETADO" NUMBER,
	"DATA_CRIACAO" TIMESTAMP (6) NOT NULL ENABLE,
	"DATA_ALTERACAO" TIMESTAMP (6) NOT NULL ENABLE,
	"CRIADO_POR" VARCHAR2(255),
	"MODIFICADO_POR" VARCHAR2(255)
);

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."HORARIOS_CONTRATO_JORNADA_ALTERADO"."DIA_SEMANA" IS 'Ex:
Segunda, Terça,etc....';

COMMENT ON COLUMN "SERVICE_VAGAS_DEV"."HORARIOS_CONTRATO_JORNADA_ALTERADO"."TIPO_HORARIO" IS 'Enum:
0 - Fixo
1 - Horario Alternativo';