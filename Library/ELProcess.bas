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

'get element by id
Sub getElementById(varName As String, elID As String) As ELProcess
	varName = varName.ToLowerCase
	elID = elID.tolowercase
	script($"const ${varName} = document.getElementById('${elID}')"$)
	Return Me
End Sub

'add event listener
Sub addEventListener(objName As String, eventName As String) As ELProcess
	objName = objName.tolowercase
	script($"${objName}.addEventListener('${eventName}', function(event) {"$)
	Return Me
End Sub

'prevent default
Sub preventDefault As ELProcess
	script("event.preventDefault()")
	Return Me
End Sub

'popup
Sub popup(menuName As String) As ELProcess
	script($"${menuName}.popup()"$)
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

'tostring
Sub ToString As String
	Dim sout As String = code.ToString
	sout = sout.Replace("~", "$")
	Return sout
End Sub

'remove menu
Sub removeMenu(winName As String) As ELProcess
	comment("remove menu")
	script($"${winName}.removeMenu()"$)
	Return Me
End Sub

'maximise
Sub maximise(winName As String) As ELProcess
	comment("maximize menu")
	script($"${winName}.maximize()"$)
	Return Me
End Sub

'once ready to show
Sub onceReadyToShow(winName As String) As ELProcess
	comment("Wait for 'ready-to-show' to display our window")
	script($"${winName}.once('ready-to-show', function () {"$)
	Return Me
End Sub

'end function with })
Sub Done As ELProcess
	script("})")
	Return Me
End Sub

'on closed
Sub onClosed(winName As String) As ELProcess
	comment("Emitted when the window is closed.")
	script($"${winName}.on('closed', function () {"$)
	Return Me
End Sub

'open function
Sub OpenFunction(funcName As String) As ELProcess
	script($"function ${funcName} () {"$)
	Return Me
End Sub

'end function with }
Sub CloseFunction As ELProcess
	script("}")
	Return Me
End Sub


'EndIf
Sub EndIf As ELProcess
	script("}")
	Return Me
End Sub


'load html
Sub loadHTML(winName As String, fileName As String) As ELProcess
	comment($"load ${fileName}"$)
	script($"${winName}.loadURL(url.format({"$)
	script($"pathname: path.join(__dirname, '${fileName}'),"$)
	script("protocol: 'file:',")
	script("slashes: true")
	script("}))")
	Return Me
End Sub

'mullify
Sub nullify(winName As String) As ELProcess
	comment("nullyfy window")
	let(winName, "null")
	Return Me
End Sub

'show
Sub show(winName As String) As ELProcess
	comment("show the window")
	script($"${winName}.show()"$)
	Return Me
End Sub

'openDevTools
Sub openDevTools(winName As String) As ELProcess
	comment("open the devtools")
	script($"${winName}.webContents.openDevTools()"$)
	Return Me
End Sub

'if IsNull
Sub IfIsNull(varName As String) As ELProcess
	script($"if (${varName} === null) {"$)
	Return Me
End Sub
	
'app on activate
Sub appOnActivate(appName As String) As ELProcess
	script($"${appName}.on('activate', function () {"$)
	Return Me
End Sub
	
'app quit
Sub appQuit(appName As String) As ELProcess
	script($"${appName}.quit()"$)
	Return Me
End Sub

'if process not darwin
Sub IfPlatformNotDarwin As ELProcess
	comment("On OS X it Is common for applications and their menu bar")
	comment("To stay active until the user quits explicitly with Cmd + Q")
	script("if (process.platform !== 'darwin') {")
	Return Me
End Sub

'RunMethod
Sub RunFunction(funcName As String) As ELProcess
	script($"${funcName}()"$)
	Return Me
End Sub

'app on windows all closes
Sub appOnWindowAllClosed(appName As String) As ELProcess
	comment("Quit when all windows are closed.")
	script($"${appName}.on('window-all-closed', function () {"$)
	Return Me
End Sub

'app onReady
Sub appOnReady(appName As String) As ELProcess
	comment("Fired when electron is ready to create the window")
	script($"${appName}.on('ready', function () {"$)
	Return Me
End Sub

'menu build from template
Sub MenuBuildFromTemplate(menuName As String, mainMenu As String, templateName As String) As ELProcess
	constant($"${menuName}"$, $"${mainMenu}.buildFromTemplate(${templateName})"$)
	Return Me	
End Sub

'menu setApplicationMenu
Sub MenuSetApplicationMenu(menuName As String, mainMenu As String) As ELProcess
	script($"${mainMenu}.setApplicationMenu(${menuName})"$)
	Return Me	
End Sub


'convert map to json
private Sub Map2Json(m As Map) As String
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(m)
	Return JSONGenerator.ToString
End Sub

'newBrowserWindow
Sub newBrowserWindow(winName As String, options As Map) As ELProcess
	comment("create a new browser window")
	Dim woJSON As String = Map2Json(options)
	script($"${winName} = new BrowserWindow(${woJSON})"$)
	Return Me
End Sub


'create a menu
Sub newMenu(key As String, label As String) As ELMenu
	Dim em As ELMenu
	em.Initialize(key, label)
	Return em
End Sub

'create a separator
Sub newMenuSeparator() As ELMenu
	Dim em As ELMenu
	em.Initialize("", "")
	em.Separator
	Return em
End Sub


'new list
Sub newList As List
	Dim nl As List
	nl.Initialize
	Return nl
End Sub