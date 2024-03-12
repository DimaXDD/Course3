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
    Имя NVARCHAR(100) NOT NULL,
    Фамилия NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    Пароль NVARCHAR(100) NOT NULL,
    Роль NVARCHAR(20) CHECK (Роль IN ('Студент', 'Преподаватель', 'Администратор')) NOT NULL,
    Данные NVARCHAR(100)
);

CREATE TABLE Тест (
    ID INT PRIMARY KEY,
    Название NVARCHAR(100) NOT NULL,
    Описание NVARCHAR(255) NOT NULL,
    Предмет NVARCHAR(100) NOT NULL,
	ID_пользователя INT FOREIGN KEY REFERENCES Пользователь(ID) NOT NULL
);

CREATE TABLE Вопрос (
    ID INT PRIMARY KEY,
    Текст NVARCHAR(255) NOT NULL,
    ID_теста INT FOREIGN KEY REFERENCES Тест(ID) NOT NULL
);

CREATE TABLE Ответ (
    ID INT PRIMARY KEY,
    Текст NVARCHAR(255) NOT NULL,
    Правильный BIT NOT NULL,
    ID_вопроса INT FOREIGN KEY REFERENCES Вопрос(ID) NOT NULL
);

CREATE TABLE Результат_теста (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    ID_пользователя INT FOREIGN KEY REFERENCES Пользователь(ID) NOT NULL,
    ID_теста INT FOREIGN KEY REFERENCES Тест(ID) NOT NULL,
    Дата_и_время DATETIME NOT NULL,
    Итоговый_балл FLOAT NOT NULL
);


CREATE INDEX IX_Пользователь_Имя_Фамилия ON Пользователь (Имя, Фамилия);
CREATE INDEX IX_Тест_Предмет ON Тест (Предмет);
CREATE INDEX IX_Вопрос_ID_теста ON Вопрос (ID_теста);
CREATE INDEX IX_Ответ_ID_вопроса ON Ответ (ID_вопроса);
CREATE INDEX IX_Результат_теста_ID_пользователя ON Результат_теста (ID_пользователя);

SELECT OBJECT_NAME(i.object_id) AS table_name, i.name AS index_name FROM sys.indexes i WHERE i.name LIKE 'IX_%';


-- ============================== Регистрация ==============================
CREATE OR ALTER PROCEDURE Регистрация
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
CREATE OR ALTER PROCEDURE Авторизация
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
EXEC Регистрация @Имя = 'admin', @Фамилия = 'admin', @Email = 'test1@mail.ru', @Пароль = 'test1', @Роль = 'Администратор', @Данные = 'Тест 1';

EXEC Регистрация @Имя = 'Ольга', @Фамилия = 'Нистюк', @Email = 'test2@mail.ru', @Пароль = 'test2', @Роль = 'Преподаватель', @Данные = 'Тест 2';
EXEC Регистрация @Имя = 'Павел', @Фамилия = 'Бернацкий', @Email = 'test3@mail.ru', @Пароль = 'test3', @Роль = 'Преподаватель', @Данные = 'Тест 3';
EXEC Регистрация @Имя = 'Ирина', @Фамилия = 'Сухорукова', @Email = 'test4@mail.ru', @Пароль = 'test4', @Роль = 'Преподаватель', @Данные = 'Тест 4';

EXEC Регистрация @Имя = 'Дмитрий', @Фамилия = 'Трубач', @Email = 'test5@mail.ru', @Пароль = 'test5', @Роль = 'Студент', @Данные = 'Тест 5';
EXEC Регистрация @Имя = 'Александр', @Фамилия = 'Ломако', @Email = 'test6@mail.ru', @Пароль = 'test6', @Роль = 'Студент', @Данные = 'Тест 6';
EXEC Регистрация @Имя = 'Илья', @Фамилия = 'Песецкий', @Email = 'test7@mail.ru', @Пароль = 'test7', @Роль = 'Студент', @Данные = 'Тест 7';
EXEC Регистрация @Имя = 'Никита', @Фамилия = 'Песецкий', @Email = 'test8@mail.ru', @Пароль = 'test8', @Роль = 'Студент', @Данные = 'Тест 8';
EXEC Регистрация @Имя = 'Роман', @Фамилия = 'Новиков', @Email = 'test9@mail.ru', @Пароль = 'test9', @Роль = 'Студент', @Данные = 'Тест 9';

