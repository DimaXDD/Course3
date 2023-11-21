#include <windows.h>

int main()
{
	HANDLE hStopEvent = CreateEvent(NULL,
		TRUE, //FALSE - автоматический сброс; TRUE - ручной
		FALSE,
		L"Stop");
	SetEvent(hStopEvent);
}