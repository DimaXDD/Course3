@echo off
title z03-03
chcp 65001 > nul 2>&1
cls
echo --Строка параметров:  %*
echo --Параметр 1: %1
echo --Параметр 2: %2
echo --Параметр 3: %3
echo --Параметр 4: %4
pause