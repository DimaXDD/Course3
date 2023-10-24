CREATE DATABASE PoetryDatabase;
USE PoetryDatabase;

CREATE TABLE poems (
                       id INT identity(1,1) PRIMARY KEY,
                       author VARCHAR(255),
                       year INT,
                       poem varbinary(max)
);


-- Вставляем данные в таблицу poems с использованием преобразования в VARBINARY(MAX)
INSERT INTO poems (author, year, poem)
VALUES ('Пушкин', 1823, CONVERT(varbinary(max), 'BLOB_DATA_FOR_POEM_1!!'));

INSERT INTO poems (author, year, poem)
VALUES ('Лермонтов', 1831, CONVERT(varbinary(max), 'Сонет. BLOB_DATA_FOR_POEM_2. акупук11!!!!'));

INSERT INTO poems (author, year, poem)
VALUES ('Некрасов', 1911, CONVERT(varbinary(max), 'Сонет'));

INSERT INTO poems (author, year, poem)
VALUES ('Некрасов', 1912, CONVERT(varbinary(max), 'Сонет номер 2'));

INSERT INTO poems (author, year, poem)
VALUES ('Пушкин', 1823, CONVERT(varbinary(max), '!!#!!!!'));

INSERT INTO poems (author, year, poem)
VALUES ('Лермонтов', 1837, CONVERT(varbinary(max), 'Сонет.'));

select * from poems;

-- Чтобы вывести просто текст
SELECT id, author, year, CONVERT(VARCHAR(MAX), poem) AS poem_text
FROM poems;