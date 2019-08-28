;Author:BoBO
;Version:20190308
;
;20190814   优化操作
;           新增对英文支持
;20190308   修正输入状态延迟
;20181114   修正activeType本地初始化
;20181102   修复载入渲染乱码显示！
;20181102   修正渲染附加组件无法使用，加入预加载列表.
;20181023   对接口路径做判断修复只能打开一次，主要涉及到脚本本身
;20181022   新增加对MaxScript的支持,采用第3方接口MXSPyCOM.exe,配置
;           %A_ScriptDir%\custom\maxScripts\initialize_COM_server.ms 拷贝到...3ds Max 2014\scripts\Startup
;20180920   新增输入状态屏蔽功能
;20180919   新增activeType设置快捷为Ctrl+Shift+Alt+C
;;Windows Groups
;   
;            runPath = startObjectCreation box 创建对象 可拉扯
;            run2MaxScript(runPath)
;   
;提前运行


;待解决
;1.Octopus本地化
;2 http://www.scriptspot.com/3ds-max/scripts/dropbox看使用率在集成
;3.IKMAX本地化


;;3ds Max
;#IfWinActive ahk_group 3DsMax
;;Windows Groups
; GroupAdd, 3DsMax, ahk_class 3DsMax
; GroupAdd, MatEditor,Material Editor
; GroupAdd, 3DsMax, ahk_class AutoHotkeyGUI
;;3ds Max
;#IfWinActive ahk_group 3DsMax
3DsMax:

    vim.SetAction("<3DsMax_NormalMode>", "返回正常模式")
    vim.SetAction("<3DsMax_InsertMode>", "进入VIM模式")
    vim.SetWin("3DsMax","ahk_exe","3DsMax.exe")
    vim.BeforeActionDo("3DsMax_CheckMode","3DsMax")
    #include %A_ScriptDir%\plugins\3DsMax\3DsMaxComment.ahk   
 
;normal模式
    vim.SetMode("normal","3DsMax")
    vim.Map("<insert>","<3DsMax_InsertMode>","3DsMax")
;insert模式
    vim.SetMode("insert", "3DsMax")
    vim.Map("<esc>","<3DsMax_NormalMode>","3DsMax")
    #include %A_ScriptDir%\plugins\3DsMax\3DsMaxKey.ahk
    ;#include %A_ScriptDir%\plugins\3DsMax\3DsMaxPlus.ahk
return


;检测
3DsMax_CheckMode(){
    ControlGetFocus, ctrl, A
    if RegExMatch(ctrl, "i)Edit")||RegExMatch(ctrl, "i)MXS_Scintilla")||RegExMatch(ctrl, "i)EDITDUMMY")||RegExMatch(ctrl, "i)WindowsForms10")||RegExMatch(ctrl, "i)ComboBox") ;  or WinExist("ahk_class MXS_SciTEWindow")) ;|| RegExMatch(ctrl, "i)MXS_Scintilla1")
    return true
    return false
}

;预加载
3DsMax_StartupRun(){
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\lib\setEvn.ms  ; 设置脚本新目录
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\Startup\R8D_WriteICON.ms
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\Startup\r8d4.ms
return
}

<3DsMax_Vim>:
FunBoBO_VimShow()
return

; <3DsMax_InsertMode>:
;     vim.SetMode("insert","3DsMax")
;     MsgBox, 0, 提示, 【VIM模式】, 0.5
; return

; <3DsMax_NormalMode>:
;     ; Send, {Esc}
;     ; GoSub, <SwitchToEngIME>
;     vim.SetMode("normal","3DsMax")
;     MsgBox, 0, 提示, 【正常模式】, 0.5
; return

;【全局运行Max】
; <Run3DsMax>:
;     3DsMax_StartupRun()
;     MaxPath := ini.BOBOPath_Config.MaxPath
;     3DsMax_Class := ini.ahk_class_Config.3DsMax_Class
;     DetectHiddenWindows, on
;     IfWinNotExist MaxPath 3DsMax_Class 
;     { 
;    		Run %MaxPath%
;     	WinActivate 
;     } 
;     	Else IfWinNotActive ahk_class 3DsMax_Class 
;     { 
;     	WinActivate
;     } 
;     Else 
;     { 
;         WinMinimize 
;     } 
;  Return

