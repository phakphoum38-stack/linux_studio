#include "terminal_api.h"

#ifdef _WIN32


#include "pipe.h"
#include "conpty.h"
#include "process.h"
#include "reader.h"
#include "writer.h"



struct TerminalSession
{

    PipeManager pipe;


    ConPTY conpty;


    ProcessLauncher process;


    ReaderThread reader;


    WriterThread writer;


};







extern "C"
{



TERMINAL_API void*
terminal_create(

    int rows,

    int cols

)

{


    TerminalSession* session =
        new TerminalSession();



    if(
        !session->pipe.createPipes()
    )

    {

        delete session;

        return nullptr;

    }



    if(
        !session->conpty.create(

            rows,

            cols,

            session->pipe

        )

    )

    {

        delete session;

        return nullptr;

    }



    session->process.start(

        &session->conpty,

        L"powershell.exe"

    );



    session->reader.start(

        &session->pipe

    );



    session->writer.attach(

        &session->pipe

    );



    return session;

}







TERMINAL_API bool
terminal_write(

    void* handle,

    const char* data,

    int length

)

{


    if(!handle)

        return false;



    auto session =
        static_cast<TerminalSession*>(handle);



    return session->writer.write(

        data,

        length

    );


}







TERMINAL_API int
terminal_read(

    void* handle,

    char* buffer,

    int size

)

{


    if(!handle)

        return -1;



    auto session =
        static_cast<TerminalSession*>(handle);



    return session->pipe.read(

        buffer,

        size

    );


}







TERMINAL_API bool
terminal_resize(

    void* handle,

    int rows,

    int cols

)

{


    if(!handle)

        return false;



    auto session =
        static_cast<TerminalSession*>(handle);



    return session->conpty.resize(

        rows,

        cols

    );


}







TERMINAL_API void
terminal_close(

    void* handle

)

{


    if(!handle)

        return;



    auto session =
        static_cast<TerminalSession*>(handle);



    session->reader.stop();



    session->process.close();



    session->conpty.close();



    session->pipe.close();



    delete session;


}



}


#endif
