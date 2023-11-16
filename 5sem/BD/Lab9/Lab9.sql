-- 1) Используем коннект, в котором работали в 8 лабе
-- 2) Скрипт создания и заполнения таблиц лежит в той же 8 лабе

-- ============================================================

-- 1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой.

SELECT *
FROM AUDITORIUM_TYPE
WHERE AUDITORIUM_TYPE = 'ЛК';

-- 2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой. 
-- Используйте конструкцию WHEN OTHERS секции исключений и встроенную функции 
-- SQLERRM, SQLCODE для диагностирования неточной выборки.

DECLARE
  v_AUDITORIUM_TYPE     AUDITORIUM_TYPE.AUDITORIUM_TYPE%TYPE;
  v_AUDITORIUM_TYPENAME AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%TYPE;
BEGIN
  SELECT AUDITORIUM_TYPE,
         AUDITORIUM_TYPENAME
  INTO
    v_AUDITORIUM_TYPE,
    v_AUDITORIUM_TYPENAME
  FROM AUDITORIUM_TYPE;
  --WHERE AUDITORIUM_TYPE = 'ЛК';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM_TYPE: ' || v_AUDITORIUM_TYPE || ', AUDITORIUM_TYPENAME: ' || v_AUDITORIUM_TYPENAME);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS 
-- секции исключений для диагностирования неточной выборки.
-- Чтобы вызвать оишбку, вместе ЛК напишите ЛК-К
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  SELECT AUDITORIUM,
         AUDITORIUM_NAME,
         AUDITORIUM_CAPACITY
  INTO
    v_AUDITORIUM,
    v_AUDITORIUM_NAME,
    v_AUDITORIUM_CAPACITY
  FROM AUDITORIUM
  WHERE AUDITORIUM_TYPE = 'ЛК';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from AUDITORIUM;

-- 4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND. 
DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  SELECT AUDITORIUM,
         AUDITORIUM_NAME,
         AUDITORIUM_CAPACITY
  INTO
    v_AUDITORIUM,
    v_AUDITORIUM_NAME,
    v_AUDITORIUM_CAPACITY
  FROM AUDITORIUM
  WHERE AUDITORIUM_TYPE = 'ЛК-КККККК';

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 5. Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.
select * from AUDITORIUM;

DECLARE
  CURSOR auditorium_cursor IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE = 'ЛК';
    
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  -- Открываем неявный курсор
  OPEN auditorium_cursor;

  -- Используем атрибуты неявного курсора для обхода результатов
  LOOP
    FETCH auditorium_cursor INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN auditorium_cursor%NOTFOUND;

    -- Выводим информацию о каждой аудитории
    DBMS_OUTPUT.PUT_LINE('Аудитория: ' || v_AUDITORIUM);
    DBMS_OUTPUT.PUT_LINE('Название: ' || v_AUDITORIUM_NAME);
    DBMS_OUTPUT.PUT_LINE('Вместимость: ' || v_AUDITORIUM_CAPACITY);
    DBMS_OUTPUT.PUT_LINE('-------------------------');
  END LOOP;

  -- Закрываем курсор
  CLOSE auditorium_cursor;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Нет данных');
END;

-- 6. Разработайте АБ, демонстрирующий применение оператора UPDATE 
-- совместно с операторами COMMIT/ROLLBACK.
select * from AUDITORIUM;
update AUDITORIUM set AUDITORIUM_CAPACITY = 15 where AUDITORIUM = '206-1';

DECLARE
  v_old_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  v_new_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  -- Выводим текущую вместимость аудитории '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_old_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Текущая вместимость аудитории 206-1: ' || v_old_capacity);

  -- Изменяем вместимость аудитории '206-1' на 20
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 20
  WHERE AUDITORIUM = '206-1';

  -- Выводим новую вместимость аудитории '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Новая вместимость аудитории 206-1: ' || v_new_capacity);

  -- Коммит изменений
  COMMIT;

  -- Выводим обновленную вместимость аудитории '206-1' после коммита
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Обновленная вместимость аудитории 206-1 после коммита: ' || v_new_capacity);

  -- Изменяем вместимость аудитории '206-1' на 25
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 25
  WHERE AUDITORIUM = '206-1';

  -- Выводим новую вместимость аудитории '206-1'
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Новая вместимость аудитории 206-1: ' || v_new_capacity);

  -- Откат изменений
  ROLLBACK;

  -- Выводим вместимость аудитории '206-1' после отката
  SELECT AUDITORIUM_CAPACITY INTO v_new_capacity
  FROM AUDITORIUM
  WHERE AUDITORIUM = '206-1';

  DBMS_OUTPUT.PUT_LINE('Вместимость аудитории 206-1 после отката: ' || v_new_capacity);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
    -- Откат изменений в случае ошибки
    ROLLBACK;
