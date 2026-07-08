#include "process.h"


#ifdef _WIN32


#include <vector>
#include <string>



ProcessLauncher::ProcessLauncher()

{

    ZeroMemory(
        &processInfo,
        sizeof(PROCESS_INFORMATION)
    );


    conpty = nullptr;

}





ProcessLauncher::~ProcessLauncher()

{

    close();

}








bool ProcessLauncher::start(

    ConPTY* terminal,

    const wchar_t* command

)

{


    if(
        terminal == nullptr ||
        terminal->getHandle() == nullptr
    )

    {

        return false;

    }



    conpty = terminal;



    STARTUPINFOEXW siex;



    ZeroMemory(
        &siex,
        sizeof(STARTUPINFOEXW)
    );



    siex.StartupInfo.cb =
        sizeof(STARTUPINFOEXW);





    SIZE_T size = 0;



    InitializeProcThreadAttributeList(

        nullptr,

        1,

        0,

        &size

    );



    std::vector<char> buffer(size);



    siex.lpAttributeList =
        reinterpret_cast<
            LPPROC_THREAD_ATTRIBUTE_LIST
        >(buffer.data());





    if(
        !InitializeProcThreadAttributeList(

            siex.lpAttributeList,

            1,

            0,

            &size

        )

    )

    {

        return false;

    }






    if(

        !UpdateProcThreadAttribute(

            siex.lpAttributeList,

            0,

            PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,

            terminal->getHandle(),

            sizeof(HPCON),

            nullptr,

            nullptr

        )

    )

    {

        DeleteProcThreadAttributeList(

            siex.lpAttributeList

        );


        return false;

    }





    DWORD flags =
        EXTENDED_STARTUPINFO_PRESENT;



    BOOL result =
        CreateProcessW(

            nullptr,

            const_cast<wchar_t*>(command),

            nullptr,

            nullptr,

            FALSE,

            flags,

            nullptr,

            nullptr,

            &siex.StartupInfo,

            &processInfo

        );





    DeleteProcThreadAttributeList(

        siex.lpAttributeList

    );





    return result;

}









bool ProcessLauncher::isRunning() const

{

    if(
        processInfo.hProcess == nullptr
    )

    {

        return false;

    }



    DWORD code;



    if(
        GetExitCodeProcess(

            processInfo.hProcess,

            &code

        )

    )

    {

        return code == STILL_ACTIVE;

    }



    return false;

}









DWORD ProcessLauncher::getProcessId() const

{

    return processInfo.dwProcessId;

}









void ProcessLauncher::close()

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


    }



    if(processInfo.hThread)

    {

        CloseHandle(

            processInfo.hThread

        );

    }



    ZeroMemory(

        &processInfo,

        sizeof(PROCESS_INFORMATION)

    );


}


#endif
