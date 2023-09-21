DECLARE
    coluna_existente_1 int:=0;
BEGIN
  SELECT count(*) into coluna_existente_1 from all_tab_columns where table_name = 'PORTARIAS_MTE' and column_name = 'COMPLEMENTAR_OBRIGATORIA'; 

  if coluna_existente_1<=0 then
     EXECUTE IMMEDIATE 'ALTER TABLE PORTARIAS_MTE ADD COMPLEMENTAR_OBRIGATORIA NUMBER(1,0) DEFAULT 1 NOT NULL';
  end if;
END;
/
UPDATE PORTARIAS_MTE SET COMPLEMENTAR_OBRIGATORIA = 0 WHERE DESCRICAO_PORTARIA = 'Portaria MTE 723/2012 e 1005/2013';