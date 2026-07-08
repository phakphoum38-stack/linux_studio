#pragma once

#ifdef _WIN32

#include <windows.h>
#include <ConsoleApi3.h>

#include "pipe.h"


class ConPTY {

private:

    HPCON hpc;

    COORD size;

    PipeManager* pipe;


public:

    ConPTY();

    ~ConPTY();



    bool create(
        short cols,
        short rows,
        PipeManager* manager
    );



    bool resize(
        short cols,
        short rows
    );



    void close();



    bool isRunning() const;



    HPCON getHandle() const;


};

#endif
