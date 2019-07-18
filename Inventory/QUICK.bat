@echo off

IF NOT EXIST "\Inventory\DATA\" mkdir \Inventory\DATA\

REM set variables
set system=
set manufacturer=
set model=
set serialnumber=
set osname=
set room=
set dep=
set device=
set owner=
set user=
set ad=
set sophos=
set build=
set domain=
setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"

echo [Computer: %computername%]

REM Get Building
set /p build=Enter Building i.e "ESB, AER, ERB, ect...":

REM Get Room Number
set /p room=Enter Room NUMBER: 

REM Get Department
set /p dep=Enter Department: 

REM Get Device Type
set device=NA

REM Get Owner
set owner=NA 

REM Get User
set user=NA

REM Get AD INFO
FOR /F "tokens=2 delims='='" %%A in ('wmic computersystem get domain /value') do SET domain=%%A
IF "%domain%" == "wvu-ad.wvu.edu" SET ad=YES
IF NOT "%domain%" == "wvu-ad.wvu.edu" SET ad=NO

REM Get Sophos
IF EXIST "C:\Program Files (x86)\Sophos" set sophos=YES
IF NOT EXIST "C:\Program Files (x86)\Sophos" set sophos=NO
IF EXIST "C:\Program Files (x86)\Kaspersky Lab" set sophos=KASPERSKY

REM Get Computer Name
FOR /F "tokens=2 delims='='" %%A in ('wmic OS Get csname /value') do SET system=%%A

REM Get Computer Manufacturer
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Manufacturer /value') do SET manufacturer=%%A

REM Get Computer Model
FOR /F "tokens=2 delims='='" %%A in ('wmic ComputerSystem Get Model /value') do SET model=%%A

REM Get Computer Serial Number
FOR /F "tokens=2 delims='='" %%A in ('wmic Bios Get SerialNumber /value') do SET serialnumber=%%A

REM Get Computer OS
FOR /F "tokens=2 delims='='" %%A in ('wmic os get Name /value') do SET osname=%%A
FOR /F "tokens=1 delims='|'" %%A in ("%osname%") do SET osname=%%A

REM Get Computer IP
set qry=where "ipenabled=true"
set params=ipaddress
FOR /F "usebackq skip=2 tokens=1-3 delims=';'," %%a in (
  `wmic nicconfig %qry% get %params% /format:csv ^<nul^|find /v "0.0.0.0"`
    ) do set ip=%%b 

REM Get Computer Mac
set qry=where "ipenabled=true"
set params=ipaddress^^,macaddress
FOR /F "usebackq skip=2 tokens=1-4 delims=," %%a in (
  `wmic nicconfig %qry% get %params% /format:csv ^<nul^|find /v "0.0.0.0"`
    ) do set mac=%%c 

cls
echo Computer Name: %system%
echo Service-Tag: %serialnumber%
echo IP Address: %ip:{=%
echo Mac Address: %mac%
echo:
echo:
echo Building: %build%
echo Room Number: %room%
echo Department: %dep%
echo Device Type: %device%
echo Model: %model%
echo Device on AD: %ad%
echo Sophos installed: %sophos%

REM Generate file
SET file="\Inventory\DATA\%computername%.csv"
echo "Building", "Room Number", "Department", "Device Type", "Computer Name", "Manufacturer", "Model", "Service-Tag", "Operating System", "IP Address", "Mac Address", "Device Owner", "Device User", "AD", "DOMAIN", "Sophos" >> %file%
echo %build:,=%, %room:,=%, %dep:,=%, %device:,=%, %system%, %manufacturer:,=%, %model%, %serialnumber%, %osname%, %ip:{=%, %mac::=%, %owner:,=%, %user:,=%, %ad:,=%, %domain%, %sophos% >> %file%



REM request user to push any key to continue
pause

goto END

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
goto END

:END