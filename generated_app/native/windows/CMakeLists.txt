add_library(
    conpty_terminal
    STATIC

    pipe.cpp
    conpty.cpp
    process.cpp
    reader.cpp
    writer.cpp
)


target_link_libraries(
    conpty_terminal

    OneCore.lib
)
