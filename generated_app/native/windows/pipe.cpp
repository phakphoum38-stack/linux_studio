#include "pipe.h"

#ifdef _WIN32

#include <windows.h>





PipeManager::PipeManager()

{

    inputRead = nullptr;

    inputWrite = nullptr;

    outputRead = nullptr;

    outputWrite = nullptr;

}







PipeManager::~PipeManager()

{

    close();

}









bool PipeManager::createPipes()

{


    SECURITY_ATTRIBUTES sa{};



    sa.nLength =

        sizeof(SECURITY_ATTRIBUTES);



    sa.bInheritHandle =

        TRUE;



    sa.lpSecurityDescriptor =

        nullptr;









    // Input pipe

    // Flutter -> ConPTY



    if(!CreatePipe(

        &inputRead,

        &inputWrite,

        &sa,

        0

    ))

    {

        return false;

    }







    // Parent writes input

    // Child reads input



    SetHandleInformation(

        inputWrite,

        HANDLE_FLAG_INHERIT,

        0

    );









    // Output pipe

    // ConPTY -> Flutter



    if(!CreatePipe(

        &outputRead,

        &outputWrite,

        &sa,

        0

    ))

    {

        close();

        return false;

    }








    // Parent reads output



    SetHandleInformation(

        outputRead,

        HANDLE_FLAG_INHERIT,

        0

    );






    return true;



}









HANDLE PipeManager::getInputRead()

{

    return inputRead;

}









HANDLE PipeManager::getInputWrite()

{

    return inputWrite;

}









HANDLE PipeManager::getOutputRead()

{

    return outputRead;

}









HANDLE PipeManager::getOutputWrite()

{

    return outputWrite;

}









void PipeManager::close()

{


    if(inputRead)

    {

        CloseHandle(inputRead);

        inputRead = nullptr;

    }






    if(inputWrite)

    {

        CloseHandle(inputWrite);

        inputWrite = nullptr;

    }






    if(outputRead)

    {

        CloseHandle(outputRead);

        outputRead = nullptr;

    }






    if(outputWrite)

    {

        CloseHandle(outputWrite);

        outputWrite = nullptr;

    }



}



#endif