SELECT * FROM Пользователь;
EXEC Авторизация @Email = 'test1@mail.ru', @Пароль = 'test1';


-- ============================== Добавление, редактирование и удаление теста ==============================

-- ============================== Проверка количества вопросов (<=5) ==============================
CREATE OR ALTER TRIGGER Проверка_Количества_Вопросов
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
GO

-- ============================== Добавить тест ==============================
CREATE OR ALTER PROCEDURE Добавить_тест
    @ID INT,
    @Название NVARCHAR(100),
    @Описание NVARCHAR(255),
    @Предмет NVARCHAR(100),
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        INSERT INTO Тест (ID, Название, Описание, Предмет, ID_пользователя)
        VALUES (@ID, @Название, @Описание, @Предмет, @ID_пользователя);
        SELECT 1 AS Result, 'Тест успешно добавлен.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недостаточно прав для добавления теста.' AS Message;
    END
END;
GO

-- ============================== Редактировать тест ==============================
CREATE OR ALTER PROCEDURE Редактировать_тест
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

-- ============================== Удалить тест ==============================
CREATE OR ALTER PROCEDURE Удалить_тест
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
GO

select * from Тест; -- для просмотра ID

SELECT * FROM Все_тесты;


-- Добавление теста
EXEC Добавить_тест @ID = 1, @Название = 'Тест №1', @Описание = 'Тесттест', @Предмет = 'Математика', @ID_пользователя = 2;
-- Редактирование теста
EXEC Редактировать_тест @ID = 1, @Название = 'Измененный тест 1', @Описание = 'Измененное описание теста 1', @Предмет = 'Информатика', @ID_пользователя = 1;
-- Удаление теста
EXEC Удалить_тест @ID = 1, @ID_пользователя = 1;

-- ============================== Добавление вопроса ==============================
CREATE OR ALTER PROCEDURE Добавить_Вопрос
    @ID INT,
    @Текст NVARCHAR(100),
    @ID_теста INT,
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        IF EXISTS (SELECT 1 FROM Тест WHERE ID = @ID_теста AND ID_пользователя = @ID_пользователя)
        BEGIN
            INSERT INTO Вопрос (ID, Текст, ID_теста)
            VALUES (@ID, @Текст, @ID_теста);
            
            SELECT 1 AS Result, 'Вопрос успешно добавлен.' AS Message;
        END
        ELSE
        BEGIN
            SELECT 0 AS Result, 'Тест не принадлежит данному пользователю.' AS Message;
        END
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недопустимая роль. Только преподаватель может добавлять вопросы.' AS Message;
    END
END;
GO

-- ============================== Добавление ответа ==============================
CREATE OR ALTER PROCEDURE Добавить_Ответ
    @ID INT,
    @Текст NVARCHAR(100),
    @Правильный BIT,
    @ID_вопроса INT,
    @ID_пользователя INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_пользователя AND Роль = 'Преподаватель')
    BEGIN
        IF EXISTS (SELECT 1 FROM Вопрос INNER JOIN Тест ON Вопрос.ID_теста = Тест.ID WHERE Вопрос.ID = @ID_вопроса AND Тест.ID_пользователя = @ID_пользователя)
        BEGIN
            INSERT INTO Ответ (ID, Текст, Правильный, ID_вопроса)
            VALUES (@ID, @Текст, @Правильный, @ID_вопроса);
            
            SELECT 1 AS Result, 'Ответ успешно добавлен.' AS Message;
        END
        ELSE
        BEGIN
            SELECT 0 AS Result, 'Вопрос не принадлежит тесту данного пользователя.' AS Message;
        END
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Недопустимая роль. Только преподаватель может добавлять ответы.' AS Message;
    END
END;
GO


EXEC Добавить_Вопрос
    @ID = 1,
    @Текст = 'Вопрос 1, ответ да',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 1,
    @Текст = 'Да',
    @Правильный = 1,
    @ID_вопроса = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 2,
    @Текст = 'Нет',
    @Правильный = 0,
    @ID_вопроса = 1,
    @ID_пользователя = 2;

