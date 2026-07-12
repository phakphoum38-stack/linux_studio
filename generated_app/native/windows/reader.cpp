#include "reader.h"

#ifdef _WIN32

#include <windows.h>

Reader::Reader() : pipe(nullptr) {}

Reader::~Reader() {
    stop();
}

void Reader::attach(PipeManager* manager) {
    pipe = manager;
}

int32_t Reader::read(char* buffer, int32_t size) {
    if (!pipe || !buffer || size <= 0) {
        return 0;
    }

    HANDLE handle = pipe->getOutputRead();
    if (!handle) {
        return 0;
    }

    DWORD available = 0;
    if (!PeekNamedPipe(handle, nullptr, 0, nullptr, &available, nullptr) ||
        available == 0) {
        return 0;
    }

    const DWORD requested =
        available < static_cast<DWORD>(size) ? available : static_cast<DWORD>(size);
    DWORD bytesRead = 0;
    if (!ReadFile(handle, buffer, requested, &bytesRead, nullptr)) {
        return 0;
    }

    return static_cast<int32_t>(bytesRead);
}

void Reader::stop() {
    pipe = nullptr;
}

#endif
