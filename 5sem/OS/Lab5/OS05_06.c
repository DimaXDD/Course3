#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sched.h>

/*
 Ctrl+Z:  Stop process
 bg:   Move process to background
 fg [%n]: Move process [%n] to foreground
 jobs:  All processes in this bash console
 kill -9: Terminate process
 <cmd> &: Start command in bg

 vmstart 5 - command for easier demonstration
*/

int main()
{
    pid_t pid = getpid();
    pid_t tid = gettid();

    for (int i = 0; i < 1000000; ++i)
    {
        printf("PID:  %d\nTID:  %d\n\n", pid, tid);
        sleep(1);
    }
}