EXEC Добавить_Вопрос
    @ID = 2,
    @Текст = 'Вопрос 2, ответ да',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 3,
    @Текст = 'Да',
    @Правильный = 1,
    @ID_вопроса = 2,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 4,
    @Текст = 'Нет',
    @Правильный = 0,
    @ID_вопроса = 2,
    @ID_пользователя = 2;

EXEC Добавить_Вопрос
    @ID = 3,
    @Текст = 'Вопрос 3, ответ нет',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 5,
    @Текст = 'Да',
    @Правильный = 0,
    @ID_вопроса = 3,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 6,
    @Текст = 'Нет',
    @Правильный = 1,
    @ID_вопроса = 3,
    @ID_пользователя = 2;

EXEC Добавить_Вопрос
    @ID = 4,
    @Текст = 'Вопрос 4, ответ нет',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 7,
    @Текст = 'Да',
    @Правильный = 0,
    @ID_вопроса = 4,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 8,
    @Текст = 'Нет',
    @Правильный = 1,
    @ID_вопроса = 4,
    @ID_пользователя = 2;

EXEC Добавить_Вопрос
    @ID = 5,
    @Текст = 'Вопрос 5, ответ нет',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 9,
    @Текст = 'Да',
    @Правильный = 0,
    @ID_вопроса = 5,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 10,
    @Текст = 'Нет',
    @Правильный = 1,
    @ID_вопроса = 5,
    @ID_пользователя = 2;

EXEC Добавить_Вопрос
    @ID = 6,
    @Текст = 'Вопрос 6, ответ нет',
    @ID_теста = 1,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 11,
    @Текст = 'Да',
    @Правильный = 0,
    @ID_вопроса = 6,
    @ID_пользователя = 2;

EXEC Добавить_Ответ
    @ID = 12,
    @Текст = 'Нет',
    @Правильный = 1,
    @ID_вопроса = 6,
    @ID_пользователя = 2;



-- ============================== Вывод информации о тесте ==============================
CREATE OR ALTER FUNCTION Информация_О_Тесте(@ID_теста INT)
RETURNS TABLE
AS
RETURN 
SELECT Название, Описание
FROM Тест
WHERE ID = @ID_теста;
GO

-- ============================== Вывод вопросов теста ==============================
CREATE OR ALTER FUNCTION Вопросы_Теста(@ID_теста INT)
RETURNS TABLE
AS
RETURN 
SELECT ID, Текст AS Вопрос
FROM Вопрос
WHERE ID_теста = @ID_теста;
GO

SELECT * FROM Информация_О_Тесте(1);
SELECT * FROM Вопросы_Теста(1);


-- ============================== Проверка ответов ==============================
CREATE OR ALTER PROCEDURE ПроверитьОтветы (
    @ID_теста INT,
    @ID_пользователя INT,
    @Ответы NVARCHAR(MAX)
)
AS
BEGIN
    -- Создаем таблицу для хранения ответов
    CREATE TABLE #Ответы (ID_вопроса INT, Ответ NVARCHAR(3));

    -- Разделяем строку ответов на отдельные ответы
    DECLARE @ID_вопроса INT = 1;
    DECLARE @Ответ NVARCHAR(3);
    WHILE LEN(@Ответы) > 0
    BEGIN
        IF CHARINDEX(',', @Ответы) > 0
        BEGIN
            SET @Ответ = SUBSTRING(@Ответы, 1, CHARINDEX(',', @Ответы) - 1);
            SET @Ответы = SUBSTRING(@Ответы, CHARINDEX(',', @Ответы) + 1, LEN(@Ответы));
        END
        ELSE
        BEGIN
            SET @Ответ = @Ответы;
            SET @Ответы = '';
        END
        INSERT INTO #Ответы VALUES (@ID_вопроса, @Ответ);
        SET @ID_вопроса = @ID_вопроса + 1;
    END

    -- Проверяем, что количество ответов соответствует количеству вопросов в тесте
    DECLARE @КоличествоВопросов INT;
    SELECT @КоличествоВопросов = COUNT(*) FROM Вопрос WHERE ID_теста = @ID_теста;
    IF @КоличествоВопросов <> @ID_вопроса - 1
    BEGIN
        PRINT 'Ошибка: количество ответов не соответствует количеству вопросов в тесте.';
        RETURN;
    END

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
    INNER JOIN #Ответы ON Вопрос.ID = #Ответы.ID_вопроса
    WHERE Вопрос.ID_теста = @ID_теста
    AND Ответ.Правильный = CASE
        WHEN #Ответы.Ответ = 'Да' THEN 1
        WHEN #Ответы.Ответ = 'Нет' THEN 0
        ELSE NULL
    END;

    -- Вычисляем оценку
    DECLARE @ПравильныеОтветы INT;
    DECLARE @Оценка FLOAT;

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

    -- Добавляем результаты в таблицу Результат_теста
    INSERT INTO Результат_теста (ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл)
    VALUES (@ID_пользователя, @ID_теста, GETDATE(), @Оценка);

    -- Удаляем временные таблицы
    DROP TABLE #Ответы;
    DROP TABLE #Результаты;
