::	Batch Heal & Clean v1.0.3
::  Written By - Shadab Zafar 10 December, 2010
::	http://shadabsofts.wordpress.com/
::	Check for updates at :- code.google.com/p/batch-heal-clean

::  Major inspiration - XEN by Paul Brown


@ ECHO OFF

Title Batch Heal and Clean

::------------------------------------------------------ Scanning IF OS is XP or NOT
:: WHY?????????			I am an XP fanboy... :)
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

::-------------------------------------------- Setting Up Needed Environment Variables
::Controls /Q Option
SET Quiet=FALSE

::The Basic Task
SET Task="Basic Cleanup, DONE !"
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

::------------------------------------------------------- Data File Extraction Routine
:DATAFILE
SET Dat="Data.dll"
SET TempDir="%Temp%\BHCTemp"
IF NOT EXIST %Dat% Goto NoDataFile
IF NOT EXIST "%TempDir%" MD "%TempDir%" >NUL
CLS
::Extract Files
Expand.exe %Dat% -f:* %TempDir% >NUL
CLS

::Expand Files
::FOR %%a IN (%TempDir%\*.*) DO ( Expand.exe -r %%a )

::Confirm that files have been successfully extracted
IF NOT EXIST %TempDir%\HOSTS Goto ExtractFailed

::Copy files that will be needed to the system
IF NOT EXIST %WinDir%\System32\7z.exe COPY %TempDir%\7z.exe %WinDir%\System32
IF NOT EXIST %WinDir%\System32\Nircmd.exe COPY %TempDir%\Nircmd.exe %WinDir%\System32
CLS
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

IF "%1" == "/TEST" Goto SERVOPT

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
IF "%1" == "/MRU" Goto MRU
IF "%1" == "/STARTUP" Goto CLEANSTARTUP

::Healing Features
IF "%1" == "/ASSOC" Goto ASSOC
IF "%1" == "/HOSTS" Goto HOSTS
IF "%1" == "/TROJAN" Goto CLEANTROJAN
IF "%1" == "/SPYWARE" Goto CLEANSPY

::------------------------------------------------------ Repair Damage Done by Viruses
::Remove Almost All Restrictions
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /F
REG DELETE "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /F
::EnableCMD
REG DELETE "HKCU\Software\Policies\Microsoft\Windows\System" /F
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /t Reg_dword /v DisableCMD /f /d 0
::Remove UnReadMail
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\UnreadMail" /t Reg_dword /v MessageExpiryDays /f /d 0
::Enable System Restore
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /t Reg_dword /v DisableConfig /f /d 0
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /t Reg_dword /v DisableSR /f /d 0
::Enable Windows Installer
REG ADD "HKLM\Software\Policies\Microsoft\Windows\Installer" /t Reg_dword /v DisableMSI /f /d 0
::Allow WriteToUSB
REG DELETE "HKLM\System\CurrentControlSet\Control\StorageDevicePolicies" /F
::Enable All Control Panel's Applets
REG DELETE "HKCU\Control Panel\don't load" /F
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\don't load" /F
::Enable Task Manager
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "DisableCAD" /F
REG DELETE "HKCU\Software\Microsoft\Windows NT\CurrentVersion\TaskManager" /F
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /V "DisableTaskMgr" /F
::Enable New Context Menu
REG ADD "HKCR\TempDirectory\Background\shellex\ContextMenuHandlers\New" /Ve /T REG_SZ /D "{D969A300-E7FF-11d0-A93B-00A0C90F2719}" /F
::Enable Send To Context Menu
REG ADD "HKCR\AllFilesystemObjects\shellex\ContextMenuHandlers\Send To" /Ve /T REG_SZ /D "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" /F
::Fix Opening Of Search When Folder Is Double Clicked
REG ADD "HKCR\TempDirectory\shell" /Ve /T REG_SZ /D "none" /F
REG ADD "HKCR\Drive\shell" /Ve /T REG_SZ /D "none" /F
::Set Explorer As Default Shell
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /V "Shell" /T REG_SZ /D "Explorer.exe" /F
::Fixes any changes in UserInit Logon Key
REG ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Userinit /f /d "%windir%\system32\userinit.exe",
::Disable Autorun Feature
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\IniFileMapping\Autorun.inf" /Ve /T REG_SZ /D "@SYS:DoesNotExist" /F
::Donot Show Hidden files and folders but unhide the "Protect Operating System Files"
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v Hidden /f /d 00000002
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v ShowSuperHidden /f /d 00000001
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /t Reg_dword /v SuperHidden /f /d 00000000
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN" /t Reg_dword /v CheckedValue /f /d 00000002
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\NOHIDDEN" /t Reg_dword /v DefaultValue /f /d 00000002
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL" /t Reg_dword /v CheckedValue /f /d 00000001
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL" /t Reg_dword /v DefaultValue /f /d 00000002
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v CheckedValue /f /d 00000000
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v DefaultValue /f /d 00000000
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\SuperHidden" /t Reg_dword /v UncheckedValue /f /d 00000001
CLS
:: -----------------------------~~~~~~~~~~~~~~~~~~~~~~~-------------------------------

