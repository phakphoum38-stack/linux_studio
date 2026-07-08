#include "conpty.h"


#ifdef _WIN32



ConPTY::ConPTY()

{

    hpc = nullptr;

    pipe = nullptr;

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



    HRESULT result =
        CreatePseudoConsole(

            size,

            pipe->getInputRead(),

            pipe->getOutputWrite(),

            0,

            &hpc

        );



    return SUCCEEDED(result);


}








bool ConPTY::resize(
    short cols,
    short rows
)

{


    if(!hpc)

    {

        return false;

    }



    COORD newSize;


    newSize.X = cols;

    newSize.Y = rows;



    HRESULT result =
        ResizePseudoConsole(
            hpc,
            newSize
        );



    if(
        SUCCEEDED(result)
    )
    {

        size = newSize;

        return true;

    }



    return false;

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


}








bool ConPTY::isRunning() const

{

    return hpc != nullptr;

}








HPCON ConPTY::getHandle() const

{

    return hpc;

}



#endif
