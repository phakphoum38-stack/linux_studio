#include "conpty.h"


#ifdef _WIN32



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



    if(running)

    {

        close();

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





    if(

        SUCCEEDED(result)

    )

    {

        running = true;

        return true;

    }






    hpc = nullptr;

    pipe = nullptr;


    return false;


}









bool ConPTY::resize(

    short cols,

    short rows

)

{


    if(

        !hpc ||

        !running

    )

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
