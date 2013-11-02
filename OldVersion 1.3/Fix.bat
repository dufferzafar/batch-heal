@ ECHO OFF

Title Batch Heal and Clean

::------------------------------------------------------ Scanning IF OS is XP or NOT
VER | FIND "Microsoft Windows XP"> NUL
IF ERRORLEVEL 1 GOTO NotXP

VER | FIND "5.1.2600"> NUL
IF ERRORLEVEL 1 GOTO NotXP
:: -----------------------------~~~~~~~~~~~~~~~~~~~~----------------------------------

::-------------------------------------------- Scanning IF Environment Variables Exist
IF "%PROGRAMFILES%"=="" GOTO NoEnv
IF "%SYSTEMDRIVE%"=="" GOTO NoEnv
IF "%SYSTEMROOT%"=="" GOTO NoEnv
IF "%USERPROFILE%"=="" GOTO NoEnv
IF "%TEMP%"=="" GOTO NoEnv
IF "%TMP%"=="" GOTO NoEnv
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

::------------------------------------------------ Remove Any Restrictions In Presence
::Removal is being done at the beginning so that it doesn't interfere with 
::Registry Merge afterwards
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /F
CLS
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

::-------------------------------------------- Setting Up Needed Environment Variables
::Controls /Q Option
SET Quiet=FALSE

::The Basic Task
SET Task="Basic Cleanup, DONE !"
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

::------------------------------------------------------- Data File Extraction Routine
:DATAFILE
SET Dat="Data.dll"
SET Dir="%Temp%\BHCTemp"
IF NOT EXIST %Dat% Goto NoDataFile
IF NOT EXIST "%Dir%" MD "%Dir%" >NUL
CLS
::Extract Files
Expand.exe %Dat% -f:* %Dir% >NUL
CLS
::Confirm that files have been successfully extracted
IF NOT EXIST %Dir%\HOSTS Goto ExtractFailed
::Expand Files
::FOR %%a IN (%Dir%\*.*) DO ( Expand.exe -r %%a )
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

::Perform Everything Quitely i.e No Message Boxes
IF "%1" == "/Q" SET Quiet=TRUE

::Messaging Features
IF "%1" == "/VER" Goto VERSION

IF "%1" == "/LIC" Goto LICENSE

IF "%1" == "/DEV" Goto DEVELOPER

IF "%1" == "/HELP" Goto HELP 
IF "%1" == "/?" Goto HELP 

::Cleanup Features
IF "%1" == "/MSCLEAN" Goto MSCLEAN

IF "%1" == "/MRU" Goto MRUCLEANUP

IF "%1" == "/STARTUP" Goto CLEANSTARTUP

::Healing Features
IF "%1" == "/ASSOC" Goto ASSOC

IF "%1" == "/HOSTS" Goto HOSTS

IF "%1" == "/TROJAN" Goto CLEANTROJAN

IF "%1" == "/SPYWARE" Goto CLEANSPY

REM ---------------------------------------------------------------------------------------------- SYSTEM CLEANING

::Cleanig %TEMP% Folder
IF EXIST "%TEMP%" RD /S /Q "%TEMP%\"> NUL
IF NOT EXIST "%TEMP%" MD "%TEMP%\"> NUL
::Cleaning XP Standard Temp Files
IF EXIST "%SYSTEMROOT%\temp" RD /S /Q "%SYSTEMROOT%\temp"> NUL
IF NOT EXIST "%SYSTEMROOT%\temp" MD "%SYSTEMROOT%\Temp"> NUL
CLS
::Cleaning %USERNAME% Temp Files
IF EXIST "%USERPROFILE%\locals~1\temp" RD /S /Q "%USERPROFILE%\locals~1\temp"> NUL
IF NOT EXIST "%USERPROFILE%\locals~1\temp" MD "%USERPROFILE%\locals~1\temp"> NUL
::Cleaning %USERNAME% Temporary Internet Files
IF EXIST "%USERPROFILE%\locals~1\tempor~1" DEL /F /Q /A "%USERPROFILE%\locals~1\temporary internet files\*.*"> NUL
::Cleaning %USERNAME% Recent Document History
IF EXIST "%USERPROFILE%\recent" DEL /F /Q /A "%USERPROFILE%\recent\*.*"> NUL
::Cleaning %USERNAME% Internet History
IF EXIST "%USERPROFILE%\locals~1\history" DEL /F /Q /A "%USERPROFILE%\locals~1\history\*.*"> NUL
CLS
::Cleaning %USERNAME% Cookies
IF EXIST "%USERPROFILE%\locals~1\tempor~1\*.txt" DEL /F /A "%USERPROFILE%\locals~1\temporary internet files\*.txt"> NUL
IF EXIST "%USERPROFILE%\cookies" DEL /F /Q /A "%USERPROFILE%\cookies\*.*"> NUL
::Cleaning Backup Temporary Files
FOR %%v IN (old bak syd bkp bk! _bk da0) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (old bak syd bkp bk! _bk da0) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
::Cleaning Diagnostic Files Created By Windows
FOR %%v IN (bootlog.prv suhdlg.dat iebak.dat ndimage.dat) DO IF EXIST "%SYSTEMDRIVE%\%%v" DEL /F /A "%SYSTEMDRIVE%\%%v"
FOR %%v IN (bootlog.prv modemdet.txt suhdlg.dat) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
FOR %%v IN (iebak.dat ndimage.dat) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
::Cleaning Help AVI files from Help folder.
FOR %%v IN (avi ftg fts gid) DO IF EXIST "%SYSTEMROOT%\help\*.%%v" DEL /F /A "%SYSTEMROOT%\help\*.%%v"
::Cleaning Help file search data.
FOR %%v IN (gid) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (gid) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
FOR %%v IN (gid) DO IF EXIST "%SYSTEMROOT%\system32\*.%%v" DEL /F /A "%SYSTEMROOT%\system32\*.%%v"
CLS
::Cleaning Marketing files from shareware programs.
FOR %%v IN (diz) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (diz) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
::Cleaning Save Disk Error from Scandisk and Lost cluster files.
FOR %%v IN (chk chklst chklist _dd) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (chk) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
IF EXIST "%SYSTEMDRIVE%\chklst.*" DEL /F /A "%SYSTEMDRIVE%\chklst.*"
IF EXIST "%SYSTEMDRIVE%\chklist.*" DEL /F /A "%SYSTEMDRIVE%\chklist.*"
::Cleaning Temporary Application OLE supported files.
FOR %%v IN (shs) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (shs) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
::Cleaning Temporary files left over by applications.
CD %SYSTEMDRIVE%\
FOR %%a IN (~*.* *.??~ *.?$? *.??_ *.--- *.___ *.tmp *.~mp *._mp *.hfx *.cdx *.hfa) DO DEL /F /A "%SYSTEMDRIVE%\%%a"
FOR %%a IN (*.b~k *.bmk mscreate.* ffastun.* acad.e* *.da1 *.lhx *.par ~$*.doc) DO DEL /F /A "%SYSTEMDRIVE%\%%a"
CD %SYSTEMROOT%\
FOR %%a IN (~*.* *.??~ *.?$? *.??_ *.--- *.___ *.tmp *.~mp *._mp *.hfx *.cdx *.hfa) DO DEL /F /A "%SYSTEMROOT%\%%a"
FOR %%a IN (*.b~k *.bmk mscreate.* ffastun.* acad.e* *.da1 *.lhx *.par ~$*.doc) DO DEL /F /A "%SYSTEMROOT%\%%a"
CD %SYSTEMDRIVE%\
CLS
::Cleaning temporary files in folders other than in root directory.
FOR %%v IN (prv fts ftg $$$ fnd mtx $db DB$ mfd wpx nu3) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
FOR %%v IN (sdi 000 001 002) DO IF EXIST "%SYSTEMDRIVE%\*.%%v" DEL /F /A "%SYSTEMDRIVE%\*.%%v"
::Cleaning temporary files in folders other than in windows directory.
FOR %%v IN (prv fts ftg $$$ fnd mtx $db DB$ mfd wpx nu3) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
FOR %%v IN (sdi 000 001 002) DO IF EXIST "%SYSTEMROOT%\*.%%v" DEL /F /A "%SYSTEMROOT%\*.%%v"
::Cleaning icon cache, saving some resources on restart.
IF EXIST "%USERPROFILE%\locals~1\applic~1\IconCache.db" DEL /F /A "%USERPROFILE%\locals~1\applic~1\IconCache.db"
::Cleaning offline web pages.
IF EXIST "%SYSTEMROOT%\offline web pages" DEL /F /Q /A "%SYSTEMROOT%\offline web pages\*.*"> NUL
::Cleaning MS Office recent files.
IF EXIST "%SYSTEMROOT%\applic~1\microsoft\office\recent" DEL /F /Q /A "%SYSTEMROOT%\applic~1\microsoft\office\recent\*.*"> NUL
CLS
REM ------------------------------------------------------------------------------------------ END SYSTEM CLEANING

