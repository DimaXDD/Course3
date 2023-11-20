## Как залить на Jenkins:
1) Создаем job, к примеру, Lab10
2) В шагах сборки выбираем Выполнить команду Windows и пишем туда
```
pushd E:\3course\5sem\TPO\Lab10 && mvn clean test -Dtest=NSVTest && popd
```
E:\3course\5sem\TPO\Lab10 - заменить на ваш полный путь к лабе

## UPD: вот тут можно просто писать pushd E:\3course\5sem\TPO\Lab9 && mvn test -Dtest=NSVTest && popd, можно так и так