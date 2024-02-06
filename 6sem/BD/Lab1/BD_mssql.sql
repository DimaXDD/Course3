CREATE DATABASE LabBD;

USE LabBD;

CREATE TABLE Тест (
    ID INT PRIMARY KEY,
    Название VARCHAR(100),
    Описание VARCHAR(255),
    Предмет VARCHAR(100)
);

CREATE TABLE Вопрос (
    ID INT PRIMARY KEY,
    Текст VARCHAR(255),
    Варианты_ответов VARCHAR(255),
    ID_теста INT,
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);

CREATE TABLE Ответ (
    ID INT PRIMARY KEY,
    Текст VARCHAR(255),
    Правильный BIT,
    ID_вопроса INT,
    FOREIGN KEY (ID_вопроса) REFERENCES Вопрос(ID)
);

CREATE TABLE Пользователь (
    ID INT PRIMARY KEY,
    Имя VARCHAR(100),
    Роль VARCHAR(50),
    Данные VARCHAR(255)
);

CREATE TABLE Результат_теста (
    ID_пользователя INT,
    ID_теста INT,
    Дата_и_время TIMESTAMP,
    Итоговый_балл FLOAT,
    PRIMARY KEY (ID_пользователя, ID_теста),
    FOREIGN KEY (ID_пользователя) REFERENCES Пользователь(ID),
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);