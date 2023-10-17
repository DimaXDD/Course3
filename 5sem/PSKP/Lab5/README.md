# Как залить свой пакет на npm?
### 1)  Создайте папку с именем m05_XXX и перейдите в нее
```
mkdir m05_XXX
cd m05_XXX
```
### 2)	Создайте файл package.json для вашего пакета и укажите в нем некоторые данные, например:
```
{
  "name": "m05_tds_v1",
  "version": "1.0.0",
  "description": "",
  "main": "m05_TDS.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "Dmitry Trubach",
  "license": "ISC",

  "dependencies": {
    "nodemailer": "^6.9.6",
    "nodemailer-smtp-transport": "^2.7.4"
  }
```
### 3)	В файле m05_TDS.js поместите ваш код с прошлого задания
### 4)	Опубликуйте ваш пакет на npm
```
npm publish

```
### 5) Перейдите на сайт http://npmjs.com и введите в поиске название вашего пакета (m05_XXX). Если он есть, то все хорошо, если нет - плохо(
### 6) Создайте новую папку для вашего приложения 06-04 и перейдите в нее
```
mkdir 05-04
cd 05-04

```
### 7) Инициализируйте новый проект npm в этой папке
```
mkdir 05-04
cd 05-04

```
### 8) Инициализируйте новый проект npm в этой папке
```
npm init

```
### 9) Установите пакет m05_XXX с помощью npm
```
npm install m06_XXX

```
### 10) Мне лень, поэтому дальше эти команды
```
npm uninstall m06_XXX
npm install -g m06_XXX

```