END;
GO

EXEC ПроверитьОтветы @ID_теста = 1, @ID_пользователя = 1, @Ответы = 'Да,Нет,Да,Да,Да';

select * from Результат_теста;


CREATE OR ALTER FUNCTION ВсеРезультаты()
RETURNS TABLE
AS
RETURN 
SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл
FROM Результат_теста;
GO

CREATE OR ALTER FUNCTION РезультатыПользователя(@ID_пользователя INT)
RETURNS TABLE
AS
RETURN 
SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл
FROM Результат_теста
WHERE ID_пользователя = @ID_пользователя;
GO

CREATE OR ALTER FUNCTION РезультатыТеста(@ID_теста INT)
RETURNS TABLE
AS
RETURN 
SELECT ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл
FROM Результат_теста
WHERE ID_теста = @ID_теста;
GO

SELECT * FROM ВсеРезультаты();

SELECT * FROM РезультатыПользователя(1);

SELECT * FROM РезультатыТеста(1);


-- ============================== Изменение данных о пользователе ==============================
CREATE OR ALTER PROCEDURE ИзменитьДанныеПользователя
    @ID_пользователя INT,
    @ID_администратора INT,
    @НовоеИмя NVARCHAR(100),
    @НоваяФамилия NVARCHAR(100),
    @НовыйEmail NVARCHAR(100),
    @НовыйПароль NVARCHAR(100),
    @НовыеДанные NVARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_администратора AND Роль = 'Администратор')
    BEGIN
        UPDATE Пользователь
        SET Имя = @НовоеИмя,
            Фамилия = @НоваяФамилия,
            email = @НовыйEmail,
            Пароль = HASHBYTES('SHA2_256', @НовыйПароль),
            Данные = @НовыеДанные
        WHERE ID = @ID_пользователя;

        SELECT 1 AS Result, 'Данные пользователя успешно обновлены.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 0 AS Result, 'Ошибка: только администратор может изменять данные пользователя.' AS Message;
    END
END;
GO

EXEC ИзменитьДанныеПользователя @ID_пользователя = 1, @ID_администратора = 4, @НовоеИмя = 'Dmitry', @НоваяФамилия = 'Trubach', 
@НовыйEmail = 'dima1@mail.ru', @НовыйПароль = 'dima123', @НовыеДанные = 'Тест 1';


SELECT * FROM Пользователь;

-- ============================== Изменение роли ==============================
CREATE OR ALTER PROCEDURE ИзменитьРольПользователя
    @ID_пользователя INT,
    @ID_администратора INT,
    @НоваяРоль NVARCHAR(20)
AS
BEGIN
    -- Проверяем, является ли пользователь с @ID_администратора администратором
    IF EXISTS (SELECT 1 FROM Пользователь WHERE ID = @ID_администратора AND Роль = 'Администратор')
    BEGIN
        -- Если пользователь является администратором, обновляем роль пользователя
        UPDATE Пользователь
        SET Роль = @НоваяРоль
        WHERE ID = @ID_пользователя;

        SELECT 1 AS Result, 'Роль пользователя успешно обновлена.' AS Message;
    END
    ELSE
    BEGIN
        -- Если пользователь не является администратором, возвращаем сообщение об ошибке
        SELECT 0 AS Result, 'Ошибка: только администратор может изменять роль пользователя.' AS Message;
    END
END;
GO

EXEC ИзменитьРольПользователя @ID_пользователя = 2, @ID_администратора = 4, @НоваяРоль = 'Преподаватель';