## Как запускать лабу:
### 1) Собираем OS13_HTCOM
### Тут меняйте путь на свой, ну или можете перенести нужные файлы сюда и подключить их относительно
```
#ifdef _WIN64
#pragma comment(lib, "E:\\3course\\5sem\\SP\\Lab3\\x64\\Debug\\OS10_HTAPI.lib")
#else
#pragma comment(lib, "E:\\3course\\5sem\\SP\\Lab3\\Debug\\OS10_HTAPI.lib")
#endif
```

### 2) Переходим в свойства проекта OS13_HTCOM, Компоновщик -> Ввод -> Пункт "Файл определения модуля" и пишем туда 
```
./OS13_HTCOM.def
```

### 3) Запустить коммандную строку от имени администратора
### 4) Переходим в папку с только что созданным DLL-файлом:
```
C:\Windows\system32>E:

E:\>cd 3course\5sem\SP\Lab5\Debug

E:\3course\5sem\SP\Lab5\Debug>
```
### 5) Пишем туда:
```
regsvr32 OS13_HTCOM.dll
```

### 6) Проверить в реестре: Компьютер\HKEY_CLASSES_ROOT\OS13.ComponentHT
### 7) Пересобираем OS13_HTCOM
### 8) Собираем OS13_HTCOM_LIB
### 9) Далее запускаем OS13_CREATE с командрой строки
```
OS13_CREATE 2000 3 4 4 HTspace.ht
```
```
ht::HtHandle* OS13_HTCOM::HT::create(OS13_HTCOM_HANDEL h, int capacity, int secSnapshotInterval, int maxKeyLength, int maxPayloadLength, const wchar_t* fileName)
```
### 10) Запускаем и не закрываем OS13_START с командной строки
```
OS13_START HTspace.ht
```

### 11) По аналогии с 4 (11) лабой запускаем проект OS_0402, OS_0403 и OS_0404 и показываем, что все работает

### 12) В конце запускаем OS13_STOP, чтобы завершить все процессы