#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>


void cycle(int counter, char* message)
{
    for (int i = 1; i <= counter; ++i)
    {
        printf("%d. PID = %d [%s]\n", i, getpid(), message);
        sleep(2);
    }
}


int main()
{
    // fork() создает максимально подробную копию родительского процесса (копирует дескрипторы файлов итд).
    // дочерний процесс получает новый pid (обычно ppid+1) и имеет pid старого процесса в качестве ppid.
    // так как два процесса запускают один и тот же код, можно понять кто есть кто по возвращаемому значению. 
    // дочерний возвращает 0, а родительский возвращает pid дочернего

    pid_t pid;
    switch (pid = fork())
    {
    case -1: perror("[ERROR] Fork() returned -1");      // fork возвращает -1 при ошибке (например нехватка свободных дескрипторов или памяти)
             exit(-1);
    case  0: cycle(50, "OS03_05_1");                  // дочерний процесс возвращает 0
             exit(0);
    default: printf("[INFO] default = %d\n", pid);          // родительский процесс возвращает pid дочернего
             cycle(100, "OS03_05");
             wait(0);                // ожидается завершение дочернего процесса
    }
    exit(0);
}

// Найти форкнутые процессы: ps -A | grep .out