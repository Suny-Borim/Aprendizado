
CREATE OR REPLACE PROCEDURE PROC_CONTAGEM_ATIVOS_MESES_ATUAL_FUTUROS (P_RESULTSET OUT SYS_REFCURSOR)
IS
    v_mes_ano VARCHAR(100);
    l_query   CLOB;
begin
        
    FOR i IN 0..5
    LOOP
        v_mes_ano := v_mes_ano || '''' || TO_CHAR(ADD_MONTHS(SYSDATE, i), 'YYYY-MM') || ''', ';
    END LOOP;
    v_mes_ano := SUBSTR(v_mes_ano, 1, LENGTH(v_mes_ano)-2);

    l_query := l_query || 'SELECT * FROM (
        select TO_CHAR(months, ''YYYY-MM'') as meses, tipo, count(1) qtd
        from(       
        select 
            case when (c.data_inicio_estagio < months and coalesce(c.data_rescisao, c.data_final_estagio, months) >= months) then 
                months
               else trunc(c.data_inicio_estagio, ''mm'')
               end data_inicio,
               
            case when c.data_inicio_estagio < months and coalesce(c.data_rescisao, c.data_final_estagio, months) >= months then 
                    months
                else (coalesce(c.data_rescisao, c.data_final_estagio, months))
                end data_final,
                c.tipo, d.months
               
          from (select nvl(fm.descricao,''Estagio'') tipo, cc.data_inicio_estagio, cc.data_rescisao, cc.data_final_estagio
                from contratos_estudantes_empresa cc 
                inner join rep_locais_contrato lc on cc.id_local_contrato = lc.id
                inner join rep_contratos c1 on lc.id_contrato = c1.id
                left join rep_formas_contratacao fm on c1.id_forma_contratacao = fm.id
                where cc.tipo_contrato=''E'' and cc.situacao not in(1,2) and cc.data_cancelamento is null
                
                union all
                
                select nvl(fm.descricao,''Estagio'') tipo, coalesce(ccc.data_inicio_personalizada,ccc.data_inicio) as data_inicio_estagio, cc.data_rescisao, cc.data_final_aprendiz as data_final_estagio
                from contratos_estudantes_empresa cc 
                inner join contratos_cursos_capacitacao ccc on cc.id = ccc.ID_CONTR_EMP_EST
                inner join rep_locais_contrato lc on cc.id_local_contrato = lc.id
                inner join rep_contratos c2 on lc.id_contrato = c2.id
                left join rep_formas_contratacao fm on c2.id_forma_contratacao = fm.id
                where cc.tipo_contrato=''A'' and cc.situacao not in(1,2) and cc.data_cancelamento is null
            )  c,
                (
                select trunc(sysdate,''mm'') as months from dual 
                  union 
                 select trunc(ADD_MONTHS( sysdate, 1 ),''mm'') as months from dual    
                  union 
                 select trunc(ADD_MONTHS( sysdate, 2 ),''mm'') as months from dual    
                  union 
                 select trunc(ADD_MONTHS( sysdate, 3 ),''mm'') as months from dual    
                  union 
                 select trunc(ADD_MONTHS( sysdate, 4 ), ''mm'') as months from dual 
                 union 
                 select trunc(ADD_MONTHS( sysdate, 5 ), ''mm'') as months from dual
                 ) 
                 d)
                where data_inicio = months
                   or data_final = months
                group by TO_CHAR(months, ''YYYY-MM''), tipo
            ) PIVOT (
                SUM ( qtd )
                FOR meses
                IN ('|| v_mes_ano ||')
            )
        ORDER BY
            tipo';

    OPEN P_RESULTSET FOR l_query;

end PROC_CONTAGEM_ATIVOS_MESES_ATUAL_FUTUROS;
/