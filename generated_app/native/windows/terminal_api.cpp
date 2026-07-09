#include "terminal_api.h"


#ifdef _WIN32


#include "pipe.h"
#include "conpty.h"
#include "process.h"
#include "reader.h"
#include "writer.h"

#include <windows.h>
#include <stdint.h>



struct TerminalContext
{

    PipeManager pipe;

    ConPTY conpty;

    ProcessManager process;

    Reader reader;

    Writer writer;

};







extern "C"
{








TERMINAL_API void* terminal_create(

    int32_t rows,

    int32_t cols

)

{


    TerminalContext* ctx =
        new TerminalContext();





    if(ctx == nullptr)
    {
        return nullptr;
    }







    //
    // Create Pipes
    //

    if(
        !ctx->pipe.createPipes()
    )
    {

        delete ctx;

        return nullptr;

    }









    //
    // Create ConPTY
    //

    if(
        !ctx->conpty.create(

            (short)cols,

            (short)rows,

            &ctx->pipe

        )
    )
    {

        delete ctx;

        return nullptr;

    }








    //
    // Attach IO
    //

    ctx->reader.attach(

        &ctx->pipe

    );



    ctx->writer.attach(

        &ctx->pipe

    );









    //
    // Start Shell
    //

    if(
        !ctx->process.start(

            ctx->conpty.getHandle(),

            L"C:\\Windows\\System32\\cmd.exe"

        )
    )
    {

        ctx->reader.stop();

        ctx->writer.stop();

        ctx->conpty.close();

        ctx->pipe.close();


        delete ctx;


        return nullptr;

    }






    return static_cast<void*>(ctx);


}









TERMINAL_API bool terminal_write(

    void* handle,

    const char* data,

    int32_t length

)

{


    if(
        handle == nullptr ||
        data == nullptr ||
        length <= 0
    )
    {

        return false;

    }





    TerminalContext* ctx =

        static_cast<TerminalContext*>(handle);







    return ctx->writer.write(

        data,

        length

    );



}









TERMINAL_API int32_t terminal_read(

    void* handle,

    char* buffer,

    int32_t size

)

{


    if(
        handle == nullptr ||
        buffer == nullptr ||
        size <= 0
    )
    {

        return 0;

    }






    TerminalContext* ctx =

        static_cast<TerminalContext*>(handle);






    return ctx->reader.read(

        buffer,

        size

    );


}









TERMINAL_API bool terminal_resize(

    void* handle,

    int32_t cols,

    int32_t rows

)

{


    if(
        handle == nullptr
    )
    {

        return false;

    }






    TerminalContext* ctx =

        static_cast<TerminalContext*>(handle);







    return ctx->conpty.resize(

        (short)cols,

        (short)rows

    );


}









TERMINAL_API void terminal_close(

    void* handle

)

{


    if(
        handle == nullptr
    )
    {

        return;

    }






    TerminalContext* ctx =

        static_cast<TerminalContext*>(handle);







    ctx->writer.stop();


    ctx->reader.stop();



    ctx->process.close();



    ctx->conpty.close();



    ctx->pipe.close();







    delete ctx;



}








}

#endif