REM ---------------------------------------------------------------------------------------------- TEMP CLEANING
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
::Cleaning icon cache, saving some resources on restart.
IF EXIST "%USERPROFILE%\locals~1\applic~1\IconCache.db" DEL /F /A "%USERPROFILE%\locals~1\applic~1\IconCache.db"
::Cleaning offline web pages.
IF EXIST "%SYSTEMROOT%\offline web pages" DEL /F /Q /A "%SYSTEMROOT%\offline web pages\*.*"> NUL
::Cleaning MS Office recent files.
IF EXIST "%SYSTEMROOT%\applic~1\microsoft\office\recent" DEL /F /Q /A "%SYSTEMROOT%\applic~1\microsoft\office\recent\*.*"> NUL
CLS
REM ------------------------------------------------------------------------------------------ END TEMP CLEANING

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

::-----------------------------  Execution ENDs Here  ---------------------------
:END
CLS
RD /S /Q "%TempDir%"
EXIT
::---------------------------~~~~~~~~~~~~~~~~~~~~~~------------------------------

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
::===========================	  System Cleanup	   ==========================
::=============================================================================== 
:SYSTEMCLEANUP
::Cleaning connection wizard
IF EXIST "%SYSTEMROOT%\connection wizard" RD /S /Q "%SYSTEMROOT%\connection wizard"> nul
::Cleaning Document templates
IF EXIST "%USERPROFILE%\templates" DEL /F /Q /A "%USERPROFILE%\templates\*.*"> nul
::Cleaning Document templates from default user profile
IF EXIST "%SYSTEMDRIVE%\docume~1\defaul~1\templates" RD /S /Q "%SYSTEMDRIVE%\docume~1\defaul~1\templates"> nul
::Cleaning temporary download information
IF EXIST "%SYSTEMROOT%\msdownld.tmp" DEL /F /Q /A "%SYSTEMROOT%\msdownld.tmp\*.*"> nul
IF EXIST "%SYSTEMROOT%\msdownld" DEL /F /Q /A "%SYSTEMROOT%\msdownld\*.*"> nul
::Cleaning Internet Explorer Uninstall Information
IF EXIST "%PROGRAMFILES%\Uninstall Information" RD /S /Q "%PROGRAMFILES%\uninstall information"> nul
IF EXIST "%PROGRAMFILES%\Internet Explorer\uninst~1" RD /S /Q "%PROGRAMFILES%\internet explorer\uninstall information"> nul
::Cleaning Internet Services
IF EXIST "%PROGRAMFILES%\common files\services" RD /S /Q "%PROGRAMFILES%\common files\services"> nul
::Cleaning WBEM logs
IF EXIST "%SYSTEMROOT%\system32\wbem\logs" DEL /F /Q /A "%SYSTEMROOT%\system32\wbem\logs\*.*"> nul
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

::Empty the Recycle Bin if asked by the user
IF "%2" == "-BIN" Nircmd.exe emptybin

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

SET Task="All System Junk has been removed."
Goto MESSAGE

