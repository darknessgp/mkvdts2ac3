SET USECOUCHPOTATO=1

powershell.exe -ExecutionPolicy Bypass -File "D:\newz\scripts\mkvdtstoac3.ps1" %1

REM If %2 is defined then it was sabnzbd that called this script 


IF USECOUCHPOTATO==1 (
  IF [%2] NEQ [] "D:\newz\scripts\sabToCouchPotato.exe" %1 %2 %3 %4 %5 %6 %7
)
