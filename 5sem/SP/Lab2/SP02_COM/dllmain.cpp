#include "pch.h"
#include <fstream>
#include <Windows.h>
#include <iostream>
#include <combaseapi.h>
#include "MathFactory.h"

using namespace std;

HMODULE hmodule;

// {02fe8a5e-281b-4e3a-8f87-6c544deda994}
static const CLSID CLSID_CA =
{ 0x02fe8a5e, 0x281b, 0x4e3a, { 0x8f, 0x87, 0x6c, 0x54, 0x4d, 0xed, 0xa9, 0x94 } };

const WCHAR* FNAME = L"SP02_dimaxdd.dll";
const WCHAR* VerInd = L"SP02_dimaxdd.1.0";
const WCHAR* ProgId = L"SP02_dimaxdd.1";

BOOL APIENTRY DllMain(
    HMODULE hModule,
    DWORD  ul_reason_for_call,
    LPVOID lpReserved
)
{
    cout << "DllMain\n";
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        hmodule = hModule;
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

HRESULT __declspec(dllexport) DllInstall(bool b, PCWSTR s)
{
    return S_OK;
}

HRESULT __declspec(dllexport) DllRegisterServer() {
    return RegisterServer(hmodule, CLSID_CA, FNAME, VerInd, ProgId);
}

HRESULT __declspec(dllexport) DllUnregisterServer() {
    return UnregisterServer(CLSID_CA, VerInd, ProgId);
}


STDAPI DllCanUnloadNow()
{
    return S_OK;
}

// Объект класс IClassFactory
STDAPI DllGetClassObject(const CLSID& clsid, const IID& iid, LPVOID* ppv) {
    HRESULT rc = E_UNEXPECTED;
    MathFactory* pF;
    if (clsid != CLSID_CA) rc = CLASS_E_CLASSNOTAVAILABLE;
    else if ((pF = new MathFactory()) == NULL) rc = E_OUTOFMEMORY;
    else {
        rc = pF->QueryInterface(iid, ppv);
        pF->Release();
    }
    return rc;
}