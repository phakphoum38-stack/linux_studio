#include "pipe.h"


#ifdef _WIN32


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

    sa.lpSecurityDescriptor =
        nullptr;

    sa.bInheritHandle =
        TRUE;



    // stdin

    if(
        !CreatePipe(
            &inputRead,
            &inputWrite,
            &sa,
            0
        )
    )
    {
        return false;
    }



    SetHandleInformation(
        inputWrite,
        HANDLE_FLAG_INHERIT,
        0
    );




    // stdout

    if(
        !CreatePipe(
            &outputRead,
            &outputWrite,
            &sa,
            0
        )
    )
    {

        close();

        return false;

    }



    SetHandleInformation(
        outputRead,
        HANDLE_FLAG_INHERIT,
        0
    );



    return true;

}




    //
    // ConPTY output
    //

    if(!CreatePipe(
        &outputRead,
        &outputWrite,
        &sa,
        0))
    {

        close();

        return false;
    }



    //
    // Parent reads
    //

    SetHandleInformation(
        outputRead,
        HANDLE_FLAG_INHERIT,
        0
    );



    return true;

}





HANDLE PipeManager::getInputRead() const
{
    return inputRead;
}



HANDLE PipeManager::getInputWrite() const
{
    return inputWrite;
}



HANDLE PipeManager::getOutputRead() const
{
    return outputRead;
}



HANDLE PipeManager::getOutputWrite() const
{
    return outputWrite;
}





void PipeManager::close()
{


    if(inputRead)
    {
        CloseHandle(inputRead);
        inputRead=nullptr;
    }


    if(inputWrite)
    {
        CloseHandle(inputWrite);
        inputWrite=nullptr;
    }


    if(outputRead)
    {
        CloseHandle(outputRead);
        outputRead=nullptr;
    }


    if(outputWrite)
    {
        CloseHandle(outputWrite);
        outputWrite=nullptr;
    }


}



#endif
