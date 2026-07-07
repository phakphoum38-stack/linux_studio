#include "pty.h"

#include <pty.h>
#include <unistd.h>
#include <signal.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <string.h>

static int master_fd = -1;
static pid_t child_pid = -1;

int pty_read(char* buffer, int size) {
    if (master_fd < 0) return -1;
    return (int)read(master_fd, buffer, (size_t)size);
}

int pty_spawn(const char* shell, int cols, int rows) {
    if (!shell) shell = "/bin/bash";

    struct winsize ws;
    memset(&ws, 0, sizeof(ws));
    ws.ws_col = (unsigned short)cols;
    ws.ws_row = (unsigned short)rows;

    child_pid = forkpty(&master_fd, NULL, NULL, &ws);

    if (child_pid < 0) {
        master_fd = -1;
        return -1;
    }

    if (child_pid == 0) {
        setenv("TERM", "xterm-256color", 1);
        execl(shell, shell, "-i", (char*)NULL);
        _exit(127);
    }

    return master_fd;
}

int pty_write(const char* data, int length) {
    if (master_fd < 0) return -1;
    return (int)write(master_fd, data, (size_t)length);
}

int pty_resize(int cols, int rows) {
    if (master_fd < 0) return -1;

    struct winsize ws;
    memset(&ws, 0, sizeof(ws));
    ws.ws_col = (unsigned short)cols;
    ws.ws_row = (unsigned short)rows;

    return ioctl(master_fd, TIOCSWINSZ, &ws);
}

void pty_kill(void) {
    if (child_pid > 0) {
        kill(child_pid, SIGTERM);
        child_pid = -1;
    }

    if (master_fd >= 0) {
        close(master_fd);
        master_fd = -1;
    }
}
