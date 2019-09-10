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

global Workflows_update_version:="3.5.6.02"
global githubUrl:="https://raw.githubusercontent.com"
; global giteeUrl:="https://gitee.com"
; global RunAnyGiteeDir:="/hui-Zz/RunAny/raw/master"
global GithubDir:="/BoBOVFX/Vimdesktop/master"
global lpszUrl:=githubUrl
global WorkflowsDownDir:=lpszUrl . GithubDir
	if(A_DD=01 || A_DD=15){
		;当天已经检查过就不再更新
		if(FileExist(A_Temp "\temp_vimd.ahk")){
			FileGetTime,tempMTime, %A_Temp%\temp_vimd.ahk, M  ; 获取修改时间.
			t1 := A_Now
			t1 -= %tempMTime%, Days
			FormatTime,tempTimeDD,%tempMTime%,dd
			if(t1=0 && (tempTimeDD=01 || tempTimeDD=15))
				return
		}
		Gosub,Auto_Update
	}

FeedbackLink=https://www.kancloud.cn/funbobosky/vim_unity
HelpLink=https://www.kancloud.cn/funbobosky/vim_unity
FontSize:="30"
SleepTime=1000 ; 消失时间

; 定义颜色
color1=004073
color2=004073
color3=007310
color4=303030

; 修饰符设定
N1:=new UMSS("Space","2")
N2:=new UMSS("Capslock","2")
N3:=new UMSS("Tab","2")
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

