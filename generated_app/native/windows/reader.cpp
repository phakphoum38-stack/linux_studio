#include "reader.h"

#ifdef _WIN32

#include <windows.h>
#include <cstring>





Reader::Reader()

{

    pipe = nullptr;

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


}









int32_t Reader::read(

    char* buffer,

    int32_t size

)

{


    if(!pipe ||

       !buffer ||

       size <= 0)

    {

        return 0;

    }








    DWORD bytesRead = 0;






    BOOL result =

        ReadFile(

            pipe->getOutputRead(),

            buffer,

            size - 1,

            &bytesRead,

            nullptr

        );







    if(!result ||

       bytesRead == 0)

    {

        return 0;

    }








    buffer[bytesRead] =

        '\0';






    return

        static_cast<int32_t>(

            bytesRead

        );



}









void Reader::stop()

{

    pipe = nullptr;

}



#endif








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








    if(!PeekNamedPipe(

        handle,

        nullptr,

        0,

        nullptr,

        &available,

        nullptr

    ))
    {

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
