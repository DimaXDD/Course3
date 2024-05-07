USE TESTING;

CREATE FUNCTION SelectAnswersByTestId
(
    @TestId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT o.ID AS AnswerID, o.Текст AS AnswerText, o.Правильный AS IsCorrect,
           v.ID AS QuestionID, v.Текст AS QuestionText
    FROM Ответ o
    INNER JOIN Вопрос v ON o.ID_вопроса = v.ID
    WHERE v.ID_теста = @TestId
);

SELECT * FROM SelectAnswersByTestId(1);

-- Создание файла с результатом функции
-- Код ниже делаем от админа, чтобы работал код ниже
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'xp_cmdshell', 1;
GO
RECONFIGURE;
GO

-- Экспорт в файл
DECLARE @FilePath NVARCHAR(255) = 'E:\3course\6sem\BD\Lab11\dataMSSQL.csv';
DECLARE @Command NVARCHAR(1000);

SET @Command = 'bcp "SELECT CAST(AnswerID AS NVARCHAR(MAX)) + '';'' + AnswerText + '';'' + CAST(IsCorrect AS NVARCHAR(MAX)) + '';'' + CAST(QuestionID AS NVARCHAR(MAX)) + '';'' + QuestionText FROM TESTING.dbo.SelectAnswersByTestId(1)" queryout "' + @FilePath + '" -c -T -t";" -S ' + @@SERVERNAME + ' -w -C 65001';

EXEC xp_cmdshell @Command;

-- Импорт из файла во временную таблицу
CREATE TABLE #TempAnswers (
    AnswerID INT,
    AnswerText NVARCHAR(255),
    IsCorrect BIT,
    QuestionID INT,
    QuestionText NVARCHAR(255)
);

DECLARE @File NVARCHAR(255) = 'E:\3course\6sem\BD\Lab11\dataMSSQL.csv';

DECLARE @SQL NVARCHAR(MAX);
SET @SQL = '
BULK INSERT #TempAnswers
FROM ''' + @File + '''
WITH (
    FIELDTERMINATOR = '';'',
    ROWTERMINATOR = ''\n''
);'

EXEC sp_executesql @SQL;

SELECT * FROM #TempAnswers;