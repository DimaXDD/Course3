use TESTING;

select * from Тест; -- для просмотра ID
SELECT * FROM Все_тесты;

-- Task 1-3
-- Вычисление среднего итогового балла тестов помесячно, за квартал, за полгода, за год

INSERT INTO Результат_теста (ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES
(5, 1, '2024-01-15T14:30:00', 100),
(6, 1, '2024-01-20T15:45:00', 40),
(7, 1, '2024-02-25T16:00:00', 60),
(8, 1, '2024-03-10T14:30:00', 20),
(9, 1, '2024-05-20T15:45:00', 0),
(8, 1, '2024-07-25T16:00:00', 100),
(9, 1, '2024-10-05T14:30:00', 60),
(6, 1, '2024-11-15T15:45:00', 60),
(5, 1, '2024-12-20T16:00:00', 60);

SELECT 
    YEAR(Дата_и_время) AS Год,
    CASE
        WHEN MONTH(Дата_и_время) BETWEEN 1 AND 12 THEN MONTH(Дата_и_время)
        ELSE NULL
    END AS Месяц,
    'Год' AS Период,
    CASE
        WHEN MONTH(Дата_и_время) BETWEEN 1 AND 6 THEN '1-й квартал'
        WHEN MONTH(Дата_и_время) BETWEEN 7 AND 12 THEN '2-й квартал'
        ELSE NULL
    END AS Квартал,
    AVG(Итоговый_балл) AS Средний_балл
FROM Результат_теста
GROUP BY 
    GROUPING SETS (
        (YEAR(Дата_и_время), 
        CASE
            WHEN MONTH(Дата_и_время) BETWEEN 1 AND 12 THEN MONTH(Дата_и_время)
            ELSE NULL
        END,
        CASE
            WHEN MONTH(Дата_и_время) BETWEEN 1 AND 6 THEN '1-й квартал'
            WHEN MONTH(Дата_и_время) BETWEEN 7 AND 12 THEN '2-й квартал'
            ELSE NULL
        END),
        (YEAR(Дата_и_время)),
        (CASE
            WHEN MONTH(Дата_и_время) BETWEEN 1 AND 6 THEN '1-й квартал'
            WHEN MONTH(Дата_и_время) BETWEEN 7 AND 12 THEN '2-й квартал'
            ELSE NULL
        END)
    )
HAVING COUNT(*) > 0
ORDER BY Год, Месяц, Период, Квартал;

-- Task 4
-- Общее количество пройденных тестов пользователем за указанный период.
-- Сравнение количества пройденных тестов пользователя с общим количеством пройденных тестов всеми пользователями (в процентах).
-- Сравнение количества пройденных тестов пользователя с наилучшим результатом (наибольшим количеством пройденных тестов) среди всех пользователей (в процентах).

select * from Результат_теста;

DECLARE @UserID INT = 7;
DECLARE @StartDate DATETIME = '2024-01-15T14:30:00';
DECLARE @EndDate DATETIME = '2024-12-15T14:30:00';

SELECT
    COUNT(*) AS Общее_количество_тестов,
    CONCAT(
        CAST((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM Результат_теста WHERE Дата_и_время BETWEEN @StartDate AND @EndDate) AS DECIMAL(5, 2)),
        '%'
    ) AS Процент_от_общего_количества_тестов,
    CONCAT(
        CAST((COUNT(*) * 100.0) / (SELECT MAX(Пройденные_тесты) FROM (SELECT ID_пользователя, COUNT(*) AS Пройденные_тесты FROM Результат_теста WHERE Дата_и_время BETWEEN @StartDate AND @EndDate GROUP BY ID_пользователя) AS T) AS DECIMAL(5, 2)),
        '%'
    ) AS Процент_от_наилучшего_результата
FROM Результат_теста
WHERE ID_пользователя = @UserID
AND Дата_и_время BETWEEN @StartDate AND @EndDate;


-- Task 5
-- Запрос для разбиения результатов на страницы с сортировкой по столбцу "Дата_и_время"
select * from Результат_теста;
DECLARE @PageNumber INT = 3 -- Номер страницы
DECLARE @PageSize INT = 4; -- Размер страницы (количество строк на странице)
DECLARE @Startdate DATETIME = '2024-01-14T14:30:00';
DECLARE @Enddate DATETIME = '2024-12-31T14:30:00';

SELECT *
FROM
  (
    SELECT *, ROW_NUMBER() OVER (ORDER BY Дата_и_время) AS RowNum
    FROM Результат_теста
    WHERE Дата_и_время BETWEEN @Startdate AND @Enddate
  ) AS SubQuery
WHERE RowNum BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize;

-- Task 6
-- Запрос для удаления дубликатов с группировкой по столбцу "ID_теста" и сортировкой по столбцу "Дата_и_время"
select * from Результат_теста;

INSERT INTO Результат_теста (ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES
(5, 1, '2024-01-25T14:30:00', 60);

DECLARE @Start DATETIME = '2024-01-15T14:30:00';
DECLARE @End DATETIME = '2024-12-31T14:30:00';

WITH RankedResults AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID_теста, ID_пользователя, Итоговый_балл ORDER BY Дата_и_время) AS RowNum
    FROM Результат_теста
    WHERE Дата_и_время BETWEEN @Start AND @End
)

