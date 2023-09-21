alter table service_vagas_dev."TRIAGENS_ESTUDANTES" modify DATA_ALTERACAO date;
DECLARE
    v_column_exists number := 0;
BEGIN
    Select count(1) into v_column_exists
    from user_tab_cols
    where upper(column_name) = 'INFO'
      and upper(table_name) = 'TRIAGENS_ESTUDANTES';

    if (v_column_exists = 0) then
        execute immediate 'alter table {{user}}.TRIAGENS_ESTUDANTES add (INFO VARCHAR2(4000))';
    end if;

    execute immediate 'alter table {{user}}.TRIAGENS_ESTUDANTES drop(EMAILS, TELEFONES, EXPERIENCIAS_PROFISSIONAIS, CONHECIMENTOS_DIVERSOS, AREAS_PROFISSIONAL)';

    ctx_ddl.create_index_set('ESTUDANTE_INDEX_SET');

    ctx_ddl.add_index('ESTUDANTE_INDEX_SET', ' DATA_ALTERACAO');

    ctx_ddl.create_section_group('ESTUDANTE_SECTION_GROUP',   'XML_SECTION_GROUP');

    ctx_ddl.add_field_section('ESTUDANTE_SECTION_GROUP', 'estudante','estudante');
    ctx_ddl.add_field_section('ESTUDANTE_SECTION_GROUP', 'conhecimentos','conhecimentos');
    ctx_ddl.add_field_section('ESTUDANTE_SECTION_GROUP', 'diversos','diversos');
    ctx_ddl.add_field_section('ESTUDANTE_SECTION_GROUP', 'idiomas','idiomas');
    ctx_ddl.add_field_section('ESTUDANTE_SECTION_GROUP', 'experiencias', 'experiencias');

    execute immediate 'CREATE INDEX idx_triagens_estudantes_info ON {{user}}.triagens_estudantes(info) indextype IS ctxsys.ctxcat parameters(''index set ESTUDANTE_INDEX_SET section group ESTUDANTE_SECTION_GROUP'')';
end;
/
