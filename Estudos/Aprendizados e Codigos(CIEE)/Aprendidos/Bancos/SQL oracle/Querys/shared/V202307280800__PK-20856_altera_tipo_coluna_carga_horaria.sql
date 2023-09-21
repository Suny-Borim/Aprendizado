DECLARE
    coluna_existente_1 int:=0;
    coluna_existente_2 int:=0;
    coluna_existente_3 int:=0;
BEGIN
	
  	SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_INICIAL_ANTIGA'; 
	  if coluna_existente_1<=0 then
	  	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO RENAME COLUMN CARGA_HORARIA_TEORICA_INICIAL TO CARGA_HORARIA_TEORICA_INICIAL_ANTIGA';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN DURACOES_CAPACITACAO.CARGA_HORARIA_TEORICA_INICIAL_ANTIGA IS ''Esta carga horária era utilizada nas durações dos cursos de capacitação, e foi alterado para a coluna que usa number, devido a PK-20856. Caso seja constatato que tudo está funcionando bem, a mesma será deletada através de uma outra PK''';
	 	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD (CARGA_HORARIA_TEORICA_INICIAL NUMBER(4,0) DEFAULT NULL)';
	 	EXECUTE IMMEDIATE 'UPDATE DURACOES_CAPACITACAO SET CARGA_HORARIA_TEORICA_INICIAL = EXTRACT(HOUR FROM CARGA_HORARIA_TEORICA_INICIAL_ANTIGA)';
	  end if;
	  -----------------------------------------------
	  
  	SELECT count(*) into coluna_existente_2 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_BASICA_ANTIGA'; 
	  if coluna_existente_2<=0 then
	  	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO RENAME COLUMN CARGA_HORARIA_TEORICA_BASICA TO CARGA_HORARIA_TEORICA_BASICA_ANTIGA';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN DURACOES_CAPACITACAO.CARGA_HORARIA_TEORICA_BASICA_ANTIGA IS ''Esta carga horária era utilizada nas durações dos cursos de capacitação, e foi alterado para a coluna que usa number, devido a PK-20856. Caso seja constatato que tudo está funcionando bem, a mesma será deletada através de uma outra PK''';
	 	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD (CARGA_HORARIA_TEORICA_BASICA NUMBER(4,0) DEFAULT NULL)';
	  	EXECUTE IMMEDIATE 'UPDATE DURACOES_CAPACITACAO SET CARGA_HORARIA_TEORICA_BASICA = EXTRACT(HOUR FROM CARGA_HORARIA_TEORICA_BASICA_ANTIGA)';
	  end if; 
	  -----------------------------------------------
	
	SELECT count(*) into coluna_existente_3 from all_tab_columns where table_name = 'DURACOES_CAPACITACAO' and column_name = 'CARGA_HORARIA_TEORICA_ESPECIFICA_ANTIGA'; 
	  if coluna_existente_3<=0 then
	  	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO RENAME COLUMN CARGA_HORARIA_TEORICA_ESPECIFICA TO CARGA_HORARIA_TEORICA_ESPECIFICA_ANTIGA';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN DURACOES_CAPACITACAO.CARGA_HORARIA_TEORICA_ESPECIFICA_ANTIGA IS ''Esta carga horária era utilizada nas durações dos cursos de capacitação, e foi alterado para a coluna que usa number, devido a PK-20856. Caso seja constatato que tudo está funcionando bem, a mesma será deletada através de uma outra PK''';
	 	EXECUTE IMMEDIATE 'ALTER TABLE DURACOES_CAPACITACAO ADD (CARGA_HORARIA_TEORICA_ESPECIFICA NUMBER(4,0) DEFAULT NULL)';
	  	EXECUTE IMMEDIATE 'UPDATE DURACOES_CAPACITACAO SET CARGA_HORARIA_TEORICA_ESPECIFICA = EXTRACT(HOUR FROM CARGA_HORARIA_TEORICA_ESPECIFICA_ANTIGA)';
	  end if;   

END;