::===============================================================================
::=========================		MRU Cleanup	Options		=========================
::=============================================================================== 
:MRU
IF "%2" == "-WIN" Goto WINMRUCLEAN
IF "%2" == "-PROG" Goto PROGMRUCLEAN

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -WIN        [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -PROG       [/Q]"^& vbCrlf ^& vbCrlf^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"
Goto END

:WINMRUCLEAN
::Clean All MRUs Using A Registry File
> "%Temp%.\MRUCleanup.reg" ECHO REGEDIT4
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Doc Find Spec MRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FindComputerMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\OCXStreamMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]
>>"%Temp%.\MRUCleanup.reg" ECHO "PastIconsStream"=-
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify]
>>"%Temp%.\MRUCleanup.reg" ECHO "IconStreams"=-
>>"%Temp%.\MRUCleanup.reg" ECHO.
::>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU]
::>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\PrnPortsMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpaper\MRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Wordpad\Recent File List]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer]
>>"%Temp%.\MRUCleanup.reg" ECHO "Download TempDirectory"=""
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\TypedURLs]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ComputerNameMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\ContainingTextMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Explorer Bars\{C4EE31F3-4768-11D2-BE5C-00A0C9A83DA1}\FilesNamedMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Player\RecentFileList]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Player\RecentURLList]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Radio\MRUList]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\MessengerService\PhoneMRU]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Microsoft Management Console\Recent File List]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Microsoft\Search Assistant\ACMru]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Software\Netscape\Netscape Navigator\URL History]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [-HKEY_CURRENT_USER\Network\Recent]
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit]
>>"%Temp%.\MRUCleanup.reg" ECHO "LastKey"=-
>>"%Temp%.\MRUCleanup.reg" ECHO.
>>"%Temp%.\MRUCleanup.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Telnet]
>>"%Temp%.\MRUCleanup.reg" ECHO "Machine1"=""
>>"%Temp%.\MRUCleanup.reg" ECHO "LastMachine"=""
>>"%Temp%.\MRUCleanup.reg" ECHO.

REGEDIT.EXE /S "%Temp%.\MRUCleanup.reg"
DEL "%Temp%.\MRUCleanup.reg"

IF "%2" == "/Q" Goto END

SET Task="Windows MRU Cleanup Complete."
Goto MESSAGE

:PROGMRUCLEANUP


IF "%2" == "/Q" Goto END

SET Task="Program MRU Cleanup Complete."
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
IF EXIST %SYSTEMROOT%\System32\Drivers\Etc\NUL COPY /Y %TempDir%\HOSTS %SYSTEMROOT%\System32\Drivers\Etc >NUL

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
::=============================		Fix Options		=============================
::=============================================================================== 
:FIX
IF "%2" == "-ENV" Goto FIXENV

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -ENV        [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"
Goto END

:FIXENV
::Repair any corrupt environment variable
> "%Temp%.\FixEnv.reg" ECHO Windows Registry Editor Version 5.00
>>"%Temp%.\FixEnv.reg" ECHO.
>>"%Temp%.\FixEnv.reg" ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment]
>>"%Temp%.\FixEnv.reg" ECHO "ComSpec"=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,\
>>"%Temp%.\FixEnv.reg" ECHO   74,00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,63,\
>>"%Temp%.\FixEnv.reg" ECHO   00,6d,00,64,00,2e,00,65,00,78,00,65,00,00,00
>>"%Temp%.\FixEnv.reg" ECHO "Path"=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
>>"%Temp%.\FixEnv.reg" ECHO   00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,3b,00,25,00,\
>>"%Temp%.\FixEnv.reg" ECHO   53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,3b,00,25,\
>>"%Temp%.\FixEnv.reg" ECHO   00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,00,5c,00,\
>>"%Temp%.\FixEnv.reg" ECHO   53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,57,00,62,00,65,00,6d,\
>>"%Temp%.\FixEnv.reg" ECHO   00,00,00
>>"%Temp%.\FixEnv.reg" ECHO "windir"=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
>>"%Temp%.\FixEnv.reg" ECHO   00,25,00,00,00
>>"%Temp%.\FixEnv.reg" ECHO "PATHEXT"=".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH"
>>"%Temp%.\FixEnv.reg" ECHO "TEMP"=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
>>"%Temp%.\FixEnv.reg" ECHO   00,25,00,5c,00,54,00,45,00,4d,00,50,00,00,00
>>"%Temp%.\FixEnv.reg" ECHO "TMP"=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,\
>>"%Temp%.\FixEnv.reg" ECHO   25,00,5c,00,54,00,45,00,4d,00,50,00,00,00
>>"%Temp%.\FixEnv.reg" ECHO.

