DECLARE
    tabela_existente                               NUMBER := 0;
BEGIN
    
    SELECT
        COUNT(*)
    INTO tabela_existente
    FROM
        all_tables
    WHERE
        upper(table_name) = 'REP_TURMAS_SECON';

    IF ( tabela_existente = 0 ) THEN
        EXECUTE IMMEDIATE '
        	create table service_vagas_dev.rep_turmas_secon 
			(	
				id number(20,0) not null enable, 
				codigo varchar2(305 byte), 
				titulo varchar2(305 byte), 
				descricao varchar2(2000 byte), 
				datainicio date, 
				datafim date, 
				limitealunos number(20,0), 
				realm varchar2(100 byte), 
				tutorid number(20,0), 
				unidadeid number(20,0), 
				semestreid number(20,0), 
				periodoid number(20,0), 
				tipoconteudoid number(20,0), 
				datacriacao date, 
				criadopor number(20,0), 
				dataalteracao date, 
				alteradopor number(20,0), 
				cargahoraria timestamp (6), 
				tutorexternoid number(20,0), 
				cursoid number(20,0), 
				limiteconfirmacao number(20,0), 
				tipolocal varchar2(50 byte), 
				tipobloqueioid number(20,0), 
				mid number(20,0), 
				ead number(20,0), 
				eadcontrole varchar2(100 byte), 
				tipocomplementar varchar2(1 byte), 
				turmaquintasemana number(20,0), 
				constraint krs_indice_12088 primary key (id)
			)';
    END IF;
END;