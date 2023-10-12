-- 1. Создайте табличное пространство для постоянных данных со следующими параметрами:
-- имя: TS_XXX;
-- имя файла: TS_XXX; 
-- начальный размер: 7М;
-- автоматическое приращение: 5М;
-- максимальный размер: 20М. 

-- файл будет находится по пути C:\WINDOWS.X64_193000_db_home\database
create tablespace TS_TDS
    datafile 'ts_TDS.dbf'
    size 7M
    autoextend on next 5M
    maxsize 20M
    
select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;
drop tablespace TS_TDS

-- 2. Создайте табличное пространство для временных данных со следующими параметрами:
-- имя: TS_XXX_TEMP;
-- имя файла: TS_XXX_TEMP; 
-- начальный размер: 5М;
-- автоматическое приращение: 3М;
-- максимальный размер: 30М. 

create temporary tablespace TS_TDS_TEMP
    tempfile 'ts_TDS_TEMP.dbf'
    size 5M
    autoextend on next 3M
    maxsize 30M
    
select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;
drop tablespace TS_TDS_TEMP

-- 3. Получите список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю.
select * from SYS.DBA_TABLESPACES;
select * from SYS.DBA_DATA_FILES;

-- 4. Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
-- разрешение на соединение с сервером;
-- разрешение создавать и удалять таблицы, представления, процедуры и функции.

alter session set "_ORACLE_SCRIPT" = true

create role RL_TDSCORE;
grant
    connect,
    create table,
    create view,
    create procedure,
    drop any table,
    drop any view,
    drop any procedure
to RL_TDSCORE;


-- 5. Найдите с помощью select-запроса роль в словаре.
-- Найдите с помощью select-запроса все системные привилегии, назначенные роли. 
select * from DBA_ROLES where ROLE = 'RL_TDSCORE';
select * from DBA_SYS_PRIVS where GRANTEE = 'RL_TDSCORE';

-- 6. Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.
create profile PF_TDSCORE limit
    failed_login_attempts 7 --число попыток входа в систему
    sessions_per_user 3 -- кол-во сессий на пользователя
    password_life_time 60 -- время жизни пароля
    password_reuse_time 365 -- время до повторного использования пароля
    password_lock_time 1 -- время блокировки пароля
    connect_time 180 -- время подключения
    idle_time 30; --время простоя
    
-- 7. Получите список всех профилей БД. Получите значения всех параметров профиля PF_XXXCORE. 
-- Получите значения всех параметров профиля DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where profile = 'PF_TDSCORE';
select * from DBA_PROFILES where profile = 'default';

-- 8. Создайте пользователя с именем XXXCORE со следующими параметрами:
-- табличное пространство по умолчанию: TS_XXX;
-- табличное пространство для временных данных: TS_XXX_TEMP;
-- профиль безопасности PF_XXXCORE;
-- учетная запись разблокирована;
-- срок действия пароля истек. 

create user C##TDSCORE
    identified by 111 --11111
    default tablespace TS_TDS
    temporary tablespace TS_TDS_TEMP
    profile PF_TDSCORE
    account unlock
    password expire;
    
grant
    create session,
    create table,
    create view,
    drop any table,
    drop any view
to C##TDSCORE;

drop user C##TDSCORE;

-- 9. Соединитесь с сервером Oracle с помощью sqlplus и введите новый пароль для пользователя XXXCORE.  
-- на фотке)))


-- 10. Создайте соединение с помощью SQL Developer для пользователя XXXCORE. 
-- Создайте любую таблицу и любое представление.
create table anyTable (
    id number
);

create view anyView as select * from anyTable;

drop view anyView;
drop table anyTable;

-- 11. Создайте табличное пространство с именем XXX_QDATA (10m). 
-- При создании установите его в состояние offline. 
-- Затем переведите табличное пространство в состояние online. 
-- Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
-- От имени пользователя XXX создайте таблицу в пространстве XXX_T1. 
-- В таблицу добавьте 3 строки.

create tablespace TDS_QDATA
    datafile 'TDS_QDATA.dbf'
    size 10M
    offline;

select TABLESPACE_NAME, STATUS, contents logging from SYS.DBA_TABLESPACES;

alter tablespace TDS_QDATA online;

alter user C##TDSCORE quota 2M on TDS_QDATA;

drop tablespace TDS_QDATA including contents;


connect C##TDSCORE;
create table tableTask11 (
    id number,
    name varchar(10)
) tablespace TDS_QDATA;

insert into tableTask11 values (1, 'one');
insert into tableTask11 values (2, 'two');
insert into tableTask11 values (3, 'three');

select * from tableTask11;
drop table tableTask11;