REGEDIT.EXE /S "%Temp%.\FixEnv.reg"
DEL "%Temp%.\FixEnv.reg"

IF "%3" == "/Q" Goto END

SET Task="Environment Variables have been fixed."
Goto MESSAGE


::===============================================================================
::==========================	Services Options		=========================
::=============================================================================== 
:SERVICES
IF "%2" == "-OPT" Goto SERVOPT
IF "%2" == "-BACK" Goto SERVBACKUP
IF "%2" == "-REST" Goto SERVRESTORE

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -OPT        [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -BACK       [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -REST       [/Q]"^& vbCrlf ^& vbCrlf^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"
Goto END

:SERVOPT
IF NOT EXIST "%WINDIR%\Backup\Registry" MD "%WINDIR%\Backup\Registry"
::Create a BeforeOptimisation Backup file (it would be used if anything goes wrong)
IF EXIST "%WINDIR%\Backup\Registry\Services.BOPT" DEL /F /Q "%WINDIR%\Backup\Registry\Services.BOPT" >NUL
IF NOT EXIST "%WINDIR%\Backup\Registry\Services.bak" REGEDIT.EXE /E "%WINDIR%\Backup\Registry\Services.bak" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"
7z a "%WINDIR%\Backup\Registry\Services.BOPT" "%WINDIR%\Backup\Registry\Services.bak"
DEL /F /Q "%WINDIR%\Backup\Registry\Services.bak" >NUL

::Load External Module	--	Optimize Services
::ECHO CreateObject("Wscript.Shell").Run """" ^& "%Temp%\BHCTemp\ServOpt.bat" ^& """", 0, False > "%Temp%.\InvisibleServOpt.vbs"

::%Temp%.\InvisibleServOpt.vbs
::DEL "%Temp%.\InvisibleServOpt.vbs"

IF "%3" == "/Q" Goto END
SET Task="Services Have Been Optimized."
Goto MESSAGE

:SERVBACKUP
IF NOT EXIST "%WINDIR%\Backup\Registry" MD "%WINDIR%\Backup\Registry"
IF EXIST "%WINDIR%\Backup\Registry\Services.reg" DEL "%WINDIR%\Backup\Registry\Services.reg"

REGEDIT.EXE /E "%WINDIR%\Backup\Registry\Services.reg" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"

7z a "%WINDIR%\Backup\Registry\Services.7z" "%WINDIR%\Backup\Registry\Services.reg"

DEL /F /Q "%WINDIR%\Backup\Registry\Services.reg" >NUL

IF "%3" == "/Q" Goto END
SET Task="Your Services Have Been Backed Up."
Goto MESSAGE

:SERVREST
IF NOT EXIST "%WINDIR%\Backup\Services.7z" ( 
If "%3" == "/Q" Goto END
Set Type="Services" 
Goto NoBackup )

7z x -o"%WINDIR%\Backup\Registry" "%WINDIR%\Backup\Registry\Services.7z" 

REGEDIT.EXE /S "%WINDIR%\Backup\Registry\Services.reg"

DEL /F /Q "%WINDIR%\Backup\Registry\Services.reg" >NUL

IF "%3" == "/Q" Goto END
SET Task="Your Services Have Been Restored."
Goto MESSAGE

::===============================================================================
::=======================	File Associations Options	=========================
::=============================================================================== 
:ASSOC
::Fixing File Associations
IF "%2" == "-DEF" Goto ASSOCDEF
IF "%2" == "-BACK" Goto ASSOCBACKUP
IF "%2" == "-REST" Goto ASSOCESTORE

::If /Q Parameter is present, We can't speak. Just Exit Silently.
For %%a In ( %2 %3 ) Do ( If "%%a"=="/Q" Goto END )

ECHO Msgbox "No Secondary Option has been specified."^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Possible Secondary Arguements Are:-"^& vbCrlf ^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -DEF        [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -BACK       [/Q]"^& vbCrlf ^&_ >>"%Temp%.\NoOption.vbs"
ECHO "      -REST       [/Q]"^& vbCrlf ^& vbCrlf^&_ >>"%Temp%.\NoOption.vbs"
ECHO "Consult the BHC Manual for further Help.",64," What to Do? " >>"%Temp%.\NoOption.vbs"

%Temp%.\NoOption.vbs
DEL "%Temp%.\NoOption.vbs"
Goto END

:ASSOCDEF
::Load External Module	--	Restore XPs DefaultFile Associations
ECHO CreateObject("Wscript.Shell").Run """" ^& "%Temp%\BHCTemp\DefFileAssoc.bat" ^& """", 0, False > "%Temp%.\InvisibleDefFileAssoc.vbs"

%Temp%.\InvisibleDefFileAssoc.vbs
DEL "%Temp%.\InvisibleDefFileAssoc.vbs"

IF "%3" == "/Q" Goto END

SET Task="XP's Default File Associations Have Been Restored."
Goto MESSAGE

:ASSOCBACK
::Backup current file associations
IF NOT EXIST "%WINDIR%\Backup" MD "%WINDIR%\Backup"

ASSOC > "%WINDIR%\Backup\FileAssoc.bak"
FTYPE > "%WINDIR%\Backup\FileFtype.bak"

IF "%3" == "/Q" Goto END
SET Task="Your Current File Associations Have Been Backed Up."
Goto MESSAGE

:ASSOCREST
IF NOT EXIST "%WINDIR%\Backup\FileAssoc.bak" ( 
IF "%3" == "/Q" Goto END
Set Type="File Associations" 
Goto NoBackup )

IF NOT EXIST "%WINDIR%\Backup\FileFtype.bak" ( 
IF "%3" == "/Q" Goto END
Set Type="File Associations" 
Goto NoBackup )

FOR /F "tokens=*" %%A IN ("%WINDIR%\Backup\FileAssoc.bak") DO (ASSOC %%A)
FOR /F "tokens=*" %%A IN ("%WINDIR%\Backup\FileFtype.bak") DO (FTYPE %%A)

IF "%3" == "/Q" Goto END

SET Task="File Associations Have Been Restored."
Goto MESSAGE


::===============================================================================
::==========================	   System Tweaks	  	=========================
::=============================================================================== 
:SYSTWEAK
>  "%Temp%.\SysTweaks.reg" ECHO REGEDIT4
>> "%Temp%.\SysTweaks.reg" ECHO.
::Disable Nag screens for .NET passport
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\MessengerService]
>> "%Temp%.\SysTweaks.reg" ECHO "PassportBalloon"=hex:0a,00
>> "%Temp%.\SysTweaks.reg" ECHO.
::Remove "Shortcut to" Prefix on Shortcuts
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer]
>> "%Temp%.\SysTweaks.reg" ECHO "link"=hex:00,00,00,00
>> "%Temp%.\SysTweaks.reg" ECHO.
::Add Register and Unregister to context menu of a DLL file
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\dllfile\shell]
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\dllfile\shell\Register DLL]
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\dllfile\shell\Register DLL\command]
>> "%Temp%.\SysTweaks.reg" ECHO @="\"regsvr32.exe\" %%1"
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\dllfile\shell\Unregister DLL]
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\dllfile\shell\Unregister DLL\command]
>> "%Temp%.\SysTweaks.reg" ECHO.@="\"regsvr32.exe\" /u %%1"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Speed up shutdown
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control]
>> "%Temp%.\SysTweaks.reg" ECHO "WaitToKillServiceTimeout"="5000" 
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Control Panel\Desktop]
>> "%Temp%.\SysTweaks.reg" ECHO "WaitToKillAppTimeout"="5000"
>> "%Temp%.\SysTweaks.reg" ECHO "HungAppTimeout"="1000"
>> "%Temp%.\SysTweaks.reg" ECHO "AutoEndTasks"="1"
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_USERS\.DEFAULT\ControlPanel\Desktop]
>> "%Temp%.\SysTweaks.reg" ECHO "WaitToKillAppTimeout"="5000"
>> "%Temp%.\SysTweaks.reg" ECHO "HungAppTimeout"="1000"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Allow Renaming of Recycle Bin
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\ShellFolder]
>> "%Temp%.\SysTweaks.reg" ECHO "Attributes"=hex:50,01,00,20
>> "%Temp%.\SysTweaks.reg" ECHO "CallForAttributes"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.
::Recycle bin uses 6% of available space (not 10%)
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\BitBucket]
>> "%Temp%.\SysTweaks.reg" ECHO "Percent"=dword:00000006
>> "%Temp%.\SysTweaks.reg" ECHO.
::Disable StickyKeys Keyboard shortcut (Popups up when pressing SHIFT key five times).
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys]
>> "%Temp%.\SysTweaks.reg" ECHO "Flags"="506"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Disable FilterKeys Keyboard shortcut (Popups up when pressing SHIFT key eight seconds).
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response]
>> "%Temp%.\SysTweaks.reg" ECHO "Flags"="122"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Disable ToggleKeys Keyboard shortcut (Popups up when pressing NUM LOCK key five seconds).
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys]
>> "%Temp%.\SysTweaks.reg" ECHO "Flags"="58"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Deactivate Windows tour
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Tour]
>> "%Temp%.\SysTweaks.reg" ECHO "RunCount"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Applets\Tour]
>> "%Temp%.\SysTweaks.reg" ECHO "RunCount"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.
::Add new BAT file to right click > new
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\.bat\ShellNew]
>> "%Temp%.\SysTweaks.reg" ECHO "NullFile"=""
>> "%Temp%.\SysTweaks.reg" ECHO.
::Add new REG file to right click > new
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\.reg\ShellNew]
>> "%Temp%.\SysTweaks.reg" ECHO "NullFile"=""
>> "%Temp%.\SysTweaks.reg" ECHO.
::Adds "Command Prompt" to the right-click of the top left of any explorer window.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\Directory\shell\cmd]
>> "%Temp%.\SysTweaks.reg" ECHO @="Open Command Window"
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CLASSES_ROOT\Directory\shell\cmd\command]
>> "%Temp%.\SysTweaks.reg" ECHO @="cmd.exe /k \"cd %L\""
>> "%Temp%.\SysTweaks.reg" ECHO.
::Set menu reaction time to 200ms (speeds up Start Menu)
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Control Panel\Desktop]
>> "%Temp%.\SysTweaks.reg" ECHO "MenuShowDelay"="200"
>> "%Temp%.\SysTweaks.reg" ECHO.
::Search with google from the address bar instead of MSN
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\SearchUrl\zoek]
>> "%Temp%.\SysTweaks.reg" ECHO @="http://www.google.com/search?q=%s"
>> "%Temp%.\SysTweaks.reg" ECHO.
::No web search feature for unknown filetypes
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system]
>> "%Temp%.\SysTweaks.reg" ECHO "NoInternetOpenWith"=dword:00000001
>> "%Temp%.\SysTweaks.reg" ECHO.
::Deactivate automatic search for scheduled tasks
>> "%Temp%.\SysTweaks.reg" ECHO [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{D6277990-4C6A-11CF-8D87-00AA0060F5BF}]
>> "%Temp%.\SysTweaks.reg" ECHO.
::Deactivate automatic search for network printers and folder
>> "%Temp%.\SysTweaks.reg" ECHO [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RemoteComputer\NameSpace\{2227A280-3AEA-1069-A2DE-08002B30309D}]
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
>> "%Temp%.\SysTweaks.reg" ECHO "NoNetCrawling"=dword:00000001
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_USERS\.DEFAULT\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
>> "%Temp%.\SysTweaks.reg" ECHO "NoNetCrawling"=dword:00000001
>> "%Temp%.\SysTweaks.reg" ECHO.
::Deactivate QOS (broadband-reservation)
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Psched]
>> "%Temp%.\SysTweaks.reg" ECHO "NonBestEffortLimit"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.
::Disable Internet Explorer "Send information to the Internet" prompt
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3]
>> "%Temp%.\SysTweaks.reg" ECHO "1601"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.
::Deactivate administrative shares
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters]
>> "%Temp%.\SysTweaks.reg" ECHO "AutoShareWks"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.
::Internet Explorer - increase maximum connections
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings]
>> "%Temp%.\SysTweaks.reg" ECHO "MaxConnectionsPerServer"=dword:00000008
>> "%Temp%.\SysTweaks.reg" ECHO "MaxConnectionsPer1_0Server"=dword:0000008
>> "%Temp%.\SysTweaks.reg" ECHO.
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_USERS.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Internet Settings]
>> "%Temp%.\SysTweaks.reg" ECHO "MaxConnectionsPerServer"=dword:00000008
>> "%Temp%.\SysTweaks.reg" ECHO "MaxConnectionsPer1_0Server"=dword:00000008
>> "%Temp%.\SysTweaks.reg" ECHO.
::Tweak the DNS Cache 
>> "%Temp%.\SysTweaks.reg" ECHO [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters]
>> "%Temp%.\SysTweaks.reg" ECHO "NetFailureCacheTime"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO "NegativeSOACacheTime"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO "MaxNegativeCacheTtl"=dword:00000000
>> "%Temp%.\SysTweaks.reg" ECHO.

