-- 1. Получите список всех существующих PDB в рамках экземпляра ORA12W. 
-- Определите их текущее состояние.
select * from dba_pdbs;

-- 2. Выполните запрос к ORA12W, позволяющий получить перечень экземпляров.
select * from V$INSTANCE;

-- 3. Выполните запрос к ORA12W, позволяющий получить перечень установленных 
-- компонентов СУБД Oracle 12c и их версии и статус. 
select * from v$option;

-- 4. Создайте собственный экземпляр PDB 
-- (необходимо подключиться к серверу с серверного компьютера и 
-- используйте Database Configuration Assistant) с именем XXX_PDB, где XXX – инициалы студента. 

-- Создание TDS_PDB с админом TDS_PDB_ADMIN в DB Configuration Assistant
-- Как создать? (Актуально для Oracle 19c)
-- 1. Запускаем DB Configuration Assistant (находим в поиске Windows или
-- CMD -> dbca
-- 2. После загрузки выбираем Manage Pluggable databases
-- 3. Выбираем Create Pluggable databases
-- 4. Выбираем инстанс
-- 5. Выбираем пункт Create a new pluggable database from another PDB
--  выбираем НЕ PDB$SEED (в моём случае ORCLPDB)
-- 6. Вписываем имя нашей PDB и создаём админа PDB
-- 7. Жмём некст и ждём)

-- 5. Получите список всех существующих PDB в рамках экземпляра ORA12W. 
-- Убедитесь, что созданная PDB-база данных существует.
select * from dba_pdbs;

-- 6. Подключитесь к XXX_PDB c помощью SQL Developer,
-- создайте инфраструктурные объекты (табличные пространства, роль, профиль безопасности, пользователя с именем U1_XXX_PDB).

alter session set container = TDS_PDB;
alter pluggable database TDS_PDB open;
alter session set "_ORACLE_SCRIPT" = true;
--alter session set container = CDB$ROOT; вернутся к истокам

-- Смотрим к чему мы подключены
show con_name;

-- tablespaces
create tablespace TDS_PDB_TS
  datafile 'TDS_PDB_TS.dbf'
  size 10M
  autoextend on next 5M
  maxsize 50M;
  
create temporary tablespace TDS_PDB_TS_TEMP
  tempfile 'TDS_PDB_TS_TEMP.dbf'
  size 5M
  autoextend on next 2M
  maxsize 40M;

select * from dba_tablespaces where TABLESPACE_NAME like '%TDS%';
drop tablespace TDS_PDB_TS including contents and datafiles;
drop tablespace TDS_PDB_TS_TEMP including contents and datafiles;

-- role
create role TDS_PDB_RL;

grant 
    connect, 
    create session,
    alter session,
    create any table, 
    drop any table, 
    create any view, 
    drop any view, 
    create any procedure, 
    drop any procedure 
to TDS_PDB_RL;

select * from dba_roles where ROLE like '%RL%';
drop role TDS_PDB_RL;

-- profile
-- Если не создается профиль в PDB, то
-- 1) Просто обновляйся ваш коннект
-- 2) alter session set "_ORACLE_SCRIPT" = false; мне помогло)))
create profile TDS_PDB_PROFILE limit
  password_life_time 365
  sessions_per_user 3
  failed_login_attempts 7
  password_lock_time 1
  password_reuse_time 10
  connect_time 180;
  
select * from dba_profiles where PROFILE like '%TDS_PDB_PROFILE%';
drop profile TDS_PDB_PROFILE;
  
-- user
create user U1_TDS_PDB 
    identified by 111
    default tablespace TDS_PDB_TS 
    quota unlimited on TDS_PDB_TS
    temporary tablespace TDS_PDB_TS_TEMP
    profile TDS_PDB_PROFILE
    account unlock
    password expire;
    
    
grant 
    TDS_PDB_RL,
    SYSDBA
to U1_TDS_PDB; 

select * from dba_users where USERNAME like '%U1%';
drop user U1_TDS_PDB;

-- 7. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer, 
-- создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.

