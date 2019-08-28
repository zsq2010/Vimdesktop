;Author:BoBO
;Version:2.0
;
;####################\\\使用本脚本请在双按zz下使用，效果最佳，否则会有点影响使用///////####################
;更新内容
;2019-08-28 正式提升2.0版本 优化细节 操作更舒服！
;2019-05-07 新增修改选择按键  选择:空格+w 手势平移:空格+w 长按
;2019-03-08 修复打字卡顿
;2019-02-15 1.正式引如F1超强辅助
;           2.删除dd.图层按'dd'删除(帧/效果/表达式/遮罩)& 重置(Transfrom&All)集成F1 操作更人性化
;           3.新增操作11整理素材
;
;2018-12-20 编辑与Space相关操作
;2018-12-11 引入UMSS函数,
;           主要作用引入修饰符作组合
;2018-12-10 引入全局快捷函数
;2018-12-07 封装Ae调用函数使用方式
;           getAeScriptPath =
;           getAeScript(getAeScriptPath)
;2018-12-04 新增双按8循环模式
;           新增自动遮罩分层
;2018-11-19 对图层按'dd'删除(帧/效果/表达式/遮罩)& 重置(Transfrom&All)
;2018-10-25 1.移植Ae脚本到VIMD，已经把常用功能移植到.
;           2.新增操作"/0-5" 打开|保存|最近打开|导入|退出|操作
;           3.优化使用频率 v系组合调整 vcc创建固态 vcn创建合成组
;2018-10-24 新增加zz窗口最大化功能，新增加此功能为了ahk调用脚本时窗口会缩放无法最大化严重影响体验，查阅Google目前还无法解决，但
;           好在窗口最大化环境下可以完美使用，下个版本将把脚本移动本地化运行，实现便携式.
;2018-09-20 新增加输入状态屏蔽功能
;
;功能备忘录
;
;1.一键刷新素材
;
;SetCapsLockState, AlwaysOff
;
AfterEffects:

    vim.SetAction("<AfterEffects_NormalMode>", "返回正常模式")
    vim.SetAction("<AfterEffects_InsertMode>", "进入VIM模式")
    vim.SetWin("AfterEffects","ahk_exe","AfterFX.exe")
    vim.BeforeActionDo("AE_CheckMode", "AfterEffects")

    #Include %A_ScriptDir%\plugins\AfterEffects\AfterEffectsComment.ahk 
    
;normal模式
    vim.SetMode("normal", "AfterEffects")
    vim.map("<insert>","<AfterEffects_InsertMode>","AfterEffects")
;insert模式
    vim.SetMode("insert", "AfterEffects")
    vim.Map("<esc>", "<AfterEffects_NormalMode>", "AfterEffects")
    ;载入顺序不能兑换否则会引起不良反应
    #Include %A_ScriptDir%\plugins\AfterEffects\AfterEffectsKey.ahk
    ;#Include %A_ScriptDir%\plugins\AfterEffects\AfterEffectsPlus.ahk
    ;#Include %A_ScriptDir%\plugins\AfterEffects\AfterEffectsFun.ahk

return

;判断输入状态屏蔽
AE_CheckMode(){
	ControlGetFocus, ctrl, A
	If RegExMatch(ctrl,"i)Edit")
		return True
    If (A_Cursor=="IBeam") ;工字光标
        return True
	return False

}
<AeVim>:
FunBoBO_VimShow()
return
<AE_热键帮助>:  ;{
;    QZ_VIMD_ShowKeyHelp()
return
;}

<AeSpace>:
send,{Space}
return


<HelpAe>:
; FunBoBO_ShowLayout("aeHelp1.png")
; KeyWait i
; FunBoBO_HideLayout()
AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\Help.jsx
getAeScript(AeScriptPath)
return


;【全局运行AE】
<RunAE>:
    ExePath := ini.BOBOPath_Config.AEPath
    tClass := ini.ahk_class_Config.AEClass
    FunBoBO_RunActivation(ExePath,tClass)
 Return

<AfterEffects_NormalMode>:
;   send,{esc}
    vim.SetMode("normal", "AfterEffects")
    MsgBox, 0, 提示, 【正常模式】, 0.5
return

<AfterEffects_InsertMode>:
;   send,{esc}
    vim.SetMode("insert", "AfterEffects")
    MsgBox, 0, 提示, 【VIM模式s】, 0.5
return

; <Ae_Remove>:
;     send, ^+{e}
; return

