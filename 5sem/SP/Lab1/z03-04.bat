@echo off
title z03-04
chcp 65001 > nul 2>&1
cls
echo --Первый параметр: %1
echo --Второй параметр: %2
echo --Третий параметр: %3
set /A a = %1
set /A b = %2
set /A c = %3
set /A sum = a + b
set /A proi = a * b
set /A del = c / a
set /A mn1 = b - a
set /A mn2 = a - b
set /A proi3 = mn1 * mn2
echo %a% + %b% = %sum%
echo %a% * %b% = %proi%
echo %c% / %a% = %del%
echo (%b% - %a%) * (%a% - %b%) = %proi3%
pause