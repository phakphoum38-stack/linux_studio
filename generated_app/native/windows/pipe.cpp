#include "pipe.h"


#ifdef _WIN32


PipeManager::PipeManager()

{

    inputRead = NULL;
    inputWrite = NULL;

    outputRead = NULL;
    outputWrite = NULL;

}



PipeManager::~PipeManager()

{

    close();

}





bool PipeManager::createPipes()

{


    SECURITY_ATTRIBUTES sa;


    sa.nLength =
        sizeof(SECURITY_ATTRIBUTES);


    sa.lpSecurityDescriptor =
        NULL;


    sa.bInheritHandle =
        TRUE;



    // Input Pipe

    if(
        !CreatePipe(
            &inputRead,
            &inputWrite,
            &sa,
            0
        )
    ){

        return false;

    }



    // Prevent child process
    // from inheriting write side

    SetHandleInformation(
        inputWrite,
        HANDLE_FLAG_INHERIT,
        0
    );





    // Output Pipe


    if(
        !CreatePipe(
            &outputRead,
            &outputWrite,
            &sa,
            0
        )
    ){

        close();

        return false;

    }



    // Prevent parent from inheriting read side

    SetHandleInformation(
        outputRead,
        HANDLE_FLAG_INHERIT,
        0
    );



    return true;

}







bool PipeManager::read(
    char* buffer,
    int size
)

{


    if(
        outputRead == NULL
    ){

        return false;

    }



    DWORD bytesRead = 0;



    BOOL result =
        ReadFile(
            outputRead,
            buffer,
            size,
            &bytesRead,
            NULL
        );



    return result &&
        bytesRead > 0;


}







bool PipeManager::write(
    const char* data,
    int len
)

{


    if(
        inputWrite == NULL
    ){

        return false;

    }



    DWORD bytesWritten = 0;



    BOOL result =
        WriteFile(
            inputWrite,
            data,
            len,
            &bytesWritten,
            NULL
        );



    return result &&
        bytesWritten == len;


}








void PipeManager::close()

{


    if(inputRead)
    {

        CloseHandle(
            inputRead
        );

        inputRead = NULL;

    }



    if(inputWrite)
    {

        CloseHandle(
            inputWrite
        );

        inputWrite = NULL;

    }




    if(outputRead)
    {

        CloseHandle(
            outputRead
        );

        outputRead = NULL;

    }




    if(outputWrite)
    {

        CloseHandle(
            outputWrite
        );

        outputWrite = NULL;

    }


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



#endif
