--*************************************************************************
--Remove coluna que não existe no modelo e não foi deletado nas migrations*
--*************************************************************************

ALTER TABLE PCD
    DROP COLUMN DESCRICAO_CID_AGRUPADO;

