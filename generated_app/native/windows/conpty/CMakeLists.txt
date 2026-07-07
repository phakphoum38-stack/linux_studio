cmake_minimum_required(VERSION 3.15)

project(conpty_backend)

add_library(
    conpty
    SHARED
    conpty.cpp
)

target_link_libraries(
    conpty
    user32
)
