select * from Тест; -- для просмотра ID
SELECT * FROM Все_тесты;

-- Task 1-3
-- Вычисление среднего итогового балла тестов помесячно, за квартал, за полгода, за год
SELECT * FROM Результат_теста;

INSERT ALL
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (1, 5, 1, TO_DATE('2024-01-15T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 100)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (2, 6, 1, TO_DATE('2024-01-20T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 40)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (3, 7, 1, TO_DATE('2024-02-25T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (4, 8, 1, TO_DATE('2024-03-10T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 20)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (5, 9, 1, TO_DATE('2024-05-20T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 0)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (6, 8, 1, TO_DATE('2024-07-25T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 100)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (7, 9, 1, TO_DATE('2024-10-05T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (8, 6, 1, TO_DATE('2024-11-15T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (9, 5, 1, TO_DATE('2024-12-20T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (10, 5, 2, TO_DATE('2024-02-01T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 80)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (11, 6, 2, TO_DATE('2024-02-10T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 50)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (12, 7, 2, TO_DATE('2024-02-20T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 70)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (13, 8, 2, TO_DATE('2024-03-05T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 30)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (14, 9, 2, TO_DATE('2024-05-10T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 10)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (15, 8, 2, TO_DATE('2024-06-25T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 90)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (16, 9, 2, TO_DATE('2024-09-05T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 50)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (17, 8, 3, TO_DATE('2024-03-15T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 20)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (18, 9, 3, TO_DATE('2024-04-10T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 0)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (19, 8, 3, TO_DATE('2024-06-25T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 100)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (20, 9, 3, TO_DATE('2024-08-05T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (21, 6, 3, TO_DATE('2024-09-15T15:45:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (22, 5, 3, TO_DATE('2024-11-20T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60)
SELECT 1 FROM DUAL;

SELECT
    EXTRACT(YEAR FROM Дата_и_время) AS Год,
    CASE
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 1 AND 3 THEN '1-й квартал'
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 4 AND 6 THEN '2-й квартал'
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 7 AND 9 THEN '3-й квартал'
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 10 AND 12 THEN '4-й квартал'
        ELSE NULL
    END AS Квартал,
    CASE
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 1 AND 6 THEN '1-я половина года'
        WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 7 AND 12 THEN '2-я половина года'
        ELSE NULL
    END AS Половина_года,
    AVG(Итоговый_балл) AS Средний_балл
FROM Результат_теста
GROUP BY
    GROUPING SETS (
        (EXTRACT(YEAR FROM Дата_и_время),
        CASE
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 1 AND 3 THEN '1-й квартал'
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 4 AND 6 THEN '2-й квартал'
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 7 AND 9 THEN '3-й квартал'
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 10 AND 12 THEN '4-й квартал'
            ELSE NULL
        END,
        CASE
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 1 AND 6 THEN '1-я половина года'
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 7 AND 12 THEN '2-я половина года'
            ELSE NULL
        END),
        (EXTRACT(YEAR FROM Дата_и_время)),
        (CASE
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 1 AND 6 THEN '1-я половина года'
            WHEN EXTRACT(MONTH FROM Дата_и_время) BETWEEN 7 AND 12 THEN '2-я половина года'
            ELSE NULL
        END)
    )
HAVING COUNT(*) > 0
ORDER BY Год, Квартал, Половина_года;


-- Task 4
-- 1) Общее количество пройденных тестов пользователем за указанный период.
-- 2) Сравнение количества пройденных тестов пользователя с общим количеством пройденных 
-- тестов всеми пользователями (в процентах).
-- 3) Сравнение количества пройденных тестов пользователя с наилучшим результатом 
-- (наибольшим количеством пройденных тестов) среди всех пользователей (в процентах).

SELECT * FROM Результат_теста;

DECLARE
    UserID INT := 7;
    StartDate DATE := TO_DATE('2024-01-15T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS');
    EndDate DATE := TO_DATE('2024-12-15T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS');
    TotalTests NUMBER;
    OverallPercentage NUMBER;
    BestResultPercentage NUMBER;
BEGIN
    SELECT COUNT(*) INTO TotalTests
    FROM Результат_теста
    WHERE ID_пользователя = UserID
    AND Дата_и_время BETWEEN StartDate AND EndDate;

    SELECT (TotalTests * 100.0) / (SELECT COUNT(*) FROM Результат_теста WHERE Дата_и_время BETWEEN StartDate AND EndDate)
    INTO OverallPercentage
    FROM DUAL;

    SELECT (TotalTests * 100.0) / (SELECT MAX(Пройденные_тесты) FROM (SELECT ID_пользователя, COUNT(*) AS Пройденные_тесты FROM Результат_теста WHERE Дата_и_время BETWEEN StartDate AND EndDate GROUP BY ID_пользователя))
    INTO BestResultPercentage
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE('Общее количество тестов: ' || TotalTests);
    DBMS_OUTPUT.PUT_LINE('Процент от общего количества тестов: ' || OverallPercentage || '%');
    DBMS_OUTPUT.PUT_LINE('Процент от наилучшего результата: ' || BestResultPercentage || '%');
END;
/

-- !!! Задания из прошлой лабы (их почему-то нет для оракла)
-- Запрос для разбиения результатов на страницы с сортировкой по столбцу "Дата_и_время"
DECLARE
  PageNumber INT := 3; -- Номер страницы
  PageSize INT := 4; -- Размер страницы (количество строк на странице)
  Startdate DATE := TO_DATE('2024-01-14T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS');
  Enddate DATE := TO_DATE('2024-12-31T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS');
  RowNum INT := 0;
BEGIN
  FOR Results IN (
    SELECT *
    FROM (
      SELECT Результат_теста.*,
             ROW_NUMBER() OVER (ORDER BY Дата_и_время) AS RNum
      FROM Результат_теста
      WHERE Дата_и_время BETWEEN Startdate AND Enddate
    )
  )
  LOOP
    RowNum := RowNum + 1;
    
    IF RowNum BETWEEN (PageNumber - 1) * PageSize + 1 AND PageNumber * PageSize THEN
      -- Обработка результатов
      DBMS_OUTPUT.PUT_LINE('ID: ' || Results.ID || ', ID_пользователя: ' || Results.ID_пользователя || ', ID_теста: ' || Results.ID_теста || ', Дата_и_время: ' || TO_CHAR(Results.Дата_и_время, 'YYYY-MM-DD HH24:MI:SS') || ', Итоговый_балл: ' || Results.Итоговый_балл);
    END IF;
    
    EXIT WHEN RowNum = PageNumber * PageSize;
  END LOOP;
END;

-- Запрос для удаления дубликатов с группировкой по столбцу "ID_теста" и 
-- сортировкой по столбцу "Дата_и_время"
select * from Результат_теста;

INSERT INTO Результат_теста 
(ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) 
VALUES (23, 5, 3, TO_DATE('2024-11-25T16:00:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 60);

-- ======== Не знаю как сделать ========


-- Task 5
-- Вернуть для каждого пользователя количество тестов за последние 6 месяцев помесячно
SELECT P.ID, P.Имя, P.Фамилия, 
       EXTRACT(YEAR FROM R.Дата_и_время) AS Год, 
       EXTRACT(MONTH FROM R.Дата_и_время) AS Месяц, 
       COUNT(*) OVER (PARTITION BY P.ID, EXTRACT(YEAR FROM R.Дата_и_время), EXTRACT(MONTH FROM R.Дата_и_время)) AS Количество_тестов
FROM Пользователь P
INNER JOIN Результат_теста R ON P.ID = R.ID_пользователя
WHERE R.Дата_и_время >= SYSDATE - INTERVAL '6' MONTH AND R.Дата_и_время < SYSDATE;


-- Task 6
-- Какой тест сделал преподаватель, который был пройден наибольшее кол-во раз
-- Вернуть для каждого преподавателя
SELECT
    ID_преподавателя,
    ID_теста,
    Количество_прохождений
FROM (
    SELECT
        Пользователь.ID AS ID_преподавателя,
        Тест.ID AS ID_теста,
        NVL(Прохождения.Количество_прохождений, NULL) AS Количество_прохождений,
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
) T
WHERE
    Ранг = 1
ORDER BY
    ID_преподавателя;