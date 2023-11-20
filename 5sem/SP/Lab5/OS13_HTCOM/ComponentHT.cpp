#include "pch.h"
#include "ComponentHT.h"

#ifdef _WIN64
#pragma comment(lib, "../../Lab3/x64/Debug/OS10_HTAPI.lib")
#else
#pragma comment(lib, "../../Lab3/Debug/OS10_HTAPI.lib")
#endif

#pragma region Реализация IUnknown для компонента

HRESULT __stdcall ComponentHT::QueryInterface(const IID& iid, void** ppv)
{
	if (iid == IID_IUnknown)
	{
		*ppv = (IHT*)this;
	}
	else if (iid == IID_IHT)
	{
		*ppv = (IHT*)this;
		std::cout << "Компонент:\t\tВернуть указатель на IHT" << std::endl;
	}
	else if (iid == IID_IElement)
	{
		*ppv = (IElement*)this;
		std::cout << "Компонент:\t\tВернуть указатель на IElement" << std::endl;
	}
	else
	{
		*ppv = NULL;
		return E_NOINTERFACE;
	}

	((IUnknown*)*ppv)->AddRef();
	return S_OK;
}
ULONG __stdcall ComponentHT::AddRef()
{
	return InterlockedIncrement(&m_cRef);
}
ULONG __stdcall ComponentHT::Release()
{
	if (InterlockedDecrement(&m_cRef) == 0)
	{
		delete this;
		return 0;
	}
	return m_cRef;
}

#pragma endregion

#pragma region Реализация IHT

STDMETHODIMP ComponentHT::create(ht::HtHandle** htHandle, int capacity, int secSnapshotInterval, int maxKeyLength, int maxPayloadLength, const wchar_t* fileName)
{
	*htHandle = ht::create(capacity, secSnapshotInterval, maxKeyLength, maxPayloadLength, fileName);
	return S_OK;
}

STDMETHODIMP ComponentHT::open(ht::HtHandle** htHandle, const wchar_t* fileName, bool isMapFile)
{
	*htHandle = ht::open(fileName, isMapFile);
	return S_OK;
}

STDMETHODIMP ComponentHT::snap(BOOL& rc, ht::HtHandle* htHandle)
{
	rc = ht::snap(htHandle);
	return S_OK;
}

STDMETHODIMP ComponentHT::close(BOOL& rc, ht::HtHandle* htHandle)
{
	rc = ht::close(htHandle);
	return S_OK;
}

STDMETHODIMP ComponentHT::insert(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* element)
{
	rc = ht::insert(htHandle, element);
	return S_OK;
}

STDMETHODIMP ComponentHT::removeOne(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* element)
{
	rc = ht::removeOne(htHandle, element);
	return S_OK;
}

STDMETHODIMP ComponentHT::get(ht::Element** rcElement, ht::HtHandle* htHandle, const ht::Element* element)
{
	*rcElement = ht::get(htHandle, element);
	return S_OK;
}

STDMETHODIMP ComponentHT::update(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* oldElement, const void* newPayload, int newPayloadLength)
{
	rc = ht::update(htHandle, oldElement, newPayload, newPayloadLength);
	return S_OK;
}

STDMETHODIMP ComponentHT::getLastError(const char** lastError, ht::HtHandle* htHandle)
{
	*lastError = ht::getLastError(htHandle);
	return S_OK;
}

STDMETHODIMP ComponentHT::print(const ht::Element* element)
{
	ht::print(element);
	return S_OK;
}

#pragma endregion

#pragma region Реализация IElement
STDMETHODIMP ComponentHT::createGetElement(ht::Element** getElement, const void* key, int keyLength)
{
	*getElement = new ht::Element(key, keyLength);
	return S_OK;
}

STDMETHODIMP ComponentHT::createInsertElement(ht::Element** newElement, const void* key, int keyLength, const void* payload, int  payloadLength)
{
	*newElement = new ht::Element(key, keyLength);
	return S_OK;
}

STDMETHODIMP ComponentHT::createUpdateElement(ht::Element** updateElement, const ht::Element* oldElement, const void* newPayload, int  newPayloadLength)
{
	*updateElement = new ht::Element(oldElement, oldElement, newPayloadLength);
	return S_OK;
}
#pragma endregion

