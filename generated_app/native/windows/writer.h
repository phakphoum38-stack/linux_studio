#pragma once

#include <cstdint>

#include "pipe.h"



class Writer

{

public:


    Writer();


    ~Writer();




    void attach(

        PipeManager* manager

    );




    int32_t write(

        const char* data,

        int32_t length

    );




    void stop();




private:


    PipeManager* pipe;


};
