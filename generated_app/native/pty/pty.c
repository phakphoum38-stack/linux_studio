#include "pty.h"

#include <pty.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <string.h>


static int master_fd = -1;

static pid_t child_pid;

extern int master_fd;


int pty_read(

    char* buffer,

    int size

){

    return read(

        master_fd,

        buffer,

        size

    );

}

int pty_spawn(
    const char* shell,
    int cols,
    int rows
){

    struct winsize ws;


    ws.ws_col = cols;
    ws.ws_row = rows;



    child_pid =
        forkpty(
            &master_fd,
            NULL,
            NULL,
            &ws
        );



    if(child_pid == 0){

        setenv(
            "TERM",
            "xterm-256color",
            1
        );


        execl(
            shell,
            shell,
            "-i",
            NULL
        );


        exit(1);

    }


    return master_fd;

}







int pty_write(
    const char* data,
    int length
){

    return write(
        master_fd,
        data,
        length
    );

}







int pty_resize(
    int cols,
    int rows
){

    struct winsize ws;


    ws.ws_col = cols;
    ws.ws_row = rows;



    return ioctl(
        master_fd,
        TIOCSWINSZ,
        &ws
    );

}







void pty_kill(){

    if(child_pid){

        kill(
            child_pid,
            SIGKILL
        );

    }

}
