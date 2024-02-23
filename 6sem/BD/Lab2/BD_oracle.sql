CREATE TABLE Пользователь (
    ID NUMBER PRIMARY KEY,
    Имя NVARCHAR2(100),
    Фамилия NVARCHAR2(100),
    Пароль NVARCHAR2(100),
    Роль NVARCHAR2(20),
    Данные NVARCHAR2(100)
);

CREATE TABLE Тест (
    ID NUMBER PRIMARY KEY,
    Название NVARCHAR2(100),
    Описание NVARCHAR2(255),
    Предмет NVARCHAR2(100)
);

CREATE TABLE Вопрос (
    ID NUMBER PRIMARY KEY,
    Текст NVARCHAR2(255),
    ID_теста NUMBER,
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);

CREATE TABLE Ответ (
    ID NUMBER PRIMARY KEY,
    Текст NVARCHAR2(255),
    Правильный NUMBER(1),
    ID_вопроса NUMBER,
    FOREIGN KEY (ID_вопроса) REFERENCES Вопрос(ID)
);

CREATE TABLE Результат_теста (
    ID NUMBER PRIMARY KEY,
    ID_пользователя NUMBER,
    ID_теста NUMBER,
    Дата_и_время DATE,
    Итоговый_балл FLOAT,
    FOREIGN KEY (ID_пользователя) REFERENCES Пользователь(ID),
    FOREIGN KEY (ID_теста) REFERENCES Тест(ID)
);
