#include "process.h"



#ifdef _WIN32



#include <processthreadsapi.h>





ProcessManager::ProcessManager()

{

    ZeroMemory(

        &processInfo,

        sizeof(processInfo)

    );

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





    STARTUPINFOEXW startup{};



    startup.StartupInfo.cb =

        sizeof(STARTUPINFOEXW);








    SIZE_T attributeSize = 0;





    InitializeProcThreadAttributeList(

        nullptr,

        1,

        0,

        &attributeSize

    );








    auto attributes =

        (LPPROC_THREAD_ATTRIBUTE_LIST)

        HeapAlloc(

            GetProcessHeap(),

            0,

            attributeSize

        );







    if(!attributes)

    {

        return false;

    }








    if(!InitializeProcThreadAttributeList(

        attributes,

        1,

        0,

        &attributeSize

    ))

    {

        HeapFree(

            GetProcessHeap(),

            0,

            attributes

        );


        return false;

    }








    UpdateProcThreadAttribute(

        attributes,

        0,

        PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,

        hpc,

        sizeof(HPCON),

        nullptr,

        nullptr

    );








    startup.lpAttributeList =

        attributes;







    wchar_t buffer[256];



    wcscpy_s(

        buffer,

        command

    );








    BOOL result =

        CreateProcessW(

            nullptr,

            buffer,

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

        attributes

    );





    HeapFree(

        GetProcessHeap(),

        0,

        attributes

    );








    if(!result)

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





    DWORD result =

        WaitForSingleObject(

            processInfo.hProcess,

            0

        );





    return result == WAIT_TIMEOUT;

}









DWORD ProcessManager::getProcessId() const

{

    return processInfo.dwProcessId;

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



        processInfo.hProcess = nullptr;

    }






    if(processInfo.hThread)

    {

        CloseHandle(

            processInfo.hThread

        );



        processInfo.hThread = nullptr;

    }






    running = false;


}



#endif
