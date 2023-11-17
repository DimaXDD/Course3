#include <iostream>
#include <ctime>
#include <Windows.h>
#include <tlhelp32.h>
#include <stdio.h>

using namespace std;
volatile bool active = true;

DWORD WINAPI stopCycle(HANDLE htimer) {
    WaitForSingleObject(htimer, INFINITE);
    active = false;
    return 0;
}

bool isSimple(int n) {
    int i, sq;
    if (n % 2 == 0) { return false; }
    sq = (int)sqrt(n);
    for (i = 3; i <= sq; i++) {
        if ((n % i) == 0) { return false; }
    }
    return true;
}

int main(int argc, char* argv[])
{
    int firsttime = clock();

    HANDLE htimer = NULL;
    int parm = 1;
    int val = 1;

    for (int i = 0; i < argc; i++) {
        cout << i << " = " << argv[i] << endl;
    }

    if (argc > 1) parm = atoi(argv[1]);
    cout << "Child Process " << parm << " start" << endl;

    if (parm == 1) {
        htimer = OpenWaitableTimer(TIMER_ALL_ACCESS, FALSE, L"atimer1");
    }
    else {
        htimer = OpenWaitableTimer(TIMER_ALL_ACCESS, FALSE, L"atimer2");
    }

    HANDLE hChild = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)stopCycle, htimer, NULL, NULL);

    while (active) {
        if (isSimple(val)) {
            cout << "Simple : " << val << endl;
        }
        val++;
    }

    WaitForSingleObject(hChild, INFINITE);

    cout << "time:" << clock() - firsttime << endl;
    return 0;
}