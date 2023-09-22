#!/bin/bash

pid=$1
isfd=$2
regex='^[0-9]+$'


if [ "$pid" = "" ]
then
	echo -e "\n---------------------------------"
	echo "  Missing first argument - PID!"
	echo -e "---------------------------------\n"
	exit
elif ! [[ $pid =~ $regex ]]
then
	echo -e "\n-------------------------"
	echo "   Enter correct PID!"
	echo -e "-------------------------\n"
	exit
fi


if ps -p $pid > /dev/null
then
	echo -e "\n----------------------------"
	echo -n "Name:    "
	ps -p $pid -o comm=
	echo "PID:     $pid"
	echo -n "PPID:   "
	ps -o ppid= -p $pid
else
	echo -e "\n---------------------------------------"
	echo "  There is no process with PID = $pid"
	echo -e "---------------------------------------\n"
	exit
fi


if [ "$isfd" = "fd" ]
then
	echo -n "FD:"
	ls -l /proc/$pid/fd | awk '{print $9}'
fi


echo -e "----------------------------\n"