REM ---------------------------------------------------------------------------------------------- REGISTRY TWEAKS

::Create Registry Header
IF EXIST "%Temp%.\RegTweaks.reg" DEL "%Temp%.\RegTweaks.reg"
ECHO Windows Registry Editor Version 5.00 >>"%Temp%.\RegTweaks.reg"
ECHO. >>"%Temp%.\RegTweaks.reg"

::Disable Autorun Feature
ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf] >>"%Temp%.\RegTweaks.reg"
ECHO @="@SYS:DoesNotExist" >>"%Temp%.\RegTweaks.reg"
ECHO. >>"%Temp%.\RegTweaks.reg"

::Fix Opening Of Search When Folder Is Double Clicked
ECHO [HKEY_CLASSES_ROOT\Directory\shell] >>"%Temp%.\RegTweaks.reg"
ECHO @="none" >>"%Temp%.\RegTweaks.reg"
ECHO. >>"%Temp%.\RegTweaks.reg"
ECHO [HKEY_CLASSES_ROOT\Drive\shell] >>"%Temp%.\RegTweaks.reg"
ECHO @="none" >>"%Temp%.\RegTweaks.reg"
ECHO. >>"%Temp%.\RegTweaks.reg"

::SET Explorer As Default Shell
ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon] >>"%Temp%.\RegTweaks.reg"
ECHO "Shell"="Explorer.exe" >>"%Temp%.\RegTweaks.reg"
ECHO. >>"%Temp%.\RegTweaks.reg"

::Apply All Tweaks And DELETE The File
REGEDIT.EXE /S "%Temp%.\RegTweaks.reg"
DEL "%Temp%.\RegTweaks.reg" 

REM ------------------------------------------------------------------------------------------ END REGISTRY TWEAKS

CLS

:MESSAGE
IF "%Quiet%" == "FALSE" (
::Create VBS File To Show Completion Message
IF EXIST "%Temp%.\Success.vbs" DEL "%Temp%.\Success.vbs"
ECHO Msgbox %Task% ,64," Batch Heal & Clean 1.0.3" >>"%Temp%.\Success.vbs"
%Temp%.\Success.vbs
DEL "%Temp%.\Success.vbs"
)

Goto END

::--------------------------------  THE END  ------------------------------------
:END
CLS
RD /S /Q "%Dir%"
EXIT
::---------------------------~~~~~~~~~~~~~~~~~~~~~~------------------------------

::===============================================================================
::==========================	INFO Message Boxes		=========================
::=============================================================================== 

:VERSION
::Create VBS File To Show A Message
IF EXIST "%Temp%.\Version.vbs" DEL "%Temp%.\Version.vbs"
ECHO Msgbox "Batch Heal & Clean by Shadab Zafar" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Version.vbs"
ECHO "               Version 1.0.3" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Version.vbs"
ECHO "Release Date : 23/9/2010" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Version.vbs"
ECHO "Upgrade Expected On : 30/9/2010" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Version.vbs"
ECHO "",64," Version 1.0.3 " >>"%Temp%.\Version.vbs"

%Temp%.\Version.vbs
DEL "%Temp%.\Version.vbs"

Goto END

:LICENSE
::Create VBS File To Show A Message
IF EXIST "%Temp%.\License.vbs" DEL "%Temp%.\License.vbs"
ECHO Msgbox "Batch Heal and Clean's License:-" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  This script is a FOSS i.e Free and Open Source" ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  Software." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  I could have easily compiled it into an EXE" ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  But I believe in giving power to the people." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  Now you have the source code." ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  Once you have downloaded it, Its Yours!" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  Modify it, Rebuild or Repack it." ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  You can even distribute it with your name." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\License.vbs"
ECHO "  Basically, There is no license to protect this" ^& vbCrlf ^& _>>"%Temp%.\License.vbs"
ECHO "  software." _>>"%Temp%.\License.vbs"
ECHO ,64," There is NO LICENSE " >>"%Temp%.\License.vbs"

%Temp%.\License.vbs
DEL "%Temp%.\License.vbs"

Goto END

:DEVELOPER
::Create VBS File To Show A Message
IF EXIST "%Temp%.\Developer.vbs" DEL "%Temp%.\Developer.vbs"
ECHO Msgbox "Coded By : Shadab Zafar" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "Inspirations :" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "  1. XEN by Paul Brown" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "      Some of the code has been derived from XEN," ^& vbCrlf ^&_ >>"%Temp%.\Developer.vbs"
ECHO "      Some has even been directly copied from it." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "Special Thanks To :" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "  1. Paul Brown for creating XEN." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "  2. Eric Phelps, Bill James, Doug Knox and" ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "      Rob Van Der Woude for their sample scripts." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "  3. www.mvps.org for their superb Hosts File." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Developer.vbs"
ECHO "",64," Shadab Zafar ~ The Developer" >>"%Temp%.\Developer.vbs"

%Temp%.\Developer.vbs
DEL "%Temp%.\Developer.vbs"

:WEBSITE
::Create VBS File To Show A Message
IF EXIST "%Temp%.\GotoWebsite.vbs" DEL "%Temp%.\GotoWebsite.vbs"
ECHO SET WS = CreateObject("WScript.Shell") >>"%Temp%.\GotoWebsite.vbs"
ECHO IF WS.Popup("This Script was downloaded from http://shadabsofts.wordpress.com/" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\GotoWebsite.vbs"
ECHO "There are more useful scripts just a click away." ^& vbcrlf ^& vbcrlf ^& _ >>"%Temp%.\GotoWebsite.vbs"
ECHO " Do you want to visit Shadab Softs. Inc. on the web.",,"Visit Website",4 + 64 + 4096) = 6 Then	>>"%Temp%.\GotoWebsite.vbs"
ECHO WS.Run "http://shadabsofts.wordpress.com/" >>"%Temp%.\GotoWebsite.vbs"
ECHO End IF >>"%Temp%.\GotoWebsite.vbs"

%Temp%.\GotoWebsite.vbs
DEL "%Temp%.\GotoWebsite.vbs"

Goto END

