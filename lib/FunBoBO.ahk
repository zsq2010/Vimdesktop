;定义启动1
FunBoBO_HideOrActivation1(ExePath,tClass) {
	IfWinNotExist,ahk_class %tClass%
	Run,"%ExePath%"
	IfWinActive
	WinMinimize
	else
	WinActivate
	return
}
;定义启动2
FunBoBO_HideOrActivation2(ExePath,tClass) {
    DetectHiddenWindows, on
    IfWinNotExist %ExePath% %tClass%
    { 
   		Run %ExePath% ;
    	WinActivate 
    } 
    	Else IfWinNotActive ahk_class %tClass%
    { 
    	WinActivate
    } 
    Else 
    { 
        WinMinimize 
    } 
}
FunBoBO_RunActivation(ExePath,tClass){
    IfWinExist, AHK_CLASS %tClass%
    {
        WinGet, AC, MinMax, AHK_CLASS %tClass%
        if Ac = -1
            Winactivate, AHK_ClASS %tClass%
        else
            Ifwinnotactive, AHK_CLASS %tClass%
                Winactivate, AHK_CLASS %tClass%
            else
                Winminimize, AHK_CLASS %tClass%
    }
    else
    {
        Run, %ExePath%
        Loop, 4
        {
            IfWinNotActive, AHK_CLASS %tClass%
                WinActivate, AHK_CLASS %tClass%               
            else
                Break
            Sleep, 500
        }
} 
        ;设置启动后隐藏TC标题栏
;        WinSet, Style, ^0xC40000 , ahk_class TTOTAL_CMD
;        SendPos(540)
        ;设置最大化左窗口即设置为单窗口（显示左）
;        Sleep,500
         ;~ WinMaxLR(true)
}
;双按函数束-BoBO
;使用方式

;FunBoBO_Double(Name,Var)
;   Name_double_Var_1()
;   Name_double_Var_2()
;return

;显示函数---------------------------------------
FunBoBO_VimShow(){
    run,%A_ScriptDir%\apps\HuntAniidPeck\hap.exe /hint
    return
}
FunBoBO_ShowLayout(img){
	;ShowLayout:
		Gui,ShowLayout:Add,pic,Center,%A_ScriptDir%\ui\%img% 
		Gui,ShowLayout:+LastFound +AlwaysOnTop -Caption ; +ToolWindow -DPIScale
		Gui,ShowLayout:Show,Center NoActivate
        WinSet, Transparent, 250
		;WinSet, TransColor,f0f0f0 ;去掉灰色边框
	Return
}
;隐藏iiiiiiii
FunBoBO_HideLayout(){
	;HideLayout:
	Gui,ShowLayout:Hide
	return
}
;显示图片函数结束---------------------------------------

;在窗口内点击坐标
CoordWinClick(x,y){
	CoordMode, Mouse, Relative
;	WinGetPos, X, Y, W, H, A
	ControlClick, x%x% y%y%,,,,, Pos
	return
}
;无视输入法状态发送字符串
;其实还有一种方法，就是把字符串赋值给粘贴板，然后粘贴
uStr(str)
{
    charList:=StrSplit(str)
	SetFormat, integer, hex
    for key,val in charList
    out.="{U+ " . ord(val) . "}"
	return out
}


;获取当前目录
FunBoBO_CustomFunc_getCurrentDir(ByRef CurWinClass="")
{
    if CurWinClass=
    {
        WinGetClass, CurWinClass, A
        sleep 50
    }
    ;获取当前目录
    ;CurWinClass:=QZData("winclass") ;将获取的class名赋值给用户变量
    ;Curhwnd:=QZData("hWnd")
    if CurWinClass in ExploreWClass,CabinetWClass ;如果当前激活窗口为资源管理器
    {
        DirectionDir:=FunBoBO_Explorer_GetSelected(Curhwnd)
        IfInString,DirectionDir,`;		;我的电脑、回收站、控制面板等退出
            return
    }
    if CurWinClass in WorkerW,Progman    ;如果当前激活窗口为桌面
    {
        DirectionDir:=FunBoBO_Explorer_GetSelected(Curhwnd)
    }
    if (CurWinClass="Shell_TrayWnd") ;如果当前激活窗口为任务栏
        DirectionDir:=""

    if CurWinClass in TTOTAL_CMD ;如果当前激活窗口为TC
    {
        IfWinNotActive ahk_class TTOTAL_CMD
        {
            Postmessage, 1075, 2015, 0,, ahk_class TTOTAL_CMD	;最大化
            WinWait,ahk_class TTOTAL_CMD
            WinActivate
        }
        Postmessage, 1075, 332, 0,, ahk_class TTOTAL_CMD	;光标定位到焦点地址栏
        sleep 300
        ;PostMessage,1075,2029,0,,ahk_class TTOTAL_CMD ;获取路径
        PostMessage,1075,2018,0,,ahk_class TTOTAL_CMD ;获取路径2
        sleep 100
        DirectionDir:=Clipboard
    }
    If(DirectionDir="ERROR")		;错误则退出
        DirectionDir:=""
    
    return DirectionDir
}

FunBoBO_Explorer_GetPath(hwnd="")
{
	if !(window := FunBoBO_Explorer_GetWindow(hwnd))
		return ErrorLevel := "ERROR"
	if (window="desktop")
		return A_Desktop
	path := window.LocationURL
	path := RegExReplace(path, "ftp://.*@","ftp://")
	StringReplace, path, path, file:///
	StringReplace, path, path, /, \, All
	loop
		if RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, path, path, `%%hex%, % Chr("0x" . hex), All
		else break
	return path
}

FunBoBO_Explorer_GetWindow(hwnd="")
{
	WinGet, Process, ProcessName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
	WinGetClass class, ahk_id %hwnd%

	if (Process!="explorer.exe")
		return
	if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows
			if (window.hwnd==hwnd)
				return window
	}
	else if (class ~= "Progman|WorkerW")
		return "desktop" ; desktop found
}

