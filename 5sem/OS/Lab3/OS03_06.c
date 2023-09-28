#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>


int main()
{
    // system - если exec полностью заменяет родительский процесс и никогда в него не возвращается,
    // то system разветвляется, запускает дочерний процесс и возвращает его статус. то есть system
    // запускает дочерний и ставит в ожидание родительский, а после завершения дочернего продолжает
    // работу с родителем. функционал system можно повторить с помощью fork exec wait

    system("./OS03_05_1");
    for (int i = 1; i <= 100; i++)
    {
        printf("%d. PID = %d [OS03_06]\n", i, getpid());
        sleep(1);
    }
    exit(0);
}