:HELP
::Create VBS File To Show A Message
IF EXIST "%Temp%.\Help.vbs" DEL "%Temp%.\Help.vbs"
ECHO Msgbox ""^& %0 ^&" Version 1.0.3 for Windows XP" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "Usage: " ^& %0 ^& "   [Parameters]   [/Q]" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "Parameters:" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /MRU		[/Q]" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /MSCLEAN	[/Q]" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /ASSOC	[/Q]" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /STARTUP  [ -USER | -ALL ] [/Q]" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /HOSTS  [ -SCAN | -COPY | -BACK | -REST ] [/Q]" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /TROJAN	[/Q]" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /SPYWRAE	[/Q]" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "Other Parameters:" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /VER" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /DEV" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /LIC" ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "     /HELP | /?" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\Help.vbs"
ECHO "Consult the Manual for further help." ^& _ >>"%Temp%.\Help.vbs"
ECHO "",64," Syntax " >>"%Temp%.\Help.vbs"

%Temp%.\Help.vbs
DEL "%Temp%.\Help.vbs"

Goto END

::===============================================================================
::==========================	Error Message Boxes		=========================
::=============================================================================== 

:NoEnv
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\EnvironmentError.vbs" DEL "%Temp%.\EnvironmentError.vbs"
ECHO Msgbox "Some Environment Variables were not found.  " ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\EnvironmentError.vbs"
ECHO "It seems you are not within Windows  ",16," Environment Error " >>"%Temp%.\EnvironmentError.vbs"

%Temp%.\EnvironmentError.vbs
DEL "%Temp%.\EnvironmentError.vbs"

Goto END

:NotXP
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\XPError.vbs" DEL "%Temp%.\XPError.vbs"
ECHO Msgbox "Sorry, " ^& " %UserName% " ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\XPError.vbs"
ECHO "But Heal and Clean Only works on Windows XP." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\XPError.vbs"
ECHO "Press OK to Quit",16," NON XP Error" >>"%Temp%.\XPError.vbs"

%Temp%.\XPError.vbs
DEL "%Temp%.\XPError.vbs"

Goto END

:NoCleanMGR
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\NoCLeanMGR.vbs" DEL "%Temp%.\NoCLeanMGR.vbs"
ECHO Msgbox "Microsoft Cleanup Manager was not found on the system."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoCLeanMGR.vbs"
ECHO "Cleanup cannot continue. Please Reinstall Cleanup Manager.",16," Cleanup Manager Not Found " >>"%Temp%.\NoCLeanMGR.vbs"

%Temp%.\NoCLeanMGR.vbs
DEL "%Temp%.\NoCLeanMGR.vbs"

Goto END

:NoDataFile
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\NoDataFile.vbs" DEL "%Temp%.\NoDataFile.vbs"
ECHO Msgbox "The Data File could not be Found. Make sure it is" ^& vbCrlf ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "in the same directory as BHC." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "It is required for proper functonality of Heal and Clean." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "Please Re-Download Batch Heal and Clean from" ^& vbCrlf ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "code.google.com/p/batch-heal-clean" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "Press OK to Quit." ^& _ >>"%Temp%.\NoDataFile.vbs"
ECHO "",16," Data File NOT Found ! " >>"%Temp%.\NoDataFile.vbs"

%Temp%.\NoDataFile.vbs
DEL "%Temp%.\NoDataFile.vbs"

Goto END

:ExtractFailed
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\ExtractFailed.vbs" DEL "%Temp%.\ExtractFailed.vbs"
ECHO Msgbox "The Data File could not be read." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\ExtractFailed.vbs"
ECHO "It must have been tampered." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\ExtractFailed.vbs"
ECHO "Please Re-Download Batch Heal and Clean from" ^& vbCrlf ^& _ >>"%Temp%.\ExtractFailed.vbs"
ECHO "code.google.com/p/batch-heal-clean" ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\ExtractFailed.vbs"
ECHO "Press OK to Quit." ^& _ >>"%Temp%.\ExtractFailed.vbs"
ECHO "",16," Data File Corrupted ! " >>"%Temp%.\ExtractFailed.vbs"

%Temp%.\ExtractFailed.vbs
DEL "%Temp%.\ExtractFailed.vbs"

Goto END

:NoBackup
COLOR 4F
::Create VBS File To Show Error
IF EXIST "%Temp%.\NoBackup.vbs" DEL "%Temp%.\NoBackup.vbs"
ECHO Msgbox "You have not backed up your " ^& %Type% ^& " using" ^& vbCrlf ^& _ >>"%Temp%.\NoBackup.vbs"
ECHO "Heal and Clean before." ^& vbCrlf ^& vbCrlf ^& _ >>"%Temp%.\NoBackup.vbs"
ECHO "Please Conduct a Backup Before trying to Restore." ^& _ >>"%Temp%.\NoBackup.vbs"
ECHO "",16," No Backup Present of " ^& %Type% >>"%Temp%.\NoBackup.vbs"

%Temp%.\NoBackup.vbs
DEL "%Temp%.\NoBackup.vbs"

Goto END
::===============================================================================
::======================	Misc. Optional Features		=========================
::=============================================================================== 

:MSCLEAN
IF NOT Exist %SYSTEMROOT%\system32\cleanmgr.exe Goto NoCleanMGR
::Deleting This key ensures that Cleanup Manager doesn't Hangs on deleting Compressed Old Files
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Compress old files" /f
CLS
::Use Microsoft Cleanup Manager to perform a Cleanup
%SYSTEMROOT%\system32\cleanmgr.exe /sagerun

IF "%2" == "/Q" Goto END

SET Task="Cleanup Manager has done its job."
Goto MESSAGE

::===============================================================================
::=========================	    HOSTS File Options	   ==========================
::=============================================================================== 

:HOSTS
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"
::Grant Access to Everybody
ECHO,Y|cacls %Hosts% /G everyone:f
CLS
::Remove Hidden or Read-Only Attributes
ATTRIB +A -H -R -S %SYSTEMROOT%\System32\Drivers\Etc\HOSTS*.* >NUL

IF NOT EXIST %Hosts% ( Goto NoHosts ) ELSE ( Goto OpCheck )

:NoHosts
COLOR 5F
::If /Q Parameter is present, We can't speak. Just Do the Job Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto CreateHosts )

IF EXIST "%Temp%.\NoHosts.vbs" DEL "%Temp%.\NoHosts.vbs"
ECHO Msgbox "Hosts File was not found on your system."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoHosts.vbs"
ECHO "It must have been deleted by a virus."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoHosts.vbs"
ECHO "You don't have to worry as it will be created now.",48," Hosts File Not Found " >>"%Temp%.\NoHosts.vbs"

%Temp%.\NoHosts.vbs
DEL "%Temp%.\NoHosts.vbs"

:CreateHosts
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"
::Create a New Hosts File with Default Data
ECHO # This HOSTS file was created By Shadab's Batch Heal and Clean. >> %Hosts%
ECHO # >> %Hosts%
ECHO 127.0.0.1 localhost >> %Hosts%

