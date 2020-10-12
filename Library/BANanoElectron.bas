B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private mAppName As String
	Private mWorkingDir As String
	Private mPacketName As String
	Private mTitle As String
	Private shl As Shell
End Sub

'Initializes the BANanoElectron
Public Sub Initialize(WorkingDir As String, AppName As String, PacketName As String, Title As String)
	mWorkingDir = WorkingDir
	mAppName = AppName
	mPacketName = PacketName
	mTitle = Title
End Sub
'
'Install Electron
Public Sub Install As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install", "-g", "electron"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "ISO-8859-1"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'uninstall Electron
Public Sub UnInstall As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "uninstall", "-g", "electron"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "ISO-8859-1"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub


Private Sub shl_StdOut (Buffer() As Byte, Length As Int)
	Dim s As String
	s = BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	Log(s)
End Sub

Private Sub EventName_StdErr (Buffer() As Byte, Length As Int)
	Dim s As String
	s = BytesToString(Buffer, 0, Buffer.Length, "UTF8")
	LogError(s)
End Sub

'Check if Electron is installed or not
Public Sub isInstalled As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "electron", "--version"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "ISO-8859-1"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'Copy folder recursively
'Source: https://www.b4x.com/android/forum/threads/b4x-copyfolder-deletefolder.69820/#content
Private Sub CopyFolder(Source As String, targetFolder As String)
	If File.Exists(targetFolder, "") = False Then File.MakeDir(targetFolder, "")
	For Each f As String In File.ListFiles(Source)
		If File.IsDirectory(Source, f) Then
			CopyFolder(File.Combine(Source, f), File.Combine(targetFolder, f))
			Continue
		End If
		File.Copy(Source, f, targetFolder, f)
	Next
End Sub

'run the application
Public Sub Run() As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "electron", "."))
	shl.WorkingDirectory = File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "ISO-8859-1"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub