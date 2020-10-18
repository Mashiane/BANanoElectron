﻿B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
#IgnoreWarnings:12
Sub Class_Globals
	Private submenu As List
	Public menu As Map
End Sub

'Initializes the menu
Public Sub Initialize(key As String, label As String) As ELMenu
	menu.Initialize
	menu.Put("key", key)
	menu.Put("label", label)
	submenu.Initialize 
	Return Me
End Sub

'add submenu
Sub AddItem(smenu As ELMenu) As ELMenu
	submenu.Add(smenu.menu)
	menu.Put("submenu", submenu)
	Return Me
End Sub

'make the menu a separator
Sub Separator As ELMenu
	menu.Remove("key")
	menu.Remove("label")
	menu.Put("type", "separator")
	Return Me
End Sub

'tojson
Sub ToJSON As String
	Dim sjson As String = Map2Json(menu)
	Return sjson
End Sub

'convert map to json
private Sub Map2Json(m As Map) As String
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(m)
	Return JSONGenerator.ToString
End Sub

'set accelerator
Sub SetAccelerator(saccelerator As String) As ELMenu
	menu.Put("accelerator", saccelerator)
	Return Me
End Sub

'set role
Sub SetRole(srole As String) As ELMenu
	menu.Put("role", srole)
	Return Me
End Sub

'set click
Sub SetClick(sclick As String) As ELMenu
	menu.Put("click", sclick)
	Return Me
End Sub

'set checked
Sub SetChecked(bChecked As Boolean) As ELMenu
	menu.Put("checked", bChecked)
	Return Me
End Sub

'set checkbox
Sub SetCheckBox() As ELMenu
	menu.Put("type", "checkbox")
	Return Me
End Sub

'set radio
Sub SetRadio() As ELMenu
	menu.Put("type", "radio")
	Return Me
End Sub