:OpCheck
IF "%2" == "-SCAN" Goto HOSTSCAN
IF "%2" == "-COPY" Goto HOSTCOPY
IF "%2" == "-BACK" Goto HOSTBACKUP
IF "%2" == "-REST" Goto HOSTRESTORE

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -SCAN       [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -COPY       [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -BACK       [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -REST       [/Q]"^& vbCrlf ^& vbCrlf^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"

Goto END

:HOSTSCAN
::Scan The Hosts File For Non-Malicious Entries
SET Legitimate="www.microsoft.com www.google.com www.yahoo.com www.facebook.com www.twitter.com www.orkut.com"
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"
SET Edited="%SYSTEMROOT%\System32\Drivers\Etc\HOSTSEDIT"

findstr /v %Legitimate% %Hosts% > %Edited%

DEL %Hosts%
REN %Edited% HOSTS

IF "%3" == "/Q" Goto END

SET Task="Non Malicious Entries Removed from the Hosts file."
Goto MESSAGE

:HOSTCOPY
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"
IF EXIST %Hosts%.MVP DEL %Hosts%.MVP >NUL
IF EXIST %Hosts% REN %Hosts% HOSTS.MVP >NUL

::Copy MVPS Hosts File
IF EXIST %SYSTEMROOT%\System32\Drivers\Etc\NUL COPY /Y %Dir%\HOSTS %SYSTEMROOT%\System32\Drivers\Etc >NUL

IF "%3" == "/Q" Goto END

SET Task="MVPS Hosts File Has Been Copied."
Goto MESSAGE

:HOSTBACKUP
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"

IF EXIST %Hosts%.ORIG DEL %Hosts%.ORIG >NUL
COPY %Hosts% %Hosts%.ORIG
CLS

IF "%3" == "/Q" Goto END

SET Task="Hosts File Has Been Backed Up."
Goto MESSAGE

:HOSTRESTORE
SET Hosts="%SYSTEMROOT%\System32\Drivers\Etc\HOSTS"

IF NOT EXIST %Hosts%.ORIG ( 
IF "%3" == "/Q" Goto END
Set Type="Hosts File" 
Goto NoBackup )

IF EXIST %Hosts% DEL %Hosts%
REN %Hosts%.ORIG HOSTS
CLS

IF "%3" == "/Q" Goto END

SET Task="Hosts File Has Been Restored."
Goto MESSAGE

::===============================================================================
::===========================	  Startup Cleanup	   ==========================
::=============================================================================== 
:CLEANSTARTUP
IF "%2" == "-USER" Goto CleanUserStartup
IF "%2" == "-ALL" Goto CleanAllStartup

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -USER      [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -ALL         [/Q]"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"

Goto END

:CleanUserStartup
::Removing Startup entries of the current user from registry
Reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /Va /F
Reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /Va /F
Reg DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /V load /F 2>NUL
Reg DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /V run /F 2>NUL
CLS

::Empty The Startup Folder
IF EXIST "%UserProfile%\Start Menu\Programs\Startup\*.*" DEL /F /Q /A "%UserProfile%\Start Menu\Programs\Startup\*.*" >NUL

IF "%3" == "/Q" Goto END

SET Task="Startup entries of %UserName% have been removed"
Goto MESSAGE

:CleanAllStartup
::Removing Startup entries of the current user from registry
Reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /Va /F
Reg DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" /Va /F
Reg DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /V load /F 2>NUL
Reg DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows" /V run /F 2>NUL
CLS

::Removing other Startup entries from registry
Reg DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" /Va /F
Reg DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" /Va /F
Reg DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx" /Va /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" /Va /F
CLS

::Empty The Startup Folder
IF EXIST "%UserProfile%\Start Menu\Programs\Startup\*.*" DEL /F /Q /A "%UserProfile%\Start Menu\Programs\Startup\*.*" >NUL
IF EXIST "%AllUsersProfile%\Start Menu\Programs\Startup\*.*" DEL /F /Q /A "%AllUsersProfile%\Start Menu\Programs\Startup\*.*" >NUL

IF "%3" == "/Q" Goto END

SET Task="All Startup entries have been removed"
Goto MESSAGE

::===============================================================================
::===========================	  Trojan Cleanup	   ==========================
::=============================================================================== 

:CLEANTROJAN 
::Perform a Basic Security Scan
SET Found=FALSE

::Acid Silver Trojan (uses random names)
IF EXIST "%SYSTEMROOT%\*.tmp" DEL /F /A "%SYSTEMROOT%\*.tmp"
::Back Orifice Trojan
IF EXIST "%SYSTEMROOT%\system32\windll.dll" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\windll.dll" DEL /F /A "%SYSTEMROOT%\system32\windll.dll"> NUL
IF EXIST "%SYSTEMROOT%\system32\exe~1" DEL /F /A "%SYSTEMROOT%\system32\exe~1"> NUL
::Bubbel Trojan
IF EXIST "%SYSTEMROOT%\system32\bubbel.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\bubbel.exe" DEL /F /A "%SYSTEMROOT%\system32\bubbel.exe"> NUL
::Deep Throat Trojan
IF EXIST "%SYSTEMROOT%\systempa.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\systempa.exe" DEL /F /A "%SYSTEMROOT%\systempa.exe"> NUL
IF EXIST "%SYSTEMROOT%\system32\systempa.exe" DEL /F /A "%SYSTEMROOT%\system32\systempa.exe"> NUL
::The Gate Trojan
IF EXIST "%SYSTEMROOT%\port.dat" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\port.dat" DEL /F /A "%SYSTEMROOT%\port.dat"> NUL
IF EXIST "%SYSTEMROOT%\system32\port.dat" DEL /F /A "%SYSTEMROOT%\system32\port.dat"> NUL
::The Girlfriend Trojan
IF EXIST "%SYSTEMROOT%\windll.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\windll.exe" DEL /F /A "%SYSTEMROOT%\windll.exe"> NUL
::Happy Worm Trojan
IF EXIST "%SYSTEMROOT%\system32\ska.*" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\ska.*" DEL /F /A "%SYSTEMROOT%\system32\ska.*"> NUL
IF EXIST "%SYSTEMROOT%\system32\wsock32.ska" DEL /F /A "%SYSTEMROOT%\system32\wsock32.dll"
IF EXIST "%SYSTEMROOT%\system32\wsock32.ska" RENAME "%SYSTEMROOT%\system32\wsock32.ska" "wsock32.dll"> NUL
::Kakworm Trojan
IF EXIST "%SYSTEMROOT%\kak.htm" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\kak.htm" DEL /F /A "%SYSTEMROOT%\kak.htm"
IF EXIST "%SYSTEMROOT%\start menu\programs\kak.htm" DEL /F /A "%SYSTEMROOT%\start menu\programs\kak.htm"
IF EXIST "%USERPROFILE%\start menu\programs\kak.htm" DEL /F /A "%USERPROFILE%\start menu\programs\kak.htm"
IF EXIST "%SYSTEMROOT%\menude~1\programmes\demarrage\kak.htm" DEL /F /A "%SYSTEMROOT%\menude~1\programmes\demarrage\kak.htm"
IF EXIST "%SYSTEMROOT%\system32\*.hta" DEL /F /A "%SYSTEMROOT%\system32\*.hta"
::Kim Trojan
IF EXIST "%SYSTEMROOT%\system32\wsarun.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\wsarun.exe" DEL /F /A "%SYSTEMROOT%\system32\wsarun.exe"> NUL
IF EXIST "%SYSTEMROOT%\system32\vcrond.vxd" DEL /F /A "%SYSTEMROOT%\system32\vcrond.vxd"> NUL
IF EXIST "%SYSTEMROOT%\system32\kim.exe" DEL /F /A "%SYSTEMROOT%\system32\kim.exe"> NUL
::Blaze and Control Trojan
IF EXIST "%SYSTEMROOT%\system32\mschv32.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\mschv32.exe" DEL /F /A "%SYSTEMROOT%\system32\mschv32.exe"> NUL
IF EXIST "%SYSTEMROOT%\system32\mschv.exe" DEL /F /A "%SYSTEMROOT%\system32\mschv.exe"> NUL
::Netbus Trojan
IF EXIST "%SYSTEMROOT%\system32\patch.exe" SET Found="TRUE"
IF EXIST "%SYSTEMDRIVE%\patch.exe" DEL /F /A "%SYSTEMDRIVE%\patch.exe"> NUL
IF EXIST "%SYSTEMROOT%\patch.exe" DEL /F /A "%SYSTEMROOT%\patch.exe"> NUL
IF EXIST "%SYSTEMROOT%\system32\patch.exe" DEL /F /A "%SYSTEMROOT%\system32\patch.exe"> NUL
::Netbus Variants Trojan
IF EXIST "%SYSTEMROOT%\system32\server.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\server.exe" DEL /F /A "%SYSTEMROOT%\system32\server.exe"> NUL
::Netspy Trojan
IF EXIST "%SYSTEMROOT%\system32\system.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\system.exe" DEL /F /A "%SYSTEMROOT%\system32\system.exe"> NUL
::Phineas Trojan
IF EXIST "%SYSTEMROOT%\ppmod1.sys" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\ppmod1.sys" DEL /F /A "%SYSTEMROOT%\ppmod1.sys"> NUL
IF EXIST "%SYSTEMROOT%\ppmod2.sys" DEL /F /A "%SYSTEMROOT%\ppmod2.sys"> NUL
::PrettyPark Trojan
IF EXIST "%SYSTEMROOT%\system32\prettypark.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\prettypark.exe" DEL /F /A "%SYSTEMROOT%\system32\prettypark.exe"> NUL
::Subseven Trojan
IF EXIST "%SYSTEMROOT%\server.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\server.exe" DEL /F /A "%SYSTEMROOT%\server.exe"> NUL
IF EXIST "%SYSTEMROOT%\kernel16.dl" DEL /F /A "%SYSTEMROOT%\kernel16.dl"> NUL
IF EXIST "%SYSTEMROOT%\rundll16.com" DEL /F /A "%SYSTEMROOT%\rundll16.com"> NUL
IF EXIST "%SYSTEMROOT%\systemtrayicon!.exe" DEL /F /A "%SYSTEMROOT%\systemtrayicon!.exe"> NUL
IF EXIST "%SYSTEMROOT%\windos.exe" DEL /F /A "%SYSTEMROOT%\windos.exe"> NUL
::TeleCommando Trojan
IF EXIST "%SYSTEMROOT%\system32\odbc.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\system32\odbc.exe" DEL /F /A "%SYSTEMROOT%\system32\odbc.exe"> NUL
::WinCrash Trojan
IF EXIST "%SYSTEMROOT%\icqfucke.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\icqfucke.exe" DEL /F /A "%SYSTEMROOT%\icqfucke.exe"> NUL
IF EXIST "%SYSTEMROOT%\system32\icqfucke.exe" DEL /F /A "%SYSTEMROOT%\system32\icqfucke.exe"> NUL
::LoveLetter Virus Script
IF EXIST "%SYSTEMROOT%\win-bugsfix.exe" SET Found="TRUE"
IF EXIST "%SYSTEMROOT%\win-bugsfix.exe" DEL /F /A "%SYSTEMROOT%\win-bugsfix.exe"> NUL

IF "%2" == "/Q" Goto END

IF "%Found%" == "TRUE" (
ECHO Msgbox "Trojans were found on your computer " ^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\TrojanFound.vbs"
ECHO "You don't have to panic as Heal and Clean" ^& vbCrlf ^&_ >>"%Temp%.\TrojanFound.vbs"
ECHO "has removed them." ^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\TrojanFound.vbs"
ECHO "I advise you to run a SPYWARE scan too.",48," CAUTION: Trojans Found " >>"%Temp%.\TrojanFound.vbs"
%Temp%.\TrojanFound.vbs
DEL "%Temp%.\TrojanFound.vbs"
Goto END
)

SET Task="Trojan Cleanup Complete."
Goto MESSAGE

::===============================================================================
::=============================		MRU Cleanup		=============================
::=============================================================================== 

:MRUCLEANUP
::Clean All MRUs Using A Registry File
ECHO REGEDIT4> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Doc Find Spec MRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FindComputerMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\OCXStreamMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]>> "%Temp%.\MRUCleanup.reg"
ECHO "PastIconsStream"=->> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]>> "%Temp%.\MRUCleanup.reg"
ECHO "IconStreams"=->> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\PrnPortsMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpaper\MRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer]>> "%Temp%.\MRUCleanup.reg"
ECHO "Download Directory"="">> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\TypedURLs]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ComputerNameMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ContainingTextMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\FilesNamedMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Player\RecentFileList]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Player\RecentURLList]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Radio\MRUList]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MessengerService\PhoneMRU]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Microsoft Management Console\Recent File List]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Search Assistant\ACMru]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Netscape\Netscape Navigator\URL History]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Network\Recent]>> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit]>> "%Temp%.\MRUCleanup.reg"
ECHO "LastKey"=->> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Telnet]>> "%Temp%.\MRUCleanup.reg"
ECHO "Machine1"="">> "%Temp%.\MRUCleanup.reg"
ECHO "LastMachine"="">> "%Temp%.\MRUCleanup.reg"
ECHO.>> "%Temp%.\MRUCleanup.reg"

