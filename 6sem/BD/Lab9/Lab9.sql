-- Коллекция - это структура данных, содержащая множество объектов опреелённого типа
-- Шаг 1: Создание коллекций на основе таблиц
-- Тип для коллекции Вопрос t1
CREATE TYPE ВопросType AS OBJECT (
    ID NUMBER,
    Текст NVARCHAR2(255)
);

-- Тип для хранения списка Вопросов
CREATE TYPE ВопросыList AS TABLE OF ВопросType;

-- Тип для коллекции Ответ t2
CREATE TYPE ОтветType AS OBJECT (
    ID NUMBER,
    Текст NVARCHAR2(255)
);
-- Тип для хранения списка Ответов
CREATE TYPE ОтветыList AS TABLE OF ОтветType;

-- Тип для коллекции Вопрос-Ответ
CREATE TYPE ВопросОтветType AS OBJECT (
    Вопрос ВопросType,
    Ответы ОтветыList
);

-- Таблица t1
CREATE TABLE t1 (
    вопросы ВопросыList
) NESTED TABLE вопросы STORE AS вопросы_table;

-- Таблица t2 (ОтветType) для демонстрации данных
CREATE TABLE t2 OF ОтветType;

-- Вставка данных в таблицу t2
INSERT INTO t2 VALUES (ОтветType(1, 'Ответ 1'));
INSERT INTO t2 VALUES (ОтветType(2, 'Ответ 2'));
INSERT INTO t2 VALUES (ОтветType(3, 'Ответ 3'));

-- Вставка данных в таблицу t1
INSERT INTO t1 VALUES (ВопросыList(ВопросType(1, 'Вопрос 1'), ВопросType(2, 'Вопрос 2')));
INSERT INTO t1 VALUES (ВопросыList(ВопросType(3, 'Вопрос 3')));

-- Шаг 2: Обработка данных из коллекций (пункт b и c)
DECLARE
    K1 ВопросыList;
BEGIN
    SELECT вопросы INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Проверка, является ли элемент ВопросType(1, 'Вопрос 1') членом коллекции K1
    DECLARE
        v_question_exists BOOLEAN := FALSE;
    BEGIN
        FOR i IN 1..K1.COUNT LOOP
            IF K1(i).ID = 1 AND K1(i).Текст = 'Вопрос 1' THEN
                v_question_exists := TRUE;
                EXIT;
            END IF;
        END LOOP;

        IF v_question_exists THEN
            DBMS_OUTPUT.PUT_LINE('2b');
            DBMS_OUTPUT.PUT_LINE('ВопросType(1, ''Вопрос 1'') является членом K1');
        END IF;
    END;
END;
/


-- Проверка на пустоту коллекции
DECLARE
    K1 ВопросыList;
BEGIN
    SELECT вопросы INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Проверка на пустую коллекцию
    IF K1 IS NULL OR K1.COUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 пуста');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Коллекция K1 не пуста');
    END IF;
END;
/

-- Шаг 3: Преобразовать коллекцию к другому виду (к коллекции другого типа, к реляционным данным).
DECLARE
    K1 ВопросыList;
    NewВопросыList ВопросыList := ВопросыList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    -- Присваивание K1 коллекции Вопросов из первой записи t1
    SELECT вопросы INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Добавляем элементы из K1 с ID > 1 в новую коллекцию NewВопросыList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewВопросыList.EXTEND; -- Увеличиваем размер коллекции
            NewВопросыList(NewВопросыList.LAST) := K1(i); -- Добававляем элемент в коллекцию
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('2c');
    -- Выводим содержимое новой коллекции NewВопросыList
    FOR i IN 1..NewВопросыList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewВопросыList(i).ID || ', Текст: ' || NewВопросыList(i).Текст);
    END LOOP;
END;
/

-- Шаг 4: Изменение данных в коллекции (пункт d)
DECLARE
    K1 ВопросыList;
    NewВопросыList ВопросыList := ВопросыList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    -- Присваивание K1 коллекции Вопросов из первой записи t1
    SELECT вопросы INTO K1
    FROM t1
    WHERE ROWNUM = 1;

    -- Добавляем элементы из K1 с ID > 1 в новую коллекцию NewВопросыList
    FOR i IN 1..K1.COUNT LOOP
        IF K1(i).ID > 1 THEN
            NewВопросыList.EXTEND; -- Увеличиваем размер коллекции
            NewВопросыList(NewВопросыList.LAST) := K1(i); -- Добавляем элемент в коллекцию
        END IF;
    END LOOP;

    -- Выводим содержимое новой коллекции NewВопросыList
    DBMS_OUTPUT.PUT_LINE('Contents of NewВопросыList:');
    FOR i IN 1..NewВопросыList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewВопросыList(i).ID || ', Текст: ' || NewВопросыList(i).Текст);
    END LOOP;
END;
/

-- Шаг 4: Изменение данных в коллекции (пункт d)
CREATE GLOBAL TEMPORARY TABLE temp_table (
    ID NUMBER,
    Текст NVARCHAR2(255)
) ON COMMIT PRESERVE ROWS;

DECLARE
    NewВопросыList ВопросыList := ВопросыList(); -- Создаем пустую коллекцию для новых элементов
BEGIN
    NewВопросыList.EXTEND;
    NewВопросыList(NewВопросыList.LAST) := ВопросType(4, 'Новый вопрос 1');
    NewВопросыList.EXTEND;
    NewВопросыList(NewВопросыList.LAST) := ВопросType(5, 'Новый вопрос 2');

    -- Вывод содержимого коллекции NewВопросыList перед операцией массовой вставки
    DBMS_OUTPUT.PUT_LINE('Содержимое NewВопросыList:');
    FOR i IN 1..NewВопросыList.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || NewВопросыList(i).ID || ', Текст: ' || NewВопросыList(i).Текст);
    END LOOP;

    -- Используем оператор BULK COLLECT для массового извлечения данных из 
    -- коллекции NewВопросыList во временную таблицу
    -- FORRALL - BULK оператор
    FORALL i IN 1..NewВопросыList.COUNT
        INSERT INTO temp_table VALUES (NewВопросыList(i).ID, NewВопросыList(i).Текст);

    INSERT INTO t1 (вопросы)
    SELECT ВопросыList(ВопросType(ID, Текст))
    FROM temp_table;

    -- Вывод сообщения об успешной вставке
    DBMS_OUTPUT.PUT_LINE('Массовая вставка выполнена успешно.');
END;
/