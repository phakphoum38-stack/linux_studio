#include "process.h"

#ifdef _WIN32

#include <windows.h>
#include <string>





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


    if(!hpc)

    {

        return false;

    }







    if(command == nullptr)

    {

        command =

            L"C:\\Windows\\System32\\cmd.exe";

    }








    ZeroMemory(

        &processInfo,

        sizeof(processInfo)

    );







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







    if(!attributeList)

    {

        return false;

    }








    if(!InitializeProcThreadAttributeList(

        attributeList,

        1,

        0,

        &size

    ))

    {

        HeapFree(

            GetProcessHeap(),

            0,

            attributeList

        );


        return false;

    }









    if(!UpdateProcThreadAttribute(

        attributeList,

        0,

        PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,

        hpc,

        sizeof(HPCON),

        nullptr,

        nullptr

    ))

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









    std::wstring cmdLine(command);







    BOOL result =

        CreateProcessW(

            nullptr,

            cmdLine.data(),

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








    if(!result)

    {

        ZeroMemory(

            &processInfo,

            sizeof(processInfo)

        );


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
