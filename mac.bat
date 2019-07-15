@ECHO OFF
SETLOCAL enabledelayedexpansion
FOR /f "delims=" %%a IN ('getmac /v ^|find /i "local area conn" ') DO (
 FOR %%b IN (%%a) DO (
  SET element=%%b
  IF "!element:~2,1!!element:~5,1!!element:~8,1!"=="---" set mac=%%b
 )
)
ECHO found %mac%
GOTO :EOF