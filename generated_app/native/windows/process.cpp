#include "process.h"

#ifdef _WIN32

#include <windows.h>
#include <processthreadsapi.h>


ProcessManager::ProcessManager()
{
    ZeroMemory(
        &processInfo,
        sizeof(processInfo)
    );

    running = false;
}



ProcessManager::~ProcessManager()
{
    close();
}





bool ProcessManager::start(
    HPCON hpc,
    const wchar_t* command
)
{

    if(hpc == nullptr)
        return false;



    STARTUPINFOEXW startup{};

    startup.StartupInfo.cb =
        sizeof(STARTUPINFOEXW);



    SIZE_T size = 0;



    InitializeProcThreadAttributeList(
        nullptr,
        1,
        0,
        &size
    );



    auto list =
        (LPPROC_THREAD_ATTRIBUTE_LIST)
        HeapAlloc(
            GetProcessHeap(),
            0,
            size
        );


    if(!list)
        return false;



    if(!InitializeProcThreadAttributeList(
        list,
        1,
        0,
        &size
    ))
    {

        HeapFree(
            GetProcessHeap(),
            0,
            list
        );

        return false;

    }




    UpdateProcThreadAttribute(
        list,
        0,
        PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,
        hpc,
        sizeof(HPCON),
        nullptr,
        nullptr
    );



    startup.lpAttributeList = list;



    wchar_t cmd[512];


    wcscpy_s(
        cmd,
        command
    );



    BOOL ok =
        CreateProcessW(
            nullptr,
            cmd,
            nullptr,
            nullptr,
            FALSE,
            EXTENDED_STARTUPINFO_PRESENT,
            nullptr,
            nullptr,
            &startup.StartupInfo,
            &processInfo
        );




    DeleteProcThreadAttributeList(
        list
    );


    HeapFree(
        GetProcessHeap(),
        0,
        list
    );



    if(!ok)
        return false;



    running = true;


    return true;

}







bool ProcessManager::isRunning() const
{

    if(!running)
        return false;



    return
        WaitForSingleObject(
            processInfo.hProcess,
            0
        )
        ==
        WAIT_TIMEOUT;

}






void ProcessManager::close()
{

    if(processInfo.hProcess)
    {

        TerminateProcess(
            processInfo.hProcess,
            0
        );


        CloseHandle(
            processInfo.hProcess
        );


        processInfo.hProcess=nullptr;

    }



    if(processInfo.hThread)
    {

        CloseHandle(
            processInfo.hThread
        );


        processInfo.hThread=nullptr;

    }



    running=false;

}


#endif
