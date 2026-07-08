#include "reader.h"


#ifdef _WIN32


#include <cstring>



ReaderThread::ReaderThread()

{

    pipe = nullptr;

    running = false;

}






ReaderThread::~ReaderThread()

{

    stop();

}







bool ReaderThread::start(
    PipeManager* manager
)

{


    if(
        manager == nullptr
    )

    {

        return false;

    }



    pipe = manager;


    running = true;



    worker =
        std::thread(
            &ReaderThread::loop,
            this
        );



    return true;

}







void ReaderThread::loop()

{


    char buffer[4096];



    while(
        running
    )

    {


        if(
            pipe == nullptr
        )

        {

            break;

        }



        bool result =
            pipe->read(
                buffer,
                sizeof(buffer)
            );



        if(
            result
        )

        {


            if(callback)

            {

                callback(
                    buffer,
                    strlen(buffer)
                );

            }


        }


        else

        {


            Sleep(10);


        }


    }


}







void ReaderThread::stop()

{


    running = false;



    if(
        worker.joinable()
    )

    {

        worker.join();

    }


}







void ReaderThread::setCallback(

    std::function<void(
        const char*,
        int
    )> cb

)

{

    callback = cb;

}



#endif