REGEDIT.EXE /S "%Temp%.\MRUCleanup.reg"
DEL "%Temp%.\MRUCleanup.reg"

IF "%2" == "/Q" Goto END

SET Task="MRU Cleanup Complete."
Goto MESSAGE

::===============================================================================
::==========================	FIX Associations		=========================
::=============================================================================== 

:ASSOC
::Fixing File Associations
assoc.323=h323file 
assoc.386=vxdfile 
assoc.aca=Agent.Character.2
assoc.acf=Agent.Character.2
assoc.acs=Agent.Character2.2
assoc.acw=acwfile
assoc.aif=AIFFFile
assoc.aifc=AIFFFile
assoc.aiff=AIFFFile
assoc.ani=anifile
assoc.asa=aspfile
assoc.asf=ASFFile
assoc.asp=aspfile
assoc.asx=ASXFile
assoc.AudioCD=AudioCD
assoc.avi=avifile
assoc.bat=batfile
assoc.bfc=Briefcase
assoc.bkf=msbackupfile
assoc.blg=PerfFile
assoc.bmp=Paint.Picture
assoc.cab=CLSID\{0CD7A5C0-9F37-11CE-AE65-08002B2E1262}
assoc.cat=CATFile
assoc.cda=CDAFile
assoc.cdf=ChannelFile
assoc.cdx=aspfile
assoc.cer=CERFile
assoc.chk=chkfile
assoc.chm=chm.file
assoc.clp=clpfile
assoc.cmd=cmdfile
assoc.cnf=ConferenceLink
assoc.com=comfile
assoc.cpl=cplfile
assoc.crl=CRLFile
assoc.crt=CERFile
assoc.css=CSSfile
assoc.CTT=MessengerContactList
assoc.cur=curfile
assoc.db=dbfile
CLS
assoc.der=CERFile
assoc.DeskLink=CLSID\{9E56BE61-C50F-11CF-9A2C-00A0C90A90CE}
assoc.dib=Paint.Picture
assoc.dll=dllfile
assoc.doc=WordPad.Document.1
assoc.drv=drvfile
assoc.dsn=MSDASQL
assoc.dun=dunfile
assoc.DVD=DVD
assoc.emf=emffile
assoc.eml=Microsoft Internet Mail Message
assoc.exe=exefile
assoc.fnd=fndfile
assoc.Folder=Folder
assoc.fon=fonfile
assoc.gif=giffile
assoc.grp=MSProgramGroup
assoc.hlp=hlpfile
assoc.ht=htfile
assoc.hta=htafile
assoc.htm=htmlfile
assoc.html=htmlfile
assoc.htt=HTTfile
assoc.icc=icmfile
assoc.icm=icmfile
assoc.ico=icofile
CLS
assoc.iii=iiifile
assoc.inf=inffile
assoc.ini=inifile
assoc.ins=x-internet-signup
assoc.isp=x-internet-signup
assoc.its=ITS File
assoc.IVF=IVFFile
assoc.jfif=pjpegfile
assoc.job=JobObject
assoc.jod=Microsoft.Jet.OLEDB.4.0
assoc.jpe=jpegfile
assoc.jpeg=jpegfile
assoc.jpg=jpegfile
assoc.JS=JSFile
assoc.JSE=JSEFile
assoc.lnk=lnkfile
assoc.log=txtfile
assoc.lwv=LWVFile
assoc.m1v=mpegfile
assoc.m3u=m3ufile
assoc.MAPIMail=CLSID\{9E56BE60-C50F-11CF-9A2C-00A0C90A90CE}
assoc.mht=mhtmlfile
assoc.mhtml=mhtmlfile
assoc.mid=midfile
assoc.midi=midfile
assoc.mmm=MPlayer
CLS
assoc.mp2=mpegfile
assoc.mp2v=mpegfile
assoc.mp3=mp3file
assoc.mpa=mpegfile
assoc.mpe=mpegfile
assoc.mpeg=mpegfile
assoc.mpg=mpegfile
assoc.mpv2=mpegfile
assoc.msc=MSCFile
assoc.msi=Msi.Package
assoc.msp=Msi.Patch
assoc.MsRcIncident=MsRcIncident
assoc.msstyles=msstylesfile
assoc.MSWMM=Windows.Movie.Maker
assoc.mydocs=CLSID\{ECF03A32-103D-11d2-854D-006008059367}
assoc.nfo=MSInfo.Document
assoc.NMW=T126_Whiteboard
assoc.nws=Microsoft Internet News Message
assoc.ocx=ocxfile
assoc.otf=otffile
assoc.p10=P10File
assoc.p12=PFXFile
assoc.p7b=SPCFile
assoc.p7c=certificate_wab_auto_file
assoc.p7m=P7MFile
assoc.p7r=SPCFile
assoc.p7s=P7SFile
assoc.pbk=pbkfile
assoc.pfm=pfmfile
assoc.pfx=PFXFile
assoc.pif=piffile
assoc.pko=PKOFile
assoc.pma=PerfFile
assoc.pmc=PerfFile
assoc.pml=PerfFile
assoc.pmr=PerfFile
assoc.pmw=PerfFile
assoc.pnf=pnffile
assoc.png=pngfile
CLS
assoc.prf=prffile
assoc.psw=PSWFile
assoc.qds=SavedDsQuery
assoc.rat=ratfile
assoc.RDP=RDP.File
assoc.reg=regfile
assoc.rmi=midfile
assoc.rnk=rnkfile
assoc.rtf=rtffile
assoc.scf=SHCmdFile
assoc.scp=txtfile
assoc.scr=scrfile
assoc.sct=scriptletfile
assoc.sdb=appfixfile
assoc.shb=DocShortcut
assoc.shs=ShellScrap
assoc.snd=AUFile
assoc.spc=SPCFile
assoc.spl=ShockwaveFlash.ShockwaveFlash
assoc.sst=CertificateStoreFile
assoc.stl=STLFile
assoc.swf=ShockwaveFlash.ShockwaveFlash
assoc.sys=sysfile
assoc.theme=themefile
assoc.tif=TIFImage.Document
assoc.tiff=TIFImage.Document
assoc.ttc=ttcfile
assoc.ttf=ttffile
assoc.txt=txtfile
assoc.UDL=MSDASC
assoc.uls=ulsfile
assoc.URL=InternetShortcut
assoc.VBE=VBEFile
assoc.vbs=VBSFile
assoc.vcf=vcard_wab_auto_file
assoc.vxd=vxdfile
assoc.wab=wab_auto_file
assoc.wav=soundrec
assoc.wax=WAXFile
assoc.webpnp=webpnpFile
assoc.WHT=Whiteboard
CLS
assoc.wm=ASFFile
assoc.wma=WMAFile
assoc.wmd=WMDFile
assoc.wmf=wmffile
assoc.wmp=WMPFile
assoc.wms=WMSFile
assoc.wmv=WMVFile
assoc.wmx=ASXFile
assoc.wmz=WMZFile
assoc.wri=wrifile
assoc.wsc=scriptletfile
assoc.WSF=WSFFile
assoc.WSH=WSHFile
assoc.wtx=txtfile
assoc.wvx=WVXFile
assoc.xml=xmlfile
assoc.xsl=xslfile
assoc.zap=zapfile
assoc.ZFSendToTarget=CLSID\{888DCA60-FC0A-11CF-8F0F-00C04FD7D062}
assoc.zip=CompressedFolder
CLS

