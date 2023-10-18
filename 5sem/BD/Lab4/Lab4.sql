-- 1. �������� ������ ���� ������ ��������� ����������� (������������  � ���������).
select * from DBA_TABLESPACES;

select TABLESPACE_NAME, FILE_NAME from SYS.DBA_DATA_FILES;
select TABLESPACE_NAME, FILE_NAME from SYS.DBA_TEMP_FILES;

-- 2. �������� ��������� ������������ � ������ XXX_QDATA (10m). 
-- ��� �������� ���������� ��� � ��������� offline. 
-- ����� ���������� ��������� ������������ � ��������� online. 
-- �������� ������������ XXX ����� 2m � ������������ XXX_QDATA. 
-- �� ����� XXX �  ������������ XXX_T1�������� ������� �� ���� ��������, 
-- ���� �� ������� ����� �������� ��������� ������. � ������� �������� 3 ������.

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

-- ��� �������� �����
select tablespace_name, bytes, max_bytes
from dba_ts_quotas
where tablespace_name = 'TDS_QDATA'
and username = 'C##TDS';

-- ������������ �� C##TDS (pass 111, ����� �������� � 3 ����)
select * from dba_users;

-- ���� �� ���������, ������ �� �� ������� ����� �� ������� � ������ ����
-- (��� �)
create table TDS_T1 (
    x integer primary key,
    y integer
) tablespace TDS_QDATA;

insert into TDS_T1(x, y) values (1, 2);
insert into TDS_T1(x, y) values (2, 3);
insert into TDS_T1(x, y) values (3, 4);

select * from TDS_T1;

-- 3. �������� ������ ��������� ���������� ������������  XXX_QDATA. 
-- ���������� ������� ������� XXX_T1. ���������� ��������� ��������.
select * from dba_segments where tablespace_name = 'TDS_QDATA';

--4
drop table TDS_T1;
-- ���� �� ��������, �� ��� �������� "�����", �.�. ��, ��� �� �������
-- ����� �������� ������ �������� ������� � ����������
select * from dba_segments where tablespace_name = 'TDS_QDATA';
select * from USER_RECYCLEBIN;

-- 5. ������������ (FLASHBACK) ��������� �������. 

-- ���� ������� ���� ������� ������, �� ������������� ���������� � ��������� ��������
-- ����� ���������, ������ ������� ��� ������, � ���� ������ ����� ��, ��������� �������
-- � ������� �

flashback table TDS_T1 to before drop;

-- 6. ��������� PL/SQL-������, ����������� ������� XXX_T1 ������� (10000 �����). 

declare
    i integer := 4;
begin
    while i < 10004 loop
        insert into TDS_T1(x, y) values (i, i);
        i := i + 1;
    end loop;
end;

select count(*) from TDS_T1;

-- 7. ���������� ������� � �������� ������� XXX_T1 ���������, �� ������ � ������ � ������. 
-- �������� �������� ���� ���������. 
select extents, bytes, blocks from dba_segments where segment_name = 'TDS_T1';
select * from dba_extents where segment_name = 'TDS_T1';

-- 8. ������� ��������� ������������ XXX_QDATA � ��� ����. 
drop tablespace TDS_QDATA including contents and datafiles;

-- [����� � ����� � SYS connection]
-- 9. �������� �������� ���� ����� �������� �������. ���������� ������� ������ �������� �������.

-- ������ 1 2 3 - ��� ��������, ��� � �� ���� ��� ������ �������� (log groups) 
-- � �������� 1, 2 � 3.
select group# from v$logfile;
-- ������� - 1
select group# from v$log where status = 'CURRENT';

-- 10. �������� �������� ������ ���� �������� ������� ��������.
select member from v$logfile;

-- 11. EX. � ������� ������������ �������� ������� �������� ������ ���� ������������. 
-- �������� ��������� ����� � ������ ������ ������� ������������ (��� ����������� ��� ���������� ��������� �������).

-- ����� ������ ������ ���� ��������� �������
select group#, status from v$log;
alter system switch logfile; -- ��������� 2 ���� � �������, ��� � v$log status = 'CURRENT'
select TO_CHAR(SYSDATE, 'HH24:MI DD MONTH YYYY') as current_date from DUAL;
--18:19 11 �������  2023
select group# from v$log where status = 'CURRENT';

