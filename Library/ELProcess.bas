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
Public Sub Initialize(WorkingDir As String, AppName As String) As ELProcess
	mWorkingDir = WorkingDir
	mAppName = AppName
	code.Initialize
	Return Me
End Sub

'require
Sub require(varName As String, module As String) As ELProcess
	script($"const ${varName} = require('${module}')"$)
	Return Me
End Sub

'define constants
Sub dimension(varname As String, source As String) As ELProcess
	script($"const ${varname} = ${source}"$)
	Return Me
End Sub

'define constants
Sub constant(varname As String, source As String) As ELProcess
	script($"const ${varname} = ${source}"$)
	Return Me
End Sub

'set let
Sub let(varname As String, source As String) As ELProcess
	script($"let ${varname} = ${source}"$)
	Return Me
End Sub

'set assign
Sub assign(varname As String, source As String) As ELProcess
	script($"${varname} = ${source}"$)
	Return Me
End Sub


'add code
Sub script(mcode As String) As ELProcess
	code.Append(mcode)
	newline
	Return Me
End Sub

'add comment
Sub comment(mcomment As String) As ELProcess
	code.Append($"// ${mcomment}"$)
	newline
	Return Me
End Sub

'add new line
Sub newline As ELProcess
	code.Append(CRLF)
	Return Me
End Sub

'save to main
Sub Save(jsFile As String)
	Dim sout As String = code.ToString
	sout = sout.Replace("~", "$")
	File.WriteString(File.Combine(mWorkingDir,mAppName), jsFile, sout)
End Sub