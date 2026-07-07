cmake_minimum_required(VERSION 3.20)

project(terminal_native)

add_library(
    terminal_native
    SHARED
    pty.c
)

target_compile_features(
    terminal_native
    PRIVATE
    c_std_11
)
