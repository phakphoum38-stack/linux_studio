#pragma once

#ifdef _WIN32

#include <windows.h>
#include <string>
#include <mutex>

#include "pipe.h"


class WriterThread {


private:

    PipeManager* pipe;

    std::mutex lock;



public:


    WriterThread();



    ~WriterThread();



    bool attach(
        PipeManager* manager
    );



    bool write(
        const char* data,
        int length
    );



    bool writeString(
        const std::string& text
    );



    void close();


};


#endif
