#include "pch.h"
#include "ClassFactory.h"
#include "ComponentHT.h"

#pragma region Реализация IUnknown для фабрики класса

HRESULT __stdcall ClassFactory::QueryInterface(const IID& iid, void** ppv)
{
	if ((iid == IID_IUnknown) || (iid == IID_IClassFactory))
	{
		*ppv = (IClassFactory*)this;
	}
	else
	{
		*ppv = NULL;
		return E_NOINTERFACE;
	}
	((IUnknown*)*ppv)->AddRef();
	return S_OK;
}
ULONG __stdcall ClassFactory::AddRef()
{
	return InterlockedIncrement(&m_cRef);
}
ULONG __stdcall ClassFactory::Release()
{
	if (InterlockedDecrement(&m_cRef) == 0)
	{
		delete this;
		return 0;
	}
	return m_cRef;
}

#pragma endregion

#pragma region Реализация IClassFactory

HRESULT __stdcall ClassFactory::CreateInstance(IUnknown* pUnknownOuter, const IID& iid, void** ppv)
{
	std::cout << "Фабрика класса:\t\tСоздать компонент" << std::endl;
	// Агрегирование не поддерживается
	if (pUnknownOuter != NULL)
	{
		return CLASS_E_NOAGGREGATION;
	}
	// Создать компонент	
	ComponentHT* pA = new ComponentHT;
	if (pA == NULL)
	{
		return E_OUTOFMEMORY;
	}

	// Вернуть запрошенный интерфейс
	HRESULT hr = pA->QueryInterface(iid, ppv);

	// Освободить указатель на IUnknown
	// (При ошибке в QueryInterface компонент разрушит сам себя)
	pA->Release();
	return hr;
}
// LockServer
HRESULT __stdcall ClassFactory::LockServer(BOOL bLock)
{
	if (bLock)
	{
		InterlockedIncrement(&g_cServerLocks);
	}
	else
	{
		InterlockedDecrement(&g_cServerLocks);
	}
	return S_OK;
}

#pragma endregion