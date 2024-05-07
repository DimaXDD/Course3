-- Функция, с которой будем брать результаты
CREATE OR REPLACE FUNCTION SelectAnswersByTestId
(
    TestId NUMBER
)
RETURN SYS_REFCURSOR
AS
    TestAnswers SYS_REFCURSOR;
BEGIN
    OPEN TestAnswers FOR
    SELECT o.ID AS AnswerID, o.Текст AS AnswerText, o.Правильный AS IsCorrect,
           v.ID AS QuestionID, v.Текст AS QuestionText
    FROM Ответ o
    INNER JOIN Вопрос v ON o.ID_вопроса = v.ID
    WHERE v.ID_теста = TestId;
    
    RETURN TestAnswers;
END;
/

-- Экспорт
CREATE DIRECTORY results_dir AS 'C:\BFILE';

DECLARE
  file_handle UTL_FILE.FILE_TYPE;
  test_answers SYS_REFCURSOR;
  answer_id NUMBER;
  answer_text VARCHAR2(4000);
  is_correct VARCHAR2(1);
  question_id NUMBER;
  question_text VARCHAR2(4000);
BEGIN
  file_handle := UTL_FILE.FOPEN('RESULTS_DIR', 'results.csv', 'w', 32767, 'UTF8');

  test_answers := SelectAnswersByTestId(TestId => 1);

  LOOP
    FETCH test_answers INTO answer_id, answer_text, is_correct, question_id, question_text;
    EXIT WHEN test_answers%NOTFOUND;
    UTL_FILE.PUT_LINE(file_handle, TO_CHAR(answer_id) || ';' || answer_text || ';' || is_correct || ';' || TO_CHAR(question_id) || ';' || question_text);
  END LOOP;

  UTL_FILE.FCLOSE(file_handle);
  CLOSE test_answers;

  DBMS_OUTPUT.PUT_LINE('Результаты экспортированы в файл.');

EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.IS_OPEN(file_handle) THEN
      UTL_FILE.FCLOSE(file_handle);
    END IF;
    RAISE;
END;
/


-- Импорт
-- Создаем таблицу
CREATE TABLE results (
  answer_id     NUMBER,
  answer_text   VARCHAR2(4000),
  is_correct    VARCHAR2(1),
  question_id   NUMBER,
  question_text VARCHAR2(4000)
);

-- В CMD пишем
-- 1 команда:
-- SET NLS_LANG=.UTF8
-- 2 команда:
-- sqlldr C##TDS/1111@orcl control=results.ctl
-- где C##TDS - юзер, 1111 - его пароль, orcl - имя БД
-- results.ctl - файл с указаниями, его содержимое внизу (создаем там же, где
-- и будет наш файл экспорта (у меня это C:\BFILE\results.ctl)

select * from results;

drop table results;



  
