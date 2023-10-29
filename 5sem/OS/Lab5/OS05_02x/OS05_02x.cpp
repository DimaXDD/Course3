// Разработайте  консольное Windows-приложение OS05_02x, выполняющее цикл в 1млн  итераций.
// Каждая итерация осуществляет задержку на 200 мс через каждые 1тыс итераций и выводит следующую информацию:
// -номер итерации;
// -идентификатор процесса;
// -идентификатор потока;
// -класс приоритета процесса;
// -приоритет потока;
// -номер назначенного процессора.

#include <Windows.h>
#include <iostream>

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
	HANDLE processHandle = GetCurrentProcess();
	HANDLE threadHandle = GetCurrentThread();
	int i = 0;
	clock_t start = clock();

	while (i < 1000000)
	{
		if (i % 1000 == 0)
		{
			cout << "=================================" << endl;
			cout << "Номер итерации: " << i << endl;
			cout << "Идентификатор процесса: " << GetCurrentProcessId() << endl;
			cout << "Идентификатор потока: " << GetCurrentThreadId() << endl;
			cout << "Класс приоритета процесса: ";
			PrintProcessPriority(GetCurrentProcess());
			cout << "Приоритет потока: ";
			PrintThreadPriority(GetCurrentThread());
			cout << "Номер назначенного процессора: " << GetCurrentProcessorNumber() << endl;
			cout << "\n";
			cout << "=================================" << endl;
			Sleep(200);
		}
		i++;
	}
	clock_t end = clock();
	std::cout << "Time: " << (end - start) / 1000.0 << std::endl;

	system("pause");
}