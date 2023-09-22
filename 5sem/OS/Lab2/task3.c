#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main()
{
    for (short i = 1; i <= 1000; i++) {
        printf("%d-%d\n", getpid(), i);
        sleep(2);
    }
}