#include <iostream>
#include <Windows.h>

using namespace std;

#define KB (1024)
#define MB (1024 * KB)
#define PG (4 * KB)


void saymem()
{
    MEMORYSTATUS ms;
    GlobalMemoryStatus(&ms);
    cout << "Объём физической памяти:      " << ms.dwTotalPhys / KB << " KB\n";
    cout << "Доступно физической памяти:   " << ms.dwAvailPhys / KB << " KB\n";
    cout << "Объем виртуальной памяти:     " << ms.dwTotalVirtual / KB << " KB\n";
    cout << "Доступно виртуальной памяти:  " << ms.dwAvailVirtual / KB << " KB\n\n";
}


/*
    Т - 210(10) - D2(16)
    р - 240(10) - F0(16)
    у - 243(10) - F3(16)

    Страница D2 = 210

    210 * 4096 = 860160(10) = 0xC1F80 - добавить для перехода на страницу

    F0F = (15 * 16^2) + (0 * 16^1) + (15 * 16^0)
    = (15 * 256) + (0 * 16) + (15 * 1)
    = 3840 + 0 + 15
    = 3855

    Смещение F0F = 3855(10) = 0xF0F
    Искомое значение: начало массива + 0xC1F80 + 0xF0F
*/

int main()
{
    setlocale(LC_ALL, "ru");
    int pages = 256;
    int countItems = pages * PG / sizeof(int);
    SYSTEM_INFO system_info;
    GetSystemInfo(&system_info);

    cout << "\t    Изначально в системе\n";
    saymem();

    LPVOID xmemaddr = VirtualAlloc(NULL, pages * PG, MEM_COMMIT, PAGE_READWRITE);   // выделено 1024 KB виртуальной памяти
    cout << "\tВыделено " << pages * PG / 1024 << " KB вирт. памяти\n";
    saymem();

    int* arr = (int*)xmemaddr;
    for (int i = 0; i < countItems; i++)
        arr[i] = i;

    int* byte = arr + 210 * 1024 + 3855;
    cout << "------  Значение памяти в байте: " << *byte << "  ------\n";

    VirtualFree(xmemaddr, NULL, MEM_RELEASE) ? cout << "\tВиртуальная память освобождена\n" : cout << "\tВиртуальная память не освобождена\n";
    saymem();
}