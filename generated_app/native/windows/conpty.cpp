#include "conpty.h"

#ifdef _WIN32

#include <windows.h>





ConPTY::ConPTY()

{

    hpc = nullptr;

}







ConPTY::~ConPTY()

{

    close();

}









bool ConPTY::create(

    short cols,

    short rows,

    PipeManager* pipe

)

{


    if(!pipe)

    {

        return false;

    }








    COORD size;



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







    return

        SUCCEEDED(hr);



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






    COORD size;



    size.X = cols;



    size.Y = rows;







    HRESULT hr =

        ResizePseudoConsole(

            hpc,

            size

        );







    return

        SUCCEEDED(hr);



}









HPCON ConPTY::getHandle()

{

    return hpc;

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



#endif
