#pragma once
#include "../OS13_HTCOM/Interface.h"

#define OS13_HTCOM_HANDEL void*

namespace OS13_HTCOM
{
	OS13_HTCOM_HANDEL Init();                                // инициализация OS12 (Lab2)
	//   if CoCreateInstance(... IID_Unknown)!= succesfull --> throw (int)HRESULT  
	namespace HT
	{
		ht::HtHandle* create(OS13_HTCOM_HANDEL h, int capacity, int secSnapshotInterval, int maxKeyLength, int maxPayloadLength, const wchar_t* fileName);
		ht::HtHandle* open(OS13_HTCOM_HANDEL h, const wchar_t* fileName, bool isMapFile = false);
		BOOL snap(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle);
		BOOL close(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle);
		BOOL insert(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle, const ht::Element* element);
		BOOL removeOne(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle, const ht::Element* element);
		ht::Element* get(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle, const ht::Element* element);
		BOOL update(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle, const ht::Element* oldElement, const void* newPayload, int newPayloadLength);
		const char* getLastError(OS13_HTCOM_HANDEL h, ht::HtHandle* htHandle);
		void print(OS13_HTCOM_HANDEL h, const ht::Element* element);
	}
	namespace Element
	{
		ht::Element* createGetElement(OS13_HTCOM_HANDEL h, const void* key, int keyLength);
		ht::Element* createInsertElement(OS13_HTCOM_HANDEL h, const void* key, int keyLength, const void* payload, int  payloadLength);
		ht::Element* createUpdateElement(OS13_HTCOM_HANDEL h, const ht::Element* oldElement, const void* newPayload, int  newPayloadLength);
	}
	void Dispose(OS13_HTCOM_HANDEL h);                       // завершение работы с OS12                  
}
