#pragma once

int pty_spawn(const char* shell, int cols, int rows);
int pty_read(char* buffer, int size);
int pty_write(const char* data, int length);
int pty_resize(int cols, int rows);
void pty_kill(void);
