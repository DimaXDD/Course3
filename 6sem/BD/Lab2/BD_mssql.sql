CREATE DATABASE TESTING;
USE TESTING;
--USE master;
--DROP DATABASE TESTING;
--drop table Пользователь;
--drop table Тест;
--drop table Вопрос;
--drop table Ответ;
--drop table Результат_теста;


CREATE TABLE Пользователь (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Имя NVARCHAR(100),
    Фамилия NVARCHAR(100),
    email NVARCHAR(100),
    Пароль NVARCHAR(100),
    Роль NVARCHAR(20) CHECK (Роль IN ('Студент', 'Преподаватель', 'Администратор')),
    Данные NVARCHAR(100)
);

CREATE TABLE Тест (
    ID INT PRIMARY KEY,
    Название NVARCHAR(100),
    Описание NVARCHAR(255),
    Предмет NVARCHAR(100)
);

CREATE TABLE Вопрос (
    ID INT PRIMARY KEY,
    Текст NVARCHAR(255),
    ID_теста INT FOREIGN KEY REFERENCES Тест(ID)
);

CREATE TABLE Ответ (
    ID INT PRIMARY KEY,
    Текст NVARCHAR(255),
    Правильный BIT,
    ID_вопроса INT FOREIGN KEY REFERENCES Вопрос(ID)
);

CREATE TABLE Результат_теста (
    ID INT PRIMARY KEY,
    ID_пользователя INT FOREIGN KEY REFERENCES Пользователь(ID),
    ID_теста INT FOREIGN KEY REFERENCES Тест(ID),
    Дата_и_время DATETIME,
    Итоговый_балл FLOAT
);

CREATE INDEX IX_Пользователь_Имя_Фамилия ON Пользователь (Имя, Фамилия);
CREATE INDEX IX_Тест_Предмет ON Тест (Предмет);
CREATE INDEX IX_Вопрос_ID_теста ON Вопрос (ID_теста);
CREATE INDEX IX_Ответ_ID_вопроса ON Ответ (ID_вопроса);
CREATE INDEX IX_Результат_теста_ID_пользователя ON Результат_теста (ID_пользователя);


-- ============================== Регистрация ==============================
CREATE PROCEDURE Регистрация
    @Имя NVARCHAR(100),
    @Фамилия NVARCHAR(100),
    @Email NVARCHAR(100),
    @Пароль NVARCHAR(100),
    @Роль NVARCHAR(20),
    @Данные NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Пользователь WHERE Email = @Email)
    BEGIN
        IF @Email LIKE '%@%.%' AND @Email NOT LIKE '%@%@%'
        BEGIN
            IF @Роль IN ('Студент', 'Преподаватель', 'Администратор')
            BEGIN
                -- Проверка, что пользователь с таким email уже не существует
                DECLARE @ПользовательСуществует BIT;
                SET @ПользовательСуществует = 0;
                SELECT @ПользовательСуществует = 1 FROM Пользователь WHERE Email = @Email;

                IF @ПользовательСуществует = 0
                BEGIN
                    INSERT INTO Пользователь (Имя, Фамилия, Email, Пароль, Роль, Данные)
                    VALUES (@Имя, @Фамилия, @Email, HASHBYTES('SHA2_256', @Пароль), @Роль, @Данные);
                    SELECT 1 AS Result, 'Регистрация прошла успешно.' AS Message;
                END
                ELSE
                BEGIN
                    SELECT 0 AS Result, 'Пользователь с таким email уже существует.' AS Message;
                END;
            END
            ELSE
            BEGIN
                SELECT 0 AS Result, 'Недопустимая роль. Роль должна быть либо Студент, либо Преподаватель, либо Администратор.' AS Message;
            END;
        END
        ELSE
        BEGIN
            SELECT 0 AS Result, 'Неправильный формат email.' AS Message;
        END;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Пользователь с таким email уже существует.' AS Message;
    END;
END;
GO

-- ============================== Авторизация ==============================
CREATE PROCEDURE Авторизация
    @Email NVARCHAR(100),
    @Пароль NVARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE Email = @Email AND Пароль = HASHBYTES('SHA2_256', @Пароль))
    BEGIN
        SELECT 1 AS Result, 'Авторизация прошла успешно.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Неверный email или пароль.' AS Message;
    END
END;
GO


