#include <stdio.h>
#include <stdlib.h> 
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <locale.h>

int main()
{
    char *locale = setlocale(LC_ALL, "ru");
    char c;
    int rowNumber = 0;
    int in = open("./OS09_05.txt", O_RDONLY);
    int bytesRead = 0;
    int isNewLine = 1; // Флаг для отслеживания новой строки

    while (read(in, &c, 1) == 1) {
        bytesRead++;
        if (c == '\n') {
            rowNumber++;
            isNewLine = 1;
        } else if (c != '\n' && isNewLine) {
            isNewLine = 0;
        }
    }

    // Добавляем проверку последнего символа в файле
    if (bytesRead > 0 && !isNewLine) {
        rowNumber++;
    }

    printf("Number of lines: %d\n", rowNumber);
    return 0;
}