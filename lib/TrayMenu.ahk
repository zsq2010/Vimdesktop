CreateTray:
Menu, Tray, Icon, %A_ScriptDir%\vimd.ico
menu, Tray, DeleteAll
Menu, Tray, NoStandard
;menu, Tray, UseErrorLevel
Menu, Tray, tip, %_AppName%`n版本:%v%(By_%_Author%)`n%inputStr%
menu, Tray, add, %_AppName% %v% by %_Author%,About
Menu, Tray, disable, %_AppName% %v% by %_Author%
menu, Tray, add
menu, Tray, add, (&S) %_StartUp%,StartUp
;if StartUp

;menu, Tray, check, %_StartUp%
;menu, Tray, add, %_UpdatPlugins% &U, <UpdatPlugins>
;menu, tray, disable, %_Author%
Menu, Tray, add, (&H) %_HotKeyManagement% , <VimDConfig_KeymapEdit>
Menu, Tray, Add, (&C) %_Config% , <VimDConfig_EditConfig>
Menu, Tray, Add, (&P) %_Path% , <EditConfig>
;Menu, Tray, Add,
;Menu, Tray, Add, 编辑Custom &C, <VimDConfig_EditCustom>
Menu, Tray, Add,
Menu, Tray, Add, (&H) %_Help%, <VIMD_Help>
Menu, Tray, Add, (&R) %_Restart% , <Reload>
;menu, Tray, add, (&U) %_Updater% , <Updater>
Menu, LangSet, add, 中文
Menu, LangSet, add, English
Menu, tray, add, (&L) %_Language%, :LangSet
Menu, Tray, Add, (&X) %_Exit% , Exit
Menu, Tray, Click, 1

VimdRun()

; 欢迎
; if (FirstParameter!="silent")
; {
;     Gui,welcome: +LastFound +AlwaysOnTop -Caption +ToolWindow
;     Gui,welcome: Color, %color1%
;     Gui,welcome: Font,cwhite s%FontSize% wbold q5,Segoe UI
;     Gui,welcome: Add, Text, ,欢迎使用`n        %_AppName%
; 	;Gui, Show, xCenter y0
;     Gui,welcome: Show,AutoSize Center NoActivate
; 	;Gui,welcome: Show,w180 h50,Center NoActivate
; 	;Gui,welcome: Show,h100,Center ;NoActivate
; }
; 欢迎界面
if (FirstParameter!="silent")
{
    Gui,welcome: +LastFound +AlwaysOnTop -Caption +ToolWindow
    Gui,welcome: Color, %color1% `n版本:%v%
    Gui,welcome: Font,cwhite s10 wbold q5,Segoe UI
    Gui,welcome: Add, Text, ,%_Welcome%
    Gui,welcome: Font,cwhite s20 wbold q5,Segoe UI
    Gui,welcome: Add, Text, ,%_AppName%_%_Author%
    Gui,welcome: Font,cwhite s8 wbold q5,Segoe UI
    Gui,welcome: Show,AutoSize Center NoActivate
    WinSet, Transparent,200
    sleep %SleepTime%
    Gui,welcome: Hide
}
return

Author:
About:
License:
Return


中文:
IniWrite, CN, vimd.ini, config, Language
Reload
Return

English:
IniWrite, EN, vimd.ini, config, Language
Reload
Return

;自启

;开机启动

Startup:

if Startup
{
    RegDelete, HKLM\Software\Microsoft\Windows\CurrentVersion\Run, Vimdesktop
    StartUp=0
    menu,tray,uncheck,%_StartUp%
}
else
{
    RegWrite, REG_SZ, HKLM\Software\Microsoft\Windows\CurrentVersion\Run, Vimdesktop, %A_ScriptFullPath%
    StartUp=1
    menu,tray,check,%_StartUp%
}
Return

; 用户自定义配置
<EditConfig>:
    run , %A_ScriptDir%\Editor.exe
return

<VIMD_Help>:
Run, https://www.kancloud.cn/funbobosky/vim_unity
return

Exit:
FileRemoveDir,%ProgramFilesDir%,1
MsgBox,0x40134,Vimdesktop,%_ConfirmExit%
IfMsgBox, Yes
Exitapp
Return