END;

-- 7. Продемонстрируйте оператор UPDATE, вызывающий нарушение целостности в базе данных. 
-- Обработайте возникшее исключение.
select * from AUDITORIUM;

DECLARE
BEGIN
  UPDATE AUDITORIUM
  SET AUDITORIUM_CAPACITY = 'Аудитория'
  WHERE AUDITORIUM_CAPACITY = 90;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 8. Разработайте АБ, демонстрирующий применение оператора INSERT 
-- совместно с операторами COMMIT/ROLLBACK.
select * from AUDITORIUM;
delete from AUDITORIUM where AUDITORIUM = '111-1';

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('111-1', '111-1', 100, 'ЛК')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  COMMIT;

  INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE)
  VALUES ('112-1', '112-2', 100, 'ЛК')
  RETURNING AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;

  DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                       ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);

  ROLLBACK;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;


-- 9. Продемонстрируйте оператор INSERT, вызывающий нарушение целостности в базе данных. 
-- Обработайте возникшее исключение.
select * from AUDITORIUM;

DECLARE
BEGIN
insert into AUDITORIUM (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values ('429-4', '429-4', 'ЛК', 90);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 10. Разработайте АБ, демонстрирующий применение оператора DELETE 
-- совместно с операторами COMMIT/ROLLBACK.
DECLARE
  v_count_before NUMBER;
  v_count_after NUMBER;
BEGIN
  -- Получаем текущее количество записей в таблице
  SELECT COUNT(*) INTO v_count_before FROM AUDITORIUM;
  
  -- Выводим текущее количество записей
  DBMS_OUTPUT.PUT_LINE('Количество записей до удаления: ' || v_count_before);
  
  -- Удаляем записи из таблицы
  DELETE FROM AUDITORIUM WHERE AUDITORIUM_TYPE = 'ЛК';
  
  -- Получаем количество записей после удаления
  SELECT COUNT(*) INTO v_count_after FROM AUDITORIUM;
  
  -- Выводим количество записей после удаления
  DBMS_OUTPUT.PUT_LINE('Количество записей после удаления: ' || v_count_after);
  
  -- Если все прошло успешно, фиксируем изменения
  --COMMIT;
  
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('Изменения были откачены.');
  
EXCEPTION
  WHEN OTHERS THEN
    -- Если произошла ошибка, откатываем изменения
    ROLLBACK;
    
    DBMS_OUTPUT.PUT_LINE('Произошла ошибка. Изменения были отменены.');
END;

-- 11. Продемонстрируйте оператор DELETE, вызывающий нарушение целостности в базе данных. 
-- Обработайте возникшее исключение.
select * from AUDITORIUM_TYPE;

DECLARE
BEGIN
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК-ККККК';
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
    ROLLBACK;
end;

-- 12. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением 
-- явного курсора LOOP-цикла. Считанные данные должны быть записаны в переменные, 
-- объявленные с применением опции %TYPE.
select * from TEACHER;

DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  FOR i IN c_TEACHER
    LOOP
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      v_PULPIT := i.PULPIT;
      DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                           v_PULPIT);
    END LOOP;
end;

-- 13. Создайте АБ, распечатывающий таблицу SUBJECT с применением 
-- явного курсора и WHILE-цикла. 
-- Считанные данные должны быть записаны в запись (RECORD), объявленную с применением опции %ROWTYPE.
DECLARE
  v_SUBJECT SUBJECT%ROWTYPE;
  CURSOR c_SUBJECT IS
    SELECT *
    FROM SUBJECT;
BEGIN
  OPEN c_SUBJECT;
  WHILE TRUE
    LOOP
      FETCH c_SUBJECT INTO v_SUBJECT;
      EXIT WHEN c_SUBJECT%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('SUBJECT: ' || v_SUBJECT.SUBJECT || ', SUBJECT_NAME: ' || v_SUBJECT.SUBJECT_NAME ||
                           ', PULPIT: ' || v_SUBJECT.PULPIT);
    END LOOP;
end;

-- 14. Создайте АБ, распечатывающий все кафедры (таблица PULPIT) 
-- и фамилии всех преподавателей (TEACHER) использовав
-- соединение (JOIN) PULPIT и TEACHER и с применением явного курсора и FOR-цикла.
DECLARE
  v_PULPIT         PULPIT.PULPIT%TYPE;
  v_PULPIT_NAME    PULPIT.PULPIT_NAME%TYPE;
  v_FACULTY        PULPIT.FACULTY%TYPE;
  v_TEACHER        TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME   TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT_TEACHER PULPIT.PULPIT%TYPE;
  CURSOR c_PULPIT_TEACHER IS
    SELECT PULPIT.PULPIT,
           PULPIT.PULPIT_NAME,
           PULPIT.FACULTY,
           TEACHER.TEACHER,
           TEACHER.TEACHER_NAME
    FROM PULPIT
           JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT;
