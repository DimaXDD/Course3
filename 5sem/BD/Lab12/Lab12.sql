-- Пару моментов:
-- 1) Используем коннект, в котором работали в 8 лабе
-- 2) Скрипт создания и заполнения таблиц лежит в той же 8 лабе

-- 1. Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
create table STUDENT
(
  STUDENT      varchar(20) primary key,
  STUDENT_NAME varchar(100) unique,
  PULPIT       char(20),
  foreign key (PULPIT) references PULPIT (PULPIT)
);

-- 2. Заполните таблицу строками (10 шт.).
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S001', 'Иванов Иван', 'ИСиТ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S002', 'Петров Петр', 'ИСиТ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S003', 'Сидоров Алексей', 'ПОиСОИ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S004', 'Смирнов Николай', 'ЛВ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S005', 'Ильин Дмитрий', 'ОВ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S006', 'Морозова Ольга', 'ОВ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S007', 'Кузнецов Сергей', 'ЛУ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S008', 'Соловьев Денис', 'ЛПиСПС');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S009', 'Павлов Александр', 'ТЛ');
INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S010', 'Игнатов Игорь', 'ЛМиЛЗ');

select * from STUDENT;
drop table STUDENT;

-- При создании пользователя TDS не была прописана роль, связанная с функциями
-- Ниже будет код из 7 лабы, выполните только то, что я добавил (думаю понятно что):
-- !!! Роли делаем под коннектом SYS, проверяем что все ок и переходим обратно на TDS
-- (коннект с 8 лабы)
GRANT CREATE SESSION TO TDS;
GRANT RESTRICTED SESSION TO TDS;
GRANT CREATE ANY TABLE TO TDS;
GRANT CREATE ANY VIEW TO TDS;
GRANT CREATE SEQUENCE TO TDS;
GRANT UNLIMITED TABLESPACE TO TDS;
GRANT CREATE CLUSTER TO TDS;
GRANT CREATE SYNONYM TO TDS;
GRANT CREATE PUBLIC SYNONYM TO TDS;
GRANT CREATE MATERIALIZED VIEW TO TDS;
GRANT CREATE ANY PROCEDURE TO TDS; -- из 10 лабы
GRANT CREATE TYPE TO TDS; -- из 10 лабы
GRANT CREATE TRIGGER TO TDS; -- нужно для этой лабы


-- 3. Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE.
drop trigger STUDENT_TRIGGER_OPERATORS_BEFORE;

create or replace trigger STUDENT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on STUDENT
begin
  dbms_output.put_line('STUDENT_TRIGGER OPERATORS BEFORE');
end;

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S011', 'Трубач Дмитрий', 'ИСиТ');

delete from STUDENT where STUDENT = 'S011';

-- 4. Этот и все последующие триггеры должны выдавать сообщение на серверную консоль (DMS_OUTPUT) со своим собственным именем.

-- 5. Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
drop trigger STUDENT_TRIGGER_ROW_BEFORE;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  dbms_output.put_line('STUDENT_TRIGGER ROW BEFORE');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0; -- просто чтобы триггер сработал 10 раз

-- 6. Примените предикаты INSERTING, UPDATING и DELETING.
drop trigger STUDENT_TRIGGER_ROW_BEFORE;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  if inserting then
    dbms_output.put_line('STUDENT_TRIGGER ROW INSERTING BEFORE');
  elsif updating then
    dbms_output.put_line('STUDENT_TRIGGER ROW UPDATING BEFORE');
  elsif deleting then
    dbms_output.put_line('STUDENT_TRIGGER ROW DELETING BEFORE');
  end if;
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S011', 'Трубач Дмитрий', 'ИСиТ');

delete from STUDENT where STUDENT = 'S011';

-- 7. Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
drop trigger STUDENT_TRIGGER_OPERATORS_AFTER;

