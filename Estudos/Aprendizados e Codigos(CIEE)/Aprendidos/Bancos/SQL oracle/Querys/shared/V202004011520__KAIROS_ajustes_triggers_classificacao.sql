create or replace TRIGGER TRIGGER_REP_ESTUDANTES_PCD_INSERT_UPDATE
AFTER INSERT or update of pcd ON REP_ESTUDANTES
for each row  

 declare
  pragma autonomous_transaction;

begin
   DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_PCD'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id||', ''MODULO_PCD_PENDENTE'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
end;
/


CREATE OR REPLACE TRIGGER TRIGGER_VIDEO_APRESENTACAO_INSERT_UPDATE
AFTER INSERT or UPDATE OF VIDEO_URL ON REP_ESTUDANTES
FOR EACH ROW

declare
    pragma autonomous_transaction;
BEGIN
	 DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_VIDEO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id||', ''VIDEO_APRESENTACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

end;
/


create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_REP_IDIOMAS_NIVEIS_INSERT_UPDATE"
AFTER INSERT or update ON REP_IDIOMAS_NIVEIS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

 DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_CURSO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.estudante_id||', ''CURSOS_CERTIFICACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/


create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_REP_CONHECIMENTOS_INFORMATICA_INSERT_UPDATE"
AFTER INSERT or update ON REP_CONHECIMENTOS_INFORMATICA
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

   DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_CURSO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''CURSOS_CERTIFICACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/

create or replace TRIGGER "SERVICE_VAGAS_DEV"."TRIGGER_REP_CONHECIMENTOS_DIVERSOS_STUDENT_INSERT_UPDATE"
AFTER INSERT or update ON REP_CONHECIMENTOS_DIVERSOS_STUDENT
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_CURSO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''CURSOS_CERTIFICACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/

create or replace TRIGGER TRIGGER_FAVORITOS_INSERT_UPDATE
AFTER INSERT or update ON FAVORITOS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

 DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_FAV'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_candidato||', ''FAVORITO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/

create or replace TRIGGER TRIGGER_REP_PROVAS_ONLINE_CURRICULOS_EST_INSERT_UPDATE
AFTER INSERT or update ON rep_provas_online_curriculos_estudantes_student
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

 DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_TESTES'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''TESTES_CIEE'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/


create or replace TRIGGER TRIGGER_REP_VIDEOS_CURRICULOS_ESTUDANTES_INSERT_UPDATE
AFTER INSERT or update ON REP_VIDEOS_CURRICULOS_ESTUDANTES_STUDENT
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_VIDEO'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''VIDEO_CURRICULO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/

create or replace TRIGGER TRIGGER_REP_ESCOLARIDADES_ESTUDANTES_INSERT_UPDATE
AFTER INSERT or update ON REP_ESCOLARIDADES_ESTUDANTES
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

	DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_CLASS'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''ESCOLA_CLASSIFICACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');

END;
/

create or replace TRIGGER TRIGGER_CLASSIFICACOES_IES_ENAD_INSERT_UPDATE
AFTER INSERT or update of CLASSIFICACAO ON CLASSIFICACOES_IES_ENAD
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  if (:old.CLASSIFICACAO <> :new.CLASSIFICACAO) then
	DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_CLASS'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''ESCOLA_CLASSIFICACAO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
  end if;
   
END;
/


create or replace TRIGGER TRIGGER_RESULTADOS_PROCESSO_SELETIVO_INSERT_UPDATE
AFTER INSERT or update ON RESULTADOS_PROCESSO_SELETIVO
FOR EACH ROW
DECLARE
	pragma autonomous_transaction;
    estudante_id number := 0;
BEGIN

  select v.id_estudante  INTO estudante_id from ESTUDANTES_AGENDA ea
  inner join VINCULOS_VAGA v on (v.id = ea.id_vinculo_vaga)
  where ea.id = :NEW.id_estudante_agenda
  group by v.id_estudante;
  
  IF (estudante_id > 0) THEN
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_FALTA'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||estudante_id||', ''FALTA_INJUSTIFICADA_ETAPA'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
		
  END IF;

