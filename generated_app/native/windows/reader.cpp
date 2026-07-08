#include "reader.h"


#ifdef _WIN32



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

        buffer == nullptr

    )

    {

        return -1;

    }






    DWORD bytesRead = 0;





    BOOL result =

        ReadFile(

            pipe->getOutputRead(),

            buffer,

            size,

            &bytesRead,

            nullptr

        );








    if(!result)

    {

        return -1;

    }





    return (

        int

    )bytesRead;


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
