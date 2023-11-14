## Как залить на Jenkins:
1) Создаем job, к примеру, Lab9
2) В шагах сборки выбираем Выполнить команду Windows и пишем туда
```
pushd E:\3course\5sem\TPO\Lab9 && mvn test && popd
```
E:\3course\5sem\TPO\Lab9 - заменить на ваш полный путь к лабе

## UPD: в файле NSVTestOLD старая версия тестирования, по заданию нужно делать так, как у меня в файлах NSVTest и NSVPage