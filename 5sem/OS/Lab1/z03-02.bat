@echo off
title z03-02
chcp 65001 > nul 2>&1
cls
echo --Имя этого bat-файла:     %~n0
echo --Путь bat-файла:     %~dpnx0 
:: or type %~f0 for full file name
pause