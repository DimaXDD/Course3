--1
select * from dba_pdbs;

--2
select * from V$INSTANCE;

--3
select * from v$option;

--4
-- create TDS_PDB with admin TDS_PDB_ADMIN in DB Configuration Assistant
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

--5
select * from dba_pdbs;

--6
alter session set container = TDS_PDB;
alter session set "_ORACLE_SCRIPT" = false;
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
-- Если не создается профиль в PDB, то просто обновляйте ваш коннект, 
-- мне помогло)))
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

-- 7
-- Нужно подключится к юзеру, которого создали
-- Инструкция:
-- 1. Connection -> New Connection
-- 2.   Имя пишите любое
--      Username и password пишем от юзера, которого создали
--      Role SYSDBA
--      Ниже пунктов localhost и port выбираем Service Name
--      В моём случае TDS_PDB.mshome.net, все зависит от имени PDB, которую вы
--      создавали и от global_name, вывод которой можно чекнуть внизу скриптом
--      У меня это ORCL.mshome.net, нужна эта часть: mshome.net
select global_name from global_name;
s
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

-- 8
select * from dba_tablespaces where TABLESPACE_NAME like 'TDS%';
select * from dba_data_files;
select * from dba_roles where ROLE like 'TDS%';
select * from dba_sys_privs where GRANTEE like 'TDS%';
select * from dba_profiles where PROFILE like 'TDS%';
select * from dba_users where USERNAME like 'TDS%';

-- 9
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

-- Если можно создать две таблицы, значит они создаются в разных DB

-- Запускать в ConnectToCDB_Lab3
create table x (id int);
drop table x;

-- Запускать в ConnectToPDB_Lab3
create table x (id int);
drop table x;

-- 10
select s.sid, s.serial#, s.username, p.pdb_name
from v$session s
join v$pdbs p on s.con_id = p.con_id
where s.type = 'User'