IF "%2" == "/Q" Goto END

SET Task="XP's Default File Associations have been Restored."
Goto MESSAGE

::===============================================================================
::==========================	Cleaning Spywares		=========================
::=============================================================================== 

:CLEANSPY
ECHO REGEDIT4> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Cydoor"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Cydoor"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "NSCheck"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "NSCheck"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Cydoor"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Cydoor"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "CC2KUI"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "CC2KUI"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CLASSES_ROOT\EZulaBoot.InstallCtrl]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CLASSES_ROOT\EZulaBoot.InstallCtrl.1]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CLASSES_ROOT\EZulaBootExe.InstallCtrl]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CLASSES_ROOT\EZulaBootExe.InstallCtrl.1]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\CLASSES\AppID\eZulaBootExe.EXE]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\CLASSES\AppID\{C0335198-6755-11D4-8A73-0050DA2EE1BE}]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\CLASSES\TypeLib\{3D7247D1-5DB8-11D4-8A72-0050DA2EE1BE}]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\CLASSES\TypeLib\{C0335197-6755-11D4-8A73-0050DA2EE1BE}]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Microsoft\Code Store Database\Distribution Units\{3D7247DE-5DB8-11D4-8A72-0050DA2EE1BE}]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\ModuleUsage\ C:/WINDOWS/Downloaded Program Files/eZulaBoot.dll]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Gator"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Gator"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "New.net Startup"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "New.net Startup"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "NewsUpd.exe"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "NewsUpd.exe"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run]>> "%Temp%.\SpywareCleanup.reg"
ECHO "webHancer Agent"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run-]>> "%Temp%.\SpywareCleanup.reg"
ECHO "webHancer Agent"=->> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Cydoor]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Cydoor Services]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Aureate]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\Aureate]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_CURRENT_USER\Software\TimeSink]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Comet Systems]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Gator.com]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\New.Net]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Onflow]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Removing Hotbar
ECHO [-HKEY_CURRENT_USER\Software\Hotbar]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_USERS\.DEFAULT\Software\Hotbar]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Hotbar]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\Toolbar\B195B3B3-8A05-11D3-97A4-0004ACA6948E]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [-HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Internet Settings\User Agent\Post Platform\Hotbar 3.0]>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"

:: Blocking Spyware and Adware from being run in IE by blocking kill bit

