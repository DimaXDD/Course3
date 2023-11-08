create table AUDITORIUM_TYPE (
  AUDITORIUM_TYPE varchar(20) primary key,
  AUDIOTRIUM_TYPENAME varchar(100) unique
);

create table AUDITORIUM (
  AUDITORIUM varchar(20) primary key,
  AUDITORIUM_NAME varchar(100) unique,
  AUDITORIUM_CAPACITY int,
  AUDITORIUM_TYPE varchar(20),
  foreign key (AUDITORIUM_TYPE) references AUDITORIUM_TYPE(AUDITORIUM_TYPE)
);

create table FACULTY (
  FACULTY varchar(20) primary key,
  FACULTY_NAME varchar(100) unique
);

create table PULPIT (
  PULPIT varchar(20) primary key,
  PULPIT_NAME varchar(100) unique,
  FACULTY varchar(20),
  foreign key (FACULTY) references FACULTY(FACULTY)
);

create table TEACHER (
  TEACHER varchar(20) primary key,
  TEACHER_NAME varchar(100) unique,
  PULPIT varchar(20),
  foreign key (PULPIT) references PULPIT(PULPIT)
);

create table SUBJECT (
  SUBJECT varchar(20) primary key,
  SUBJECT_NAME varchar(100) unique,
  PULPIT varchar(20),
  foreign key (PULPIT) references PULPIT(PULPIT)
);

-- Заполняем таблицу AUDITORIUM_TYPE
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDIOTRIUM_TYPENAME)
VALUES ('Lecture', 'Лекционная аудитория');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDIOTRIUM_TYPENAME)
VALUES ('Laboratory', 'Лаборатория');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDIOTRIUM_TYPENAME)
VALUES ('Auditorium', 'Аудитория');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDIOTRIUM_TYPENAME)
VALUES ('Seminar', 'Семинарская комната');
INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDIOTRIUM_TYPENAME)
VALUES ('Conference', 'Конференц-зал');

-- Заполняем таблицу AUDITORIUM
-- Здесь предполагается, что у вас есть реальные данные об аудиториях
-- Пример:
-- INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
-- VALUES ('A101', 'Аудитория 101', 100, 'Auditorium');
-- ...

-- Заполняем таблицу FACULTY
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('F001', 'Факультет информатики');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('F002', 'Факультет естественных наук');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('F003', 'Факультет искусств');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('F004', 'Факультет экономики');
INSERT INTO FACULTY (FACULTY, FACULTY_NAME)
VALUES ('F005', 'Факультет медицины');



-- Заполняем таблицу PULPIT
-- Здесь также предполагается, что у вас есть реальные данные о кафедрах и факультетах
-- Пример:
INSERT INTO PULPIT (PULPIT, PULPIT_NAME, FACULTY)
VALUES ('P001', 'Кафедра информационных технологий', 'F001');
-- ...

-- Заполняем таблицу TEACHER
-- Примеры:
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('T001', 'Иванов Иван Иванович', 'P001');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('T002', 'Петров Петр Петрович', 'P001');
INSERT INTO TEACHER (TEACHER, TEACHER_NAME, PULPIT)
VALUES ('T003', 'Сидорова Екатерина Владимировна', 'P001');
-- ...

-- Заполняем таблицу SUBJECT
-- Примеры:

INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('S001', 'Программирование', 'P001');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('S002', 'Биология', 'P001');
INSERT INTO SUBJECT (SUBJECT, SUBJECT_NAME, PULPIT)
VALUES ('S003', 'Искусствоведение', 'P001');

-- ...


-- 1. Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов.

DECLARE
BEGIN
  NULL;
END;
/

-- 2. Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.

DECLARE
BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello World!');
END;
/

-- 3. Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.

DECLARE
  v_num NUMBER;
BEGIN
  v_num := 1/0;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
end;
/

-- 4. Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.

DECLARE
  v_num NUMBER;
BEGIN
  declare
  begin
    v_num := 1/0;
  exception
    when others then
      dbms_output.put_line('Error: ' || sqlerrm);
      dbms_output.put_line('Error code: ' || sqlcode);
  end;
  dbms_output.put_line('Hello World!');
end;

-- 5. Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.

select
  type,
  value
from
  v_$parameter
where
  name = 'plsql_warnings';

-- 6. Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.

select
  keyword
from
  V_$RESERVED_WORDS
where
  LENGTH = 1 and
  KEYWORD <> 'A';

-- 7. Разработайте скрипт, позволяющий просмотреть все ключевые слова PL/SQL.

select
  keyword
from
  V_$RESERVED_WORDS
where
  LENGTH > 1 and
  keyword <> 'A'
order by keyword;

-- 8. Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL. 
-- Просмотрите эти же параметры с помощью SQL+-команды show.
select
  name,
  value
from
  v_$parameter
where
  name like 'plsql%';

-- 9. Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):

-- 10. объявление и инициализацию целых number-переменных;

DECLARE
  v_num1 NUMBER := 1;
  v_num2 INTEGER := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 11. арифметические действия над двумя целыми number-переменных, включая деление с остатком;

DECLARE
  v_num1 NUMBER := 1;
  v_num2 NUMBER(3) := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1 + v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 - v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 * v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 / v_num2);
  DBMS_OUTPUT.PUT_LINE(v_num1 mod v_num2);
