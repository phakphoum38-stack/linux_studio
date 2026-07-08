cmake_minimum_required(VERSION 3.20)


project(
    terminal_api
    VERSION 1.0
    LANGUAGES CXX
)



set(
    CMAKE_CXX_STANDARD
    20
)


set(
    CMAKE_CXX_STANDARD_REQUIRED
    ON
)





add_library(

    terminal_api

    SHARED

    terminal_api.cpp

    pipe.cpp

    conpty.cpp

    process.cpp

    reader.cpp

    writer.cpp

)





target_include_directories(

    terminal_api

    PRIVATE

    ${CMAKE_CURRENT_SOURCE_DIR}

)





target_compile_definitions(

    terminal_api

    PRIVATE

    _WIN32_WINNT=0x0A00

)





target_link_libraries(

    terminal_api

    PRIVATE

    User32

    Kernel32

)





set_target_properties(

    terminal_api

    PROPERTIES

    OUTPUT_NAME

    "terminal_api"

)