DELETE FROM Результат_теста
WHERE ID IN (
    SELECT ID
    FROM RankedResults
    WHERE RowNum > 1
);

	
-- Task 7?
-- Вернуть для каждого пользователя количество тестов за последние 6 месяцев помесячно
SELECT P.ID, P.Имя, P.Фамилия, DATEPART(YEAR, R.Дата_и_время) AS Год, DATEPART(MONTH, R.Дата_и_время) AS Месяц, COUNT(*) AS Количество_тестов
FROM Пользователь P
INNER JOIN Результат_теста R ON P.ID = R.ID_пользователя
WHERE R.Дата_и_время >= DATEADD(MONTH, -6, GETDATE())
GROUP BY P.ID, P.Имя, P.Фамилия, DATEPART(YEAR, R.Дата_и_время), DATEPART(MONTH, R.Дата_и_время);


-- Task 8
-- Какой тест сделал преподаватель, который был пройден наибольшее кол-во раз
-- Вернуть для каждого преподавателя

INSERT INTO Результат_теста (ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES
(5, 2, '2024-02-01T14:30:00', 80),
(6, 2, '2024-02-10T15:45:00', 50),
(7, 2, '2024-02-20T16:00:00', 70),
(8, 2, '2024-03-05T14:30:00', 30),
(9, 2, '2024-05-10T15:45:00', 10),
(8, 2, '2024-06-25T16:00:00', 90),
(9, 2, '2024-09-05T14:30:00', 50),
(8, 3, '2024-03-15T14:30:00', 20),
(9, 3, '2024-04-10T15:45:00', 0),
(8, 3, '2024-06-25T16:00:00', 100),
(9, 3, '2024-08-05T14:30:00', 60),
(6, 3, '2024-09-15T15:45:00', 60),
(5, 3, '2024-11-20T16:00:00', 60);


SELECT
    ID_преподавателя,
    ID_теста,
    Количество_прохождений
FROM (
    SELECT
        Пользователь.ID AS ID_преподавателя,
        Тест.ID AS ID_теста,
        COALESCE(Прохождения.Количество_прохождений, NULL) AS Количество_прохождений,
        ROW_NUMBER() OVER (PARTITION BY Пользователь.ID ORDER BY Тест.ID) AS Ранг
    FROM
        Пользователь
    LEFT JOIN
        Тест ON Пользователь.ID = Тест.ID_пользователя
    LEFT JOIN
        (
            SELECT
                ID_теста,
                COUNT(*) AS Количество_прохождений
            FROM
                Результат_теста
            GROUP BY
                ID_теста
        ) Прохождения ON Тест.ID = Прохождения.ID_теста
    WHERE
        Пользователь.Роль = 'Преподаватель'
) AS T
WHERE
    Ранг = 1
ORDER BY
    ID_преподавателя;