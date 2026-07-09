#include "reader.h"

#ifdef _WIN32


Reader::Reader()
{
    pipe=nullptr;
    running=false;
}



Reader::~Reader()
{
    stop();
}



void Reader::attach(
    PipeManager* manager
)
{

    pipe=manager;

    running =
        pipe!=nullptr;

}






int Reader::read(
    char* buffer,
    int size
)
{

    if(
        !running ||
        !pipe ||
        !buffer
    )
        return 0;



    DWORD available=0;


    if(
        !PeekNamedPipe(
            pipe->getOutputRead(),
            nullptr,
            0,
            nullptr,
            &available,
            nullptr
        )
    )
    {
        return 0;
    }



    if(available==0)
        return 0;




    DWORD read=0;



    if(
        ReadFile(
            pipe->getOutputRead(),
            buffer,
            size,
            &read,
            nullptr
        )
    )
    {

        return (int)read;

    }


    return 0;

}







void Reader::stop()
{

    running=false;

    pipe=nullptr;

}



#endif
