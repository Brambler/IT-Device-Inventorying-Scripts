@echo off

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
setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"

echo [Computer: %computername%]
REM Get Room Number
set /p room=Enter Room NUMBER: 

REM Get Department
set /p dep=Enter Department: 

REM Get Device Type
set /p device=Enter Device Type i.e "Desktop,Laptop,Printer,Other": 

REM Get Owner
set /p owner=Enter Device Owner (Who is responsible for device): 

REM Get User
set /p user=Enter Device User (Who is using the device?): 

REM Get AD INFO
set /p ad=Is this device on AD? (Yes or No): 

REM Get Sophos
set /p sophos=Does this device have Sophos (Mark if it does or not if it has Kaspersky also note): 

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

echo --------------------------------------------
echo Room Number: %room%
echo Department: %dep%
echo Device Type: %device%
echo Computer Name: %system%
echo Manufacturer: %manufacturer%
echo Model: %model%
echo Service-Tag: %serialnumber%
echo Operating System: %osname%
echo IP Address: %ip:{=%
echo Mac Address: %mac%
echo Device Owner: %owner%
echo Device User: %user%
echo Device on AD: %ad%
echo Sophos installed: %sophos%
echo --------------------------------------------

REM Generate file
SET file="%computername%.csv"
echo "Room Number", "Department", "Device Type", "Computer Name", "Manufacturer", "Model", "Service-Tag", "Operating System", "IP Address", "Mac Address", "Device Owner", "Device User", "AD", "Sophos" >> %file%
echo %room:,=%, %dep:,=%, %device:,=%, %system%, %manufacturer:,=%, %model%, %serialnumber%, %osname%, %ip:{=%, %mac%, %owner:,=%, %user:,=%, %ad:,=%, %sophos% >> %file%



REM request user to push any key to continue
pause

goto END

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
goto END

:END