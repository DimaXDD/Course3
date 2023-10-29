#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sched.h>

int main()
{
    pid_t pid = getpid();
    pid_t tid = gettid();
    int nicity = nice(0);
    cpu_set_t set;
    CPU_ZERO(&set);

    printf("PID = %d\nTID = %d\nNice = %d\n", pid, tid, nicity);

    if (sched_getaffinity(0, sizeof(cpu_set_t), &set) == 0)
    {
        int is = 0;
        for (int i = 0; i < CPU_SETSIZE; ++i)
        {
            if (CPU_ISSET(i, &set))
                printf("CPU = %i is set\n", i);
        }
    }
    else
        printf("[ERROR]: shed_getaffinity returned -1.");

    exit(0);
}