BEGIN
  FOR i IN c_PULPIT_TEACHER
    LOOP
      v_PULPIT := i.PULPIT;
      v_PULPIT_NAME := i.PULPIT_NAME;
      v_FACULTY := i.FACULTY;
      v_TEACHER := i.TEACHER;
      v_TEACHER_NAME := i.TEACHER_NAME;
      DBMS_OUTPUT.PUT_LINE('PULPIT: ' || v_PULPIT || ', PULPIT_NAME: ' || v_PULPIT_NAME || ', FACULTY: ' || v_FACULTY ||
                           ', TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME);
    END LOOP;
end;

-- 15. Создайте АБ, распечатывающий следующие списки аудиторий: 
-- все аудитории (таблица AUDITORIUM) с вместимостью 
-- меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше. 
-- Примените курсор с параметрами и три способа организации цикла по строкам курсора.

DECLARE
  -- Объявление переменных
  v_auditorium AUDITORIUM.AUDITORIUM%TYPE;
  v_auditorium_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_auditorium_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  v_auditorium_type AUDITORIUM.AUDITORIUM_TYPE%TYPE;

  -- Объявление курсора с параметрами
  CURSOR c_auditorium(p_min_capacity NUMBER, p_max_capacity NUMBER) IS
    SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY BETWEEN p_min_capacity AND p_max_capacity;

BEGIN
  -- Способ 1: LOOP-цикл с явным курсором
      DBMS_OUTPUT.PUT_LINE('Способ 1: LOOP-цикл с явным курсором');
  OPEN c_auditorium(0, 20);  -- Список аудиторий с вместимостью меньше 20
  DBMS_OUTPUT.PUT_LINE('Список аудиторий с вместимостью меньше 20:');
  LOOP
    FETCH c_auditorium INTO v_auditorium, v_auditorium_name, v_auditorium_capacity, v_auditorium_type;
    EXIT WHEN c_auditorium%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_auditorium || ' - ' || v_auditorium_name || ' - ' || v_auditorium_capacity || ' - ' || v_auditorium_type);
  END LOOP;
  CLOSE c_auditorium;

  -- Способ 2: FOR-цикл с неявным курсором
        DBMS_OUTPUT.PUT_LINE('FOR-цикл с неявным курсором');
  DBMS_OUTPUT.PUT_LINE('Список аудиторий с вместимостью от 21 до 30:');
  FOR auditorium_rec IN c_auditorium(21, 30) LOOP
    DBMS_OUTPUT.PUT_LINE(auditorium_rec.AUDITORIUM || ' - ' || auditorium_rec.AUDITORIUM_NAME || ' - ' || auditorium_rec.AUDITORIUM_CAPACITY || ' - ' || auditorium_rec.AUDITORIUM_TYPE);
  END LOOP;

  -- Способ 3: LOOP-цикл с использованием FETCH INTO
          DBMS_OUTPUT.PUT_LINE('LOOP-цикл с использованием FETCH INTO');
  DBMS_OUTPUT.PUT_LINE('Список аудиторий с вместимостью от 31 до 60:');
  OPEN c_auditorium(31, 60);  -- Список аудиторий с вместимостью от 31 до 60
  LOOP
    FETCH c_auditorium INTO v_auditorium, v_auditorium_name, v_auditorium_capacity, v_auditorium_type;
    EXIT WHEN c_auditorium%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_auditorium || ' - ' || v_auditorium_name || ' - ' || v_auditorium_capacity || ' - ' || v_auditorium_type);
  END LOOP;
  CLOSE c_auditorium;

END;

-- 16. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor. 
-- Продемонстрируйте ее применение для курсора c параметрами.

-- Переменная с типом refcursor используется для временного хранения результатов запроса 
-- и позволяет последовательно обрабатывать эти результаты. Она удобна, когда необходимо 
-- выполнить дополнительные операции с данными, полученными из запроса, или передать 
-- результаты в другую часть программы для дальнейшей обработки.

DECLARE
  v_AUDITORIUM          AUDITORIUM.AUDITORIUM%TYPE;
  v_AUDITORIUM_NAME     AUDITORIUM.AUDITORIUM_NAME%TYPE;
  v_AUDITORIUM_CAPACITY AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
  c_AUDITORIUM          SYS_REFCURSOR;
BEGIN
  OPEN c_AUDITORIUM FOR
    SELECT AUDITORIUM,
           AUDITORIUM_NAME,
           AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_TYPE = 'ЛК';

  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM, v_AUDITORIUM_NAME, v_AUDITORIUM_CAPACITY;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('AUDITORIUM: ' || v_AUDITORIUM || ', AUDITORIUM_NAME: ' || v_AUDITORIUM_NAME ||
                         ', AUDITORIUM_CAPACITY: ' || v_AUDITORIUM_CAPACITY);
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

