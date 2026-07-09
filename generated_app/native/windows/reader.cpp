#include "reader.h"

#ifdef _WIN32

#include <windows.h>


Reader::Reader()
{
    pipe = nullptr;
    running = false;
}



Reader::~Reader()
{
    stop();
}






void Reader::attach(
    PipeManager* manager
)
{

    pipe = manager;

    running =
        pipe != nullptr;

}









int Reader::read(
    char* buffer,
    int size
)

{

    if(
        !running ||
        pipe == nullptr ||
        buffer == nullptr ||
        size <= 0
    )
    {
        return 0;
    }




    HANDLE handle =
        pipe->getOutputRead();




    if(handle == nullptr)
    {
        return 0;
    }





    DWORD available = 0;



    BOOL peek =
        PeekNamedPipe(

            handle,

            nullptr,

            0,

            nullptr,

            &available,

            nullptr

        );





    if(!peek)
    {

        DWORD error =
            GetLastError();


        if(
            error ==
            ERROR_BROKEN_PIPE
        )
        {
            running = false;
        }


        return 0;

    }






    if(available == 0)
    {
        return 0;
    }







    DWORD bytesRead = 0;




    BOOL result =
        ReadFile(

            handle,

            buffer,

            size,

            &bytesRead,

            nullptr

        );






    if(!result)
    {

        DWORD error =
            GetLastError();


        if(
            error ==
            ERROR_BROKEN_PIPE
        )
        {
            running = false;
        }


        return 0;

    }







    return static_cast<int>(
        bytesRead
    );


}








bool Reader::isRunning() const
{
    return running;
}








void Reader::stop()
{

    running = false;

    pipe = nullptr;

}



#endif
