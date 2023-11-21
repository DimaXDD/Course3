## Как запустить лабу:
### 1) Собрать проекты OS11_HTAPI и OS11_CREATE
### 2) Запустить OS11_CREATE через командную строку с такими параметрами (исходя по заданию):
```
OS11_CREATE.exe 2000 3 4 4 HTspace.ht
```

```C++
HtHandle* create(
	int	  capacity,					// емкость хранилища
	int   secSnapshotInterval,		// переодичность сохранения в сек.
	int   maxKeyLength,             // максимальный размер ключа
	int   maxPayloadLength,			// максимальный размер данных
	const wchar_t* fileName)		// имя файла 
{
	...
}
```

### 3) Запустить OS11_START через командную строку с такими параметрами:
```
OS11_START.exe HTspace.ht
```

```C++
HtHandle* open
(
	const wchar_t* fileName,         // имя файла
	bool isMapFile)					// true если открыть fileMapping; false если открыть файл; по умолчанию false
{
	...
}
```

### 4) Дальше запускаете задания OS11_02, OS11_03, OS11_04 и показываете, что всё выполняется