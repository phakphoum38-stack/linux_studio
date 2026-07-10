#include "writer.h"

#ifdef _WIN32

#include <windows.h>



Writer::Writer()
{

    pipe = nullptr;

    running = false;

}







Writer::~Writer()
{

    stop();

}









void Writer::attach(

    PipeManager* manager

)
{

    pipe = manager;


    running =
        pipe != nullptr;


}









bool Writer::write(

    const char* data,

    int length

)
{

    if(
        !running ||
        pipe == nullptr ||
        data == nullptr ||
        length <= 0
    )
    {

        return false;

    }







    HANDLE handle =

        pipe->getInputWrite();








    if(handle == nullptr)
    {

        return false;

    }








    DWORD written = 0;







    BOOL result =

        WriteFile(

            handle,

            data,

            length,

            &written,

            nullptr

        );








    return

        result &&

        written == static_cast<DWORD>(length);


}









bool Writer::isRunning() const
{

    return running;

}









void Writer::stop()
{

    running = false;


    pipe = nullptr;


}



#endif
