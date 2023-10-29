#include <iostream>
#include "Windows.h"

using namespace std;

// приоритет (приоритетный класс) текущего процесса;
void PrintProcessPriority(HANDLE hp)
{
	int priority = GetPriorityClass(hp);
	switch (priority)
	{
	case IDLE_PRIORITY_CLASS:
		cout << "Priority: IDLE_PRIORITY_CLASS" << endl;
		break;
	case BELOW_NORMAL_PRIORITY_CLASS:
		cout << "Priority: BELOW_NORMAL_PRIORITY_CLASS" << endl;
		break;
	case NORMAL_PRIORITY_CLASS:
		cout << "Priority: NORMAL_PRIORITY_CLASS" << endl;
		break;
	case ABOVE_NORMAL_PRIORITY_CLASS:
		cout << "Priority: ABOVE_NORMAL_PRIORITY_CLASS" << endl;
		break;
	case HIGH_PRIORITY_CLASS:
		cout << "Priority: HIGH_PRIORITY_CLASS" << endl;
		break;
	case REALTIME_PRIORITY_CLASS:
		cout << "Priority: REALTIME_PRIORITY_CLASS" << endl;
		break;
	}
}

// приоритет текущего потока;
void PrintThreadPriority(HANDLE ht)
{
	int priority = GetThreadPriority(ht);
	switch (priority)
	{
	case THREAD_PRIORITY_IDLE:
		cout << "Thread priority: THREAD_PRIORITY_IDLE" << endl;
		break;
	case THREAD_PRIORITY_LOWEST:
		cout << "Thread priority: THREAD_PRIORITY_LOWEST" << endl;
		break;
	case THREAD_PRIORITY_BELOW_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_BELOW_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_ABOVE_NORMAL:
		cout << "Thread priority: THREAD_PRIORITY_ABOVE_NORMAL" << endl;
		break;
	case THREAD_PRIORITY_HIGHEST:
		cout << "Thread priority: THREAD_PRIORITY_HIGHEST" << endl;
		break;
	case THREAD_PRIORITY_TIME_CRITICAL:
		cout << "Thread priority: THREAD_PRIORITY_TIME_CRITICAL" << endl;
		break;
	}
}

//маска (affinity mask) доступных процессу процессоров в двоичном виде;
void PrintAffinityMask(HANDLE hp, HANDLE ht) {
	DWORD_PTR pa = NULL, sa = NULL, icpu = -1;
	char buf[10];

	if (!GetProcessAffinityMask(hp, &pa, &sa))
		throw "[FATAL] GetProcessAffinityMask threw an exception.";

	_itoa_s(pa, buf, 2);
	cout << "Process affinity mask: " << buf;
	cout << " (" << showbase << hex << pa << ")\n";
	_itoa_s(sa, buf, 2);
	cout << "System affinity mask:  " << buf;
	cout << " (" << showbase << hex << sa << ")\n";


	SYSTEM_INFO sys_info;
	GetSystemInfo(&sys_info);
	cout << "Max processors count:  " << dec << sys_info.dwNumberOfProcessors << "\n";
	icpu = SetThreadIdealProcessor(ht, MAXIMUM_PROCESSORS);
	cout << "Thread IdealProcessor: " << dec << icpu << "\n";
}

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);
	HANDLE hp = GetCurrentProcess();
	HANDLE ht = GetCurrentThread();
	// идентификатор текущего процесса;
	cout << "Process ID: " << GetCurrentProcessId() << endl;
	// идентификатор текущего main потока;
	cout << "Thread ID: " << GetCurrentThreadId() << endl;
	PrintProcessPriority(hp);
	PrintThreadPriority(ht);
	PrintAffinityMask(hp, ht);
	system("pause");
	return 0;
}
