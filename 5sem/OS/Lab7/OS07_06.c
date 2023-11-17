#include <stdio.h>
#include <time.h>

int main() {
    clock_t start_time, current_time;
    int counter = 0;
    
    start_time = clock();

    while (1) {
        counter++;

        current_time = clock();
        if ((double)(current_time - start_time) / CLOCKS_PER_SEC >= 2.0) {
            printf("Iterations: %d\n", counter);
            printf("Load time: %d\n", current_time - start_time);
            start_time = current_time;
            break;
        }
    }

    return 0;
}