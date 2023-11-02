#include <iostream>
#include <Windows.h>

using namespace std;


PROCESS_INFORMATION createProcess(LPCWSTR path)
{
	STARTUPINFO startupInfo;
	PROCESS_INFORMATION processInfo;

	ZeroMemory(&startupInfo, sizeof(STARTUPINFO));
	startupInfo.cb = sizeof(STARTUPINFO);

	if (CreateProcessW(path, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &startupInfo, &processInfo))
		cout << "Process created\n";
	else
		cout << "[ERROR] CreateProcessW\n";

	return processInfo;
}


int main()
{
	int pid = GetCurrentProcessId();
	const int size = 2;
	HANDLE semaphore;
	HANDLE processes[size];

	processes[0] = createProcess(L"E:\\3course\\5sem\\OS\\Lab6\\Debug\\OS06_04A.exe").hProcess;
	processes[1] = createProcess(L"E:\\3course\\5sem\\OS\\Lab6\\Debug\\OS06_04B.exe").hProcess;

	semaphore = CreateSemaphore(NULL, 2, 2, L"OS06_04");

	for (int i = 1; i <= 90; i++)
	{
		if (i == 30)
			WaitForSingleObject(semaphore, INFINITE);

		else if (i == 60)
			ReleaseSemaphore(semaphore, 1, NULL);

		printf("[OS06_04]\t %d.  PID = %d\n", i, pid);
		Sleep(100);
	}

	WaitForMultipleObjects(size, processes, TRUE, INFINITE);
	for (int i = 0; i < size; i++)
		CloseHandle(processes[i]);

	CloseHandle(semaphore);
	cout << '\n';
	system("pause");
	return 0;
}