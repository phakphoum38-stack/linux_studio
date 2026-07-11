#pragma once

#include <cstdint>

#include "pipe.h"



class Reader

{

public:


    Reader();


    ~Reader();



    void attach(

        PipeManager* manager

    );




    int32_t read(

        char* buffer,

        int32_t size

    );




    void stop();




private:


    PipeManager* pipe;


};
