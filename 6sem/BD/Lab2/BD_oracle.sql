CREATE SEQUENCE seq_Пользователь START WITH 1;
CREATE SEQUENCE seq_Тест START WITH 1;
CREATE SEQUENCE seq_Вопрос START WITH 1;
CREATE SEQUENCE seq_Ответ START WITH 1;
CREATE SEQUENCE seq_Результат_теста START WITH 1;

drop SEQUENCE seq_Пользователь;
drop SEQUENCE seq_Тест;
drop SEQUENCE seq_Вопрос;
drop SEQUENCE seq_Ответ;
drop SEQUENCE seq_Результат_теста;

drop table Результат_теста;
drop table Ответ;
drop table Вопрос;
drop table Тест;
drop table Пользователь;

-- ERROR: Если возникает ошибка, что нельзя делать триггеры на объектах,
-- которые принадлежат SYS, то делаем:
-- 1) Подключаемся не под SYS (гениально)
-- 2) Можно либо создать юзера, либо взять с прошлых лаб по бд (мой случай)
-- 3) Роль указываем default (вроде с этим у меня стало нормас работать)

CREATE TABLE Пользователь (
    ID NUMBER PRIMARY KEY,
    Имя NVARCHAR2(100) NOT NULL,
    Фамилия NVARCHAR2(100) NOT NULL,
    email NVARCHAR2(100) NOT NULL,
    Пароль NVARCHAR2(100) NOT NULL,
    Роль NVARCHAR2(20) CHECK (Роль IN ('Студент', 'Преподаватель', 'Администратор')) NOT NULL,
    Данные NVARCHAR2(100)
);

CREATE TRIGGER trg_Пользователь
BEFORE INSERT ON Пользователь
FOR EACH ROW
BEGIN
  SELECT seq_Пользователь.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE Тест (
    ID NUMBER PRIMARY KEY,
    Название NVARCHAR2(100) NOT NULL,
    Описание NVARCHAR2(255) NOT NULL,
    Предмет NVARCHAR2(100) NOT NULL,
	ID_пользователя NUMBER REFERENCES Пользователь(ID) NOT NULL
);

CREATE TRIGGER trg_Тест
BEFORE INSERT ON Тест
FOR EACH ROW
BEGIN
  SELECT seq_Тест.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE Вопрос (
    ID NUMBER PRIMARY KEY,
    Текст NVARCHAR2(255) NOT NULL,
    ID_теста NUMBER REFERENCES Тест(ID) NOT NULL
);

CREATE TRIGGER trg_Вопрос
BEFORE INSERT ON Вопрос
FOR EACH ROW
BEGIN
  SELECT seq_Вопрос.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE Ответ (
    ID NUMBER PRIMARY KEY,
    Текст NVARCHAR2(255) NOT NULL,
    Правильный NUMBER(1) NOT NULL,
    ID_вопроса NUMBER REFERENCES Вопрос(ID) NOT NULL
);

CREATE TRIGGER trg_Ответ
BEFORE INSERT ON Ответ
FOR EACH ROW
BEGIN
  SELECT seq_Ответ.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE TABLE Результат_теста (
    ID NUMBER PRIMARY KEY,
    ID_пользователя NUMBER REFERENCES Пользователь(ID) NOT NULL,
    ID_теста NUMBER REFERENCES Тест(ID) NOT NULL,
    Дата_и_время DATE NOT NULL,
    Итоговый_балл FLOAT NOT NULL
);

CREATE TRIGGER trg_Результат_теста
BEFORE INSERT ON Результат_теста
FOR EACH ROW
BEGIN
  SELECT seq_Результат_теста.NEXTVAL
  INTO :new.ID
  FROM dual;
END;
/

CREATE INDEX IX_Пользователь_Имя_Фамилия ON Пользователь (Имя, Фамилия);
CREATE INDEX IX_Тест_Предмет ON Тест (Предмет);
CREATE INDEX IX_Вопрос_ID_теста ON Вопрос (ID_теста);
CREATE INDEX IX_Ответ_ID_вопроса ON Ответ (ID_вопроса);
CREATE INDEX IX_Результат_теста_ID_пользователя ON Результат_теста (ID_пользователя);

-- INFO: Может вы в лабах уже делали хэширование паролей, но если нет, то
-- пропишите команду ниже с учетом имени вашего юзера (выполняем от SYS)
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO C##TDS;

