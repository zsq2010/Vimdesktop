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
;Menu, Tray, Add, (&H) %_Help%, <VIMD_Help>

;menu, Tray, add, (&U) %_Updater% , <Updater>
Menu, LangSet, add, 中文
Menu, LangSet, add, English
Menu, tray, add, (&L) %_Language%, :LangSet
Menu, aboutMe, add, (&H) %_Help%, <VIMD_Help>
Menu, aboutMe, add, (&U) %_Update%, <VIMD_Update>
Menu, aboutMe, add, (&B) %_BackupRestore%, <VIMD_BackupRestore>
Menu, tray, add, (&L) %_aboutMe%, :aboutMe
Menu, Tray, Add, (&R) %_Restart% , <Reload>
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
    Gui,welcome: Color, %color1% 
    Gui,welcome: Font,cwhite s8 wbold q5,Segoe UI
    Gui,welcome: Add, Text, ,%_Welcome%
    Gui,welcome: Font,cwhite s50 wbold q5,Segoe UI
    Gui,welcome: Add, Text, ,%_AppName%
    Gui,welcome: Font,cwhite s8 wbold q5,Segoe UI
    Gui,welcome: Add, Text, ,%_Authors%                                                        
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

<VIMD_Update>:
; 执行备份文件
d = (%A_YYYY%_%A_MM%_%A_DD%_%A_Hour%%A_Min%%A_Sec%)
; 执行备份文件
FileCopy, %A_ScriptDir%\vimd.ini, %A_ScriptDir%\vimd_备份_%d%.ini ,1
; 执行备份文件2
FileCopy, %A_ScriptDir%\vimd.ini, %A_ScriptDir%\vimd_备份_还原.ini ,1
Sleep, 1000
; 开始运行更新工具
; run, %A_ScriptDir%\updata.exe
; Sleep, 2000
; ; 查看更新日志
; Run, https://github.com/BoBOVFX/Vimdesktop
; Sleep, 2000
; Exitapp
Gosub,Auto_Update
return

<VIMD_BackupRestore>:
MsgBox, 4,, 如果您更新过程序 请选择是? (press Yes or No)
IfMsgBox Yes
    if FileExist("%A_ScriptDir%\vimd_备份_还原.ini")
        {
            ToolTip, 正在执行还原操作！
            sleep 100
            SetTimer, RemoveToolTip, -4000
            FileCopy, %A_ScriptDir%\vimd_备份_还原.ini, %A_ScriptDir%\vimd.ini ,1
            sleep 500
            ToolTip, 重启中...
            SetTimer, RemoveToolTip, -4000
            FileRecycle, %A_ScriptDir%\vimd_备份_还原.ini
            sleep 500
            Reload
            Return
        }
        else
        {
        MsgBox , 4, ,您未更新过程序！5秒后退出..., 5
        Return
        }
    
else
    {
        return
    }
return

Exit:
FileRemoveDir,%ProgramFilesDir%,1
MsgBox,0x40134,%_AppName%,%_ConfirmExit%
IfMsgBox, Yes
Exitapp
Return

Check_Update:
	checkUpdateFlag:=true
	TrayTip,,%_AppName%检查更新中……,2,1
	gosub,Auto_Update
return

Auto_Update:
	if(FileExist(A_Temp "\Vimdesktop_Update.bat"))
		FileDelete, %A_Temp%\Vimdesktop_Update.bat
	;[下载最新的更新脚本]
	if(!Check_Github()){
		lpszUrl:=githubUrl
		WorkflowsDownDir:=lpszUrl . GithubDir
		if(!Check_Github()){
			TrayTip,,网络异常，无法连接网络读取最新版本文件,3,1
			return
		}
	}
	URLDownloadToFile(WorkflowsDownDir "/vimd.ahk",A_Temp "\temp_vimd.ahk")
	versionReg=iS)^\t*\s*global Workflows_update_version:="([\d\.]*)"
	Loop, read, %A_Temp%\temp_vimd.ahk
	{
		if(RegExMatch(A_LoopReadLine,versionReg)){
			versionStr:=RegExReplace(A_LoopReadLine,versionReg,"$1")
			break
		}
		if(A_LoopReadLine="404: Not Found"){
			TrayTip,,文件下载异常，更新失败！,3,1
			return
		}
	}
	if(versionStr){
		if(Workflows_update_version<versionStr){
			MsgBox,33,%_AppName%检查更新,检测到%_AppName%有新版本`n`n%Workflows_update_version%`t版本更新后=>`t%versionStr%`n`n是否更新到最新版本？`n覆盖老版本文件，如有修改过RunAny.ahk请注意备份！
			IfMsgBox Ok
			{
				TrayTip,,%_AppName%下载最新版本并替换老版本...,5,1
				; gosub,Config_Update
				URLDownloadToFile(WorkflowsDownDir "/vimd.exe",A_Temp "\temp_vimd.exe")
				gosub,vimd_Update
				shell := ComObjCreate("WScript.Shell")
				shell.run(A_Temp "\vimd_Update.bat",0)
				ExitApp
			}
		}else if(checkUpdateFlag){
			FileDelete, %A_Temp%\temp_vimd.ahk
			TrayTip,,%_AppName%已经是最新版本。,5,1
			checkUpdateFlag:=false
		}else if(A_DD!=01 && A_DD!=15){
			FileDelete, %A_Temp%\temp_vimd.ahk
		}
	}
return

vimd_Update:
; Run,https://github.com/hui-Zz/RunAny/wiki/RunAny版本更新历史
TrayTip,,%_AppName%已经更新到最新版本。,5,1
FileAppend,
(
@ECHO OFF & setlocal enabledelayedexpansion & TITLE vimd更新版本
set /a x=1
:BEGIN
set /a x+=1
ping -n 2 127.1>nul
if exist "%A_Temp%\temp_vimd.ahk" `(
  MOVE /y "%A_Temp%\temp_vimd.ahk" "%A_ScriptDir%\vimd.ahk"
`)
if exist "%A_Temp%\temp_vimd.exe" `(
  MOVE /y "%A_Temp%\temp_vimd.exe" "%A_ScriptDir%\vimd.exe"
`)
goto INDEX
:INDEX
if !x! GTR 10 `(
  exit
`)
if exist "%A_Temp%\temp_vimd.ahk" `(
  goto BEGIN
`)
if exist "%A_Temp%\temp_vimd.exe" `(
  if !x! EQU 5 `(
    taskkill /f /im %A_ScriptName%
  `)
  goto BEGIN
`)
start "" "%A_ScriptDir%\%A_ScriptName%"
exit
),%A_Temp%\vimd_Update.bat
return