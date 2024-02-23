@ECHO OFF
REM This batch script to clean up Zoom and install new version
REM Peter Nguyen
REM https://ITWiz.io
REM Created: 02-22-2024
REM Modified 02-22-2024

REM Three files need to be in the same folder
REM "\\SharePath\Zoom\ZoomInstallerFull.msi"
REM "\\SharePath\Zoom\CleanZoom.exe"
REM "\\SharePath\Zoom\AutoSetupZoom.cmd"

REM Log path
SET "LogPath=C:\Services\Logs\Zoom"
SET "LogName=Zoom.log"

REM Create Log Dir
IF NOT EXIST %LogPath% MD %LogPath%
ECHO Start Install Zoom Script - %date% - %time% > %LogPath%\%LogName%
ECHO Start - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

ECHO End Zoom app
TASKKILL /F /IM Zoom.exe
ECHO End Zoom app - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

ECHO Stop Zoom Service
NET STOP ZoomCptService
ECHO Stop Zoom Service - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

ECHO Uninstall Zoom Product ID
REM Remove "REM" and update product ID
REM Product ID HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{499EA83F-642D-40CB-A55E-5D385DEDD376}
REM Example msiexec /x{499EA83F-642D-40CB-A55E-5D385DEDD376} /q
REM msiexec /x{OLD_PRODUCT_ID_1} /q
REM ECHO Uninstall 01 - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%
REM msiexec /x{OLD_PRODUCT_ID_2} /q
REM ECHO Uninstall 02 - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

ECHO Zoom Cleanup
"%~dp0CleanZoom.exe" /silent
ECHO Zoom Cleanup - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

REM ECHO Wait for Cleanup
REM ping -n 30 127.0.0.1 > NUL 2>&1

ECHO Remove Registry
REM reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\ZoomUMX" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\ZoomUMX\PerInstall" /f
ECHO Remove Registry - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

REM Pause

ECHO Install Zoom
msiexec /i "%~dp0ZoomInstallerFull.msi" /quiet /norestart
ECHO Install Zoom - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

ECHO Wait for review before exiting
ping -n 30 127.0.0.1 > NUL 2>&1

ECHO End Install Zoom Script - %date% - %time% - %ERRORLEVEL% >> %LogPath%\%LogName%

EXIT /B 0