-- 12. EX. �������� �������������� ������ �������� ������� � ����� ������� �������. 
-- ��������� � ������� ������ � ������, � ����� � ����������������� ������ (�������������). 
-- ���������� ������������������ SCN. 
alter database add logfile 
    group 4 
    'C:\OracleDB\oradata\ORCL\REDO04.LOG'
    size 50m 
    blocksize 512;

-- ��������
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
-- ������� ����� ������, �������� �� ������ ���
alter system switch logfile;
select group#, status from V$LOG;
select group# from V$LOG where status = 'CURRENT';


-- 13. EX. ������� ��������� ������ �������� �������. ������� ��������� ���� ����� �������� �� �������.
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_3.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_2.LOG';
alter database drop logfile member 'C:\OracleDB\oradata\ORCL\REDO04_1.LOG';
alter database drop logfile group 4;

-- 14. ����������, ����������� ��� ��� ������������� �������� ������� 
-- (������������� ������ ���� ���������, ����� ���������, ���� ������ ������� �������� ������� � ��������).

-- ������ ���� ��������: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

-- 15. ���������� ����� ���������� ������.
select * from V$ARCHIVED_LOG;

--16
-- �������� �������������
-- ������� � SQLPLUS:
-- connect /as sysdba (��� sys /as sysdba);
-- shutdown immediate;
-- startup mount;
-- alter database archivelog;
-- alter database open;

-- ������ ����� ��������: LOG_MODE = ARCHIVELOG; ARCHIVER = STARTED
select DBID, NAME, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

-- 17. EX. ������������� �������� �������� ����. ���������� ��� �����. 
-- ���������� ��� �������������� � ��������� � ��� �������. 
-- ���������� ������������������ SCN � ������� � �������� �������. 

-- ������ ��� ������ ��������� ����� ���������
-- (��� �� �������� ����� ������ ������������� ����� 
-- ��������� ������� � ����� ������������� ����������)
alter system switch logfile;
select group# from V$LOG where status = 'CURRENT';
select * from V$ARCHIVED_LOG;

--18
-- ��������� �������������
-- ������� � SQLPLUS:
-- connect /as sysdba (��� sys /as sysdba);
-- shutdown immediate;
-- startup mount;
-- alter database noarchivelog;
-- alter database open;

-- ������ ����� ����� ��������: LOG_MODE = NOARCHIVELOG; ARCHIVER = STOPPED
select DBID, name, LOG_MODE from V$DATABASE;
select INSTANCE_NAME, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

-- 19. �������� ������ ����������� ������.
select * from V$CONTROLFILE;

-- 20. �������� � ���������� ���������� ������������ �����. �������� ��������� ��� ��������� � �����.

-- ���� C:\ORACLEDB\ORADATA\ORCL\CONTROL01.CTL, 
--      C:\ORACLEDB\ORADATA\ORCL\CONTROL02.CTL 
show parameter control_files; -- � sqlplus, �� ����� � ���
select * from V$CONTROLFILE_RECORD_SECTION;

-- 21. ���������� �������������� ����� ���������� ��������. ��������� � ������� ����� �����.
-- ���� C:\WINDOWS.X64_193000_DB_HOME\DATABASE\SPFILEORCL.ORA
show parameter pfile;
--select NAME, DESCRIPTION from V$PARAMETER;

-- 22. ����������� PFILE � ������ XXX_PFILE.ORA. 
-- ���������� ��� ����������. �������� ��������� ��� ��������� � �����.

-- ���� C:\WINDOWS.X64_193000_db_home\database\TDS_PFILE.ora
create pfile = 'TDS_PFILE.ora' from spfile;

-- 23. ���������� �������������� ����� ������� ��������. ��������� � ������� ����� �����.
select * from V$PWFILE_USERS;     -- ������������ � �� ���� � ����� �������
show parameter remote_login_passwordfile;   -- exclusive/shared/none

-- 24. �������� �������� ����������� ��� ������ ��������� � �����������.
-- ���� ��������� (��������� ������, �����, �����������)
select * from V$DIAG_INFO;

-- 25. ������� � ���������� ���������� ��������� ������ �������� (LOG.XML), 
-- ������� � ��� ������� ������������ �������� ������� �� ���������.
-- ������ ������ 25_1, 25_2
-- C:\app\oraora\diag\rdbms\orcl\orcl\alert\log.xml