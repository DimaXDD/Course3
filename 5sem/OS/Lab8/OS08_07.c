#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sched.h>

int main()
{
	pid_t pid = getpid();
	printf("[OS08_07] PID = %d\n", pid);
	sleep(10);

	void* memr = malloc(1024 * 1024 * 256);
	printf("memr(1024 * 1024) = %p\n", memr);

	int* arr = (int*)memr;
	for (int i = 0; i < 256; i++)
		arr[i] = i;

	sleep(20);
	exit(0);
}