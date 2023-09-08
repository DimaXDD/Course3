@echo off
title z03-01
:: > nul 2>&1 для того, чтобы не было видно выполнения этой команды
chcp 65001 > nul 2>&1
echo Текущий пользователь, %username%!
echo Текущее дата и время: %date% , %time%
echo Имя компьютера: %hostname%
whoami
pause