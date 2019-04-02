@echo off

REM syntax: ping_scan.bat (first three octets of /24) [wait time in milliseconds]

REM Performs a parallel ping scan across a specified /24 with optional timeout on individual pings
REM The parallel replies sometimes arrive faster than the shell can enter newline characters
REM   so some replies may show up on the same line

IF "%2" == "" ( 
	SET wait="300"
) ELSE (
	SET wait=%2
)

FOR /L %%i in (1,1,255) do start /b cmd /c "ping -n 1 -w %wait% %1.%%i | find "Reply" &"
@echo on
