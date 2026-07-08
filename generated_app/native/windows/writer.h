#pragma once

#ifdef _WIN32


#include <windows.h>

#include "pipe.h"



class Writer {


private:


    PipeManager* pipe = nullptr;


    bool running = false;



public:


    Writer();


    ~Writer();





    void attach(

        PipeManager* manager

    );





    bool write(

        const char* data,

        int length

    );





    bool isRunning() const;





    void stop();



};


#endif