;基本
<Ae_Open>:
{
    send,^o
    return
}
<Ae_OpenRecent>:
{
    send,^!+p
    return
}
<Ae_Save>:
{
    send,^s
    return
}
<Ae_SaveAs>:
{
    send,^+s
    return
}
<Ae_Import>:
{
    send,^i
    return
}
<Ae_Exit>:
{
    send,^q
    return
}

<Ae_CllectFiles>:
{
    AeScriptPath = app.executeCommand(2482);
    getAeScript(AeScriptPath)
    return
}

<Ae_AllMemoryDisk>:
{
    AeScriptPath = app.executeCommand(10200);
    getAeScript(AeScriptPath)
    return
}

<Ae_SwitchLabel>:
DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, s
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,^{w}
        return
    }
    KeyWait, s, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
            tool_pathandname = "%activePath%"
            send !+{<}
            return

        }
    else
        {
            WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
            tool_pathandname = "%activePath%"
            send !+{>}
            return
        }
return




;新建
<AfterEffects_新建合成>:
    send, ^n
return

<AfterEffects_固态层>:
    send, ^y
return

<AfterEffects_调节层>:
    send, ^!y
return

<AfterEffects_Null>:
    send, ^!+y
return

<AfterEffects_优化合成时间>:
    send, ^+x
Return

<AfterEffects_渲染输出>:
    send, ^m
Return

<AfterEffects_QuickMenu>:
    send, ^!6
return

<AfterEffects_我的工具>:
    send, ^!7
return

;面板

<Ae_ui_y>:
{
    return
}
return
; Double组


; Double_K 合成设置
; #if WinActive("ahk_class Qt5QWindowIcon")
<Ae_Double_0>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, 0
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ;Null Command
        return
    }
    KeyWait, 0, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\resetTransformations.jsx
        getAeScript(AeScriptPath)
        return
    }

    else
    {
        send, {0}
        return
    } 
}
<Ae_Double_1>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, 1
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\OrganizeProjectAssets.jsxbin
        getAeScript(AeScriptPath)
        sleep 500
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\deleteDiskCache.jsx
        getAeScript(AeScriptPath)
        return
    }
    KeyWait, 1, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            Send, {Home}
            return
        }
    else
        {
            Send, {PgUp}
            return
        }
return
}
<Ae_Double_2>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, 2
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; Send,{Delete}
        ; Click 1
        return
    }
    KeyWait, 2, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            Send, {End}
            return
        }
    else
        {
            Send, {PgDn}
            return
        }
return
}
<Ae_Double_8>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, ae_tappedkey_8, %t%
    if (t == "off")
    goto ae_double_8
    return

    ae_tappedkey_8:
    Send, 8
    return

    ae_double_8:
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\(BOBOToolsFunctions)\LoopMaker.jsx
        getAeScript(AeScriptPath)
    return
}
<Ae_Double_F9>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, ae_tappedkey_F9, %t%
    if (t == "off")
    goto ae_double_F9
    return

    ae_tappedkey_F9:
    Send, ^{m}
    return

    ae_double_F9:
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\(BOBOToolsFunctions)\SPRenderQueueTools.jsx
        getAeScript(AeScriptPath)
    return
}
Return

<Ae_Double_y>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, y
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,{Delete}
        Click 1
        return
    }
    KeyWait, y, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send, ^+{y}
            return

        }
    else
        {
           ; Send, y
           ;快速创建
            send, ^y
            sleep 100
            send {Enter}
            return
        }
return
}

<Ae_Double_h>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, h
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\layer_Lock.jsx
        getAeScript(AeScriptPath)
        Click 1
        return
    }
    KeyWait, h, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\layer_Solo.jsx
            getAeScript(AeScriptPath)
            return
        }
    else
        {
            AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\layer_Hides.jsx
            getAeScript(AeScriptPath)
            return
        }
return
}

<Ae_Double_w>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, w
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; send, ^{w}
        return
    }
    KeyWait, w, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            Send,w
            
            return

        }
    else
        {
            Send, v
            return
        }
}
Return

<Ae_Double_Ctrl>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, Ctrl
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; send, ^{w}
        return
    }
    KeyWait, Ctrl, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            AeScriptPath = %A_ScriptDir%\\custom\\ae_scripts\add_keys.jsx 
            getAeScript(AeScriptPath)
            return
        }
    else
        {
            return
        }
}
Return
<Ae_Double_Shift>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, Shift
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; send, ^{w}
        return
    }
    KeyWait, Shift, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send +{F3}
            return

        }
    else
        {
           ; Send ctrl
            return
        }
}
Return

