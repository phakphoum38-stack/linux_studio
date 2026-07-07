#include "conpty.h"

#include <windows.h>

static HPCON g_hPC = nullptr;

static HANDLE g_inputWrite = INVALID_HANDLE_VALUE;
static HANDLE g_outputRead = INVALID_HANDLE_VALUE;

static HANDLE g_process = nullptr;

static ConptyOutputCallback g_callback = nullptr;

void conpty_set_output_callback(ConptyOutputCallback callback)
{
    g_callback = callback;
}
