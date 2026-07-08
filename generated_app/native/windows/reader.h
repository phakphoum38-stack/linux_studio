#pragma once

#ifdef _WIN32

#include <windows.h>

#include "pipe.h"


class Reader {


private:


    PipeManager* pipe = nullptr;


    bool running = false;



public:


    Reader();


    ~Reader();





    void attach(

        PipeManager* manager

    );





    int read(

        char* buffer,

        int size

    );





    bool isRunning() const;





    void stop();



};

#endif
