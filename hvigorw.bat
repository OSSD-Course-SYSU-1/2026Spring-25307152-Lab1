@echo off
setlocal
set HVIGOR_VERSION=4.0.2
set HVIGOR_APP_HOME=%~dp0
set HVIGOR_WRAPPER_DIR=%HVIGOR_APP_HOME%hvigor
set HVIGOR_WRAPPER_JAR=%HVIGOR_WRAPPER_DIR%\hvigor-wrapper.jar
if exist "%HVIGOR_WRAPPER_JAR%" goto execute
echo ERROR: HVIGOR_WRAPPER_JAR not found.
echo Please sync project in DevEco Studio to download hvigor wrapper.
goto end
:execute
node "%HVIGOR_WRAPPER_DIR%\hvigor-wrapper.js" %*
:end
endlocal
