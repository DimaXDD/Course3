# Приложение запускается на архитектуре x86, если хотите запускать на x64:
### 1)  Где есть
```
#pragma comment(lib, "../debug/OS10_HTAPI.lib")
```
### Меняйте на
```
#pragma comment(lib, "../x64/debug/OS10_HTAPI.lib")
```