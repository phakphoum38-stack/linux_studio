@echo off

echo ================================
echo Building Terminal API DLL
echo ================================


cd /d %~dp0



if not exist build (

    mkdir build

)



cd build





cmake ..





if %ERRORLEVEL% NEQ 0 (

    echo CMake configure failed

    pause

    exit /b 1

)





cmake --build . --config Release





if %ERRORLEVEL% NEQ 0 (

    echo Build failed

    pause

    exit /b 1

)





echo.
echo ================================
echo Build Complete
echo ================================
echo.



dir Release\terminal_api.dll



pause