END;

-- 12. объявление и инициализацию number-переменных с фиксированной точкой;

DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, 1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 13. объявление и инициализацию number-переменных с фиксированной точкой и отрицательным масштабом 
-- (округление);

DECLARE
  v_num1 NUMBER := 1.1;
  v_num2 NUMBER(3, -1) := 2.2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 14. объявление и инициализацию BINARY_FLOAT-переменной;

DECLARE
  v_num BINARY_FLOAT := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
end;

-- 15. объявление и инициализацию BINARY_DOUBLE-переменной;

DECLARE
  v_num BINARY_DOUBLE := 1.1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num);
END;

-- 16. объявление number-переменных с точкой и применением символа E (степень 10) 
-- при инициализации/присвоении;

DECLARE
  v_num1 NUMBER := 1.1E1;
  v_num2 NUMBER := 1.1E-1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_num1);
  DBMS_OUTPUT.PUT_LINE(v_num2);
END;

-- 17. объявление и инициализацию BOOLEAN-переменных

DECLARE
  v_bool BOOLEAN := TRUE;
BEGIN
  IF v_bool THEN
    DBMS_OUTPUT.PUT_LINE('TRUE');
  ELSE
    DBMS_OUTPUT.PUT_LINE('FALSE');
  END IF;
END;

-- 18. Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER). 
-- Продемонстрируйте возможные операции константами.

DECLARE
  VCHAR_CONST CONSTANT VARCHAR2(20) := 'VCHAR_CONST';
  CHAR_CONST CONSTANT CHAR(20) := 'CHAR_CONST';
  NUMBER_CONST CONSTANT NUMBER := 1;
BEGIN
  DBMS_OUTPUT.PUT_LINE(VCHAR_CONST);
  DBMS_OUTPUT.PUT_LINE(CHAR_CONST);
  DBMS_OUTPUT.PUT_LINE(NUMBER_CONST);
END;

-- 19. Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.

DECLARE
  VCHAR_CONST CONSTANT VARCHAR2(20) := 'VCHAR_CONST';
  CHAR_CONST CONSTANT CHAR(20) := 'CHAR_CONST';
  NUMBER_CONST CONSTANT NUMBER := 1;
  VCHAR_CONST2 VCHAR_CONST%TYPE := 'VCHAR_CONST2';
  CHAR_CONST2 CHAR_CONST%TYPE := 'CHAR_CONST2';
  NUMBER_CONST2 NUMBER_CONST%TYPE := 2;
BEGIN
  DBMS_OUTPUT.PUT_LINE(VCHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(CHAR_CONST2);
  DBMS_OUTPUT.PUT_LINE(NUMBER_CONST2);
END;

-- 20. Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.

DECLARE
  AUDITORIUM_TYPE_ROW AUDITORIUM_TYPE%ROWTYPE;
BEGIN
  AUDITORIUM_TYPE_ROW.AUDIOTRIUM_TYPENAME := 'Аудитория';
  AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE := 'Auditorium';

  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDITORIUM_TYPE);
  DBMS_OUTPUT.PUT_LINE(AUDITORIUM_TYPE_ROW.AUDIOTRIUM_TYPENAME);
end;

-- 21. Разработайте АБ, демонстрирующий все возможные конструкции оператора IF.

DECLARE
  v_num NUMBER := 1;
BEGIN
  IF v_num = 1 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 1');
  ELSIF v_num = 2 THEN
    DBMS_OUTPUT.PUT_LINE('v_num = 2');
  ELSIF v_num is null THEN
    DBMS_OUTPUT.PUT_LINE('v_num is null');
  ELSE
    DBMS_OUTPUT.PUT_LINE('v_num = 3');
  END IF;
END;

-- 22. Разработайте АБ, демонстрирующий все возможные конструкции оператора IF.
-- Повтор 21 )))

-- 23. Разработайте АБ, демонстрирующий работу оператора CASE.

DECLARE
  v_num NUMBER := 1;
BEGIN
  CASE v_num
    WHEN 1 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 1');
    WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 2');
    WHEN 3 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 3');
    ELSE
      DBMS_OUTPUT.PUT_LINE('v_num is null');
  END CASE;
END;

-- 24. Разработайте АБ, демонстрирующий работу оператора LOOP.

DECLARE
  v_num NUMBER := 1;
BEGIN
  CASE v_num
    WHEN 1 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 1');
    WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 2');
    WHEN 3 THEN
      DBMS_OUTPUT.PUT_LINE('v_num = 3');
    ELSE
      DBMS_OUTPUT.PUT_LINE('v_num is null');
  END CASE;
END;

-- 25. Разработайте АБ, демонстрирующий работу оператора WHILE.

DECLARE
  v_num NUMBER := 1;
BEGIN
  WHILE v_num <= 10 LOOP
    DBMS_OUTPUT.PUT_LINE(v_num);
    v_num := v_num + 1;
  END LOOP;
END;

-- 26. Разработайте АБ, демонстрирующий работу оператора FOR.

DECLARE
  v_num NUMBER := 1;
BEGIN
  FOR i IN 1..10 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;