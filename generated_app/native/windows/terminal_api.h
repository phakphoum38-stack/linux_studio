#pragma once

#ifdef _WIN32

#define TERMINAL_API __declspec(dllexport)

#include <stdint.h>


#ifdef __cplusplus
extern "C" {
#endif



TERMINAL_API void* terminal_create(

    int32_t rows,

    int32_t cols

);





TERMINAL_API bool terminal_write(

    void* handle,

    const char* data,

    int32_t length

);





TERMINAL_API int32_t terminal_read(

    void* handle,

    char* buffer,

    int32_t size

);





TERMINAL_API bool terminal_resize(

    void* handle,

    int32_t rows,

    int32_t cols

);





TERMINAL_API void terminal_close(

    void* handle

);





#ifdef __cplusplus
}

#endif


#endif