-- Инструкция:
-- 1. Connection -> New Connection
-- 2.   Имя пишите любое
--      Username и password пишем от юзера, которого создали
--      Role SYSDBA
--      Ниже пунктов localhost и port выбираем Service Name
--      В моём случае TDS_PDB.mshome.net, все зависит от имени PDB, которую вы
--      создавали и от global_name, вывод которой можно чекнуть внизу скриптом
--      У меня это ORCL.mshome.net, нужна эта часть: mshome.net
--      Думаю принцип понятен)

select global_name from global_name;

create table TDS_PDB_TABLE 
(
    id int primary key,
    field varchar(50)
);

insert into TDS_PDB_TABLE values (1, 'Test1'); 
insert into TDS_PDB_TABLE values (2, 'Test2');
insert into TDS_PDB_TABLE values (3, 'Test3');
       
select * from TDS_PDB_TABLE
drop table  TDS_PDB_TABLE;

-- 8. С помощью представлений словаря базы данных определите, 
-- все табличные пространства, все  файлы (перманентные и временные), 
-- все роли (и выданные им привилегии), профили безопасности, 
-- всех пользователей  базы данных XXX_PDB и  назначенные им роли.

select * from dba_tablespaces where TABLESPACE_NAME like 'TDS%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'TDS%';
select * from dba_sys_privs where GRANTEE like 'TDS%';
select * from dba_profiles where PROFILE like 'TDS%';
select * from dba_users where USERNAME like 'TDS%';

-- 9. Подключитесь  к CDB-базе данных, создайте общего пользователя с именем C##XXX, 
-- назначьте ему привилегию, позволяющую подключится к базе данных XXX_PDB. 
-- Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных 
-- и  XXX_PDB – базе данных. Проверьте их работоспособность.
  
alter session set container = CDB$ROOT;
SHOW CON_NAME;

create user C##TDS
    identified by 111;
    
grant 
    connect, 
    create session, 
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##TDS container = all;

select * from dba_users where USERNAME like '%C##%';

-- !!! Если можно создать две таблицы, значит они создаются в разных DB

-- Создание коннекта ConnectToCDB_Lab3 как обычный коннект,
-- просто подключение по логину и паролю, база
-- только используем юзера C##TDS

-- Создание коннекта ConnectToPDB_Lab3 по аналогии с заданием 7,
-- только используем юзера C##TDS


-- Запускать в коннекте ConnectToСDB_Lab3
create table x (id int);
drop table x;

-- Запускать в коннекте ConnectToPDB_Lab3
create table x (id int);
drop table x;

-- 10. Назначьте привилегию, разрешающему подключение к XXX_PDB общему пользователю C##YYY, 
-- созданному другим студентом. Убедитесь в работоспособности  этого пользователя в базе данных XXX_PDB. 


-- Чтобы не ставить еще одну виртуалку с oracle, проще поставить DataGrip
-- на свою основную Windows
-- Инструкция:
-- 1. Внизу скрипт для создания юзера C##TDS2, через которого мы и будем делать
-- коннект. Создайте юзера :)
-- 2. Скачиваем Datagrip
-- 3. После установки слева вверху (окно Database Explorer) нажимаем на "+"
-- 4. В окне впишите параметры по такому же принципу, как на фото ex10.png 
-- и нажмите Test Connection
-- 5. Если ошибки не выдает, значит все хорошо и можно работать уже в DataGrip

create user C##TDS2
    identified by 111;
    
grant 
    connect, 
    create session, 
    alter session, 
    create any table,
    drop any table,
    SYSDBA
to C##TDS2 container = all;

select * from dba_users where USERNAME like '%C##%';

-- 11. Подключитесь к пользователю U1_XXX_PDB со своего компьютера, 
-- а к пользователям C##XXX и C##YYY с другого (к XXX_PDB-базе данных). 
-- На своем компьютере получите список всех текущих подключений к XXX_PDB (найдите в списке созданные вами подключения). 
-- На своем компьютере получите список всех текущих подключений к СDB (найдите в списке созданные вами подключений).

-- В файле Ex11(DataGrip).sql

-- 13. Удалите созданную базу данных XXX_DB. 
-- Убедитесь, что все файлы PDB-базы данных удалены. 
-- Удалите пользователя C##XXX. 
-- Удалите в SQL Developer все подключения к XXX_PDB.
show pdbs;
alter pluggable database TDS_PDB open;
drop pluggable database TDS_PDB including datafiles;
