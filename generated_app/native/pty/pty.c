#include "pty.h"

#ifdef __linux__

#include <pty.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>

static int master_fd=-1;
static pid_t child_pid;

int pty_spawn(const char* shell){

    child_pid=forkpty(&master_fd,NULL,NULL,NULL);

    if(child_pid==0){

        execlp(shell,shell,NULL);

        _exit(1);

    }

    return child_pid;

}

int pty_write(const char* data,int len){

    return write(master_fd,data,len);

}

int pty_read(char* buffer,int size){

    return read(master_fd,buffer,size);

}

void pty_resize(int cols,int rows){

}

void pty_close(){

    if(child_pid>0){

        kill(child_pid,SIGTERM);

    }

}

#else

int pty_spawn(const char* shell){return -1;}
int pty_write(const char* data,int len){return -1;}
int pty_read(char* buffer,int size){return -1;}
void pty_resize(int cols,int rows){}
void pty_close(){}

#endif
