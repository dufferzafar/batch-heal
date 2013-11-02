'© Shadab Zafar - http://shadabsofts.wordpress.com/

Option Explicit
On Error Resume Next

Dim WS : Set WS = CreateObject("WScript.Shell")
Dim Args : Set Args = WScript.Arguments

If Args.Count = 0 Then
	WS.Run "Fix.bat", 0, False
	If Err Then 
		NoFix 
	End If
ElseIf Args.Count = 1 Then
	WS.Run "Fix.bat " & Args(0), 0, False
	If Err Then 
		NoFix 
	End If
ElseIf Args.Count = 2 Then
	WS.Run "Fix.bat " & Args(0) & " " & Args(1), 0, False
	If Err Then 
		NoFix 
	End If
ElseIf Args.Count = 3 Then
	WS.Run "Fix.bat " & Args(0) & " " & Args(1) & " " & Args(2), 0, False
	If Err Then 
		NoFix 
	End If
ElseIf Args.Count = 4 Then
	WS.Run "Fix.bat " & Args(0) & " " & Args(1) & " " & Args(2) & " " & Args(3), 0, False
	If Err Then 
		NoFix 
	End If
End If

Set WS = Nothing
Set Args = Nothing

WScript.Quit

Sub NoFix
		Msgbox "This file can only launch BHC.bat" & vbcrlf & vbcrlf &_
				"So, Please rename Batch Heal & Clean's file to BHC.bat", 64, "Rename the file to BHC.bat"
End Sub