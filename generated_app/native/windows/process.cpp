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
    {
        return false;
    }



    if(command == nullptr)
    {
        command =
            L"C:\\Windows\\System32\\cmd.exe";
    }






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






    auto attributeList =
        reinterpret_cast<LPPROC_THREAD_ATTRIBUTE_LIST>(
            HeapAlloc(
                GetProcessHeap(),
                0,
                size
            )
        );





    if(attributeList == nullptr)
    {
        return false;
    }







    if(
        !InitializeProcThreadAttributeList(
            attributeList,
            1,
            0,
            &size
        )
    )
    {

        HeapFree(
            GetProcessHeap(),
            0,
            attributeList
        );


        return false;

    }







    BOOL attributeResult =
        UpdateProcThreadAttribute(

            attributeList,

            0,

            PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,

            hpc,

            sizeof(HPCON),

            nullptr,

            nullptr

        );







    if(!attributeResult)
    {

        DeleteProcThreadAttributeList(
            attributeList
        );


        HeapFree(
            GetProcessHeap(),
            0,
            attributeList
        );


        return false;

    }






    startup.lpAttributeList =
        attributeList;








    wchar_t cmdLine[512]{};




    wcscpy_s(
        cmdLine,
        command
    );








    BOOL created =
        CreateProcessW(

            nullptr,


            cmdLine,


            nullptr,


            nullptr,


            FALSE,


            EXTENDED_STARTUPINFO_PRESENT |
            CREATE_UNICODE_ENVIRONMENT,


            nullptr,


            nullptr,


            &startup.StartupInfo,


            &processInfo

        );









    DeleteProcThreadAttributeList(
        attributeList
    );



    HeapFree(
        GetProcessHeap(),
        0,
        attributeList
    );








    if(!created)
    {

        return false;

    }






    running = true;



    return true;


}









bool ProcessManager::isRunning() const
{

    if(!running)
    {
        return false;
    }



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


        WaitForSingleObject(
            processInfo.hProcess,
            1000
        );



        CloseHandle(
            processInfo.hProcess
        );


        processInfo.hProcess =
            nullptr;

    }






    if(processInfo.hThread)
    {

        CloseHandle(
            processInfo.hThread
        );


        processInfo.hThread =
            nullptr;

    }




    running = false;

}



#endif
