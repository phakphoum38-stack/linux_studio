#ifndef PTY_H
#define PTY_H

#ifdef __cplusplus
extern "C" {
#endif

int pty_spawn(const char* shell);
int pty_write(const char* data, int len);
int pty_read(char* buffer, int size);
void pty_resize(int cols, int rows);
void pty_close();

#ifdef __cplusplus
}
#endif

#endif
