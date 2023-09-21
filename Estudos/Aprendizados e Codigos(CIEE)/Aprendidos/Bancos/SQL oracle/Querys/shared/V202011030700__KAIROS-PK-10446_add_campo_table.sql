--PK-10446 - Refatoração Estudante - Idiomas

alter table IDIOMAS
    add CHAVE_IDIOMA VARCHAR2(30 CHAR);

update IDIOMAS set CHAVE_IDIOMA = 'INGLÊS' where IDIOMA = 'Inglês';
update IDIOMAS set CHAVE_IDIOMA = 'ALEMÃO' where IDIOMA = 'Alemão';
update IDIOMAS set CHAVE_IDIOMA = 'ESPANHOL' where IDIOMA = 'Espanhol';
update IDIOMAS set CHAVE_IDIOMA = 'ITALIANO' where IDIOMA = 'Italiano';
update IDIOMAS set CHAVE_IDIOMA = 'FRANCÊS' where IDIOMA = 'Francês';
update IDIOMAS set CHAVE_IDIOMA = 'FRANCÊS' where IDIOMA = 'Francês';
update IDIOMAS set CHAVE_IDIOMA = 'JAPONÊS' where IDIOMA = 'Japonês';
update IDIOMAS set CHAVE_IDIOMA = 'LIBRAS' where IDIOMA = 'Libras';
