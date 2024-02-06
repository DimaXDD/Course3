CREATE TABLE Тест (
    ID NUMBER(10) PRIMARY KEY,
    Название VARCHAR2(100),
    Описание VARCHAR2(255),
    Предмет VARCHAR2(100)
);

CREATE TABLE Вопрос (
    ID NUMBER(10) PRIMARY KEY,
    Текст VARCHAR2(255),
    Варианты_ответов VARCHAR2(255),
    ID_теста NUMBER(10),
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);

CREATE TABLE Ответ (
    ID NUMBER(10) PRIMARY KEY,
    Текст VARCHAR2(255),
    Правильный NUMBER(1),
    ID_вопроса NUMBER(10),
    FOREIGN KEY (ID_вопроса) REFERENCES Вопрос(ID)
);

CREATE TABLE Пользователь (
    ID NUMBER(10) PRIMARY KEY,
    Имя VARCHAR2(100),
    Роль VARCHAR2(50),
    Данные VARCHAR2(255)
);

CREATE TABLE Результат_теста (
    ID_пользователя NUMBER(10),
    ID_теста NUMBER(10),
    Дата_и_время TIMESTAMP,
    Итоговый_балл FLOAT,
    PRIMARY KEY (ID_пользователя, ID_теста),
    FOREIGN KEY (ID_пользователя) REFERENCES Пользователь(ID),
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);

