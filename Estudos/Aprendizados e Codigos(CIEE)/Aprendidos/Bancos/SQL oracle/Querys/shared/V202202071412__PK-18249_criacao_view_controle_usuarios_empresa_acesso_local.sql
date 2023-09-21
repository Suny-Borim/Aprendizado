create or replace view service_vagas_dev.v_usuarios_dominios
as
select /*+ PARALLEL 6*/
    ud.id_usuario,
    ud.composicao_dominio,
    REGEXP_SUBSTR (ud.composicao_dominio, '[^.]+', 1, 1) AS ID_CONTRATO,
    REGEXP_SUBSTR (ud.composicao_dominio, '[^.]+', 1, 2) AS ID_LOCAL_CONTRATO,
    aum.administrador_contrato,
    ud.id_grupo_acesso
from service_vagas_dev.rep_usuarios_dominios_company ud
inner join service_vagas_dev.rep_acessos_usuario_empresa_company aum on aum.id_usuario = ud.id_usuario;