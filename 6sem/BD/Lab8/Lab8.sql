-- Для каких таблиц делаю (Вопрос)
CREATE TABLE Вопрос (
    ID NUMBER PRIMARY KEY,
    Текст NVARCHAR2(255) NOT NULL,
    ID_теста NUMBER REFERENCES Тест(ID) NOT NULL
);

-- 2. Создать объектные типы данных по своему варианту, реализовав:
-- a. Дополнительный конструктор;
-- b. Метод сравнения типа MAP или ORDER;
-- c. Функцию, как метод экземпляра;
-- d. Процедуру. как метод экземпляра.

-- Создание объектного типа Вопрос_OBJ
--drop type Вопрос_OBJ force
CREATE OR REPLACE TYPE Вопрос_OBJ AS OBJECT (
    ID NUMBER,
    Текст NVARCHAR2(255),
    -- Конструктор объекта
    CONSTRUCTOR FUNCTION Вопрос_OBJ(Текст NVARCHAR2) RETURN SELF AS RESULT,
    -- Метод сравнения ORDER
    ORDER MEMBER FUNCTION compare(other Вопрос_OBJ) RETURN INTEGER,
    MEMBER FUNCTION get_text RETURN VARCHAR2 DETERMINISTIC
);
/

-- Определение тела конструктора типа USER_ROLE_OBJ
CREATE OR REPLACE TYPE BODY Вопрос_OBJ AS
    -- Конструктор объекта
    CONSTRUCTOR FUNCTION Вопрос_OBJ(Текст NVARCHAR2) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ID := seq_Вопрос.NEXTVAL; -- Используем созданную последовательность
        SELF.Текст := Текст;
        RETURN;
    END;
    
    -- Метод сравнения ORDER (детерминированный)
    MEMBER FUNCTION get_text RETURN VARCHAR2 DETERMINISTIC IS
    BEGIN
        return Текст;
    END;
    
    ORDER MEMBER FUNCTION compare(other Вопрос_OBJ) RETURN INTEGER IS
    BEGIN
        IF self.ID < other.ID THEN
            RETURN -1;
        ELSIF self.ID > other.ID THEN
            RETURN 1;
        ELSE
            RETURN 0;
        END IF;
    END;
END;
/

-- 3 Скопировать данные из реляционных таблиц в объектные.
DECLARE
    TYPE вопрос_obj_typ IS TABLE OF Вопрос_OBJ;
    question_recs вопрос_obj_typ := вопрос_obj_typ(); -- Инициализация пустой коллекции объектов
    
    -- Курсор для выборки данных из реляционной таблицы Вопрос
    CURSOR c_questions IS
        SELECT ID, Текст
        FROM Вопрос;
BEGIN
    -- Заполнение коллекции объектов из реляционной таблицы
    FOR que IN c_questions LOOP
        -- Создание объекта типа USER_ROLE_OBJ с использованием конструктора
        question_recs.EXTEND; -- Расширение коллекции
        question_recs(question_recs.LAST) := Вопрос_OBJ(que.ID, que.Текст);
        
        -- Использование объекта role_rec для вывода информации
        DBMS_OUTPUT.PUT_LINE('Question ID: ' || que.ID || ', Text: ' || que.Текст);
        
    END LOOP;
    
    -- Итерация по коллекции объектов для вывода информации
    FOR i IN 1..question_recs.COUNT LOOP
        -- Получаем текущий объект из коллекции
        DECLARE
            current_question_rec Вопрос_OBJ := question_recs(i);
        BEGIN
            -- Выводим информацию о текущем объекте в DBMS_OUTPUT
            DBMS_OUTPUT.PUT_LINE('Qustion ID: ' || current_question_rec.ID || ', Name: ' || current_question_rec.get_text);
        END;
    END LOOP;
END;
/

-- Пример применения метода compare для сравнения объектов
DECLARE
    que1 Вопрос_OBJ;
    que2 Вопрос_OBJ;
    comparison_result INTEGER;
BEGIN
    -- Создаем объекты с разными
    que1 := Вопрос_OBJ('Вопрос 5, ответ да');
    que2 := Вопрос_OBJ('Вопрос 1, ответ нет');
    
    -- Сравниваем объекты
    comparison_result := que1.compare(que2);
    
    -- Выводим результат сравнения
    DBMS_OUTPUT.PUT_LINE('Comparison result: ' || comparison_result);
END;

-- 4. Продемонстрировать применение объектных представлений
--DROP VIEW QuestionView;

-- Создание объектного представления RoleView, возвращающего объекты типа USER_ROLE_OBJ
CREATE OR REPLACE VIEW QuestionView AS
SELECT Вопрос_OBJ(ID, Текст) AS question_object
FROM Вопрос;

-- Пример использования объектного представления RoleView

select qv.question_object.Текст from QuestionView qv;

DECLARE
    question_rec QuestionView.question_object%TYPE;
BEGIN
    FOR que IN (SELECT question_object FROM QuestionView) LOOP
        -- Получение объекта типа Вопрос_OBJ из поля question_object представления
        question_rec := que.question_object;
        
        -- Использование объекта question_rec для вывода информации
        DBMS_OUTPUT.PUT_LINE('Question ID: ' || question_rec.ID || ', Text: ' || question_rec.get_text);
    END LOOP;
END;
/


-- 5.	Продемонстрировать применение индексов для индексирования по атрибуту и по методу в объектной таблице.
-- Создание индекса на атрибуте Текст для таблицы Вопрос
CREATE INDEX idx_Вопрос ON Вопрос(Текст);
SELECT * FROM Вопрос WHERE Текст = 'Вопрос 5, ответ да';

--
--drop table Вопрос_INDEX
create table Вопрос_INDEX(
    Вопрос_OBJ Вопрос_OBJ
);
    
-- Детерминированная функция и индекс bitmap
select * from Вопрос_INDEX;
insert into Вопрос_INDEX(Вопрос_OBJ)VALUES(Вопрос_OBJ('Вопрос 4, ответ нет'));
insert into Вопрос_INDEX(Вопрос_OBJ)VALUES(Вопрос_OBJ('Вопрос 1, ответ нет'));
insert into Вопрос_INDEX(Вопрос_OBJ)VALUES(Вопрос_OBJ('Вопрос 5, ответ да'));

create index IndexField on Вопрос_INDEX (Вопрос_OBJ.get_text());

CREATE BITMAP INDEX idx_text ON Вопрос_INDEX(Вопрос_OBJ.Текст);

SELECT vi.Вопрос_OBJ.Текст
FROM Вопрос_INDEX vi
WHERE vi.Вопрос_OBJ.Текст = 'Вопрос 5, ответ да';

SELECT vi.Вопрос_OBJ.Текст
FROM Вопрос_INDEX vi
WHERE vi.Вопрос_OBJ.get_text() = 'Вопрос 5, ответ да';