-- 17. Создайте AБ. Продемонстрируйте понятие курсорный подзапрос

-- Курсорный подзапрос - это запрос, который используется внутри другого запроса 
-- и возвращает набор результатов для дальнейшего использования во внешнем запросе. 
-- Курсорный подзапрос может быть использован в различных частях SQL-запроса, 
-- таких как предложение SELECT, FROM, WHERE и других.

DECLARE
   CURSOR task17 IS
      SELECT AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY
      FROM AUDITORIUM
      WHERE AUDITORIUM_TYPE = (
         SELECT AUDITORIUM_TYPE
         FROM AUDITORIUM
         WHERE AUDITORIUM_NAME = '429-4'
      );
   auditorium_id AUDITORIUM.AUDITORIUM%TYPE;
   auditorium_name AUDITORIUM.AUDITORIUM_NAME%TYPE;
   auditorium_type AUDITORIUM.AUDITORIUM_TYPE%TYPE;
   auditorium_capacity AUDITORIUM.AUDITORIUM_CAPACITY%TYPE;
BEGIN
   OPEN task17;
   LOOP
      FETCH task17 INTO auditorium_id, auditorium_name, auditorium_type, auditorium_capacity;
      EXIT WHEN task17%NOTFOUND;
      -- Выводим значения аудиторий, удовлетворяющих условию подзапроса
      DBMS_OUTPUT.PUT_LINE(
         'Аудитория: ' || auditorium_id ||
         ', Название: ' || auditorium_name ||
         ', Тип: ' || auditorium_type ||
         ', Вместимость: ' || auditorium_capacity
      );
   END LOOP;
   CLOSE task17;
END;

-- 18. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM) 
-- вместимостью от 40 до 80 на 10%. 
-- Используйте явный курсор с параметрами, цикл FOR, конструкцию UPDATE CURRENT OF.
select * from AUDITORIUM;
rollback;

DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT *
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 40
      and AUDITORIUM_CAPACITY <= 80
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE CURRENT OF c_AUDITORIUM;
    END LOOP;
end;

-- 19. Создайте AБ. Удалите все аудитории (таблица AUDITORIUM) вместимостью от 0 до 20. 
-- Используйте явный курсор с параметрами, цикл WHILE, конструкцию UPDATE CURRENT OF.
DECLARE
  v_AUDITORIUM AUDITORIUM.AUDITORIUM%TYPE;
  CURSOR c_AUDITORIUM IS
    SELECT AUDITORIUM
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  OPEN c_AUDITORIUM;
  LOOP
    FETCH c_AUDITORIUM INTO v_AUDITORIUM;
    EXIT WHEN c_AUDITORIUM%NOTFOUND;
    DELETE
    FROM AUDITORIUM
    WHERE CURRENT OF c_AUDITORIUM;
  END LOOP;

  CLOSE c_AUDITORIUM;
end;

-- 20. Создайте AБ. Продемонстрируйте применение псевдостолбца ROWID 
-- в операторах UPDATE и DELETE.
DECLARE
  CURSOR c_AUDITORIUM IS
    SELECT ROWID
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= 0
      and AUDITORIUM_CAPACITY <= 20
      FOR UPDATE;
BEGIN
  FOR i IN c_AUDITORIUM
    LOOP
      UPDATE AUDITORIUM
      SET AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9
      WHERE ROWID = i.ROWID;
      DELETE
      FROM AUDITORIUM
      WHERE ROWID = i.ROWID;
    END LOOP;
end;

-- 21. Распечатайте в одном цикле всех преподавателей (TEACHER), 
-- разделив группами по три (отделите группы линией -------------).

DECLARE
  v_TEACHER      TEACHER.TEACHER%TYPE;
  v_TEACHER_NAME TEACHER.TEACHER_NAME%TYPE;
  v_PULPIT       TEACHER.PULPIT%TYPE;
  CURSOR c_TEACHER IS
    SELECT TEACHER,
           TEACHER_NAME,
           PULPIT
    FROM TEACHER;
BEGIN
  OPEN c_TEACHER;
  LOOP
    FETCH c_TEACHER INTO v_TEACHER, v_TEACHER_NAME, v_PULPIT;
    EXIT WHEN c_TEACHER%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('TEACHER: ' || v_TEACHER || ', TEACHER_NAME: ' || v_TEACHER_NAME || ', PULPIT: ' ||
                         v_PULPIT);
    IF MOD(c_TEACHER%ROWCOUNT, 3) = 0 THEN
      DBMS_OUTPUT.PUT_LINE('-----------------');
    END IF;
  END LOOP;

  CLOSE c_TEACHER;
end;