REGEDIT.EXE /S "%Temp%.\SysTweaks.reg"
DEL "%Temp%.\SysTweaks.reg"

IF "%2" == "/Q" Goto END

SET Task="System Tweaking Complete."
Goto MESSAGE

::===============================================================================
::==========================	 Spyware Cleanup		=========================
::=============================================================================== 

:CLEANSPY
::Load External Module	--	Removes basic Spywares
ECHO CreateObject("Wscript.Shell").Run """" ^& "%Temp%\BHCTemp\Spyclean.bat" ^& """", 0, False > "%Temp%.\InvisibleSpyClean.vbs"

%Temp%.\InvisibleSpyClean.vbs
DEL "%Temp%.\InvisibleSpyClean.vbs"

::Cleaning spyware aureate
IF EXIST "%SYSTEMROOT%\system32\adcache" RD /S /Q "%SYSTEMROOT%\system32\adcache"> nul
IF EXIST "%SYSTEMROOT%\amcdl" RD /S /Q "%SYSTEMROOT%\amcdl"> nul
IF EXIST "%SYSTEMROOT%\amc" RD /S /Q "%SYSTEMROOT%\amc"> nul
IF EXIST "%USERPROFILE%\start menu\programs\radiate" RD /S /Q "%USERPROFILE%\start menu\programs\radiate"> nul
FOR %%v IN (adimage.dll advert.dll amcis.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
FOR %%v IN (amcis2.dll anadsc.ocx) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
FOR %%v IN (anadscb.ocx ipcclient.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
FOR %%v IN (htmdeng.exe msipcsv.exe tfde.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
::Cleaning spyware comet cursors
IF EXIST "%SYSTEMROOT%\system32\comet" RD /S /Q "%SYSTEMROOT%\system32\comet"> nul
IF EXIST "%SYSTEMROOT%\system32\comet\bin" RD /S /Q "%SYSTEMROOT%\system32\comet\bin"> nul
IF EXIST "%SYSTEMROOT%\downlo~1\mcc.inf" DEL /F /A "%SYSTEMROOT%\downlo~1\mcc.inf"
IF EXIST "%USERPROFILE%\desktop\comet cursor.lnk" DEL /F /A "%USERPROFILE%\desktop\comet cursor.lnk"
IF EXIST "%USERPROFILE%\start menu\programs\comet cursor.lnk" DEL /F /A "%USERPROFILE%\start menu\programs\comet cursor.lnk"
::Cleaning spyware cydoor
FOR %%v IN (cd_clint.dll cd_load.exe) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
FOR %%v IN (cd_swf.dll cd_gif.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
::Cleaning spyware dssagent
IF EXIST "%SYSTEMROOT%\dssagent.exe" DEL /F /A "%SYSTEMROOT%\dssagent.exe"
IF EXIST "%SYSTEMROOT%\system32\dssagent.exe" DEL /F /A "%SYSTEMROOT%\system32\dssagent.exe"
::Cleaning spyware ezula spyware
IF EXIST "%SYSTEMROOT%\ezulains.exe" DEL /F /A "%SYSTEMROOT%\ezulains.exe"
::Cleaning spyware gator
IF EXIST "%PROGRAMFILES%\gator.com" RD /S /Q "%PROGRAMFILES%\gator.com"> nul
IF EXIST "%PROGRAMFILES%\common files\gmt" RD /S /Q "%PROGRAMFILES%\common files\gmt"> nul
IF EXIST "%USERPROFILE%\start menu\programs\gator" RD /S /Q "%USERPROFILE%\start menu\programs\gator"> nul
FOR %%v IN (gatorplugin.log gatorsetup.log gatorfiledrop.log) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
FOR %%v IN (iegator.dll iegator.inf) DO IF EXIST "%SYSTEMROOT%\downlo~1\%%v" DEL /F /A "%SYSTEMROOT%\downlo~1\%%v"
::Cleaning spyware gohip
IF EXIST "%SYSTEMROOT%\winstartup.exe" DEL /F /A "%SYSTEMROOT%\winstartup.exe"
::Cleaning spyware newdotnet
FOR %%v IN (newdotnet2_78.dll newdotnet3_15.dll) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
::Cleaning spyware newsupd
IF EXIST "%PROGRAMFILES%\creative\news" RD /S /Q "%PROGRAMFILES%\creative\news"> nul
FOR %%v IN (ctnews.ini ctnet.ini) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
::Cleaning spyware onflow
IF EXIST "%PROGRAMFILES%\onflow" RD /S /Q "%PROGRAMFILES%\onflow"> nul
IF EXIST "%PROGRAMFILES%\intern~1\plugins\onflowreport.exe" DEL /F /A "%PROGRAMFILES%\intern~1\plugins\onflowreport.exe"
IF EXIST "%PROGRAMFILES%\intern~1\plugins\ieonflow.dll" DEL /F /A "%PROGRAMFILES%\intern~1\plugins\ieonflow.dll"
IF EXIST "%PROGRAMFILES%\intern~1\plugins\nponflow.dll" DEL /F /A "%PROGRAMFILES%\intern~1\plugins\nponflow.dll"
IF EXIST "%PROGRAMFILES%\intern~1\plugins\onflowplayer0.dll" DEL /F /A "%PROGRAMFILES%\intern~1\plugins\onflowplayer0.dll"
::Cleaning spyware tsadbot timesink
IF EXIST "%PROGRAMFILES%\timesink" RD /S /Q "%PROGRAMFILES%\timesink"> nul
FOR %%v IN (tsad.dll flexactv.dll vcpdll.dll addon2vb.dll) DO IF EXIST "%SYSTEMROOT%\%%v" DEL /F /A "%SYSTEMROOT%\%%v"
FOR %%v IN (tsad.dll flexactv.dll vcpdll.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
FOR %%v IN (addon2vb.dll) DO IF EXIST "%SYSTEMROOT%\system32\%%v" DEL /F /A "%SYSTEMROOT%\system32\%%v"
::Cleaning spyware ultimate
IF EXIST "%PROGRAMFILES%\diallerprogram" RD /S /Q "%PROGRAMFILES%\diallerprogram"> nul
IF EXIST "%SYSTEMROOT%\downlo~1\lolitas.exe" DEL /F /A "%SYSTEMROOT%\downlo~1\lolitas.exe"
IF EXIST "%USERPROFILE%\desktop\ultimatesexxx.lnk" DEL /F /A "%USERPROFILE%\desktop\ultimatesexxx.lnk"
IF EXIST "%USERPROFILE%\start menu\ultimatesexxx.lnk" DEL /F /A "%USERPROFILE%\start menu\ultimatesexxx.lnk"
::Cleaning submitwolf reports
IF EXIST "%PROGRAMFILES%\trellian\submitwolf\reports" DEL /F /A "%PROGRAMFILES%\trellian\submitwolf\reports\*.htm"> nul
IF EXIST "%PROGRAMFILES%\trellian\submitwolf de\reports" DEL /F /A "%PROGRAMFILES%\trellian\submitwolf de\reports\*.htm">nul
::Cleaning teleport downloaded pages
IF EXIST "%PROGRAMFILES%\teleport pro\projects" DEL /F /Q /A "%PROGRAMFILES%\teleport pro\projects\*.*"> nul

IF "%2" == "/Q" Goto END

SET Task="Spyware Cleanup Complete."
Goto MESSAGE


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

Goto END

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