--**********************************************************
--Adiciona colunas de controle para tabelas que ficaram sem*
--**********************************************************

alter table {{user}}.favoritos
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));

alter table {{user}}.valor_medio_bolsa_mensal
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));

alter table {{user}}.valor_medio_bolsa_hora
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));

alter table {{user}}.destaques_atv_tce
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));

alter table {{user}}.destaques_areas_atua_tce
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));


alter table {{user}}.destaques_cursos_tce
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));


alter table {{user}}.destaques_areas_prof_tce
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));


alter table {{user}}.duracoes_capacit_cbos
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));



alter table {{user}}.idiomas
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));

alter table {{user}}.conhecimentos
    add (deletado               NUMBER,
         data_criacao           TIMESTAMP,
         data_alteracao         TIMESTAMP NOT NULL,
         criado_por             VARCHAR2(255),
         modificado_por         VARCHAR2(255));


ALTER TABLE {{user}}.rep_atividades
    MODIFY descricao_atividade VARCHAR2(200);