alter table {{user}}.REGISTROS_CMDCAS
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));
