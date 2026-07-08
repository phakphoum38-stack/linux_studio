#include "terminal_api.h"

#include "conpty.h"

#include <stdlib.h>
#include <string.h>



struct TerminalHandle
{

    ConPTY* conpty;

};







void* terminal_create(
    int rows,
    int cols
)
{

    TerminalHandle* handle =
        new TerminalHandle();



    handle->conpty =
        new ConPTY();



    if(!handle->conpty->create(
        rows,
        cols
    ))
    {

        delete handle->conpty;

        delete handle;

        return nullptr;

    }



    return handle;

}








int terminal_write(
    void* ptr,
    const char* data,
    int length
)
{


    if(ptr == nullptr)
        return 0;



    TerminalHandle* handle =
        (TerminalHandle*)ptr;



    return handle->conpty->write(
        data,
        length
    );

}








int terminal_read(
    void* ptr,
    unsigned char* buffer,
    int size
)
{


    if(ptr == nullptr)
        return 0;



    TerminalHandle* handle =
        (TerminalHandle*)ptr;



    return handle->conpty->read(
        buffer,
        size
    );


}








int terminal_resize(
    void* ptr,
    int rows,
    int cols
)
{


    if(ptr == nullptr)
        return 0;



    TerminalHandle* handle =
        (TerminalHandle*)ptr;



    return handle->conpty->resize(
        rows,
        cols
    );


}








void terminal_close(
    void* ptr
)
{


    if(ptr == nullptr)
        return;



    TerminalHandle* handle =
        (TerminalHandle*)ptr;



    if(handle->conpty)
    {

        handle->conpty->close();

        delete handle->conpty;

    }



    delete handle;


}
