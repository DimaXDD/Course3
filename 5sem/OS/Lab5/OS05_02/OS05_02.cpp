// Разработайте консольное Windows - приложение OS05_02, принимающее следующие параметры :
// -P1 : целое число, задающее маску доступности процессоров(affinity mask);
// -P2: целое число, задающее класс приоритета первого дочернего процесса;
// -P3: целое число, задающее класс приоритета второго  дочернего процесса.
// Приложение OS05_02 должно вывести в свое консольное окно  заданные параметры  и запустить два одинаковых дочерних процесса OS05_02x,осуществляющих вывод в отдельные консольные окна и имеющих  заданные в параметрах  приоритеты.

#include <windows.h>
#include <iostream>

using namespace std;

DWORD intToProcessPriority(int i) {
	switch (i)
	{
	case 1: return IDLE_PRIORITY_CLASS;
	case 2: return BELOW_NORMAL_PRIORITY_CLASS;
	case 3: return NORMAL_PRIORITY_CLASS;
	case 4: return ABOVE_NORMAL_PRIORITY_CLASS;
	case 5: return HIGH_PRIORITY_CLASS;
	case 6: return REALTIME_PRIORITY_CLASS;
	default: throw "Unknown priority class";
	}
}


int main(int argc, char* argv[])
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);

	//case 1:
	//	P1 = 0xff (255);
	//	P2 = NORMAL_PRIORITY_CLASS (3);
	//	P3 = NORMAL_PRIORITY_CLASS (3);
	//case 2:
	//	P1 = 0xff (255);
	//	P2 = BELOW_NORMAL_PRIORITY_CLASS (2);
	//	priority2 = HIGH_PRIORITY_CLASS (5);
	//case 3:
	//	P1 = 0x01 (1);
	//	P2 = BELOW_NORMAL_PRIORITY_CLASS (2);
	//	P3 = HIGH_PRIORITY_CLASS (5);

	try
	{
		if (argc == 4)
		{
			HANDLE processHandle = GetCurrentProcess();
			DWORD_PTR pa = NULL, sa = NULL, icpu = -1;
			char buf[13];
			int parm1 = atoi(argv[1]);
			int parm2 = atoi(argv[2]);
			int parm3 = atoi(argv[3]);


			// Маска доступности процессоров
			// Как пример у нас есть 4 ядерынй процессор. Мы хотим использовать 1 и 3 ядро, вводим число 10, битовое значение числа 10 -> 0101
			// 65535 - 16 потоков | 16383 - 14 | 4095 - 12 | 1023 - 10 | 255 - 8 | 63 - 6 | 15 - 4 | 3 - 2 | 1 - 1

			if (!GetProcessAffinityMask(processHandle, &pa, &sa))
				throw "Error in GetProcessAffinityMask";
			cout << "\t\tBefore applying parameters:\n";
			_itoa_s(pa, buf, 2);
			cout << "Process affinity Mask: " << buf << endl;
			_itoa_s(sa, buf, 2);
			cout << "System affinity Mask:  " << buf << endl;

			if (!SetProcessAffinityMask(processHandle, parm1))
				throw "ERROR in SetProcessAffinityMask";
			if (!GetProcessAffinityMask(processHandle, &pa, &sa))
				throw "Error in GetProcessAffinityMask";

			cout << "\t\tAfter applying parameters:\n";
			_itoa_s(pa, buf, 2);
			cout << "Process affinity Mask: " << buf << endl;
			_itoa_s(sa, buf, 2);
			cout << "System affinity Mask:  " << buf << endl;

			_itoa_s(parm1, buf, 2);
			cout << "Child 1 PriorityClass: " << parm2 << endl;
			cout << "Child 2 PriorityClass: " << parm3 << endl;

			LPCWSTR path1 = L"E:\\3course\\5sem\\OS\\Lab5\\Debug\\OS05_02x.exe";
			LPCWSTR path2 = L"E:\\3course\\5sem\\OS\\Lab5\\Debug\\OS05_02x.exe";

			STARTUPINFO si1, si2;
			PROCESS_INFORMATION pi1, pi2;

			ZeroMemory(&si1, sizeof(STARTUPINFO));
			ZeroMemory(&si2, sizeof(STARTUPINFO));
			si1.cb = sizeof(STARTUPINFO);
			si2.cb = sizeof(STARTUPINFO);

			if (CreateProcess(path1, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE | intToProcessPriority(parm2), NULL, NULL, &si1, &pi1))
				cout << "-- Process OS05_02 1 was created\n";
			else cout << "-- Process OS05_02 1 wasn't created\n";

			if (CreateProcess(path2, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE | intToProcessPriority(parm3), NULL, NULL, &si2, &pi2))
				cout << "-- Process OS05_02 2 was created\n";
			else cout << "-- Process OS05_02 2 wasn't created\n";

			WaitForSingleObject(pi1.hProcess, INFINITE);
			WaitForSingleObject(pi2.hProcess, INFINITE);

			CloseHandle(pi1.hProcess);
			CloseHandle(pi2.hProcess);
		}
		else
			cout << "No parameters provided" << endl;
	}
	catch (string err)
	{
		cout << err << endl;
	}
	system("pause");
}