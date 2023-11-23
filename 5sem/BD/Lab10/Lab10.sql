-- Пару моментов:
-- 1) Используем коннект, в котором работали в 8 лабе
-- 2) Скрипт создания и заполнения таблиц лежит в той же 8 лабе

alter pluggable database TDS_PDB open;

-- 1. Добавьте в таблицу TEACHER два столбца BIRTHDAY (рандомная дата) и SALARY, заполните их значениями.
   
ALTER TABLE TEACHER
ADD (BIRTHDAY DATE, SALARY NUMBER);

UPDATE TEACHER
SET BIRTHDAY = TRUNC(SYSDATE) - FLOOR(DBMS_RANDOM.VALUE(365*23, 365*3)),
    SALARY = FLOOR(DBMS_RANDOM.VALUE(30000, 80000));


ALTER TABLE TEACHER
DROP COLUMN BIRTHDAY;

ALTER TABLE TEACHER
DROP COLUMN SALARY;

  
select * from TEACHER;

-- 2. Получите список преподавателей в виде Фамилия И.О.

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
GRANT CREATE ANY PROCEDURE TO TDS; -- !!! нужно будет добавить эту команду

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'TDS'; -- заменить в 7 лабе эту строчку

CREATE OR REPLACE FUNCTION GET_FIO(TEACHER_NAME VARCHAR2)
    RETURN VARCHAR2
IS
    FIO VARCHAR2(200);
BEGIN
    FIO := SUBSTR(TEACHER_NAME, 1, INSTR(TEACHER_NAME, ' ') - 1) || ' ' ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ') + 1, 1) || '.' ||
                 SUBSTR(TEACHER_NAME, INSTR(TEACHER_NAME, ' ', 1, 2) + 1, 1) || '.';

    RETURN FIO;
END;

select GET_FIO(TEACHER_NAME), BIRTHDAY
from TEACHER;

-- 3. Получите список преподавателей, родившихся в понедельник.
SELECT TEACHER_NAME, BIRTHDAY FROM TEACHER
WHERE TO_CHAR(BIRTHDAY, 'D') = '1';

-- 4. Создайте представление, в котором поместите список преподавателей, 
-- которые родились в следующем месяце.
create view TEACHERS_NEXT_MONTH as
select GET_FIO(TEACHER_NAME) as TEACHER_NAME, -- используем функции с ФИО
       to_char(BIRTHDAY, 'DD.MM.YYYY')   as BIRTHDAY
from teacher
where to_char(BIRTHDAY, 'MM') = to_char(sysdate, 'MM') + 1;

select * from TEACHERS_NEXT_MONTH;

-- 5. Создайте представление, в котором поместите количество преподавателей, 
-- которые родились в каждом месяце.
drop table MONTHS;

create table MONTHS
(
  month_name   varchar(20),
  month_number varchar(2)
);


insert into MONTHS (month_name, month_number)
values ('Январь', '01');
insert into MONTHS (month_name, month_number)
values ('Февраль', '02');
insert into MONTHS (month_name, month_number)
values ('Март', '03');
insert into MONTHS (month_name, month_number)
values ('Апрель', '04');
insert into MONTHS (month_name, month_number)
values ('Май', '05');
insert into MONTHS (month_name, month_number)
values ('Июнь', '06');
insert into MONTHS (month_name, month_number)
values ('Июль', '07');
insert into MONTHS (month_name, month_number)
values ('Август', '08');
insert into MONTHS (month_name, month_number)
values ('Сентябрь', '09');
insert into MONTHS (month_name, month_number)
values ('Октябрь', '10');
insert into MONTHS (month_name, month_number)
values ('Ноябрь', '11');
insert into MONTHS (month_name, month_number)
values ('Декабрь', '12');

create view TEACHER_COUNT_BY_MONTH as
select month_name,
       (select count(*) from TEACHER where to_char(birthday, 'MM') = month_number) as count
from MONTHS;

select * from TEACHER_COUNT_BY_MONTH;
select SUM(COUNT) from TEACHER_COUNT_BY_MONTH;
select COUNT(*) from TEACHER;

-- 6. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.
declare
  cursor c1 is
    select GET_FIO(TEACHER_NAME) as teacher_name,
           to_char(BIRTHDAY, 'DD.MM.YYYY')   as birthday
    from TEACHER
    where MOD((to_number(to_char(sysdate, 'YYYY')) - to_number(to_char(BIRTHDAY, 'YYYY')) + 1), 5) = 0;
begin
  for i in c1
    loop
      dbms_output.put_line(i.teacher_name || ' ' || i.birthday);
    end loop;
end;

-- 7. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых,
-- вывести средние итоговые значения для каждого факультета и для всех факультетов в целом.
select * from TEACHER;
select * from FACULTY;

DECLARE
  CURSOR c_average_salary IS
    SELECT P.FACULTY, AVG(T.SALARY) AS AVERAGE_SALARY
    FROM TEACHER T
    INNER JOIN PULPIT P ON T.PULPIT = P.PULPIT
    GROUP BY P.FACULTY;

  v_faculty CHAR(20);
  v_average_salary NUMBER; -- среднее по одному факультету
  v_count_faculty NUMBER; -- кол-во факультетов
  v_total_average_salary NUMBER := 0;
  v_average_salary_all_faculty NUMBER; -- среднее по всем факультетам
BEGIN
  OPEN c_average_salary;
  
  DBMS_OUTPUT.PUT_LINE('Average Salary by Faculty:');
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  
  LOOP
    FETCH c_average_salary INTO v_faculty, v_average_salary;
    EXIT WHEN c_average_salary%NOTFOUND;
    
    SELECT COUNT(*) INTO v_count_faculty FROM FACULTY;
    v_total_average_salary := v_total_average_salary + v_average_salary;
    v_average_salary_all_faculty := v_total_average_salary / v_count_faculty;
    
    DBMS_OUTPUT.PUT_LINE('Faculty: ' || v_faculty || ', Average Salary: ' || FLOOR(v_average_salary));
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('-------------------------');
  DBMS_OUTPUT.PUT_LINE('Total: ' || FLOOR(v_total_average_salary));
  DBMS_OUTPUT.PUT_LINE('Total Average Salary: ' || FLOOR(v_average_salary_all_faculty));
  
  CLOSE c_average_salary;
END;

-- 8. Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним.
-- Продемонстрируйте работу с вложенными записями. Продемонстрируйте и объясните операцию присвоения.
select * from TEACHER;

-- Создание типа записи
CREATE OR REPLACE TYPE teacher_record IS RECORD (
  teacher VARCHAR2(20),
  teacher_name VARCHAR2(200),
  pulpit CHAR(20)
);

-- Создание процедуры для демонстрации работы с типом записи
CREATE OR REPLACE PROCEDURE demonstrate_record AS
  -- Объявление переменной типа записи
  t teacher_record;
BEGIN
  -- Присвоение значений переменной типа записи
  t.teacher := 'СМЛВ';
  t.teacher_name := 'Смелов Владимир Владиславович';
  t.pulpit := 'ИСиТ';

  -- Вывод значений переменной типа записи
  DBMS_OUTPUT.PUT_LINE('Teacher: ' || t.teacher);
  DBMS_OUTPUT.PUT_LINE('Teacher Name: ' || t.teacher_name);
  DBMS_OUTPUT.PUT_LINE('Pulpit: ' || t.pulpit);
END;


-- Вызов процедуры для демонстрации работы с типом записи
BEGIN
  demonstrate_record;
END;
