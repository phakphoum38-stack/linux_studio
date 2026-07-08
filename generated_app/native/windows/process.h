#pragma once

#ifdef _WIN32

#include <windows.h>

#include "conpty.h"


class ProcessLauncher {

private:

    PROCESS_INFORMATION processInfo;

    ConPTY* conpty;


public:

    ProcessLauncher();

    ~ProcessLauncher();



    bool start(
        ConPTY* terminal,
        const wchar_t* command
    );



    bool isRunning() const;



    DWORD getProcessId() const;



    void close();


};

#endif
