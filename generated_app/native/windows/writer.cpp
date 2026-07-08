#include "writer.h"


#ifdef _WIN32



WriterThread::WriterThread()

{

    pipe = nullptr;

}





WriterThread::~WriterThread()

{

    close();

}







bool WriterThread::attach(
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


    return true;

}







bool WriterThread::write(

    const char* data,

    int length

)

{


    if(
        pipe == nullptr ||
        data == nullptr ||
        length <= 0
    )

    {

        return false;

    }



    std::lock_guard<std::mutex> guard(
        lock
    );



    return pipe->write(
        data,
        length
    );


}







bool WriterThread::writeString(

    const std::string& text

)

{

    return write(

        text.c_str(),

        static_cast<int>(
            text.size()
        )

    );

}







void WriterThread::close()

{

    pipe = nullptr;

}



#endif
