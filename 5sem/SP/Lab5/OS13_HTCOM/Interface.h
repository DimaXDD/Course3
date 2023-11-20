#pragma once

#include "../../Lab3/OS10_HTAPI/pch.h"
#include "../../Lab3/OS10_HTAPI/HT.h"

static const GUID IID_IHT =
{ 0xe5c68a2d, 0x67f, 0x4240, { 0x9d, 0xbd, 0xfe, 0x4e, 0x4a, 0xa, 0xa6, 0x6c } };

interface IHT : IUnknown {
    STDMETHOD(create(ht::HtHandle** htHandle, int capacity, int secSnapshotInterval, int maxKeyLength, int maxPayloadLength, const wchar_t* fileName)) PURE;
    STDMETHOD(open(ht::HtHandle** htHandle, const wchar_t* fileName, bool isMapFile = false)) PURE;
    STDMETHOD(snap(BOOL& rc, ht::HtHandle* htHandle)) PURE;
    STDMETHOD(close(BOOL& rc, ht::HtHandle* htHandle)) PURE;
    STDMETHOD(insert(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* element)) PURE;
    STDMETHOD(removeOne(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* element)) PURE;
    STDMETHOD(get(ht::Element** rcElement, ht::HtHandle* htHandle, const ht::Element* element)) PURE;
    STDMETHOD(update(BOOL& rc, ht::HtHandle* htHandle, const ht::Element* oldElement, const void* newPayload, int newPayloadLength)) PURE;
    STDMETHOD(getLastError(const char** lastError, ht::HtHandle* htHandle)) PURE;
    STDMETHOD(print(const ht::Element* element)) PURE;
};

static const GUID IID_IElement =
{ 0xe5850b11, 0x565c, 0x4812, { 0xa8, 0xc9, 0x3b, 0x62, 0xcc, 0x6e, 0xec, 0x9a } };

interface IElement : IUnknown {
    STDMETHOD(createGetElement(ht::Element** getElement, const void* key, int keyLength)) PURE;
    STDMETHOD(createInsertElement(ht::Element** newElement, const void* key, int keyLength, const void* payload, int  payloadLength)) PURE;
    STDMETHOD(createUpdateElement(ht::Element** updateElement, const ht::Element* oldElement, const void* newPayload, int  newPayloadLength)) PURE;
};