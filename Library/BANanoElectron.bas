B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
#IgnoreWarnings:12
Sub Class_Globals
	Private mAppName As String
	Private mWorkingDir As String
	Private mPacketName As String
	Private mTitle As String
	Private shl As Shell
	Private BANano As BANano
	Public MainProcess As ELProcess
	Public RendererProcess As ELProcess
	Public BrowserWindow As ELBrowserWindow
	Private package As StringBuilder
	Private scripts As StringBuilder
	Private keywords As StringBuilder
	Private scriptsL As List
	Private keywordsL As List
	Private props As List
End Sub

'Initializes the BANanoElectron
Public Sub Initialize(WorkingDir As String, AppName As String, PacketName As String, Title As String)
	mWorkingDir = WorkingDir
	mAppName = AppName
	mPacketName = PacketName
	mTitle = Title
	props.Initialize 
	keywords.Initialize 
	keywords.Append("[")
	keywords.Append(CRLF)
	keywordsL.Initialize 
	scripts.initialize
	scripts.Append("{")
	scripts.Append(CRLF)
	scriptsL.Initialize 
	'build the package file
	package.Initialize 
	package.Append("{")
	package.Append(CRLF)
	AddProperty("name", AppName)
	AddProperty("productName", Title)
	AddProperty("main", "main.js")
	'useful classes
	MainProcess.Initialize(mWorkingDir, mAppName)
	RendererProcess.Initialize(mWorkingDir, mAppName)
End Sub

'new list
Sub NewList As List
	Dim nl As List
	nl.Initialize 
	Return nl
End Sub

'create a menu
Sub CreateMenu(key As String, label As String) As ELMenu
	Dim em As ELMenu
	em.Initialize(key, label)
	Return em
End Sub

'create a separator
Sub CreateMenuSeparator() As ELMenu
	Dim em As ELMenu
	em.Initialize("", "")
	em.Separator
	Return em
End Sub

'convert list to json
Sub List2Json(l As List) As String
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize2(l)
	Return JSONGenerator.ToString
End Sub

'convert map to json
Sub Map2Json(m As Map) As String
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(m)
	Return JSONGenerator.ToString
End Sub

'convert json string to map
Sub Json2Map(jsonText As String) As Map
	Dim Map1 As Map
	Map1.Initialize
	Try
		Dim json As JSONParser
		json.Initialize(jsonText)
		Map1 = json.NextObject
		Return Map1
	Catch
		Return Map1
	End Try
End Sub

'convert json2list
Sub Json2List(jsonTxt As String) As List
	Dim root As List
	root.Initialize
	Try
		Dim parser As JSONParser
		parser.Initialize(jsonTxt)
		root = parser.NextArray
		Return root
	Catch
		Return root
	End Try
End Sub

'join list to mv string
private Sub Join(delimiter As String, lst As List) As String
	Dim i As Int
	Dim sbx As StringBuilder
	Dim fld As String
	sbx.Initialize
	fld = lst.Get(0)
	sbx.Append(fld)
	For i = 1 To lst.size - 1
		Dim fld As String = lst.Get(i)
		sbx.Append(delimiter).Append(fld)
	Next
	Return sbx.ToString
End Sub

'set version
Sub setVersion(v As String)
	AddProperty("version", v)
End Sub

'set description
Sub setDescription(v As String)
	AddProperty("description", v)
End Sub

'set repository
Sub setRepository(v As String)
	AddProperty("repository", v)
End Sub

'set author
Sub setAuthor(v As String)
	AddProperty("author", v)
End Sub

'set license
Sub setLicense(v As String)
	AddProperty("license", v)
End Sub

'add a script to the list
Sub AddScript(propName As String, propValue As String)
	Dim sprop As String = $""${propName}": "${propValue}""$
	scriptsL.Add(sprop)
End Sub

'add property
Sub AddProperty(propName As String, propValue As String)
	Dim sprop As String = $""${propName}": "${propValue}""$
	props.Add(sprop)
End Sub

'add keyword
Sub AddKeyword(kw As String) As BANanoElectron
	keywordsL.Add($""${kw}""$)
	Return Me
End Sub

'save package
Sub Save
	'close the keywords
	Dim v As String = Join("," & CRLF, keywordsL)
	keywords.Append(v)
	keywords.Append("]")
	keywords.Append(CRLF)
	v = Join("," & CRLF, props)
	package.Append(v)
	package.Append(",")
	package.Append(CRLF)
	'close the scripts
	v = Join("," & CRLF, scriptsL)
	scripts.Append(v)
	scripts.Append("},")
	scripts.Append(CRLF)
	package.Append($""scripts":"$).Append(scripts.ToString)
	package.Append($""keywords":"$).Append(keywords.ToString)
	'close the package file
	package.Append("}")
	package.Append(CRLF)
	File.WriteString(File.Combine(mWorkingDir,mAppName), "package.json", package.ToString)
	'
	MainProcess.Save("main.js")
	RendererProcess.save("renderer.js")
End Sub


'Install App
Public Sub AppInstall As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'start app
Public Sub AppStart As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "run", "start"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'build app
Public Sub AppBuild As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "run", "build"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'Add Dependency
Public Sub InstallDependency(args As String) As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install", args, "--save"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub


'Add Development Dependency
Public Sub InstallDevDependency(args As String) As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install", "--save-dev", args))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub

'Add global electron
Public Sub Install() As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install", "-g", "electron"))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub


'Add global package
Public Sub InstallPackage(args As String) As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "install", "-g", args))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub


'uninstall package
Public Sub UnInstallPackage(args As String) As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", "npm", "uninstall", "-g", args))
	shl.WorkingDirectory =  File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
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
	shl.Encoding = "UTF-8"
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
Public Sub Run(args As String) As ResumableSub
	shl.Initialize("shl", "cmd", Array As String("/c", args, "."))
	shl.WorkingDirectory = File.Combine(mWorkingDir, mAppName)
	shl.Encoding = "UTF-8"
	Dim res As ShellSyncResult = shl.RunSynchronous(-1)
	Log(res.StdOut)
	LogError(res.StdErr)
	Return (res.Success And res.ExitCode = 0)
End Sub