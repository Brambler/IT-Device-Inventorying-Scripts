@echo off
setlocal enabledelayedexpansion

Rem | Expand ipconfig To Loop
for /f "tokens=*" %%A in ('ipconfig /all') do (

    Rem | Only Find The Adapter Names With "Ethernet"
    for /f "tokens=*" %%B in ('Echo %%A^| find /V "."^| find /V "::"^| find /I ":"^| find /I "Ethernet"') do (

        Rem | Remove ":" From Output
        set "adapter=%%B"
        set adapter=!adapter::=%!

        Rem | Find the first "adapter" In ipconfig
        set adapterfound=false
        for /f "tokens=1-2 delims=:" %%f in ('ipconfig /all') do (
            set "item=%%f"
            if /i "!item!"=="!adapter!" (
                set adapterfound=true
            ) else if not "!item!"=="!item:Physical Address=!" if "!adapterfound!"=="true" (

                Rem | It Was Found, Extract Physical Address Data
                set "adress=%%g"
                set adress=!adress:* =%!
                set adapterfound=false
            )
        )

        Rem | Echo Each Result
        echo !adapter!: !adress!

    )
)

pause
GOTO :EOF