--1
select * from DBA_TABLESPACES;

--2
--drop tablespace TDS_QDATA including contents and datafiles;

create tablespace TDS_QDATA
    datafile 'TDS_QDATA.dbf'
    size 10M
    autoextend on
    next 5M
    maxsize 20M
    offline;

alter tablespace TDS_QDATA online;
select tablespace_name, status, contents logging from SYS.DBA_TABLESPACES;
alter user C##TDS quota 2m on TDS_QDATA;

-- Для проверки квоты
select tablespace_name, bytes, max_bytes
from dba_ts_quotas
where tablespace_name = 'TDS_QDATA'
and username = 'C##TDS';

-- переключение на C##TDS (pass 111, юзера создавли в 3 лабе)
select * from dba_users;

-- Если не создается, значит вы не удалили такую же таблицу с первой лабы
-- (как я)
create table TDS_T1 (
    x integer primary key,
    y integer
) tablespace TDS_QDATA;

insert into TDS_T1(x, y) values (1, 2);
insert into TDS_T1(x, y) values (2, 3);
insert into TDS_T1(x, y) values (3, 4);

select * from TDS_T1;

--3
select * from dba_segments where tablespace_name = 'TDS_QDATA';

--4
drop table TDS_T1;
-- Если по простому, то тут хранится "мусор", т.е. то, что мы удаляем
-- Можно привести пример аналогии корзины в компьютере
select * from dba_segments where tablespace_name = 'TDS_QDATA';
select * from USER_RECYCLEBIN;

--5
-- Если таблица была удалена дважды, то восстановится информацию о последнем удалении
-- Можно проверить, удалив таблицу без данных, а пото создав такую же, заполнить данными
-- и удалить её
flashback table TDS_T1 to before drop;

--6

declare
    i integer := 4;
begin
    while i < 10004 loop
        insert into TDS_T1(x, y) values (i, i);
        i := i + 1;
    end loop;
end;

select count(*) from TDS_T1;

--7
select extents, bytes, blocks from dba_segments where segment_name = 'TDS_T1';
select * from dba_extents where segment_name = 'TDS_T1';

--8
drop tablespace TDS_QDATA including contents and datafiles;

--9  [здесь и далее — SYS connection]
-- Вывело 1 2 3 - это означает, что в БД есть три группы журналов (log groups) 
-- с номерами 1, 2 и 3.
select group# from v$logfile;
-- Текущий - 1
select group# from v$log where status = 'CURRENT';

--10
select member from v$logfile;

--11 (EX)
-- Нужно просто пройти путь изменения статуса
select group#, status from v$log;
alter system switch logfile; -- выполнить 2 раза и следить, где в v$log status = 'CURRENT'
select TO_CHAR(SYSDATE, 'HH24:MI DD MONTH YYYY') as current_date from DUAL;
--18:19 11 ОКТЯБРЬ  2023
select group# from v$log where status = 'CURRENT';

--12 (EX)
alter database add logfile 
    group 4 
    'C:\OracleDB\oradata\ORCL\REDO04.LOG'
    size 50m 
    blocksize 512;

-- Проверка
select group# from v$logfile;

alter database add logfile 
    member 
    'C:\OracleDB\oradata\ORCL\REDO04_1.LOG' 
    to group 4;
    
alter database add logfile 
    member 
    'C:\OracleDB\oradata\ORCL\REDO04_2.LOG' 
    to group 4;
    
alter database add logfile 
    member 
    'C:\OracleDB\oradata\ORCL\REDO04_3.LOG' 
    to group 4;
    
    
select * from V$LOG order by GROUP#;
select * from V$LOGFILE order by GROUP#;
-- Переход будет кривым, смотрите на каждый шаг
alter system switch logfile;
select group#, status from V$LOG;
select group# from V$LOG where status = 'CURRENT';


--13 (не работает)
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_3.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_2.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_1.LOG';
alter database drop logfile group 4;

--14
-- Должны быть значения: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--15
select * from V$ARCHIVED_LOG;

--16
-- Включить архивирование
-- Заходим в SQLPLUS:
-- connect /as sysdba (или sys /as sysdba);
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;

-- Теперь будут значения: LOG_MODE = ARCHIVELOG; ARCHIVER = STARTED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--17 
-- Теперь тут должны появиться файлы архивации
-- (для их создания можно просто переключиться между 
-- журналами повтора и файлы автоматически создадутся)
alter system switch logfile;
select group# from V$LOG where status = 'CURRENT';
select * from V$ARCHIVED_LOG;

--18
-- Выключить архивирование
-- Заходим в SQLPLUS:
-- connect /as sysdba (или sys /as sysdba);
-- shutdown immediate;
-- startup mount;
-- alter database noarchivelog;
-- alter database open;

-- Теперь опять будут значения: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, name, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--19
-- Список управляющих файлов
select * from V$CONTROLFILE;

--20
-- Параметры управляющего файла
-- Путь C:\ORACLEDB\ORADATA\ORCL\CONTROL01.CTL, 
--      C:\ORACLEDB\ORADATA\ORCL\CONTROL02.CTL 
show parameter control_files; -- в sqlplus, но можно и тут
select * from V$CONTROLFILE_RECORD_SECTION;

--21
-- Путь C:\WINDOWS.X64_193000_DB_HOME\DATABASE\SPFILEORCL.ORA
show parameter pfile;
--select NAME, DESCRIPTION from V$PARAMETER;

--22
-- Путь C:\WINDOWS.X64_193000_db_home\database\TDS_PFILE.ora
create pfile = 'TDS_PFILE.ora' from spfile;

--23
-- Файл паролей
select * from V$PWFILE_USERS;     -- пользователи и их роли в файле паролей
show parameter remote_login_passwordfile;   -- exclusive/shared/none

--24
-- Файл сообщений (протоколы работы, дампы, трассировки)
select * from V$DIAG_INFO;

--25
-- Смотри скрины 25_1, 25_2
-- C:\app\oraora\diag\rdbms\orcl\orcl\alert\log.xml