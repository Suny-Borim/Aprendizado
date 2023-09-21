--Migration inicial Sprint 21 - Service_Vagas v.0


--PK-11191 - Validar Comprovante de Situação Escolar (BackOffice CIEE)
--PK-11189 - Gerar Processo CSE
--PK-11190 - Listar estudantes CSE (BackOffice CIEE)
--PK-11196 - Confirmar Situação Escolar de Estudantes (IE)
alter table cse add documento_validado NUMBER(1);
alter table cse add motivo_reprova NUMBER(1);
alter table cse add curso_atual VARCHAR2(150 CHAR);
alter table cse add ano_semestre VARCHAR2(100 CHAR);

COMMENT ON COLUMN cse.situacao_confirmacao IS
    'ENUM:
0-Pendente
1-Em Analise
2-Confirmado
3-Regular
4-Irregular';

COMMENT ON COLUMN cse.documento_validado IS
    '0-Reprovado
1-Aprovado';

COMMENT ON COLUMN cse.motivo_reprova IS
    'Enum:
0-Documento ilegível
1-Documento não é uma declaração de matrícula
2-Declaração escolar é de uma IE diferente da que está no cadastro do estagiário ';