FunBoBO_Explorer_GetSelected(hwnd="")  
{  
    return FunBoBO_Explorer_Get(hwnd,true)  
}  

FunBoBO_Explorer_Get(hwnd="",selection=false)  
{  
    if !(window := FunBoBO_Explorer_GetWindow(hwnd))  
        return ErrorLevel := "ERROR"  
    if (window="desktop")  
    {  
        ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman  
        if !hwWindow ; #D mode  
            ControlGet, hwWindow, HWND,, SysListView321, A  
        ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%  
        base := SubStr(A_Desktop,0,1)=="\" ? SubStr(A_Desktop,1,-1) : A_Desktop  
        Loop, Parse, files, `n, `r  
        {  
            path := base "\" A_LoopField  
            IfExist %path% ; ignore special icons like Computer (at least for now)  
                ret .= path "`n"  
        }  
    }  
    else  
    {  
        if selection  
            collection := window.document.SelectedItems  
        else  
            collection := window.document.Folder.Items  
        for item in collection  
            ret .= item.path "`n"  
    }  
    return Trim(ret,"`n")  
}  

;AeScript调用函数_ByBoBO
;20181207
;函数getAeScript(Path)
getAeScript(AeScriptPath){
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    run, %comspec% /c %tool_pathandname% -s -ro %AeScriptPath% ,,Hide
    return
}

runMax(runPath){
    ;tempStr := "filein """ . A_LoopFileFullPath . """"
    runPath = %A_ScriptDir%\custom\maxScripts\initialize_COM_server.ms
    tempStr := "filein """ . %runPath% . """"
    StringReplace, tempStr, tempStr, `\, `\`\, ALL
    Control, EditPaste, %tempStr%, MXS_Scintilla2, A
    ControlSend, MXS_Scintilla2, {NumpadEnter}, A
    return
}

;;运行函数
getMaxScriptCommands(MaxScriptPath){
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\%MaxScriptPath%
    return
}

;;测试运行函数
get2MaxScript(runPath){
    ;tempStr := "filein """ . A_LoopFileFullPath . """"
    ;runPath = %A_ScriptDir%\custom\maxScripts\initialize_COM_server.ms
    tempStr := "filein """ . %runPath% . """"
    StringReplace, tempStr, tempStr, `\, `\`\, ALL
    Control, EditPaste, %tempStr%, MXS_Scintilla2, A
    ControlSend, MXS_Scintilla2, {NumpadEnter}, A
    return
}

run2MaxScript(runPath){
ControlFocus, MXS_Scintilla2
ControlSetText, MXS_Scintilla2, %runPath%
send, +{Enter}
Click 1
Return
}
;;Photoshop运行函数
runPsScript(PsPath){
    app:=ComObjCreate("Photoshop.Application")
    app.DoJavaScriptFile(%PsPath%)
    return
}

; 运行自定义标题
FunBoBO_RunActivationTitle(ExePath,tClass,NewTitle){
    IfWinExist, AHK_CLASS %tClass%
    {
        WinGet, AC, MinMax, AHK_CLASS %tClass%
        if Ac = -1
            Winactivate, AHK_ClASS %tClass%

        else
                Ifwinnotactive, AHK_CLASS %tClass%
                Winactivate, AHK_CLASS %tClass%
            else
                Winminimize, AHK_CLASS %tClass%
    }
    else
    {
        Run, %ExePath%
        Loop, 4
        {
            IfWinNotActive, AHK_CLASS %tClass%
                WinActivate, AHK_CLASS %tClass%        
            else
                Break
            Sleep, 500
        }
    } 

    SetTitleMatchMode, regex

    IfWinExist, ahk_class %tClass%,,2
    WinSetTitle, %NewTitle% ; %N_Title%

return
}

Morse(timeout = 400) {
   tout := timeout/1000
   key := RegExReplace(A_ThisHotKey,"[\*\~\$\#\+\!\^]")
   Loop {
      t := A_TickCount
      KeyWait %key%
      Pattern .= A_TickCount-t > timeout
      KeyWait %key%,DT%tout%
      If (ErrorLevel)
         Return Pattern
   }
}

setzh(){
		PostMessage, 0x50, 0, 0x8040804, , A
		if !IME_GET0E1C()
			SendInput, {LShift}
		return
}
seten(){
	if IME_GET0E1C()
		SendInput, {LShift}
return
}

IME_GET0E1C(WinTitle="A"){			;借鉴了某日本人脚本中的获取输入法状态的内容,减少了不必要的切换,切换更流畅了
    ;~ ifEqual WinTitle,,  SetEnv,WinTitle,A
    WinGet,hWnd,ID,%WinTitle%
    DefaultIMEWnd := DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)

    ;Message : WM_IME_CONTROL  wParam:IMC_GETOPENSTATUS
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, 0x005,0,,ahk_id %DefaultIMEWnd%
    DetectHiddenWindows,%DetectSave%
    Return ErrorLevel
}

varExist(ByRef v) { ; 检测变量是否存在
   return &v = &n ? 0 : v = "" ? 2 : 1 
}