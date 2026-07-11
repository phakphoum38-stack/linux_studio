#pragma once


#include <cstdint>





#ifdef _WIN32


#ifdef TERMINAL_BUILD_DLL

#define TERMINAL_API __declspec(dllexport)

#else

#define TERMINAL_API __declspec(dllimport)

#endif



#else


#define TERMINAL_API


#endif







extern "C"
{





TERMINAL_API void* terminal_create(

    int32_t rows,

    int32_t cols

);









TERMINAL_API int32_t terminal_write(

    void* handle,

    const char* data,

    int32_t length

);









TERMINAL_API int32_t terminal_read(

    void* handle,

    char* buffer,

    int32_t size

);









TERMINAL_API int32_t terminal_resize(

    void* handle,

    int32_t rows,

    int32_t cols

);









TERMINAL_API void terminal_close(

    void* handle

);




}
