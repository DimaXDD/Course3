#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    int filedesc = open("OS09_05.txt", O_RDONLY);

    if (filedesc < 0) {
        return -1;
    }

    // Перемещаемся на 10 байт от начала файла
    lseek(filedesc, 10, SEEK_SET);

    char buffer[11];
    read(filedesc, buffer, 10);
    buffer[10] = '\0';

    printf("Символы 11-20 файла: %s\n", buffer);

    close(filedesc);
    return 0;
}