<Ae_Double_d>:

    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, d
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,{Delete}
        Click 1
        return
    }
    KeyWait, d, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            Send,^{d}
            
            return

        }
    else
        {
            Send, d
            return
        }
return

<Ae_Double_k>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, ae_tappedkey_k, %t%
    if (t == "off")
    goto ae_double_k
    return

    ae_tappedkey_k:
    Send, k
    return

    ae_double_k:
    send, ^k
    return
}
Return

; Double_Q 渲染输出
; #if WinActive("ahk_class Qt5QWindowIcon")
<Ae_Double_q>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, q
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; send, ^k
        return
    }
    KeyWait, c, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send, ^m
            return

        }
    else
        {
            Send {q}
            return
        }
    ; t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    ; settimer, ae_tappedkey_q, %t%
    ; if (t == "off")
    ; goto ae_double_q
    ; return

    ; ae_tappedkey_q:
    ; Send {q}
    ; return

    ; ae_double_q:
    ; send, ^m
    return
}
Return

; Double_C 合成组
<Ae_Double_c>:
{

    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, c
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        send, ^k
        return
    }
    KeyWait, c, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
               send,^+c
            return

        }
    else
        {
            Send, ^n
            return
        }
return

}
Return


<Ae_Double_x>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, x
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
            MsgBox, 4,, 危险操作 清除当前所有特效 继续? (press Yes or No)
            IfMsgBox Yes
            {
                ToolTip, 执行 清除...请稍后！
                sleep 100
                send, ^+{e}
                SetTimer, RemoveToolTip, -1000
                return
            }
            IfMsgBox No
            {
                return
            }
        ; 删除所有效果
        
        return
    }
    KeyWait, x, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            send, ^w
            return

        }
    else
        {
            Send,x
            return
        }
return

}
Return
; Double_z 最大化显示
<Ae_Double_z>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, ae_tappedkey_z, %t%
    if (t == "off")
    goto ae_double_z
    return

    ae_tappedkey_z:
    Send,z
    return

    ae_double_z:
    send, ^!\
    return
}
Return
; Double_o 打开
<Ae_Double_o>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, o
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,^{s}
        return
    }
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
    ; t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    ; settimer, ae_tappedkey_o, %t%

    ; if (t == "off")
    ; goto ae_double_o
    ; return

    ; ae_tappedkey_o:
    ; Send,o
    ; return

    ; ae_double_o:
    ; Send,^o
    ; return
}
Return
<Ae_Double_n>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'c' to be released
    KeyWait, n
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ;创建调节层
        send, ^!y
        return
    }
    KeyWait, n, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       

        ;创建新合成
        send, ^n
        return
    }

    else
    {
        send, ^y
        return
    } 
}
<Ae_Double_[>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, [
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ;Null Command
        return
    }
    KeyWait, [, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       
        send, {b}
        return
    }

    else
    {
        send, {[}
        return
    } 
}
<Ae_Double_]>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, ]
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ;Null Command
        return
    }
    KeyWait, ], % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       
        send, {n}
        return
    }
    else
    {
        send, {]}
        return
    } 
}
<Ae_Double_->:
{
    ; DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; KeyWait, -
    ; if (A_TimeSinceThisHotkey > DoubleClickTime) {
    ;     ;Null Command
    ;     return
    ; }
    ; KeyWait, -, % "d T"DoubleClickTime/1000
    ; If ! Errorlevel
    ; {       
    ;     ;Null Command
    ;     return
    ; }

    ; else
    ; {
        send, {,}
        return
    ;} 
}
<Ae_Double_=>:
{
    ; DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; KeyWait, =
    ; if (A_TimeSinceThisHotkey > DoubleClickTime) {
    ;     ;Null Command
    ;     return
    ; }
    ; KeyWait, =, % "d T"DoubleClickTime/1000
    ; If ! Errorlevel
    ; {       
    ;     send, {/}
    ;     return
    ; }
    ; else
    ; {
        send, {.}
        return
    ;} 
}
<Ae_Double_最小化>:
{   
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, ae_tappedkey_minimize, %t%

    if (t == "off")
    goto ae_double_minimize
    return

    ae_tappedkey_minimize:
    Send,-
    return

    ae_double_minimize:
    Send,!{Space}
    sleep 100
    Send,n
    return  
}

