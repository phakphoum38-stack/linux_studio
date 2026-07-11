#include "writer.h"

#ifdef _WIN32

#include <windows.h>





Writer::Writer()

{

    pipe = nullptr;

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


}









int32_t Writer::write(

    const char* data,

    int32_t length

)

{


    if(!pipe ||

       !data ||

       length <= 0)

    {

        return 0;

    }








    DWORD written = 0;







    BOOL result =

        WriteFile(

            pipe->getInputWrite(),

            data,

            static_cast<DWORD>(

                length

            ),

            &written,

            nullptr

        );








    if(!result)

    {

        return 0;

    }







    return

        static_cast<int32_t>(

            written

        );



}









void Writer::stop()

{

    pipe = nullptr;

}



#endif
