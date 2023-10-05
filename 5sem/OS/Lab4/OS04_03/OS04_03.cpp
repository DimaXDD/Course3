#include <iostream>
#include <Windows.h>

using namespace std;

DWORD pid = NULL;


DWORD WINAPI ChildThread_1()
{
	DWORD tid = GetCurrentThreadId();

	for (short i = 1; i <= 50; ++i)
	{
		cout << i << ". PID = " << pid << "\t\t[CHILD-1]   TID = " << tid << "\n";
		Sleep(1000);
	}
	return 0;
}


DWORD WINAPI ChildThread_2()
{
	DWORD tid = GetCurrentThreadId();

	for (short i = 1; i <= 125; ++i)
	{
		cout << i << ". PID = " << pid << "\t\t[CHILD-2]   TID = " << tid << "\n";
		Sleep(1000);
	}
	return 0;
}


// Powershell ISE:	   (Get-Process OS04_03).Threads

int main()
{
	pid = GetCurrentProcessId();
	DWORD parentId = GetCurrentThreadId();
	DWORD childId_1 = NULL;
	DWORD childId_2 = NULL;
	HANDLE handleClild_1 = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ChildThread_1, NULL, 0, &childId_1);
	HANDLE handleClild_2 = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ChildThread_2, NULL, 0, &childId_2);


	for (short i = 1; i <= 100; ++i)
	{
		switch (i)
		{
		case 20: SuspendThread(handleClild_1); break;
		case 60: ResumeThread(handleClild_1);  break;
		case 40: SuspendThread(handleClild_2); break;
		case 100: ResumeThread(handleClild_2); break;
		}
		cout << i << ". PID = " << pid << "\t\t[PARENT]    TID = " << parentId << "\n";
		Sleep(1000);
	}


	WaitForSingleObject(handleClild_1, INFINITE);
	WaitForSingleObject(handleClild_2, INFINITE);

	CloseHandle(handleClild_1);
	CloseHandle(handleClild_2);
	system("pause");
	return 0;
}