-- Проверка (если 1 - то нормально, если 0 - то нет)
SELECT COUNT(*)
FROM all_objects
WHERE object_name = 'DBMS_CRYPTO' AND object_type = 'PACKAGE';
-- ============================== Регистрация ==============================
CREATE OR REPLACE PROCEDURE Регистрация (
    p_Имя IN Пользователь.Имя%TYPE,
    p_Фамилия IN Пользователь.Фамилия%TYPE,
    p_Email IN Пользователь.Email%TYPE,
    p_Пароль IN Пользователь.Пароль%TYPE,
    p_Роль IN Пользователь.Роль%TYPE,
    p_Данные IN Пользователь.Данные%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_ПользовательСуществует NUMBER;
    v_Хеш_Пароля VARCHAR2(100); -- Изменено на VARCHAR2 с максимальной длиной 100 символов
BEGIN
    SELECT COUNT(*)
    INTO v_ПользовательСуществует
    FROM Пользователь
    WHERE Email = p_Email;

    IF v_ПользовательСуществует = 0 THEN
        IF REGEXP_LIKE(p_Email, '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            IF p_Роль IN ('Студент', 'Преподаватель', 'Администратор') THEN
                v_Хеш_Пароля := SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_Пароль, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100);
                INSERT INTO Пользователь (Имя, Фамилия, Email, Пароль, Роль, Данные)
                VALUES (p_Имя, p_Фамилия, p_Email, v_Хеш_Пароля, p_Роль, p_Данные);
                p_Result := 1;
                p_Message := 'Регистрация прошла успешно.';
            ELSE
                p_Result := 0;
                p_Message := 'Недопустимая роль. Роль должна быть либо Студент, либо Преподаватель, либо Администратор.';
            END IF;
        ELSE
            p_Result := 0;
            p_Message := 'Неправильный формат email.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := 'Пользователь с таким email уже существует.';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Регистрация;
/

-- ============================== Авторизация ==============================
CREATE OR REPLACE PROCEDURE Авторизация (
    p_Email IN Пользователь.Email%TYPE,
    p_Пароль IN Пользователь.Пароль%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Хеш_Пароля VARCHAR2(100); -- Изменено на VARCHAR2 с максимальной длиной 100 символов
BEGIN
    SELECT Пароль
    INTO v_Хеш_Пароля
    FROM Пользователь
    WHERE Email = p_Email;

    IF SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_Пароль, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100) = v_Хеш_Пароля THEN
        p_Result := 1;
        p_Message := 'Авторизация прошла успешно.';
    ELSE
        p_Result := 0;
        p_Message := 'Неверный email или пароль.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Неверный email или пароль.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Авторизация;
/

-- ============================== Провека регистрации и авторизации ==============================
DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    Регистрация('Dmitry', 'Trubach', 'dima1@mail.ru', 'dima123', 'Студент', 'Тест 1', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL; -- Обнуляем переменные перед следующим вызовом
    v_Message := NULL;
    
    Регистрация('Prepod', 'Prepod', 'dima2@mail.ru', 'dima1234', 'Преподаватель', 'Тест 2', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL;
    v_Message := NULL;
    
    Регистрация('Тестовый', 'Препод', 'dima3@mail.ru', 'dima12345', 'Преподаватель', 'Тест 3', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    
    v_Result := NULL;
    v_Message := NULL;
    
    Регистрация('admin', 'admin', 'dima4@mail.ru', 'dima123456', 'Администратор', 'Тест 3', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

SELECT * FROM Пользователь;

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    Авторизация('dima1@mail.ru', 'dima123', v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

-- ============================== Добавление, редактирование и удаление теста ==============================

-- ============================== Проверка количества вопросов (<=5) ==============================
CREATE OR REPLACE TRIGGER Проверка_Количества_Вопросов
BEFORE INSERT ON Вопрос
FOR EACH ROW
DECLARE
    Количество_Вопросов NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO Количество_Вопросов
    FROM Вопрос
    WHERE ID_теста = :NEW.ID_теста;

    IF Количество_Вопросов >= 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Максимальное количество вопросов в тесте составляет 5.');
    END IF;
END;
/

-- ============================== Добавить тест ==============================
CREATE OR REPLACE PROCEDURE Добавить_тест (
    p_ID IN Тест.ID%TYPE,
    p_Название IN Тест.Название%TYPE,
    p_Описание IN Тест.Описание%TYPE,
    p_Предмет IN Тест.Предмет%TYPE,
    p_ID_пользователя IN Тест.ID_пользователя%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Роль Пользователь.Роль%TYPE;
BEGIN
    SELECT Роль
    INTO v_Роль
    FROM Пользователь
    WHERE ID = p_ID_пользователя;

    IF v_Роль = 'Преподаватель' THEN
        INSERT INTO Тест (ID, Название, Описание, Предмет, ID_пользователя)
        VALUES (p_ID, p_Название, p_Описание, p_Предмет, p_ID_пользователя);
        p_Result := 1;
        p_Message := 'Тест успешно добавлен.';
    ELSE
        p_Result := 0;
        p_Message := 'Недостаточно прав для добавления теста.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Недостаточно прав для добавления теста.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Добавить_тест;
/

-- ============================== Редактировать тест ==============================
CREATE OR REPLACE PROCEDURE Редактировать_тест (
    p_ID IN Тест.ID%TYPE,
    p_Название IN Тест.Название%TYPE,
    p_Описание IN Тест.Описание%TYPE,
    p_Предмет IN Тест.Предмет%TYPE,
    p_ID_пользователя IN Тест.ID_пользователя%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Роль Пользователь.Роль%TYPE;
BEGIN
    SELECT Роль
    INTO v_Роль
    FROM Пользователь
    WHERE ID = p_ID_пользователя;

    IF v_Роль = 'Преподаватель' THEN
        UPDATE Тест
        SET Название = p_Название, Описание = p_Описание, Предмет = p_Предмет
        WHERE ID = p_ID;
        p_Result := 1;
        p_Message := 'Тест успешно отредактирован.';
    ELSE
        p_Result := 0;
        p_Message := 'Недостаточно прав для редактирования теста.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Недостаточно прав для редактирования теста.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Редактировать_тест;
/

-- ============================== Удалить тест ==============================
CREATE OR REPLACE PROCEDURE Удалить_тест (
    p_ID IN Тест.ID%TYPE,
    p_ID_пользователя IN Тест.ID_пользователя%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Роль Пользователь.Роль%TYPE;
BEGIN
    SELECT Роль
    INTO v_Роль
    FROM Пользователь
    WHERE ID = p_ID_пользователя;

    IF v_Роль = 'Преподаватель' THEN
        DELETE FROM Тест
        WHERE ID = p_ID;
        p_Result := 1;
        p_Message := 'Тест успешно удален.';
    ELSE
        p_Result := 0;
        p_Message := 'Недостаточно прав для удаления теста.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Недостаточно прав для удаления теста.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Удалить_тест;
/

-- ============================== Просмотр всех тестов ==============================
CREATE OR REPLACE VIEW Все_тесты AS
SELECT ID, Название, Описание, Предмет
FROM Тест;


select * from Тест; -- для просмотра ID

SELECT * FROM Все_тесты;


DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    Добавить_тест(1, 'Тест №1', 'Тесттест', 'Математика', 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    Редактировать_тест(1, 'Измененный тест 1', 'Измененное описание теста 1', 'Информатика', 1, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(100);
BEGIN
    Удалить_тест(1, 1, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
END;
/


-- ============================== Добавление вопроса ==============================
CREATE OR REPLACE PROCEDURE Добавить_Вопрос (
    p_ID IN Вопрос.ID%TYPE,
    p_Текст IN Вопрос.Текст%TYPE,
    p_ID_теста IN Вопрос.ID_теста%TYPE,
    p_ID_пользователя IN Пользователь.ID%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Роль Пользователь.Роль%TYPE;
    v_Тест_принадлежит_пользователю NUMBER;
BEGIN
    SELECT Роль
    INTO v_Роль
    FROM Пользователь
    WHERE ID = p_ID_пользователя;

    IF v_Роль = 'Преподаватель' THEN
        SELECT COUNT(*)
        INTO v_Тест_принадлежит_пользователю
        FROM Тест
        WHERE ID = p_ID_теста AND ID_пользователя = p_ID_пользователя;

        IF v_Тест_принадлежит_пользователю > 0 THEN
            INSERT INTO Вопрос (ID, Текст, ID_теста)
            VALUES (p_ID, p_Текст, p_ID_теста);
            p_Result := 1;
            p_Message := 'Вопрос успешно добавлен.';
        ELSE
            p_Result := 0;
            p_Message := 'Тест не принадлежит данному пользователю.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := 'Недопустимая роль. Только преподаватель может добавлять вопросы.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Недопустимая роль. Только преподаватель может добавлять вопросы.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Добавить_Вопрос;
/

-- ============================== Добавление ответа ==============================
CREATE OR REPLACE PROCEDURE Добавить_Ответ (
    p_ID IN Ответ.ID%TYPE,
    p_Текст IN Ответ.Текст%TYPE,
    p_Правильный IN Ответ.Правильный%TYPE,
    p_ID_вопроса IN Ответ.ID_вопроса%TYPE,
    p_ID_пользователя IN Пользователь.ID%TYPE,
    p_Result OUT NUMBER,
    p_Message OUT NVARCHAR2
) AS
    v_Роль Пользователь.Роль%TYPE;
    v_Вопрос_принадлежит_тесту NUMBER;
BEGIN
    SELECT Роль
    INTO v_Роль
    FROM Пользователь
    WHERE ID = p_ID_пользователя;

    IF v_Роль = 'Преподаватель' THEN
        SELECT COUNT(*)
        INTO v_Вопрос_принадлежит_тесту
        FROM Вопрос
        JOIN Тест ON Вопрос.ID_теста = Тест.ID
        WHERE Вопрос.ID = p_ID_вопроса AND Тест.ID_пользователя = p_ID_пользователя;

        IF v_Вопрос_принадлежит_тесту > 0 THEN
            INSERT INTO Ответ (ID, Текст, Правильный, ID_вопроса)
            VALUES (p_ID, p_Текст, p_Правильный, p_ID_вопроса);
            p_Result := 1;
            p_Message := 'Ответ успешно добавлен.';
        ELSE
            p_Result := 0;
            p_Message := 'Вопрос не принадлежит тесту данного пользователя.';
        END IF;
    ELSE
        p_Result := 0;
        p_Message := 'Недопустимая роль. Только преподаватель может добавлять ответы.';
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_Result := 0;
        p_Message := 'Недопустимая роль. Только преподаватель может добавлять ответы.';
    WHEN OTHERS THEN
        p_Result := 0;
        p_Message := SQLERRM;
END Добавить_Ответ;
/

select * from Вопрос;

DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(200);
BEGIN
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(1, 'Вопрос 1, ответ да', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(1, 'Да', 1, 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(2, 'Нет', 0, 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(2, 'Вопрос 2, ответ да', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(3, 'Да', 1, 2, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(4, 'Нет', 0, 2, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(3, 'Вопрос 3, ответ нет', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(5, 'Да', 0, 3, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(6, 'Нет', 1, 3, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(4, 'Вопрос 4, ответ нет', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(7, 'Да', 0, 4, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(8, 'Нет', 1, 4, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(5, 'Вопрос 5, ответ да', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(9, 'Да', 1, 5, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(10, 'Нет', 0, 5, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
END;
/

-- Добавление 6-го вопроса (проверка триггера)
DECLARE
    v_Result NUMBER;
    v_Message NVARCHAR2(200);
BEGIN
    -- ID, текст, ID_теста, ID_препода
    Добавить_Вопрос(6, 'Вопрос 6, ответ нет', 1, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    
    -- ID, текст, Правильность, ID_вопроса, ID_препода
    Добавить_Ответ(11, 'Да', 0, 6, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
    Добавить_Ответ(12, 'Нет', 1, 6, 2, v_Result, v_Message);
    DBMS_OUTPUT.PUT_LINE('Result: ' || v_Result || ', Message: ' || v_Message);
    v_Result := NULL;
    v_Message := NULL;
END;
/

-- ============================== Вывод информации о тесте ==============================
CREATE OR REPLACE FUNCTION Информация_О_Тесте (p_ID_теста IN NUMBER)
RETURN SYS_REFCURSOR IS
    v_результат SYS_REFCURSOR;
BEGIN
    OPEN v_результат FOR
    SELECT Название, Описание
    FROM Тест
    WHERE ID = p_ID_теста;
    
    RETURN v_результат;
END Информация_О_Тесте;
/


-- ============================== Вывод вопросов теста ==============================
CREATE OR REPLACE FUNCTION Вопросы_Теста (p_ID_теста IN NUMBER)
RETURN SYS_REFCURSOR IS
    v_результат SYS_REFCURSOR;
BEGIN
    OPEN v_результат FOR
    SELECT ID, Текст AS "Вопрос"
    FROM Вопрос
    WHERE ID_теста = p_ID_теста;
    
    RETURN v_результат;
END Вопросы_Теста;
/

-- Вызов функций
DECLARE
    v_результат SYS_REFCURSOR;
    v_название Тест.Название%TYPE;
    v_описание Тест.Описание%TYPE;
    v_ID Вопрос.ID%TYPE;
    v_вопрос Вопрос.Текст%TYPE;
BEGIN
    -- Вызов функции Информация_О_Тесте
    v_результат := Информация_О_Тесте(1);
    FETCH v_результат INTO v_название, v_описание;
    CLOSE v_результат;
    DBMS_OUTPUT.PUT_LINE('Название: ' || v_название || ', Описание: ' || v_описание);

    -- Вызов функции Вопросы_Теста
    v_результат := Вопросы_Теста(1); -- замените 1 на ID теста
    LOOP
        FETCH v_результат INTO v_ID, v_вопрос;
        EXIT WHEN v_результат%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ID: ' || v_ID || ', Вопрос: ' || v_вопрос);
    END LOOP;
    CLOSE v_результат;
END;
/

-- ============================== Проверка ответов ==============================
CREATE OR REPLACE PROCEDURE ПроверитьОтветы (
    ID_теста IN NUMBER,
    ID_пользователя IN NUMBER,
    Ответы IN VARCHAR2
) AS
    КоличествоВопросов NUMBER;
    ПравильныеОтветы NUMBER;
    Оценка NUMBER;
BEGIN
    -- Проверяем, что количество ответов соответствует количеству вопросов в тесте
    SELECT COUNT(*) INTO КоличествоВопросов FROM Вопрос WHERE ID_теста = ID_теста;
    IF КоличествоВопросов <> REGEXP_COUNT(Ответы, ',') + 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: количество ответов не соответствует количеству вопросов в тесте.');
        RETURN;
    END IF;

    -- Сравниваем ответы с правильными ответами
    FOR i IN 1..КоличествоВопросов LOOP
        SELECT COUNT(*)
        INTO ПравильныеОтветы
        FROM Вопрос
        INNER JOIN Ответ ON Вопрос.ID = Ответ.ID_вопроса
        WHERE Вопрос.ID_теста = ID_теста
        AND Ответ.Правильный = CASE
            WHEN REGEXP_SUBSTR(Ответы, '[^,]+', 1, i) = 'Да' THEN 1
            WHEN REGEXP_SUBSTR(Ответы, '[^,]+', 1, i) = 'Нет' THEN 0
            ELSE NULL
        END;
    END LOOP;

    -- Вычисляем оценку
    IF ПравильныеОтветы = КоличествоВопросов THEN
        Оценка := 10.0;
    ELSIF ПравильныеОтветы = 0 THEN
        Оценка := 0.0;
    ELSE
        Оценка := 10.0 - ((1.0 / КоличествоВопросов) * 10.0 * (КоличествоВопросов - ПравильныеОтветы));
    END IF;

    -- Выводим результаты и оценку
    DBMS_OUTPUT.PUT_LINE('Оценка: ' || TO_CHAR(Оценка));

    -- Добавляем результаты в таблицу Результат_теста
    INSERT INTO Результат_теста (ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл)
    VALUES (ID_пользователя, ID_теста, SYSDATE, Оценка);
END;
/

BEGIN
    ПроверитьОтветы(1, 1, 'Да,Нет,Да,Да,Да');
END;
/

SELECT * FROM Результат_теста;



CREATE OR REPLACE FUNCTION ВсеРезультаты RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл FROM Результат_теста;
  RETURN rc;
END;
/

CREATE OR REPLACE FUNCTION РезультатыПользователя (p_ID_пользователя INT) RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл FROM Результат_теста WHERE ID_пользователя = p_ID_пользователя;
  RETURN rc;
END;
/

CREATE OR REPLACE FUNCTION РезультатыТеста (p_ID_теста INT) RETURN SYS_REFCURSOR IS
  rc  SYS_REFCURSOR;
BEGIN
  OPEN rc FOR SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл FROM Результат_теста WHERE ID_теста = p_ID_теста;
  RETURN rc;
END;
/


DECLARE
  rc  SYS_REFCURSOR;
  row Результат_теста%ROWTYPE;
BEGIN
  rc := ВсеРезультаты();
  DBMS_OUTPUT.PUT_LINE('ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_пользователя || ', ' || row.ID_теста || ', ' || row.Дата_и_время || ', ' || row.Итоговый_балл);
  END LOOP;
  CLOSE rc;
END;
/

DECLARE
  rc  SYS_REFCURSOR;
  row Результат_теста%ROWTYPE;
BEGIN
  rc := РезультатыПользователя(1);
  DBMS_OUTPUT.PUT_LINE('ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_пользователя || ', ' || row.ID_теста || ', ' || row.Дата_и_время || ', ' || row.Итоговый_балл);
  END LOOP;
  CLOSE rc;
END;
/

DECLARE
  rc  SYS_REFCURSOR;
  row Результат_теста%ROWTYPE;
BEGIN
  rc := РезультатыТеста(1);
  DBMS_OUTPUT.PUT_LINE('ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл');
  LOOP
    FETCH rc INTO row;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(row.ID || ', ' || row.ID_пользователя || ', ' || row.ID_теста || ', ' || row.Дата_и_время || ', ' || row.Итоговый_балл);
  END LOOP;
  CLOSE rc;
END;
/

-- ============================== Изменение данных о пользователе ==============================
CREATE OR REPLACE PROCEDURE ИзменитьДанныеПользователя(
    p_ID_пользователя INT,
    p_ID_администратора INT,
    p_НовоеИмя NVARCHAR2,
    p_НоваяФамилия NVARCHAR2,
    p_НовыйEmail NVARCHAR2,
    p_НовыйПароль NVARCHAR2,
    p_НовыеДанные NVARCHAR2
) AS
  v_count INT;
  v_Хеш_Пароля VARCHAR2(100);
BEGIN
  SELECT COUNT(*) INTO v_count FROM Пользователь WHERE ID = p_ID_администратора AND Роль = 'Администратор';
  
  IF v_count = 1 THEN
    v_Хеш_Пароля := SUBSTR(UTL_RAW.CAST_TO_RAW(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW(p_НовыйПароль, 'AL32UTF8'), DBMS_CRYPTO.HASH_SH256)), 1, 100);
    UPDATE Пользователь
    SET Имя = p_НовоеИмя,
        Фамилия = p_НоваяФамилия,
        email = p_НовыйEmail,
        Пароль = v_Хеш_Пароля,
        Данные = p_НовыеДанные
    WHERE ID = p_ID_пользователя;
    
    DBMS_OUTPUT.PUT_LINE('1, Данные пользователя успешно обновлены.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('0, Ошибка: только администратор может изменять данные пользователя.');
  END IF;
END;
/


DECLARE
BEGIN
  ИзменитьДанныеПользователя(1, 4, 'Dmitry', 'Trubach', 'dima1@mail.ru', 'dima123', 'Тест 1');
END;
/

SELECT * FROM Пользователь;


-- ============================== Изменение роли ==============================
CREATE OR REPLACE PROCEDURE ИзменитьРольПользователя(
    p_ID_пользователя IN Пользователь.ID%TYPE,
    p_ID_администратора IN Пользователь.ID%TYPE,
    p_НоваяРоль IN Пользователь.Роль%TYPE
) AS
  v_count INT;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Пользователь WHERE ID = p_ID_администратора AND Роль = 'Администратор';
  
  IF v_count = 1 THEN
    UPDATE Пользователь
    SET Роль = p_НоваяРоль
    WHERE ID = p_ID_пользователя;
    
    DBMS_OUTPUT.PUT_LINE('1, Роль пользователя успешно обновлена.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('0, Ошибка: только администратор может изменять роль пользователя.');
  END IF;
END;
/

DECLARE
  v_Result NUMBER;
  v_Message NVARCHAR2(100);
BEGIN
  ИзменитьРольПользователя(2, 4, 'Преподаватель');
END;
/

SELECT * FROM Пользователь;