<Run3DsMax>:
    ExePath := ini.BOBOPath_Config.MaxPath
    tClass := ini.ahk_class_Config.3DsMax_Class
    FunBoBO_RunActivation(ExePath,tClass)
 return

<3DsMax_NormalMode>:
;   send,{esc}
    vim.SetMode("normal", "3DsMax")
    MsgBox, 0, 提示, 【正常模式】, 0.5
return

<3DsMax_InsertMode>:
;   send,{esc}
    vim.SetMode("insert", "3DsMax")
    3DsMax_StartupRun()
    MsgBox, 0, 提示, 【VIM模式】, 0.5
return
;辅助帮助显示
<3DsMax_Help>:
FunBoBO_ShowLayout("ae3DsMax1.png")
KeyWait i
FunBoBO_HideLayout()
return

;基本操作
<3DsMax_Save>:
{
    Send,^s
}
return
<3DsMax_Open>:
{
    Send,^o
}
return
<3DsMax_SaveAs>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\SaveAs.ms 
}
return
<3DsMax_Exit>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\Exit.ms 
}
return
<3DsMax_Archive>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\Archive.ms 

}
return
<3DsMax_Reset>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\Reset.ms 
}
return

<3DsMax_Import>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\Import.ms 
}
return
<3DsMax_Export>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\Export.ms 
}
return

<3DsMax_displayFloater>:
{
    ;显示
    getMaxScriptCommands("displayFloater.ms")
}
return

<3DsMax_attachSelection>:
{
    ;所选物体塌陷
    getMaxScriptCommands("attachSelection.ms")
}
return

<3DsMax_copyModifiers>:
{
    ;拷贝Modifiers
    getMaxScriptCommands("copyModifiers.ms")
}
return
<3DsMax_pasteCopyModifiers>:
{
    ;粘贴Modifiers
    getMaxScriptCommands("pasteCopyModifiers.ms")
}
return

<3DsMax_convertToPoly>:
{
    ;转成Poly
    getMaxScriptCommands("convertToPoly.ms")
}
return
<3DsMax_convertToMesh>:
{
    ;转成Mesh
    getMaxScriptCommands("convertToMesh.ms")
}
return
<3DsMax_convertToSpline>:
{
    ;转成Spline
    getMaxScriptCommands("convertToSpline.ms")
}
return
;end
<3DsMax_CloseAllUI>:
{
    WinClose, Measure
	WinClose, Display Floater
	WinClose, Layer: 
	WinClose, Transform Type-In
	WinClose, Material Editor -
	WinClose, Slate Material Editor 
	WinClose, Render Setup: 
	WinClose, Scene Explorer -
	WinClose, materialByName
	WinClose, LPM v2.00 
    return
}
;轴操作
<3DsMax_PivotCenter>:
    getMaxScriptCommands("PivotCenter.ms")
return
<3DsMax_PivotReset>:
    getMaxScriptCommands("PivotReset.ms")
return
<3DsMax_PivotRotate>:
    getMaxScriptCommands("PivotRotate.ms")
return
<3DsMax_PivotSet>:
    getMaxScriptCommands("PivotSet.ms")
return

;双按操作
<3DsMax_Double_Z>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_z, %t%
    if (t == "off")
    goto 3DsMax_double_z
    return

    3DsMax_tappedkey_z:
    Send z
    return

    3DsMax_double_z:
    Send, ^+z
    return
}
 Return


<3DsMax_Double_O>:
{

    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, o
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,^{s}
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, o, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send ^{o}
            return
        }
    else
        {
            send {o}
            return
        }
    return

}
Return

<3DsMax_Double_I>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, i
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        runPath = unhide objects
        run2MaxScript(runPath)
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, i, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            getMaxScriptCommands("IsolateSelection.ms")
            return
        }
    else
        {
            send {i}
            return
        }
    return


}
Return

<3DsMax_Space>:
{
    ; send,{Space}
    send,{/}
    return
}

<3DsMax_Double_P>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_p, %t%

    if (t == "off")
    goto 3DsMax_double_p
    return

    3DsMax_tappedkey_p:
        Send, p
    return

    3DsMax_double_p:
        getMaxScriptCommands("commandPlanel.ms")
    return  
}
return

