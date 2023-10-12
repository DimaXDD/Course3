-- 1. Получите список всех файлов табличных пространств (перманентных  и временных).
select * from DBA_TABLESPACES;

-- 2. Создайте табличное пространство с именем XXX_QDATA (10m). 
-- При создании установите его в состояние offline. 
-- Затем переведите табличное пространство в состояние online. 
-- Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA. 
-- От имени XXX в  пространстве XXX_T1создайте таблицу из двух столбцов, 
-- один из которых будет являться первичным ключом. В таблицу добавьте 3 строки.

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

-- 3. Получите список сегментов табличного пространства  XXX_QDATA. 
-- Определите сегмент таблицы XXX_T1. Определите остальные сегменты.
select * from dba_segments where tablespace_name = 'TDS_QDATA';

--4
drop table TDS_T1;
-- Если по простому, то тут хранится "мусор", т.е. то, что мы удаляем
-- Можно привести пример аналогии корзины в компьютере
select * from dba_segments where tablespace_name = 'TDS_QDATA';
select * from USER_RECYCLEBIN;

-- 5. Восстановите (FLASHBACK) удаленную таблицу. 

-- Если таблица была удалена дважды, то восстановится информацию о последнем удалении
-- Можно проверить, удалив таблицу без данных, а пото создав такую же, заполнить данными
-- и удалить её

flashback table TDS_T1 to before drop;

-- 6. Выполните PL/SQL-скрипт, заполняющий таблицу XXX_T1 данными (10000 строк). 

declare
    i integer := 4;
begin
    while i < 10004 loop
        insert into TDS_T1(x, y) values (i, i);
        i := i + 1;
    end loop;
end;

select count(*) from TDS_T1;

-- 7. Определите сколько в сегменте таблицы XXX_T1 экстентов, их размер в блоках и байтах. 
-- Получите перечень всех экстентов. 
select extents, bytes, blocks from dba_segments where segment_name = 'TDS_T1';
select * from dba_extents where segment_name = 'TDS_T1';

-- 8. Удалите табличное пространство XXX_QDATA и его файл. 
drop tablespace TDS_QDATA including contents and datafiles;

-- [здесь и далее — SYS connection]
-- 9. Получите перечень всех групп журналов повтора. Определите текущую группу журналов повтора.

-- Вывело 1 2 3 - это означает, что в БД есть три группы журналов (log groups) 
-- с номерами 1, 2 и 3.
select group# from v$logfile;
-- Текущий - 1
select group# from v$log where status = 'CURRENT';

-- 10. Получите перечень файлов всех журналов повтора инстанса.
select member from v$logfile;

-- 11. EX. С помощью переключения журналов повтора пройдите полный цикл переключений. 
-- Запишите серверное время в момент вашего первого переключения (оно понадобится для выполнения следующих заданий).

-- Нужно просто пройти путь изменения статуса
select group#, status from v$log;
alter system switch logfile; -- выполнить 2 раза и следить, где в v$log status = 'CURRENT'
select TO_CHAR(SYSDATE, 'HH24:MI DD MONTH YYYY') as current_date from DUAL;
--18:19 11 ОКТЯБРЬ  2023
select group# from v$log where status = 'CURRENT';

-- 12. EX. Создайте дополнительную группу журналов повтора с тремя файлами журнала. 
-- Убедитесь в наличии группы и файлов, а также в работоспособности группы (переключением). 
-- Проследите последовательность SCN. 
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


-- 13. EX. Удалите созданную группу журналов повтора. Удалите созданные вами файлы журналов на сервере.
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_3.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_2.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_1.LOG';
alter database drop logfile group 4;

-- 14. Определите, выполняется или нет архивирование журналов повтора 
-- (архивирование должно быть отключено, иначе дождитесь, пока другой студент выполнит задание и отключит).

-- Должны быть значения: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

-- 15. Определите номер последнего архива.
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

-- 17. EX. Принудительно создайте архивный файл. Определите его номер. 
-- Определите его местоположение и убедитесь в его наличии. 
-- Проследите последовательность SCN в архивах и журналах повтора. 

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

-- 19. Получите список управляющих файлов.
select * from V$CONTROLFILE;

-- 20. Получите и исследуйте содержимое управляющего файла. Поясните известные вам параметры в файле.

-- Путь C:\ORACLEDB\ORADATA\ORCL\CONTROL01.CTL, 
--      C:\ORACLEDB\ORADATA\ORCL\CONTROL02.CTL 
show parameter control_files; -- в sqlplus, но можно и тут
select * from V$CONTROLFILE_RECORD_SECTION;

-- 21. Определите местоположение файла параметров инстанса. Убедитесь в наличии этого файла.
-- Путь C:\WINDOWS.X64_193000_DB_HOME\DATABASE\SPFILEORCL.ORA
show parameter pfile;
--select NAME, DESCRIPTION from V$PARAMETER;

-- 22. Сформируйте PFILE с именем XXX_PFILE.ORA. 
-- Исследуйте его содержимое. Поясните известные вам параметры в файле.

-- Путь C:\WINDOWS.X64_193000_db_home\database\TDS_PFILE.ora
create pfile = 'TDS_PFILE.ora' from spfile;

-- 23. Определите местоположение файла паролей инстанса. Убедитесь в наличии этого файла.

select * from V$PWFILE_USERS;     -- пользователи и их роли в файле паролей
show parameter remote_login_passwordfile;   -- exclusive/shared/none

-- 24. Получите перечень директориев для файлов сообщений и диагностики.
-- Файл сообщений (протоколы работы, дампы, трассировки)
select * from V$DIAG_INFO;

-- 25. Найдите и исследуйте содержимое протокола работы инстанса (LOG.XML), 
-- найдите в нем команды переключения журналов которые вы выполняли.
-- Смотри скрины 25_1, 25_2
-- C:\app\oraora\diag\rdbms\orcl\orcl\alert\log.xml