#include <iostream>
#include <Windows.h>
#include <ctime>

#define SECOND 10000000
HANDLE htimer;
HANDLE htimer2;

long long i = 1;
volatile bool active = true;
using namespace std;

void main() {
    int firsttime = clock();
    DWORD pid = GetCurrentProcessId();
    cout << "pid: " << pid << endl;

    htimer = CreateWaitableTimer(NULL, FALSE, L"atimer1");
    htimer2 = CreateWaitableTimer(NULL, FALSE, L"atimer2");

    long long time1 = -10 * SECOND;
    long long time2 = -20 * SECOND;

    if (!SetWaitableTimer(htimer, (LARGE_INTEGER*)&time1, 0, NULL, NULL, FALSE)) throw "Err SetWaitableTimer1";
    if (!SetWaitableTimer(htimer2, (LARGE_INTEGER*)&time2, 0, NULL, NULL, FALSE)) throw "Err SetWaitableTimer2";

    std::cout << "Start timers" << std::endl;

    LPCWSTR an = L"OS07_04x.exe";
    STARTUPINFO si1;
    STARTUPINFO si2;
    PROCESS_INFORMATION pi1;
    PROCESS_INFORMATION pi2;

    ZeroMemory(&si1, sizeof(STARTUPINFO));
    ZeroMemory(&si2, sizeof(STARTUPINFO));

    si1.cb = sizeof(STARTUPINFO);
    si2.cb = sizeof(STARTUPINFO);

    wchar_t cLine1[] = L"1 1";
    wchar_t cLine2[] = L"2 2";

    if (CreateProcess(an, cLine1, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si1, &pi1))
        cout << "Child Process created" << endl;
    else
        cout << "Child Process not created" << endl;

    if (CreateProcess(an, cLine2, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si2, &pi2))
        cout << "Child Process created" << endl;
    else
        cout << "Child Process not created" << endl;

    //delete[]cmdparm1;
    //delete[]cmdparm2;
    WaitForSingleObject(pi1.hProcess, INFINITE);
    WaitForSingleObject(pi2.hProcess, INFINITE);
    CloseHandle(pi1.hProcess);
    CloseHandle(pi2.hProcess);
    CancelWaitableTimer(htimer);
    CancelWaitableTimer(htimer2);
    system("pause");

}