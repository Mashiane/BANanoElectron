B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
#IgnoreWarnings:12
Sub Class_Globals
	Private code As StringBuilder
	Private mAppName As String
	Private mWorkingDir As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(WorkingDir As String, AppName As String) As ELRenderer
	mWorkingDir = WorkingDir
	mAppName = AppName
	code.Initialize
	Return Me
End Sub

'add code
Sub AddCode(mcode As String) As ELRenderer
	code.Append(mcode)
	Return Me
End Sub

'add comment
Sub AddComment(mcomment As String) As ELRenderer
	code.Append($"// ${mcomment}"$)
	Return Me
End Sub

'add new line
Sub AddNewline As ELRenderer
	code.Append(CRLF)
	Return Me
End Sub

'save to renderer
Sub Save
	Dim sout As String = code.ToString
	sout = sout.Replace("~", "$")
	File.WriteString(File.Combine(mWorkingDir,mAppName), "renderer.js", sout)
End Sub