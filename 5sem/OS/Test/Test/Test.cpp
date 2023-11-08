#include <windows.h>
#include <WINBASE.H>
#include <stdio.h>

int main() {

    SYSTEM_INFO SystemInfo;
    GetSystemInfo(&SystemInfo);

    printf("         dwPageSize= %x\n\
     lpMinimumApplicationAddress= %x\n\
     lpMaximumApplicationAddress= %x\n\
     dwActiveProcessorMask= %d\n\
     dwNumberOfProcessors= %d\n\
     dwProcessorType= %d\n\
     dwAllocationGranularity= %d   =%xh\n\
     wProcessorLevel= %d\n\
     wProcessorRevision= %d\n", SystemInfo.dwPageSize,
        SystemInfo.lpMinimumApplicationAddress,
        SystemInfo.lpMaximumApplicationAddress,
        SystemInfo.dwActiveProcessorMask,
        SystemInfo.dwNumberOfProcessors,
        SystemInfo.dwProcessorType,
        SystemInfo.dwAllocationGranularity, SystemInfo.dwAllocationGranularity,
        SystemInfo.wProcessorLevel,
        SystemInfo.wProcessorRevision);


    system("PAUSE");
}