<Ae_LShift>:
WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
tool_pathandname = "%activePath%"
if (A_PriorHotkey <> "~LShift" or A_TimeSincePriorHotkey > 400) 
{ 
	KeyWait, LShift
	return 
} 
;執行腳本
send +{F3}
return

<Ae_LCtrl>:
; ~LCtrl::  
WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
tool_pathandname = "%activePath%"
if (A_PriorHotkey <> "~LCtrl" or A_TimeSincePriorHotkey > 400) 
{ 
	KeyWait, LCtrl
	return 
} 
;執行腳本
run, %comspec% /c %tool_pathandname% -ro %A_ScriptDir%\\custom\\ae_scripts\add_keys.jsx ,,Hide
return


; 长按

;長鍵add position key
<Ae_Press_p>:
{
    KeyWait,p
    if A_TimeSinceThisHotkey >= 300 ; in milliseconds.
    {
        send !+p
    }
    else
        send p
    return
}

;长按add scale key
<Ae_Press_s>:
{
    KeyWait,s
    if  A_TimeSinceThisHotkey >= 300  ; in milliseconds.
    {
        send !+s
    }
    else
        send s
    return
}

;长按add rotation key0
<Ae_Press_r>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'c' to be released
    KeyWait, r
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        send, !+r
        return
    }
    ; Wait for 'c' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, r, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\RevealLayerSourceInProject.jsx
        getAeScript(AeScriptPath)
        return
    }
    else
    {
        send, {r}
        return
    } 
    Return
}

;长按add opacity key
<Ae_Press_t>:
{
    KeyWait,t
    if A_TimeSinceThisHotkey >= 300 ; in milliseconds.
    {
        send, !+t
    }
    else
        send, t
    return
}
;按键
; <Ae_key_vh>:
; {
;     If (A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < 500)
; 		Send h
; 	else
; 		Send v
; 	return
; }


<Ae_Help3>:
{
Run,https://www.kancloud.cn/funbobosky/vimd_aftereffect
return
}


<ShowHelp2>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\ShowHelp2.jsx 
    getAeScript(AeScriptPath)
    return
}
<Ae_ReloadFootage>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\ReloadFootage.jsx
    getAeScript(AeScriptPath)
    return
}
;调用Script
<AfterEffects_全局控制初始化>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\Global.jsx
    getAeScript(AeScriptPath)
    return  
}
<Ae_Script_Render>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\(BOBOToolsFunctions)\SPRenderQueueTools.jsx 
    getAeScript(AeScriptPath)
    return  
}

<Ae_Script_BoboTools>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\02_BOBO_Tools.jsx 
    getAeScript(AeScriptPath)
    return
}

<Ae_Script_KeyBoard>:
{
    ; AeScriptPath = %A_ScriptDir%\custom\ae_scripts\01_Key-board.jsxbin
    ; getAeScript(AeScriptPath)
    return
}

<Ae_Script_QuickMenu>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\00_QuickMenu.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_Script_AEProject>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\AEProject.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_Script_batchFootage>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\batchFootage.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_Script_CompSetter>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\CompSetter.jsx
    getAeScript(AeScriptPath)
    return
}
<Ae_Script_AutoMatte>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\cz_AutoMatte.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_Script_GlobalRename>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\AEGlobalRenamer.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_OrganizeProjectAssets>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\OrganizeProjectAssets.jsxbin
    getAeScript(AeScriptPath)
    return
}
<Ae_ProjectCleaner>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\ProjectCleaner.jsx
    getAeScript(AeScriptPath)
    return
}


; 先按鼠标在按按键

; 图层模式切换
; ~LButton & d::
<Ae_differenceToggle>:
{
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton

    ;執行腳本
    run, %comspec% /c %tool_pathandname% -ro %A_ScriptDir%\\custom\\ae_scripts\differenceToggle.jsx ,,Hide
return
}

;截取图层
;按左鍵再按[
<Ae_LayerInterceptLeft>:
{
; ~LButton & [:: 
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton
    send, !{[}
return
}

;按左鍵再按]
<Ae_LayerInterceptRight>:
{
; ~LButton & ]:: 
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton
    send, !{]}
    return
}

;按左鍵再按g
<Ae_layerGuideLayer>:
; ~LButton & g:: 
{
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\layer_GuideLayer.jsx
    KeyWait, LButton
    ;執行腳本
        getAeScript(AeScriptPath)
    return
}

