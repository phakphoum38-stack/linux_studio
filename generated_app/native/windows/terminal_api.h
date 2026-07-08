#pragma once

#ifdef _WIN32

#include <windows.h>


#ifdef TERMINAL_EXPORTS
#define TERMINAL_API __declspec(dllexport)
#else
#define TERMINAL_API __declspec(dllimport)
#endif



extern "C"
{


// Create terminal session

TERMINAL_API void*
terminal_create(
    int rows,
    int cols
);



// Write keyboard input

TERMINAL_API bool
terminal_write(
    void* handle,
    const char* data,
    int length
);



// Read terminal output

TERMINAL_API int
terminal_read(
    void* handle,
    char* buffer,
    int size
);



// Resize terminal

TERMINAL_API bool
terminal_resize(
    void* handle,
    int rows,
    int cols
);



// Close terminal

TERMINAL_API void
terminal_close(
    void* handle
);


}


#endif
