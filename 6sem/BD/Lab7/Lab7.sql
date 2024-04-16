-- Task 1
-- Через MODEL
-- Создание плана улучшения производительности каждого студента, 
-- увеличивая их средний балл на 10% каждый раз при прохождении от предыдущего.

SELECT *
FROM (
  SELECT ID_пользователя,
         TRUNC(Дата_и_время, 'MM') AS Месяц,
         AVG(Итоговый_балл) AS Средний_балл
  FROM Результат_теста
  GROUP BY ID_пользователя, TRUNC(Дата_и_время, 'MM')
)
MODEL
  PARTITION BY (ID_пользователя)
  DIMENSION BY (ROW_NUMBER() OVER (PARTITION BY ID_пользователя ORDER BY Месяц) AS rn)
  MEASURES (Средний_балл, Месяц)
  RULES (
    Средний_балл[rn > 1] = LEAST(100, CASE WHEN Средний_балл[CV() - 1] < 100 THEN Средний_балл[CV() - 1] * 1.1 ELSE Средний_балл[CV() - 1] END)
  )
ORDER BY ID_пользователя, Месяц;
    
-- Task 2
-- Рост, падение, рост итогового балла для каждого студента

INSERT ALL
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (23, 7, 1, TO_DATE('2024-01-01T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 10)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (24, 7, 1, TO_DATE('2024-01-02T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 30)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (25, 7, 1, TO_DATE('2024-01-03T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 20)
    INTO Результат_теста (ID, ID_пользователя, ID_теста, Дата_и_время, Итоговый_балл) VALUES (26, 7, 1, TO_DATE('2024-01-04T14:30:00', 'YYYY-MM-DD"T"HH24:MI:SS'), 40)
SELECT 1 FROM dual;


select * from Результат_теста;

-- 1 версия
SELECT *
FROM Результат_теста
MATCH_RECOGNIZE (
  PARTITION BY ID_пользователя
  ORDER BY Дата_и_время
  MEASURES
    FIRST(Итоговый_балл) AS начальный_балл,
    FINAL LAST(Итоговый_балл) AS конечный_балл,
    CLASSIFIER() AS pattern_match
  ONE ROW PER MATCH
  AFTER MATCH SKIP TO NEXT ROW
  PATTERN (Рост Падение Рост)
  DEFINE
    Рост AS Итоговый_балл > PREV(Итоговый_балл),
    Падение AS Итоговый_балл < PREV(Итоговый_балл)
)

-- 2 версия
SELECT *
FROM Результат_теста
MATCH_RECOGNIZE (
  PARTITION BY ID_пользователя
  ORDER BY Дата_и_время
  MEASURES
    FIRST(Итоговый_балл) AS начальный_балл,
    FINAL LAST(Итоговый_балл) AS конечный_балл,
    CLASSIFIER() AS pattern_match
  ONE ROW PER MATCH
  AFTER MATCH SKIP TO NEXT ROW
  PATTERN (Старт Рост* Падение* Рост*)
  DEFINE
    Старт AS Итоговый_балл IS NOT NULL,
    Рост AS Итоговый_балл > PREV(Итоговый_балл),
    Падение AS Итоговый_балл < PREV(Итоговый_балл)
)
