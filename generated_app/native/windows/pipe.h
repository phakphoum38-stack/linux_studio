#pragma once

#ifdef _WIN32

#include <windows.h>


class PipeManager {

private:

    HANDLE inputRead;
    HANDLE inputWrite;

    HANDLE outputRead;
    HANDLE outputWrite;


public:

    PipeManager();

    ~PipeManager();


    bool createPipes();


    bool read(
        char* buffer,
        int size
    );


    bool write(
        const char* data,
        int len
    );


    void close();



    HANDLE getInputRead() const;

    HANDLE getInputWrite() const;


    HANDLE getOutputRead() const;

    HANDLE getOutputWrite() const;


};

#endif
