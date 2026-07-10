#include "conpty.h"

#ifdef _WIN32

#include <windows.h>



ConPTY::ConPTY()
{

    hpc = nullptr;

    pipe = nullptr;

    running = false;


    size.X = 80;

    size.Y = 24;

}






ConPTY::~ConPTY()
{
    close();
}









bool ConPTY::create(

    short cols,

    short rows,

    PipeManager* manager

)
{

    if(manager == nullptr)
    {
        return false;
    }



    pipe = manager;



    size.X = cols;

    size.Y = rows;






    HRESULT hr =
        CreatePseudoConsole(

            size,

            pipe->getInputRead(),

            pipe->getOutputWrite(),

            0,

            &hpc

        );






    if(FAILED(hr))
    {

        hpc = nullptr;

        pipe = nullptr;


        return false;

    }







    running = true;



    return true;


}









bool ConPTY::resize(

    short cols,

    short rows

)
{


    if(
        !running ||
        hpc == nullptr
    )
    {
        return false;
    }






    COORD newSize;


    newSize.X = cols;

    newSize.Y = rows;







    HRESULT hr =
        ResizePseudoConsole(

            hpc,

            newSize

        );






    if(FAILED(hr))
    {
        return false;
    }







    size = newSize;



    return true;


}









void ConPTY::close()
{


    if(hpc)
    {

        ClosePseudoConsole(
            hpc
        );


        hpc = nullptr;

    }





    pipe = nullptr;


    running = false;




    size.X = 0;

    size.Y = 0;


}









bool ConPTY::isRunning() const
{

    return running;

}









HPCON ConPTY::getHandle() const
{

    return hpc;

}



#endif
