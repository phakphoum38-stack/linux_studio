add_library(
    terminal_api
    SHARED

    pipe.cpp
    conpty.cpp
    process.cpp
    reader.cpp
    writer.cpp
    terminal_api.cpp
)


target_compile_definitions(
    terminal_api
    PRIVATE
    TERMINAL_EXPORTS
)


target_link_libraries(
    terminal_api

    OneCore.lib
)