<Ae_jumpToKey>:
{
; ~LButton & j:: 
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton

    ;執行腳本
    run, %comspec% /c %tool_pathandname% -ro %A_ScriptDir%\\custom\\ae_scripts\jumpToKey.jsx ,,Hide
    return

}
;按左鍵再按h
<Ae_MaskAndShapeVisibility>:
; ~LButton & h:: 
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton
    ;執行腳本
    send +^H
    send v
return


;按左鍵再按n
<Ae_simpleNamer>:
;~LButton & n:: 
WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
tool_pathandname = "%activePath%"
KeyWait, LButton

CoordMode, Mouse,Screen
MouseGetPos, xpos, ypos  
FileDelete, %A_AppData%\\Ola script UI\cursorPos.txt
FileAppend, %xpos%`,%ypos%, %A_AppData%\\Ola script UI\cursorPos.txt

;執行腳本
run, %comspec% /c %tool_pathandname% -ro %A_ScriptDir%\\custom\\ae_scripts\simpleNamer 1.1.jsxbin ,,Hide

return

;按左鍵再按n
<Ae_PointCenter>:
; ~LButton & c:: 
WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
tool_pathandname = "%activePath%"
KeyWait, LButton

send ^!{Home}

return


<Ae_foolParent>:
;~LButton & a:: 
WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
tool_pathandname = "%activePath%"
KeyWait, LButton

;if FileExist("%A_AppData%\\Ola script UI\cursorPos.txt")
CoordMode, Mouse,Screen
MouseGetPos, xpos, ypos  
FileDelete, %A_AppData%\\Ola script UI\cursorPos.txtcursorPos.txt
FileAppend, %xpos%`,%ypos%, %A_AppData%\\Ola script UI\cursorPos.txt

;執行腳本
run, %comspec% /c %tool_pathandname% -ro %A_ScriptDir%\\custom\\ae_scripts\foolParent.jsxbin ,,Hide
return

<Ae_CopyPaste>:
; ~LCtrl & c::
DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
; Wait for 'c' to be released
KeyWait, c
if (A_TimeSinceThisHotkey > DoubleClickTime) {
    Msgbox Longpress
    return
}
; Wait for 'c' to be pressed down again (option "d")
; But timeout after T0.5 seconds (If DoubleClickTime is 500)
KeyWait, c, % "d T"DoubleClickTime/1000
If ! Errorlevel
	send ^{v}
else
	send ^{c}
Return

;调用动画预设文件
<Ae_Preset_Apply>:
{
    send ^+!{f}
    return
}
<Ae_Preset_Ani1>:
{
	Gui,Ae: Hide
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\PresetAnimation\add_PresetAnimation_1.jsx
    getAeScript(AeScriptPath)
    return
}
<Ae_Preset_Ani2>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\PresetAnimation\add_PresetAnimation_2.jsx
    getAeScript(AeScriptPath)
    return
}
<Ae_Preset_Ani3>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\PresetAnimation\add_PresetAnimation_3.jsx
    getAeScript(AeScriptPath)
    return
}
<Ae_Preset_Ani4>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\PresetAnimation\add_PresetAnimation_4.jsx
    getAeScript(AeScriptPath)
    return
}
<Ae_Preset_Ani5>:
{
    AeScriptPath = %A_ScriptDir%\custom\ae_scripts\PresetAnimation\add_PresetAnimation_5.jsx
    getAeScript(AeScriptPath)
    return
}
   
<Ae_Help>:
run,https://www.kancloud.cn/funbobosky/vimd_aftereffect
return

<Ae_Help_Script>:
run,http://estk.aenhancers.com/
return

<Ae_FXConsole>:
send {LCtrl}{Space}
return

<Ae_ReplaceFootageFile>:
{
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton
    send, ^{h}
    return
}
<Ae_6>:
MsgBox 测试这是大窗口
return

<Ae_UpDater>:
Gui,Updating: +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui,Updating: Color, %color2%
Gui,Updating: Font,cwhite s%FontSize% wbold q5,Segoe UI
Gui,Updating: Add, Text, ,%_AeUpdating%
Gui,Updating: Show,AutoSize Center NoActivate
UrlDownloadToFile, %UrlDownloadToFile_Ae1%, %A_ScriptDir%\plugins\AfterEffects\latest-Aftereffects.ahk ;

if ErrorLevel
{
    Gosub, AeExitUpdater
}
Else
{
    FileMove,%A_ScriptDir%\plugins\AfterEffects\latest-Aftereffects.ahk, %A_ScriptDir%\plugins\AfterEffects\Aftereffects.ahk,1
    Gosub, AeExitUpdater
}
return

