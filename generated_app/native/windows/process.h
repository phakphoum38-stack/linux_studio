#pragma once

#ifdef _WIN32

#include <windows.h>
#include <ConsoleApi3.h>


class ProcessManager {


private:


    PROCESS_INFORMATION processInfo{};


    bool running = false;



public:


    ProcessManager();


    ~ProcessManager();





    bool start(

        HPCON hpc,

        const wchar_t* command = L"powershell.exe"

    );





    bool isRunning() const;





    DWORD getProcessId() const;





    void close();



};

#endif