END;
/

create or replace TRIGGER TRIGGER_VINCULOS_VAGA_INSERT_UPDATE
AFTER INSERT or update ON VINCULOS_VAGA
FOR EACH ROW
DECLARE
	pragma autonomous_transaction;
BEGIN

	DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_RET'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''SEM_RETORNO_PENDENTE'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
   
END;
/

create or replace TRIGGER TRIGGER_ESCOLA_NAO_IDENTIFICADA_INSERT_UPDATE
AFTER INSERT or update of id_escola, id_periodo_curso ON REP_ESCOLARIDADES_ESTUDANTES
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  if (:new.id_escola = null or :new.id_periodo_curso = null) then
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''MODULO_ESCOLA_NAO_IDENTIFICADA'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
  end if;
  
  COMMIT;
   
END;
/

create or replace TRIGGER TRIGGER_REP_CAMPUS_INATIVO_INSERT_UPDATE
AFTER INSERT or update of ativo ON REP_CAMPUS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  if (:new.ativo = 0) then
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''MODULO_CAMPUS_INATIVO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
  end if;
   
END;
/

create or replace TRIGGER TRIGGER_REP_CAMPUS_CURSO_BLOQUEADO_INSERT_UPDATE
AFTER INSERT or update of bloqueado ON REP_CAMPUS_CURSOS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  if (:new.bloqueado = 1) then
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''MODULO_CAMPUS_INATIVO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
  end if;
   
END;
/

create or replace TRIGGER TRIGGER_REP_CAMPUS_CURSO_PERIODO_BLOQUEADO_INSERT_UPDATE
AFTER INSERT or update of bloqueado ON REP_CAMPUS_CURSOS_PERIODOS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

  if (:new.bloqueado = 1) then
		DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_ESC'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                        SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_GERAL_ESTUDANTES_INC_FILA(''MODULO_CAMPUS_INATIVO'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
  end if;
   
END;
/

create or replace TRIGGER TRIGGER_REP_EMAILS_INSERT_UPDATE
AFTER INSERT or update ON REP_EMAILS
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

	DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_CONT'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                         SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''MODULO_CONTATO_SEM_EMAIL'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
   
END;
/

create or replace TRIGGER TRIGGER_REP_TELEFONES_INSERT_UPDATE
AFTER INSERT or update ON REP_TELEFONES
FOR EACH ROW
declare
    pragma autonomous_transaction;
BEGIN

	DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_CONT'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                         SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||:new.id_estudante||', ''MODULO_CONTATO_SEM_EMAIL'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
   
END;
/

create or replace TRIGGER TRIGGER_REP_LAUDOS_MEDICOS_DOCUMENTOS_INSERT_UPDATE
AFTER INSERT or update ON REP_LAUDOS_MEDICOS_DOCUMENTOS
FOR EACH ROW
DECLARE
	pragma autonomous_transaction;
    v_estudante_id number := 0;
BEGIN

    select estudante_id into v_estudante_id from REP_LAUDOS_MEDICOS l 
    where
    l.id = :new.laudo_medico_id
    group by estudante_id;
    
    if (v_estudante_id > 0) then
		 DBMS_SCHEDULER.CREATE_JOB (
        job_name => 'SERVICE_VAGAS_DEV.REP_ESTUDANTES_INC_FILA_MOD_PCD'|| DBMS_RANDOM.string('a',15) || to_char(sysdate, 'yyyymmddhh24miss'),
        job_type => 'PLSQL_BLOCK',
        job_action => 'BEGIN 
                         SERVICE_VAGAS_DEV.PROC_CLASSIFICACOES_ESTUDANTES_INC_FILA('||v_estudante_id||', ''MODULO_PCD_PENDENTE'');
                       END;',
        number_of_arguments => 0,
        start_date => NULL,
        repeat_interval => NULL,
        end_date => NULL,
        enabled => TRUE,
        auto_drop => TRUE,
        comments => '');
    end if;

END;
/