AeExitUpdater:
FileDelete, %A_ScriptDir%\plugins\AfterEffects\latest-Aftereffects.ahk
sleep %SleepTime%
Gui,Updating: Hide
Return


;载入UMSS/增强功能
;#Include,%A_ScriptDir%\plugins\AfterEffects\AfterEffectsKeyUMSS.ahk
;UMSS/增强功能


; #If GetKeyState(N1.keys,"p") AND WinActive("ahk_exe AfterFX.exe") ;## 语境约束:意思是当keys被实际按下时,以下内容就生效
; q::
; 	N1.ST() ;## 这个函数的意思是告诉程序已经触发功能,不需要再等,Send模式1和Send模式2用得到,Send模式3用不到
; 	MsgBox,%Change_History%

;     Change_History=
;         (
;         使用本脚本请在Ae窗口双按zz下最大化使用，效果最佳，否则会有点影响体验!
;         )
; return

; #If ;## 语境约束结束
; #If GetKeyState(N2.keys,"p") AND WinActive("ahk_exe AfterFX.exe") ;## 语境约束:意思是当keys被实际按下时,以下内容就生效
; 1::
; 	N2.ST() ;## 这个函数的意思是告诉程序已经触发功能,不需要再等,Send模式1和Send模式2用得到,Send模式3用不到
;     WinActive ("ahk_exe AfterFX.exe")
; 	Send,^{Tab}
; return

; #If ;## 语境约束结束
; #If GetKeyState(N2.keys,"p");## 语境约束:意思是当keys被实际按下时,以下内容就生效
; s::
;     N2.ST() ;
;     run,%A_ScriptDir%\apps\TaskSwch\TaskSwch.exe
;     return
; #If ;## 语境约束结束
; Project界面操作
#If ActiveControlIs("DroverLord - Window Class3")
; ~LButton:: 
; ;~ 是否双击判定
;     if (A_ThisHotkey!=A_PriorHotkey)
;         send,{Space}
;         return
; return
6::
MsgBox 测试项目窗口
return
e::
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'c' to be released
    KeyWait, e
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ; send, ^{h}
        return
    }
    ; Wait for 'c' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, e, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\RevealInExplorer.jsx
        getAeScript(AeScriptPath)
        return
    }

    else
    {
        send, e
        return
    } 
}
Return
F5::
{
    ; 1.ReloadFootage | 2.ReduceProject  |  long：CollectFiles
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    KeyWait, F5
        if (A_TimeSinceThisHotkey > DoubleClickTime) {
            MsgBox, 4,, 执行打包 continue? (press Yes or No)
            IfMsgBox Yes
            {
                ToolTip, 执行打包...请稍后！
                sleep 100
                AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\CollectFiles.jsx
                getAeScript(AeScriptPath)
                SetTimer, RemoveToolTip, -1000
                return
            }
        else
            {
                return
            }
                ; MsgBox You pressed No.           
    }
    KeyWait, F5, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {       
        MsgBox, 4,, 简化项目文件 continue? (press Yes or No)
        IfMsgBox Yes
            {
                ToolTip, 正在简化中...请稍后！
                sleep 100
                AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\ReduceProject.jsx
                getAeScript(AeScriptPath)
                SetTimer, RemoveToolTip, -1000
                return
            }
        else
            {
                return 
            }
            
    }
    else
    {
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\ReloadFootage.jsx
        getAeScript(AeScriptPath)
        ToolTip, 正在刷新素材请稍后！
        SetTimer, RemoveToolTip, -2000
        return
    } 
}
Return
n::
{
    ;1 NewCompFromSelection| 2 InterpretFootage | long:CompSetter
    DoubleClickTime := DllCall("GetDoubleClickTime") ; 
    KeyWait, n
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        ;CompSetter
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\CompSetter.jsx
        getAeScript(AeScriptPath)
        return
    }
    KeyWait, n, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {   
        ;Interpret Footage
        send, ^!{g}
        return
    }

    else
    {
        ;NewCompFromSelection
        AeScriptPath = %A_ScriptDir%\custom\ae_scripts\commands\NewCompFromSelection.jsx
        getAeScript(AeScriptPath)
        return
    } 
}
<Ae_ReplaceFootageFile2>:
{
    ; 替换素材
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton
    send, ^{h}
    return
}
#If
ActiveControlIs(Control) {
    ControlGetFocus, FocusedControl, A
    return (FocusedControl=Control)
}
RemoveToolTip:
ToolTip
return