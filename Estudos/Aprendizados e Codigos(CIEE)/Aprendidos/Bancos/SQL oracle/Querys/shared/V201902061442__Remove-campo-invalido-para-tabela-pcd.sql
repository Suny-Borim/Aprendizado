--*************************************************************
--Remove campo que foi adicionado de maneira inválida a tabela*
--*************************************************************

ALTER TABLE pcd
    DROP COLUMN valido_cota;