:: Preventing 7FaSSt Malware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{06dfedaa-6196-11d5-bfc8-00508b4a487d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{669695bc-a811-4a9d-8cdf-ba8c795f261e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing 7FaSSt 2 Malware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{b8875bfe-b021-11d4-bfa8-00508b8e9bd3}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing AccessPlugin from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d8efadf1-9009-11d6-8c73-608c5dc19089}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing ACX Install Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a4a435cf-3583-11d4-91bd-0048546a1450}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing AdBreak Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000012-890e-4aac-afd9-eff6954a34dd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000000-d9e3-4bc6-a0bd-3d0ca4be5271}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Adult Content Dialer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a45f39dc-3608-4237-8f0e-139f1bc49464}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8522f9b3-38c5-4aa4-ae40-7401f1bbc898}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Adult Links Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{765e6b09-6832-4738-bdbe-25f226ba2ab0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5c015aa7-3392-4044-90cc-8e95019cfff1}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Aornum Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{910e7499-6311-4843-8eb0-0100a7955a1f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{70522fa2-4656-11d5-b0e9-0050dac24e8f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{9c813b33-52a2-466d-8c51-eb4189c1ff98}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing ASpam Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{657b9354-bb3b-4500-a9b0-109b4fa64815}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{499db658-1909-420b-931a-4a8caefd232f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Aureate/Radiate Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ebbfe27c-bdf0-11d2-bbe5-00609419f467}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing BandObjs 1001.dll Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8786386e-4b22-11d6-9c60-e5da06d87378}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Bargain Buddy Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ce31a1f7-3d90-4874-8fbe-a5d97f8bc8f1}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{72f81209-6c73-4de7-a3dc-408a8bd472fb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Bargain Buddy 2 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{9dbafccf-592f-ffff-ffff-00608cec297b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Belcomm Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e44151c8-0c6c-4a7d-b677-4fcc9552e957}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing BonziBuddy Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a28c2a31-3ab0-4118-922f-f6b3184f5495}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{bd11a280-2e73-11cf-b6cf-00aa00a74daf}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Brilliant Digital Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{51958169-d5e3-11d1-aa42-0000e842e40a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Browser Toolbar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{868b015f-3515-44db-b0ad-182cd058985e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Browser Wise Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a27cfcae-9351-4d74-bffc-21eb19693d8c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Bulla Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{3e8a1971-45a5-45ee-828b-8c78431c0bd4}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Cash Toolbar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{f20ae630-6de2-43ca-a988-7cd40c36ef0b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Click The Button Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ab4dd0f0-38da-4f48-aafe-7de7323bb6b2}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing CnsMin Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{b83fc273-3522-4cc6-92ec-75cc86678da4}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing CometCursor Plugin from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d14d6793-9b65-11d3-80b6-00500487bdba}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1678f7e1-c422-11d0-ad7d-00400515caaa}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing CometCursor Shop Plugin from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{268cba84-25ae-4d38-89fe-e7606a6460e3}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Comload Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ad7fafb0-16d6-40c3-af27-585d6e6453fd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Commonname Toolbar from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1e1b2879-88ff-11d2-8d96-d7acac95951f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a6475e6b-3c2e-4b1f-82fd-8f1c0b1d8ad0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{6656b666-992f-4d74-8588-8ca69e97d90c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing CrackedEarth Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{f08555b0-9cc3-11d2-aa8e-000000000000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing CyberSearch Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{cce83e45-30b2-4bae-b1f5-25d128d27a43}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Cytron Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{3750bfa3-1392-4af3-af86-9d2d4776e5a4}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing DeltaClick Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0fc817c2-3b45-11d4-8340-0050da825906}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Daily Winner Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{7dd896a9-7aeb-430f-955b-cd125604fdcb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Dialer Offline Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ceb29da4-7afa-4f24-b3cd-17351d590df0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Dialers from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{da9a0b1e-9b7b-11d3-b8a4-00c04f79641c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e8edb60c-951e-4130-93dc-faf1ad25f8e7}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{da9a0b1e-9b7b-11d3-b8a4-00c04f79641c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d53b810f-6219-11d4-95b6-0040950375e7}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000000-8633-1405-0B53-2C8830E9FAEC}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Divago Surfairy Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e0b9b5fe-b66e-4fb0-a1d9-726f0e743cfd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Download Receiver Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8869786c-8e72-45dc-911d-ab3416ac1df1}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing DownloadWare Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{eb6afdab-e16d-430b-a5ee-0408a12289dc}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing eAcceleration StopSign Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{6acd11bd-4ca0-4283-a8d8-872b9ba289b6}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing eBoom Search Bar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c4d99500-4c77-11d4-93b7-0040950570ba}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing EComm Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ab1e62eb-3de3-428f-a417-64ab3c9b6cf0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing eXactSearch Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{f9765480-72d1-11d4-a75a-004f49045a87}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing EZSearchBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{760a9dde-1433-4a7c-8189-d6735bb5d3dd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing EZCyberSearch / EZSearchBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{B8AB2281-447F-482B-86E9-1F0ED5973637}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing ezula adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{3d7247e8-5db8-11d4-8a72-0050da2ee1be}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{58359010-bf36-11d3-99a2-0050da2ee1be}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing f1.dll adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000ef1-34e3-4633-87c6-1aa7a44296da}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing FavoriteMan Plugin from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000ef1-34e3-4633-87c6-1aa7a44296da}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{139d88e5-c372-469d-b4c5-1fe00852ab9b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing FlashTrack Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{665acd90-4541-4836-9fe4-062386bb8f05}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing FlySwat Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{82b98006-7a56-11d2-a26f-00c04f962769}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing FreeScratchAndWin Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{99b0b113-6f25-49c9-8ecf-2fddd3edff6a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{20a03a4c-9faf-45d5-a5c2-b6c49774e03c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5dd7b3be-fdec-4563-b038-ff80f2345b89}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing FriendGreeting Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{7011471d-3f74-498e-88e1-c0491200312d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Gator Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{731918d2-517a-47e2-886a-3bc1380c591d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a9ef28a2-55d1-480b-a403-84928d59f556}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{4006e7b2-0fb2-4345-b388-083b138e80af}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Gator ActiveX Installer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{29eeff42-f3fa-11d5-a9d5-00500413153c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing GoHip Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{f17edbc0-3eb2-11d3-ab74-00a0c9a522f2}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Gigext SpeedDelivery Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a7798d6c-c6b5-4f26-9363-f7cdbbffa607}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Gozilla dll Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{cd4c3cf0-4b15-11d1-abed-709549c10000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Gratisware Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5843a29e-1246-11d4-ba8c-0050da707acd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing HighTraffic Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{53e10c2c-43b2-4657-ba29-aae179e7d35c}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Hotbar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{b195b3b3-8a05-11d3-97a4-0004aca6948e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Hotbar 2 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{69fd62b1-0216-4c31-8d55-840ed86b7c8f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing HotSex Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{018b7ec3-eeca-11d3-8e71-0000e82c6c0d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing HuntBar Plugin from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{59450db0-341d-4436-b380-b8377d8b6796}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0a68c5a2-64ae-4415-88a2-6542304a4745}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d6e66235-7aa6-44ed-a06c-6f2033b1d993}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8a05273a-2ea5-42de-aa75-59ea7d9d50d7}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a6250fb8-2206-499e-a7aa-e1ec437e71c0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IEAccess Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1d2dca0d-b30f-40ad-9690-087105f214ec}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IEPlugin Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{914afb33-550b-4bd0-b4ef-8da185504836}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IEPlugin 2 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{556dde35-e955-11d0-a707-000000521958}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IGN Keywords Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{730f2451-a3fe-4a72-938c-fc8a74f15978}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IGN Keywords 2 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{676058e4-89bd-11d6-8a8c-0050ba8452c0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing ILookup/Ineb Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{61d029ac-972b-49fe-a155-962dfa0a37bb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8e4c16f3-45c8-4b24-99e6-f55082b7c4f1}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing ILookup/Chgrgs Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c82b55f0-60e0-478c-bc55-e4e22f11301d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{35cc7369-c6eb-4a64-ab05-44cf0b5087a0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing InetSpeak Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d6862a22-1dd6-11d3-bb7c-444553540000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{2e12b523-3d4c-4fac-9b04-0376a8f5e879}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a76066c9-941b-4209-9d96-0ac80501100d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c389f2cf-26ed-11d5-a212-004005f6feb6}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{388d7ebb-cbb9-4126-8db2-86dc6863a206}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{bc0d2038-2de5-4a6f-92bc-b18a3e0de32a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{39af31dd-eafc-45ea-a56c-385b52e25cc0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Interfun Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{15c3c7a4-9676-11d3-9799-0060087190b9}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing IPInsight Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{000004cc-e4ff-4f2c-bc30-dbef0b983bc9}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing JimmySearch Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{5998b08e-cfac-11d5-822a-0050048e6e38}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Lop.com Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d44b5436-b3e4-4595-b0e9-106690e70a58}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Lop.com Variant Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8522f9b3-38c5-4aa4-ae40-7401f1bbc851}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0d4312e2-5e4d-4a27-a9d8-043e43904277}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{189210a0-36c2-11d7-9928-444553540000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{9b35a850-66ab-4c6d-8a66-136ecadcd904}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{bcd5534b-2f54-428e-b3f3-e03b6f10a233}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{eb9bdd24-ccf1-4a87-98c0-579dba9bda83}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Lop.com, Central24, MoneyTree Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000012-890e-4aac-afd9-000000000000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing MarketScore Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{b2c03e2e-2219-4ff9-810a-540aca63f8d9}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing MasterDialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e9c87343-0e63-4aca-9b76-b155333ee67a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{788a7678-38d7-4eec-9d20-67a86d21a7fd}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Medialoads Enhanced Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{85a702ba-ea8f-4b83-aa07-07a5186acd7e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Meridian Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{fa79fa22-8db3-43d1-997b-6dbfd8845569}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing MySearch Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{014da6c9-189f-421a-88cd-07cfe51cff10}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{58f0b492-a42e-435a-bcbf-c6b2608077ba}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Netpal Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{fc327b3f-377b-4cb7-8b61-27cd69816bc3}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c7ade150-743d-11d4-8141-00e029626f6a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{6085fb5b-c281-4b9c-8e5d-d2792ea30d2f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing NetSource101 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{15589fa1-c456-11ce-bf01-00aa0055595a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing New.Net Malware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{dd770a75-ce18-11d5-98d8-00e018981b9e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{dd521a1d-1f98-11d4-9676-00e018981b9e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Network Essentials Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d5c778f1-cf13-4e70-adf0-45a953e7cb8b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing NewDotNet Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{4a2aacf3-adf6-11d5-98a9-00e018981b9e}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e9407738-a996-421a-a309-5c93c699e10a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Newton Knows Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ee392a64-f30b-47c8-a363-cda1cec7dc1b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing NowBox Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a0bd4ff5-d828-11d3-9eb5-00600837e6ee}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing OOd Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ffff0001-0002-101a-a3c9-08002b2f49fb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Onflow Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0cef79d8-d373-11d3-a7d3-00062962bf17}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Online Dialer/MA Connect from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{02c20140-76f8-4763-83d5-b660107b7a90}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Online Dialer/VLoading Variant from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{11bf0e2b-4229-4adc-9c11-1c6968731018}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing PerMedia Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a47693d1-7e2a-4de3-9907-310c5d310b5f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing PerMedia C Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8cdc6a46-08ab-435b-a3fa-7cc00e74ec9f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing PerMedia D Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{36372a5f-1436-4a70-b808-59f6dfd36658}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing PluginAccess from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a1dc3241-b122-195f-b21a-000000000000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing PopUp Network from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d0b0c04a-dc73-4a91-9307-41f3e36579bf}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing QCBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d6fc35d1-04ab-4d40-94cf-2e5ae4d0f8d2}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing RapidBlaster Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{f0aa2376-f073-4e57-86e8-0238f99087c7}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SaveNow Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{fee7fd53-3356-4d4d-8978-2c4ae3a7e109}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SearchAndBrowse Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ec788b03-a743-4274-ac9e-db4f2a03f515}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Search Explorer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{23ddae8c-6a79-4d62-80aa-e95d89cb9811}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{3717df55-0396-463d-98b7-647c7dc6898a}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1a98bca2-0bd1-47de-9710-c7665f7f1fcb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{a116a5c1-ad77-446c-992a-f56200b112db}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SearchITBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{6c413541-29a1-4ffe-894c-9d68313c9f73}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SearchSquire Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{11990e9f-2a4d-11d6-9507-02608cdd2842}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{907ca0e5-ce84-11d6-9508-02608cdd2842}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SideStep Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0835121f-6472-43bd-8a40-d9221ff1c4ce}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0837121a-6472-43bd-8a40-d9221ff1c4ce}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SMS Dialer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{bd11a280-2e73-11cf-b6cf-00aa00a74dae}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SpotOnBH Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{001dae60-95c0-11d3-924e-009027950886}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Strip Player Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e3f7205f-2ae0-4bf0-816b-2d24a5f20ec7}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Star Dialer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{e0b795b4-fd95-4abd-a375-27962efce8cf}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SubSearch Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{77f1268b-6c19-4c61-962d-54691a128cd2}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{4c4871fd-30f6-4430-8834-bc75d58f1529}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SunInfo Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{91df007c-2f7f-4731-be1f-38c1c13ceb8b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SuperBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c776136e-fdb9-4f4b-837d-90593fb5a3fa}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SurfMonkey Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0000001d-ba9b-11d2-bdf1-0090272a6d78}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing SVAPlayer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1e6f1d6a-1f20-11d4-8859-00a0cce26836}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Tellafriend Trojan from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{72a58725-2635-4725-8c53-676dfd1feb8d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing TinyBar Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{69550be2-9a78-11d2-ba91-00600827878d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{69555be2-9a78-11d2-ba91-00600827878d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing TopMoxie Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{05ce4481-8015-11d3-9811-c4da9f000000}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing TPS108 Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{50a28604-52f2-11d6-8f0f-5254ab11d5c2}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Transponder Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{0000026A-8230-4DD4-BE4F-6889D1E74167}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{1000026a-8230-4dd4-be4f-6889d1e74167}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Transponder / MSView Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000580-c637-11d5-831c-00105ad6acf0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing UCMore Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{53cbee82-d747-11d3-9ed0-005004189684}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{ed8db0fd-d8f4-4b2c-bb5b-9ef040fe104d}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing VX2 Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{00000000-5eb9-11d5-9d45-009027c14662}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing VX2 Transponder / NetPal Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{11111111-1111-1111-1111-111111111111}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing WazAm Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{b5e60a66-0c51-4894-8df8-cbdf4e478d58}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing WebHancer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{c900b400-cdfe-11d3-976a-00e02913a9e0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing WebInstall Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{8699d723-6dc6-47d3-b55c-489ba006b917}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Wonderland Dialer from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{efcf25f1-c8f9-4c53-a03d-68d5c19225d0}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing WurldMedia Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{40ac4d2d-491d-11d4-aaf2-0008c75dcd2b}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{d14641fa-445b-448e-9994-209f7af15641}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing X Dialer Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{69a4f9ff-e915-11d5-a9f1-009099104002}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{9e7138ee-4e7b-11d5-94ef-006008a4ed7f}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Xupiter Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{57e69d5a-6539-4d7d-9637-775de8a385b4}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{2662bdd7-05d6-408f-b241-ff98face6054}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
:: Preventing Xupiter Variant Adware from running
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{3c5ba506-6c30-4738-9ced-797acadea8dc}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"
ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer\ActiveX Compatibility\{6e6dd93e-1fc3-4f43-8afb-1b7b90c9d3eb}]>> "%Temp%.\SpywareCleanup.reg"
ECHO "Compatibility Flags"=dword:00000400>> "%Temp%.\SpywareCleanup.reg"
ECHO.>> "%Temp%.\SpywareCleanup.reg"

REGEDIT.EXE /S "%Temp%.\SpywareCleanup.reg"
DEL "%Temp%.\SpywareCleanup.reg"

IF "%2" == "/Q" Goto END

SET Task="Spyware Cleanup Complete."
Goto MESSAGE