-- ============================== Провека регистрации и авторизации ==============================
EXEC Регистрация @Имя = 'Dmitry', @Фамилия = 'Trubach', @Email = 'dima1@mail.ru', @Пароль = 'dima123', @Роль = 'Студент', @Данные = 'Тест1';
EXEC Регистрация @Имя = 'Prepod', @Фамилия = 'Prepod', @Email = 'dima2@mail.ru', @Пароль = 'dima1234', @Роль = 'Преподаватель', @Данные = 'Тест2';
SELECT * FROM Пользователь;
EXEC Авторизация @Email = 'dima1@mail.ru', @Пароль = 'dima123';


-- ============================== Добавление, редактирование и удаление теста ==============================

-- ============================== Проверка количества вопросов (<=5) ==============================
CREATE TRIGGER Проверка_Количества_Вопросов
ON Вопрос
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT T.ID, COUNT(*) AS Количество_Вопросов
        FROM Тест T
        JOIN Вопрос V ON T.ID = V.ID_теста
        WHERE T.ID IN (SELECT ID_теста FROM inserted)
        GROUP BY T.ID
        HAVING COUNT(*) > 5
    )
    BEGIN
        RAISERROR ('Максимальное количество вопросов в тесте составляет 5.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE PROCEDURE Добавить_тест
    @ID INT,
    @Название NVARCHAR(100),
    @Описание NVARCHAR(255),
    @Предмет NVARCHAR(100),
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        INSERT INTO Тест (ID, Название, Описание, Предмет)
        VALUES (@ID, @Название, @Описание, @Предмет);
        SELECT 1 AS Result, 'Тест успешно добавлен.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недостаточно прав для добавления теста.' AS Message;
    END
END;
GO

CREATE PROCEDURE Редактировать_тест
    @ID INT,
    @Название NVARCHAR(100),
    @Описание NVARCHAR(255),
    @Предмет NVARCHAR(100),
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        UPDATE Тест
        SET Название = @Название, Описание = @Описание, Предмет = @Предмет
        WHERE ID = @ID;
        SELECT 1 AS Result, 'Тест успешно отредактирован.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недостаточно прав для редактирования теста.' AS Message;
    END
END;
GO

CREATE PROCEDURE Удалить_тест
    @ID INT,
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        DELETE FROM Тест
        WHERE ID = @ID;
        SELECT 1 AS Result, 'Тест успешно удален.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недостаточно прав для удаления теста.' AS Message;
    END
END;
GO


-- ============================== Просмотр всех тестов ==============================
CREATE VIEW Все_тесты
AS
SELECT ID, Название, Описание, Предмет
FROM Тест;
SELECT * FROM Все_тесты;


-- Добавление теста
EXEC Добавить_тест @ID = 1, @Название = 'Тест №1', @Описание = 'Тесттест', @Предмет = 'Математика', @ID_пользователя = 2;
-- Редактирование теста
EXEC Редактировать_тест @ID = 1, @Название = 'Измененный тест 1', @Описание = 'Измененное описание теста 1', @Предмет = 'Информатика', @ID_пользователя = 1;
-- Удаление теста
EXEC Удалить_тест @ID = 1, @ID_пользователя = 1;

-- ============================== Добавление вопроса ==============================
CREATE PROCEDURE Добавить_Вопрос
    @ID INT,
    @Текст NVARCHAR(100),
    @ID_теста INT,
    @Роль NVARCHAR(20)
AS
BEGIN
    IF @Роль = 'Преподаватель'
    BEGIN
        INSERT INTO Вопрос (ID, Текст, ID_теста)
        VALUES (@ID, @Текст, @ID_теста);
        
        SELECT 1 AS Result, 'Вопрос успешно добавлен.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недопустимая роль. Только преподаватель может добавлять вопросы.' AS Message;
    END
END;
GO

-- ============================== Добавление ответа ==============================
CREATE PROCEDURE Добавить_Ответ
    @ID INT,
    @Текст NVARCHAR(100),
    @Правильный BIT,
    @ID_вопроса INT,
    @Роль NVARCHAR(20)
AS
BEGIN
    IF @Роль = 'Преподаватель'
    BEGIN
        INSERT INTO Ответ (ID, Текст, Правильный, ID_вопроса)
        VALUES (@ID, @Текст, @Правильный, @ID_вопроса);
        
        SELECT 1 AS Result, 'Ответ успешно добавлен.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недопустимая роль. Только преподаватель может добавлять ответы.' AS Message;
    END
END;
GO
-- Вызов процедуры Добавить_Вопрос
DECLARE @Роль NVARCHAR(20) = 'Преподаватель';

EXEC Добавить_Вопрос
    @ID = 1,
    @Текст = 'Вопрос 1, ответ да',
    @ID_теста = 1,
    @Роль = @Роль;

-- Вызов процедуры Добавить_Ответ
EXEC Добавить_Ответ
    @ID = 1,
    @Текст = 'Да',
    @Правильный = 1,
    @ID_вопроса = 1,
    @Роль = @Роль;

EXEC Добавить_Ответ
    @ID = 2,
    @Текст = 'Нет',
    @Правильный = 0,
    @ID_вопроса = 1,
    @Роль = @Роль;




DECLARE @Роль NVARCHAR(20) = 'Преподаватель';

EXEC Добавить_Вопрос
    @ID = 2,
    @Текст = 'Вопрос 2, ответ да',
    @ID_теста = 1,
    @Роль = @Роль;

-- Вызов процедуры Добавить_Ответ
EXEC Добавить_Ответ
    @ID = 3,
    @Текст = 'Да',
    @Правильный = 1,
    @ID_вопроса = 2,
    @Роль = @Роль;

EXEC Добавить_Ответ
    @ID = 4,
    @Текст = 'Нет',
    @Правильный = 0,
    @ID_вопроса = 2,
    @Роль = @Роль;


DECLARE @Роль NVARCHAR(20) = 'Преподаватель';

EXEC Добавить_Вопрос
    @ID = 3,
    @Текст = 'Вопрос 3, ответ нет',
    @ID_теста = 1,
    @Роль = @Роль;

-- Вызов процедуры Добавить_Ответ
EXEC Добавить_Ответ
    @ID = 5,
    @Текст = 'Да',
    @Правильный = 0,
    @ID_вопроса = 3,
    @Роль = @Роль;

EXEC Добавить_Ответ
    @ID = 6,
    @Текст = 'Нет',
    @Правильный = 1,
    @ID_вопроса = 3,
    @Роль = @Роль;


-- Вывод информации о тесте
SELECT Название, Описание
FROM Тест
WHERE ID = 1;

-- Вывод вопросов теста
SELECT ID, Текст AS Вопрос
FROM Вопрос
WHERE ID_теста = 1;

--drop procedure ПроверитьОтветы;
CREATE PROCEDURE ПроверитьОтветы (
    @ID_теста INT
)
AS
BEGIN
    -- Сравниваем ответы с правильными ответами
    SELECT
        Вопрос.ID AS ID_вопроса,
        Вопрос.Текст AS Текст_вопроса,
        Ответ.Текст AS Текст_ответа,
        CASE
            WHEN Ответ.Правильный = 1 THEN 'Правильно'
            ELSE 'Неправильно'
        END AS Результат
    INTO #Результаты
    FROM Вопрос
    INNER JOIN Ответ ON Вопрос.ID = Ответ.ID_вопроса
    INNER JOIN #ВременныеОтветы ON Вопрос.ID = #ВременныеОтветы.ID_вопроса
    WHERE Вопрос.ID_теста = @ID_теста
    AND Ответ.Правильный = CASE
        WHEN #ВременныеОтветы.Ответ = 'Да' THEN 1
        WHEN #ВременныеОтветы.Ответ = 'Нет' THEN 0
        ELSE NULL
    END;

    -- Вычисляем оценку
    DECLARE @КоличествоВопросов INT;
    DECLARE @ПравильныеОтветы INT;
    DECLARE @Оценка FLOAT;

    SELECT
        @КоличествоВопросов = COUNT(*) FROM #Результаты;
    
    SELECT
        @ПравильныеОтветы = COUNT(*) FROM #Результаты WHERE Результат = 'Правильно';

    IF @ПравильныеОтветы = @КоличествоВопросов
        SET @Оценка = 10.0;
    ELSE IF @ПравильныеОтветы = 0
        SET @Оценка = 0.0;
    ELSE
        SET @Оценка = 10.0 - ((1.0 / @КоличествоВопросов) * 10.0 * (@КоличествоВопросов - @ПравильныеОтветы));

    -- Выводим результаты и оценку
    SELECT * FROM #Результаты;
    PRINT 'Оценка: ' + CAST(@Оценка AS VARCHAR);

    -- Удаляем временные таблицы
    DROP TABLE #Результаты;
    DROP TABLE #ВременныеОтветы;
END;

-- Создаем временную таблицу для хранения ответов на вопросы
CREATE TABLE #ВременныеОтветы (
    ID_вопроса INT,
    Ответ NVARCHAR(3)
);
SELECT * FROM #ВременныеОтветы;
INSERT INTO #ВременныеОтветы (ID_вопроса, Ответ)
VALUES
   (1, 'Да'),
   (2, 'Нет'),
   (3, 'Да');

EXEC ПроверитьОтветы @ID_теста = 1;