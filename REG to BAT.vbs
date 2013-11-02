'reg2bat.vbs - Convert .REG files to their BATCH equivalents
'© Shadab Zafar - http://shadabsofts.wordpress.com/

Option Explicit

Dim WS : Set WS = CreateObject("WScript.Shell")
Dim FSO : Set FSO = CreateObject("Scripting.FileSystemObject")
Dim Args : Set Args = WScript.Arguments

Dim RegFile, BatFile, regLine
Dim nFileName, FileName
Dim i

If Args.Count <> 1 Then
	Msgbox "Drop a REG file on me and i'll give you its BAT equivalent.", 64, "Reg2Bat © Shadab Zafar"
	WScript.Quit
End If

If LCase(FSO.GetExtensionName(Args(0))) <> "reg" Then
	Msgbox "Please drop a .reg file only.", 48, "Reg2Bat © Shadab Zafar"
	WScript.Quit
End If

nFileName = "@-@%Temp%.\" & FSO.GetFileName(FSO.GetFile(Args(0))) & "@-@"
FileName = Replace(nFileName,chr(64)&chr(45)&chr(64),"""")
	
'Open the passed Reg file for Reading (1)
Set RegFile = FSO.OpenTextFile(Args(0), 1, False, 0)

'Create & Open a new BAT file with the same name as the REG file
Set BatFile = FSO.OpenTextFile(Args(0) & ".bat", 8, True, 0)

i = 0 
Do While RegFile.AtEndOfStream <> True
	 regLine = RegFile.Readline
	 
	 If i = 0 Then		
		If IsValidRegFile(regLine) = False Then
			Msgbox "The reg file is corrupt.", 48, "Reg2Bat © Shadab Zafar"
			On Error Resume Next
			FSO.DeleteFile(Args(0) & ".bat")
			WScript.Quit
		End If
		
		BatFile.WriteLine "@ECHO OFF"
		BatFile.WriteLine "> " & FileName & " ECHO " & regLine
	 ElseIf regLine = "" Then
		BatFile.WriteLine ">>" & FileName & " ECHO."
	 Else
		BatFile.WriteLine ">>" & FileName & " ECHO " & regLine
	 End If
	 
	 i = i + 1
Loop

BatFile.WriteLine ""
BatFile.WriteLine "REGEDIT.EXE /S " & FileName
BatFile.WriteLine "DEL " & FileName

RegFile.Close
BatFile.Close

Function IsValidRegFile(sFirstLine)
	'Checks for valid registry file
	Dim Result
	Select Case sFirstLine
	Case "Windows Registry Editor Version 5.00"
		'Windows 2000, XP
		Result = True
	Case "REGEDIT4"
		'Windows 95, 98 ME
		Result = True
	Case Else
		'Unknown registry file format
		Result = False
	End Select
	IsValidRegFile = Result
End Function