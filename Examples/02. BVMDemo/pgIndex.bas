B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.5
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Public VA As VueApp
	Public app As VApp
	Public BANano As BANano
	Private navdrawer As VNavigationDrawer
	Private hamburger As Vappbarnavicon
End Sub


Sub Init
	'initialize the library
	VA.Initialize(Me)
	'load a layout
	BANano.LoadLayout("#placeholder", "mainapp")
	
	'bind navdrawer and hamburger to app state
	navdrawer.AddToApp(VA)
	hamburger.AddToApp(VA)
	'
	'hide the drawer
	VA.setdata("drawer", False)
	'feed placeholder content to the template
	VA.Placeholder2Template	
	'serve the application
	VA.Serve
End Sub

Sub hamburger_clickstop (e As BANanoEvent)
	VA.ToggleState("drawer")
End Sub