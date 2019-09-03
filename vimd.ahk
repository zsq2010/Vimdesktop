;管理员权限
Loop, %0%  ; For each parameter:
  {
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
  }
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}
#Include %A_ScriptDir%\lib\Language.ahk
#NoEnv
#SingleInstance, Force
#SingleInstance ignore
#Persistent
#InstallKeybdHook
#MaxHotkeysPerInterval 1000

CoordMode, Tooltip, Screen
CoordMode, Mouse, Screen
Coordmode, Menu, Window
SetControlDelay, -1
SetKeyDelay, -1
SetBatchLines -1
Detecthiddenwindows, on
FileEncoding, utf-8
SendMode Input
ListLines Off
;Suspend, on
SetStoreCapslockMode, off

; 
;
;
AppName:="VimDesktop"
_Author:="BoBO"
v:="3.5.6.02"
FeedbackLink=https://www.kancloud.cn/funbobosky/vim_unity
HelpLink=https://www.kancloud.cn/funbobosky/vim_unity
FontSize:="30"
SleepTime=1000

; 颜色
color1=004073
color2=004073
color3=007310
color4=303030


; FileCreateDir,%AppDataLocal%\Vimdesktop
; FileCreateDir,%ProgramFilesDir%
; SetWorkingDir,%AppDataLocal%\Vimdesktop

; 修饰符设定
    N1:=new UMSS("Space","2")
    N2:=new UMSS("Capslock","2")
    N3:=new UMSS("Tab","2")
; 附属功能  
; 智能跳转 
;  Run, %A_ScriptDir%\advanced\smartJump.ahk

; ----------------------------------
#Include %A_ScriptDir%\lib\checkUser.ahk
#Include %A_ScriptDir%\lib\DownloadFile.ahk
#Include %A_ScriptDir%\lib\AutoExecute.ahk
#Include %A_ScriptDir%\lib\AutoUpdate.ahk
#Include %A_ScriptDir%\lib\FunBoBO.ahk
#Include %A_ScriptDir%\lib\TrayMenu.ahk
#Include %A_ScriptDir%\core\Main.ahk
#Include %A_ScriptDir%\core\class_vim.ahk
#Include %A_ScriptDir%\core\VimDConfig.ahk
#Include %A_ScriptDir%\lib\class_EasyINI.ahk
#Include %A_ScriptDir%\lib\acc.ahk
#Include %A_ScriptDir%\lib\ini.ahk
#Include %A_ScriptDir%\lib\gdip.ahk
#Include %A_ScriptDir%\lib\Logger.ahk
#Include %A_ScriptDir%\lib\Updater.ahk
#Include %A_ScriptDir%\lib\TrayMenu.ahk
#Include %A_ScriptDir%\lib\UMSS.ahk
#Include %A_ScriptDir%\lib\ImageButton.ahk
#Include %A_ScriptDir%\plugins\plugins.ahk
; 用户自定义配置yy
#Include *i %A_ScriptDir%\custom.ahk
; 动态加载|User|
QZ_UpdatePlugin()
SearchFileForKey(SelectedKeys,SelectedAction, SelectedDesc, true)
Sleep, 1000
#Include *i %A_ScriptDir%\User\plugins.ahk
return