<3DsMax_Double_Q>:
{

    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, q
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        WinClose, Measure
        WinClose, Display Floater
        WinClose, Layer: 
        WinClose, Transform Type-In
        WinClose, Material Editor -
        WinClose, Slate Material Editor 
        WinClose, Render Setup: 
        WinClose, Scene Explorer -
        WinClose, materialByName
        WinClose, LPM v2.00 
        return
    }
    KeyWait, q, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            Send,+q
            return
        }
    else
        {
            send {q}
            return
        }
    return
}
Return



<3DsMax_Double_W>:
{

    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, w
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; Send,^{s}
        return
    }
    KeyWait, w, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            getMaxScriptCommands("MaximizeViewport.ms")
            return
        }
    else
        {
            send {w}
            return
        }
    return
    ; t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    ; settimer, 3DsMax_tappedkey_w, %t%
    ; if (t == "off")
    ; goto 3DsMax_double_w
    ; return

    ; 3DsMax_tappedkey_w:
    ;     Send,w
    ; return

    ; 3DsMax_double_w:
    ;     getMaxScriptCommands("MaximizeViewport.ms")
    ; return
}
<3DsMax_Double_D>:
{
    ; 复制粘贴|删除
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, d
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,{Delete}
        return
    }
    KeyWait, d, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send ^{c}
            sleep 100
            send ^{v}
            return
        }
    else
        {
            send {d}
            return
        }
    return
}

<3DsMax_Double_0>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_0, %t%
    if (t == "off")
    goto 3DsMax_double_0
    return

    3DsMax_tappedkey_0:
        Send,0
    return

    3DsMax_double_0:
        getMaxScriptCommands("XYZ_0.ms")
    return
}




<3DsMax_Double_X>:
{
    ; 搜索|ActiveType|删除
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, x
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,{Delete}
        return
    }
    KeyWait, x, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\activeType.ms 
            return
        }
    else
        {
            send {x}
            return
        }
    return
}
Return
<3DsMax_Tab>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\activeType.ms 
    return  
}


<3DsMax_Double_Y>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_y, %t%
    if (t == "off")
    goto 3DsMax_double_y
    return

    3DsMax_tappedkey_y:
    Send {y}
    return

    3DsMax_double_y:
    Send, ^!+{y}
    return
}
Return


<3DsMax_Double_S>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_s, %t%
    if (t == "off")
    goto 3DsMax_double_s
    return

    3DsMax_tappedkey_s:
    Send {s}
    return

    3DsMax_double_s:
    Send, ^{s}
    return
}
Return

<3DsMax_Double_F9>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, 3DsMax_tappedkey_F9, %t%
    if (t == "off")
    goto 3DsMax_double_F9
    return

    3DsMax_tappedkey_F9:
    Send {F9}
    return

    3DsMax_double_F9:
    Send, {F10}
    return
}
Return

;发送ESC
<3DsMax_esc>:
{
    Send, {Esc}
;    MsgBox
}


;播放暂停
<3DsMax_Numpad0>:
{
    Send, /
}
Return

; Scrolllock::
; Suspend,Toggle
; Return

; +Scrolllock::
; reloadgg
; return

<3DsMax_activeType>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\activeType.ms 
}
Return

;动作保存模块
; <3DsMax_saveAniTime>:
; {
;     run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\saveAniTime.ms 
;     return
; }

;批渲染脚本
<3DsMax_render8Direction>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\Render8Direction.ms
    return
}
;
<3DsMax_maxToTotalcmd>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\maxToTotalcmd.ms
    return
}
<3DsMax_Renderlayers>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\BatchRender.ms
    return
}

;功能性脚本

<3DsMax_Double_E>:
{
    ; 缩放
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, e
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; Send,^{s}
        return
    }
    KeyWait, e, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            runPath = rotate $ (angleaxis 90 [0,0,1])
            run2MaxScript(runPath)
            return
        }
    else
        {
            send {e}
            return
        }
    return
}

;#Include,%A_ScriptDir%\plugins\3DsMax\3DsMaxPlus.ahk
; 只在3DsMax界面上生效的热键，这个就只是在max的Label1窗口起作用，
; 在其他地方6还是6，
; #If ActiveControlIs("Label1")
; 6::Send {F5}
; 7::MsgBox
; #If

