create database Lab17NodeJS;

use Lab17NodeJS;

-- Создание таблицы Users
CREATE TABLE Users (
    username CHAR(20) NOT NULL PRIMARY KEY,
    FIO VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);