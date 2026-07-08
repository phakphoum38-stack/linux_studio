#pragma once

#ifdef _WIN32
#define TERMINAL_API __declspec(dllexport)
#else
#define TERMINAL_API
#endif


#ifdef __cplusplus
extern "C" {
#endif



// Create ConPTY session
TERMINAL_API void* terminal_create(
    int rows,
    int cols
);



// Write input to terminal
TERMINAL_API int terminal_write(
    void* handle,
    const char* data,
    int length
);



// Read terminal output
TERMINAL_API int terminal_read(
    void* handle,
    unsigned char* buffer,
    int size
);



// Resize terminal
TERMINAL_API int terminal_resize(
    void* handle,
    int rows,
    int cols
);



// Close terminal
TERMINAL_API void terminal_close(
    void* handle
);



#ifdef __cplusplus
}
#endif
