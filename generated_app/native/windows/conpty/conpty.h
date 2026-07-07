#pragma once

#include <windows.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*ConptyOutputCallback)(const char* data, int length);

int conpty_start(int cols, int rows);
int conpty_write(const char* data, int length);
int conpty_resize(int cols, int rows);
void conpty_set_output_callback(ConptyOutputCallback callback);
void conpty_stop();

#ifdef __cplusplus
}
#endif
