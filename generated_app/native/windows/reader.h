#pragma once

#ifdef _WIN32

#include <windows.h>
#include <thread>
#include <atomic>
#include <functional>

#include "pipe.h"


class ReaderThread {

private:

    PipeManager* pipe;


    std::thread worker;


    std::atomic<bool> running;


    std::function<void(
        const char*,
        int
    )> callback;



    void loop();



public:


    ReaderThread();


    ~ReaderThread();



    bool start(
        PipeManager* manager
    );



    void stop();



    void setCallback(
        std::function<void(
            const char*,
            int
        )> cb
    );

};


#endif
