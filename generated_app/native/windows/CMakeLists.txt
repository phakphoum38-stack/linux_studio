cmake_minimum_required(VERSION 3.20)

project(
    terminal_api
    VERSION 1.0
    LANGUAGES CXX
)



set(CMAKE_CXX_STANDARD 20)

set(CMAKE_CXX_STANDARD_REQUIRED ON)





add_library(

    terminal_api

    SHARED

    terminal_api.cpp

    conpty.cpp

    pipe.cpp

    process.cpp

    reader.cpp

    writer.cpp

)







target_compile_definitions(

    terminal_api

    PRIVATE

    TERMINAL_BUILD_DLL

)







target_include_directories(

    terminal_api

    PRIVATE

    ${CMAKE_CURRENT_SOURCE_DIR}

)







if(WIN32)


    target_link_libraries(

        terminal_api

        PRIVATE

        advapi32

        user32

    )


endif()







set_target_properties(

    terminal_api

    PROPERTIES

    OUTPUT_NAME

    "terminal_api"

)
