use TESTING;

-- 1. Создайте таблицу Report, содержащую два столбца – id и XML-столбец в базе данных SQL Server.
CREATE TABLE Report (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ReportData XML
);

SELECT * FROM Report;


-- 2. Создайте процедуру генерации XML. XML должен включать данные из как минимум 3 соединенных таблиц, 
-- различные промежуточные итоги и штамп времени.
CREATE OR ALTER PROCEDURE GenerateXMLReport
AS
BEGIN
    DECLARE @ReportXML XML;

    SET @ReportXML = (
        SELECT 
            P.ID AS ПользовательID,
            P.Имя,
            P.Фамилия,
            T.ID AS ТестID,
            T.Название AS НазваниеТеста,
            T.Описание AS ОписаниеТеста,
            R.ID AS РезультатID,
            R.Дата_и_время,
            R.Итоговый_балл,
            (
                SELECT 
                    Q.ID AS ВопросID,
                    Q.Текст AS ТекстВопроса,
                    (
                        SELECT 
                            A.ID AS ОтветID,
                            A.Текст AS ТекстОтвета,
                            A.Правильный AS ПравильныйОтвет
                        FROM Ответ A
                        WHERE A.ID_вопроса = Q.ID
                        FOR XML PATH('Ответ'), TYPE
                    )
                FROM Вопрос Q
                WHERE Q.ID_теста = T.ID
                FOR XML PATH('Вопрос'), TYPE
            ) AS Вопросы
        FROM Результат_теста R
        JOIN Пользователь P ON R.ID_пользователя = P.ID
        JOIN Тест T ON R.ID_теста = T.ID
        FOR XML PATH('Результат'), ROOT('Отчет'), TYPE
    );

    SELECT @ReportXML AS Report;
END;


EXEC GenerateXMLReport;

-- 3. Создайте процедуру вставки этого XML в таблицу Report.
CREATE OR ALTER PROCEDURE InsertXMLReport
AS
BEGIN
    DECLARE @ReportXML XML;

    CREATE TABLE #TempReport (Report XML);

    INSERT INTO #TempReport (Report)
    EXEC GenerateXMLReport;

    SELECT @ReportXML = Report FROM #TempReport;

    INSERT INTO Report (ReportData)
    VALUES (@ReportXML);

    DROP TABLE #TempReport;
END;

EXEC InsertXMLReport;

SELECT * FROM Report;


-- 4. Создайте индекс над XML-столбцом в таблице Report. 
CREATE PRIMARY XML INDEX PXML_ReportData_Index
ON Report (ReportData);


-- 5. Создайте процедуру извлечения значений элементов и/или атрибутов из XML -столбца 
-- в таблице Report (параметр – значение атрибута или элемента).
CREATE OR ALTER PROCEDURE ExtractFromXMLReport
    @ElementName NVARCHAR(100),
    @ElementValue NVARCHAR(100)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
    SELECT 
        ReportData.value(''(/Отчет/Результат/ПользовательID/text())[1]'', ''INT'') AS ПользовательID,
        ReportData.value(''(/Отчет/Результат/Имя/text())[1]'', ''NVARCHAR(100)'') AS Имя,
        ReportData.value(''(/Отчет/Результат/Фамилия/text())[1]'', ''NVARCHAR(100)'') AS Фамилия,
        ReportData.value(''(/Отчет/Результат/Дата_и_время/text())[1]'', ''DATETIME'') AS Дата_и_время,
        ReportData.value(''(/Отчет/Результат/Итоговый_балл/text())[1]'', ''FLOAT'') AS Итоговый_балл
    FROM Report
    WHERE ReportData.exist(''(/Отчет/Результат/' + @ElementName + '[text()="' + @ElementValue + '"])'') = 1;';

    EXEC sp_executesql @sql;
END;

EXEC ExtractFromXMLReport @ElementName = 'Имя', @ElementValue = 'Дмитрий';