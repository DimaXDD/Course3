#pragma once

extern long g_cComponents;		// Количество активных компонентов
extern long g_cServerLocks;		// Счетчик блокировок

// Фабрика класса
//
class ClassFactory : public IClassFactory
{
public:
	// IUnknown
	virtual HRESULT __stdcall QueryInterface(const IID& iid, void** ppv);
	virtual ULONG __stdcall AddRef();
	virtual ULONG __stdcall Release();
	// Интерфейс IClassFactory
	virtual HRESULT __stdcall CreateInstance(IUnknown* pUnknownOuter, const IID& iid, void** ppv);
	virtual HRESULT __stdcall LockServer(BOOL bLock);

	// Конструктор
	ClassFactory() : m_cRef(1) {}
	// Деструктор
	~ClassFactory() { std::cout << "Фабрика класса:\t\tСаморазрушение" << std::endl; }
private:
	long m_cRef;
};