create or replace trigger STUDENT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on STUDENT
begin
  dbms_output.put_line('STUDENT_TRIGGER OPERATORS AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0; -- выполнится один раз в конце

-- 8. Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.
drop trigger STUDENT_TRIGGER_ROW_AFTER;

create or replace trigger STUDENT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on STUDENT
  for each row
begin
  dbms_output.put_line('STUDENT_TRIGGER ROW AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;

-- Короче, если вы посмотрите на каждый триггер отдельно, то можно сказать так,
-- триггеры BEFORE срабатывают до выполнения операции (insert, delete или update), 
-- а триггеры AFTER срабатывают после выполнения операции.
-- !!! Наглядно это видно, если оставить только триггеры из 3, 7 и 8 задания
-- и сделать вставку в таблицу

-- 9. Создайте таблицу с именем AUDIT. Таблица должна содержать поля: 
-- OperationDate,
-- OperationType (операция вставки, обновления и удаления),
-- TriggerName(имя триггера),
-- Data (строка с значениями полей до и после операции).

create table AUDIT_LOG
(
  OperationDate date,
  OperationType varchar(100),
  TriggerName   varchar(100)
);

-- 10. Измените триггеры таким образом, чтобы они регистрировали все операции 
-- с исходной таблицей в таблице AUDIT.
drop trigger STUDENT_TRIGGER_OPERATORS_BEFORE;
drop trigger STUDENT_TRIGGER_ROW_BEFORE;
drop trigger STUDENT_TRIGGER_OPERATORS_AFTER;
drop trigger STUDENT_TRIGGER_ROW_AFTER;

create or replace trigger STUDENT_TRIGGER_OPERATORS_BEFORE
  before insert or delete or update
  on STUDENT
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER OPERATORS BEFORE', 'STUDENT_TRIGGER_OPERATORS_BEFORE');
end;

create or replace trigger STUDENT_TRIGGER_ROW_BEFORE
  before insert or delete or update
  on STUDENT
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER ROW BEFORE', 'STUDENT_TRIGGER_ROW_BEFORE');
end;

create or replace trigger STUDENT_TRIGGER_OPERATORS_AFTER
  after insert or delete or update
  on STUDENT
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER OPERATORS AFTER', 'STUDENT_TRIGGER_OPERATORS_AFTER');
end;

create or replace trigger STUDENT_TRIGGER_ROW_AFTER
  after insert or delete or update
  on STUDENT
  for each row
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_TRIGGER ROW AFTER', 'STUDENT_TRIGGER_ROW_AFTER');
end;

update STUDENT set STUDENT_NAME = STUDENT_NAME where 0 = 0;
select * from AUDIT_LOG;
truncate table AUDIT_LOG; -- очисчит таблицу без удаления           WOW :)

-- 11. Выполните операцию, нарушающую целостность таблицы по первичному ключу. 
-- Выясните, зарегистрировал ли триггер это событие. Объясните результат.

INSERT INTO STUDENT (STUDENT, STUDENT_NAME, PULPIT)
VALUES ('S001', 'Иванов Иван', 'ИСиТ');

select * from DBA_TRIGGERS where OWNER = 'TDS'; -- от коннекта SYS
select * from AUDIT_LOG;

-- 12. Удалите (drop) исходную таблицу. Объясните результат. 
-- Добавьте триггер, запрещающий удаление исходной таблицы.

drop table STUDENT;

flashback table STUDENT to before drop;

select * from STUDENT;

create or replace trigger BEFORE_DROP
  before drop on TDS.SCHEMA
begin
  if ORA_DICT_OBJ_NAME <> 'STUDENT' then
    return;
  end if;

  raise_application_error(-20001, 'Нельзя удалять таблицу STUDENT');
end;

-- 13. Удалите (drop) таблицу AUDIT. 
-- Просмотрите состояние триггеров с помощью SQL-DEVELOPER. 
-- Объясните результат. Измените триггеры.

drop table AUDIT_LOG;
flashback table AUDIT_LOG to before drop;
select TRIGGER_NAME, STATUS from USER_TRIGGERS;

-- 14. Создайте представление над исходной таблицей. 
-- Разработайте INSTEADOF INSERT-триггер. 
-- Триггер должен добавлять строку в таблицу.
drop trigger STUDENT_VIEW_TRIGGER;

create view STUDENT_VIEW
as
select * from STUDENT;

create or replace trigger STUDENT_VIEW_TRIGGER
  instead of insert on STUDENT_VIEW
begin
  insert into AUDIT_LOG values (sysdate, 'STUDENT_VIEW_TRIGGER', 'STUDENT_VIEW_TRIGGER');
  insert into STUDENT values (:new.STUDENT, :new.STUDENT_NAME, :new.PULPIT);
end;

INSERT INTO STUDENT_VIEW (STUDENT, STUDENT_NAME, PULPIT) 
VALUES ('S018', 'Песецкий Илья', 'ИСиТ');
delete from STUDENT where STUDENT = 'S018';

select * from STUDENT;
select * from AUDIT_LOG;
truncate table AUDIT_LOG;

-- 15. Продемонстрируйте, в каком порядке выполняются триггеры.

-- Было описано между 8 и 9 заданием