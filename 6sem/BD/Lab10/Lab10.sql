-- 1. Создайте отдельное табличное пространство для хранения LOB
create tablespace lob_data
    datafile 'log.tb.dbf'
    size 1000m
    autoextend on next 100m;

-- 2. Создайте отдельную папку для хранения внешних WORD (или PDF) документов.
-- Папка C:/BFILE
-- Закидываем туда файлы, у меня это phono.png и test.docx

-- 3. Создайте пользователя lob_user с необходимыми привилегиями 
-- для вставки, обновления и удаления больших объектов.
create user C##lob_user identified by 1111
    default tablespace lob_data
    temporary tablespace temp
    quota unlimited on lob_data
    account unlock;

GRANT CONNECT, RESOURCE TO C##lob_user;
GRANT CREATE ANY DIRECTORY TO C##lob_user;
GRANT CREATE SESSION TO C##lob_user;
GRANT CREATE TABLE TO C##lob_user;
GRANT DROP ANY DIRECTORY TO C##lob_user;
GRANT EXECUTE ON DBMS_LOB TO C##lob_user;

-- 4. Добавьте квоту на данное табличное пространство пользователю lob_user.
ALTER USER C##lob_user QUOTA 100M ON lob_data;


-- 5. Добавьте в какую-либо таблицу следующие столбцы:
-- FOTO BLOB: для хранения фотографии;
-- DOC (или PDF) BFILE: для хранения внешних WORD (или PDF) документов.
CREATE TABLE lob_table (
    id NUMBER PRIMARY KEY
);
ALTER TABLE lob_table ADD (foto BLOB);
ALTER TABLE lob_table ADD (doc BFILE);

drop table lob_table;

-- 6. Добавьте (INSERT) фотографии и документы в таблицу.
CREATE DIRECTORY HOME AS 'C:/BFILE';
INSERT INTO lob_table (id, foto, doc) VALUES (9, BFILENAME('HOME', 'photo.png'), BFILENAME('HOME', 'test.docx'));
select * from lob_table;
select * from all_directories;