; ActiveControlIs(Control) {
;     ControlGetFocus, FocusedControl, A
;     return (FocusedControl=Control)
; }

;位置坐标操作
;物体归00点
<3DsMax_maxPos>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\XYZ_0.ms
    return
}
;坐标归物体00点
<3DsMax_maxXYZ>:
{
    run, %A_ScriptDir%\custom\maxScripts\MXSPyCOM.exe -f %A_ScriptDir%\custom\maxScripts\commands\XYZ_Z.ms
    return 
}


;更新
<3DsMax_UpDater>:
Gui,Updating: +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui,Updating: Color, %color2%
Gui,Updating: Font,cwhite s%FontSize% wbold q5,Segoe UI
Gui,Updating: Add, Text, ,%_MaxUpdating%
Gui,Updating: Show,AutoSize Center NoActivate
UrlDownloadToFile, %UrlDownloadToFile_Ae1%, %A_ScriptDir%\plugins\3DsMax\latest-3DsMax.ahk ;

if ErrorLevel
{
    Gosub, MaxExitUpdater
}
Else
{
    FileMove,%A_ScriptDir%\plugins\3DsMax\latest-3DsMax.ahk, %A_ScriptDir%\plugins\3DsMax\3DsMax.ahk,1
    Gosub, MaxExitUpdater
}
return

MaxExitUpdater:
FileDelete, %A_ScriptDir%\plugins\3DsMax\latest-3DsMax.ahk
sleep %SleepTime%
Gui,Updating: Hide
Gui,Updating2: +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui,Updating2: Color, %color3%
Gui,Updating2: Font,cwhite s%FontSize% wbold q5,Segoe UI
Gui,Updating2: Add, Text, ,%_UpdateCompleted%
Gui,Updating2: Show,AutoSize Center NoActivate
sleep %SleepTime%
Gui,Updating2: Hide
Run,%A_ScriptDir%\Vimd.exe
Return

; 待整合功能
; lshift & escape::send,{f12}
; +z::
; test2 =try(filein @"D:\3d插件\轮廓.ms")catch()
; ControlFocus, MXS_Scintilla2
; ControlSetText, MXS_Scintilla2, %test1%
; send, +{Enter}
; Return
; lalt & Escape::
; test1 =max move
; ControlFocus, MXS_Scintilla2
; ControlSetText, MXS_Scintilla2, %test1%
; send, +{Enter}
; Return
; ^+!R::
; test =actionMan.executeAction -43434444 "4096"  -- Render: Batch Render Dialog Toggle
; ControlFocus, MXS_Scintilla2
; ControlSetText, MXS_Scintilla2, %test%
; send, +{Enter}
; Return
; +f1::send,{f10}
; f1::send,!+^{pgup}
; f2::send,!+^{pgdn}
; space & v::
; send,+^!v
; return
; space & c::
; send,+^!c
; return
; space & e::
; send,+^!e
; return
; space & b::
; send,+^!b
; return
; space & n::
; send,+^!n
; return
; space & q::
; send,+^!q
; return
; space & w::
; send,+^!w
; return
; space & a::
; send,+^!a
; return
; space & g::
; send,+^!g
; return
; space & m::
; send,+^!m
; return
; space & l::
; send,+^!l

; 只在3dsmax界面上生效的热键，这个就只是在max的Label1窗口起作用，
; 在其他地方6还是6，
; #If ActiveControlIs("Label1")
; 6::Send {F5}
; 7::MsgBox
; #If

; ActiveControlIs(Control) {
;     ControlGetFocus, FocusedControl, A
;     return (FocusedControl=Control)
; }
; ---长按鼠标左键后操作-----------------------------------------------------------------------

;按左鍵再按d | 向下合并

; ~LButton & d:: 
; WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
; tool_pathandname = "%activePath%"
; KeyWait, LButton

;     getMaxScriptCommands("XYZ_0.ms")

; return
;~LButton & d:: 
; WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
; tool_pathandname = "%activePath%"
; KeyWait, LButton

; ;執行腳本
; getMaxScriptCommands("duplicateBase.ms")
;~return
;清楚材质
;for o in $ do (o.material = undefined)
;macros.run "PolyTools" "TransformTools"