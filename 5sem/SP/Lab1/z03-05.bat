@echo off
title z03-05
chcp 65001 > nul 2>&1
cls
echo --Первый параметр: %1
echo --Второй параметр: %2
echo --Третий параметр: %3
set /A result = %1 %3 %2
echo %result%
pause