#include <iostream>
#include <Windows.h>

using namespace std;

int main()
{
	for (short i = 1; i <= 10000; ++i)
	{
		cout << i << ". PID = " << GetCurrentProcessId() << "\n";
		Sleep(1000);
	}
	return 0;
}

// 1. Task Manager:				
// Диспетчер задач -> Подробности -> OS03_01.exe
// 
// 2. Tasklist:					
// tasklist /FI "IMAGENAME eq OS03_01.exe"   ИЛИ   tasklist /FI "pid eq PID"
// 
// 3. PowerShell ISE:			
// Get-Process OS03_01
// 
// 4. Performance Monitor:		
// Монитор ресурсов