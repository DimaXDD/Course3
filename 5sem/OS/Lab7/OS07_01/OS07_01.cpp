#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <time.h>

int main() {
    time_t rawtime;
    struct tm info;
    char buffer[80];

    time(&rawtime);
    localtime_s(&info, &rawtime);

    strftime(buffer, sizeof(buffer), "%d.%m.%Y %H:%M:%S", &info);
    printf("%s\n", buffer);

    return 0;
}