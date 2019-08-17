@echo off

SET mypath=%~dp0
IF NOT EXIST "%~dp0\DATA\" mkdir %~dp0\DATA\
IF NOT EXIST "%~dp0\DATA\Combine_PC_INFO.cmd" copy "%~dp0Combine_PC_INFO.cmd" "%~dp0DATA\Combine_PC_INFO.cmd"
IF EXIST "%~dp0DATA\Combine_PC_INFO.cmd" del "%~dp0Combine_PC_INFO.cmd"
cls

setlocal ENABLEDELAYEDEXPANSION
set "volume=C:"

echo [Computer: %computername%]

REM Get Building
echo Which building is the machine in?
set build=
set /P build=1)ESB 2)MRB 3)ERB 4)AERB 5)Other: %=%
IF /I "%build%"=="1" set build=ESB
IF /I "%build%"=="2" set build=MRB
IF /I "%build%"=="3" set build=ERB
IF /I "%build%"=="4" set build=AERB
IF /I "%build%"=="5" set /p build=Enter the building:
cls

REM Get Room Number
set /p room=Enter Room NUMBER:

REM Get Department
echo Which Department does the machine belong to?
set dep=
set /P dep=1)MAE 2)CBE 3)CEE 4)PNGE 5)IMSE 6)LCSEE 7)MINE 8)MINDEXT 9)ADM 10)FRE 11)Other: %=%
IF /I "%dep%"=="1" set dep=MAE
IF /I "%dep%"=="2" set dep=CBE
IF /I "%dep%"=="3" set dep=CEE
IF /I "%dep%"=="4" set dep=PNGE
IF /I "%dep%"=="5" set dep=IMSE
IF /I "%dep%"=="6" set dep=LCSEE
IF /I "%dep%"=="7" set dep=MINE
IF /I "%dep%"=="8" set dep=MINDEXT
IF /I "%dep%"=="9" set dep=ADM
IF /I "%dep%"=="10" set dep=FRE
IF /I "%dep%"=="11" set /p dep=Enter the department:
cls

REM Get Device Type
set device=NA

REM Get Owner
set owner=%dep% Faculty

REM Get User
set user=%dep% Students

REM Get OC Tag
echo Does this Machine have an OC Tag?
set /P oc=1)Yes 2)No: %=%
IF /I "%oc%"=="1" set /p oc=Enter the OC Tag:
IF /I "%oc%"=="2" set oc=NA
cls

REM Get NETL/OTHER TAG Tag
echo Does this Machine have a NETL/OTHER Tag?
set /P netl=1)Yes 2)No: %=%
IF /I "%netl%"=="1" set /p netl=Enter the NETL/OTHER Tag:
IF /I "%netl%"=="2" set netl=NA
cls

REM Get AD INFO
FOR /F "tokens=2 delims='='" %%A in ('wmic computersystem get domain /value') do SET domain=%%A
IF "%domain%" == "wvu-ad" SET ad=YES
IF NOT "%domain%" == "wvu-ad" SET ad=NO

REM Get AntiVirus
IF EXIST "C:\Program Files (x86)\Sophos" set antivirus=YES
IF NOT EXIST "C:\Program Files (x86)\Sophos" set antivirus=NO
IF EXIST "C:\Program Files (x86)\Kaspersky Lab" set antivirus=KASPERSKY

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

REM Generate file
SET file="%~dp0\DATA\%computername%.csv"
echo "Building", "Room Number", "Department", "Device Type", "Computer Name", "Manufacturer", "Model", "Service-Tag", "Operating System", "IP Address", "Mac Address", "Device Owner", "Device User", "AD", "DOMAIN", "Antivirus", "netl", "oc">> %file%
echo %build:,=%, %room:,=%, %dep:,=%, %device:,=%, %system%, %manufacturer:,=%, %model%, %serialnumber%, %osname%, %ip:{=%, %mac::=%, %owner:,=%, %user:,=%, %ad:,=%, %domain%, %antivirus% , %netl%, %oc% >> %file%

call %~dp0\DATA\Combine_PC_INFO.cmd

REM request user to push any key to continue
pause

goto END

:NOCON
echo Error...Invalid Operating System...
echo Error...No actions were made...
goto END

:END