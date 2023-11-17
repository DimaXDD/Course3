#include <stdio.h>
#include <time.h>

int main() {
    time_t rawtime;
    struct tm *info;

    time(&rawtime);
    info = localtime(&rawtime);

    printf("%02d.%02d.%04d %02d:%02d:%02d\n",
           info->tm_mday, info->tm_mon + 1, info->tm_year + 1900,
           info->tm_hour, info->tm_min, info->tm_sec);

    return 0;
}