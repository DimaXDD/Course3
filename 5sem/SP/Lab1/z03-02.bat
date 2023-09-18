@echo off
title z03-02
chcp 65001 > nul 2>&1
set "BatchName=%~n0"
for /f "tokens=1,2" %%i in ('dir "%BatchName%.bat" /tc ^| findstr /i "%BatchName%.bat"') do (
    set "CreationDate=%%i"
    set "CreationTime=%%j"
)

echo -- имя этого bat-файла: %~n0
echo -- этот bat-файл создан: %CreationDate% %CreationTime%
echo -- путь bat-файла: %~dp0
:: or type %~f0 for full file name
pause