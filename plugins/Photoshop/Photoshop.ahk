;Author:BoBO
;Version:v0.2
;Date:20190808
;
;8+8=
;########################################
;更新内容
;2019-08-09 空格+1 笔刷变小  空格+3 笔刷变大  空格+2 橡皮檫
;
;
;2019-08-08 F2标签切换双按逆 | F3增加颜色明度 | F4增加颜色暗度  
;---------- 空格+w 当前图层上移动    空格+s 当前图层下移动
;---------- 空格+q 透明度加5        空格+e 透明度减5
;---------- 双按c 颜色面板          双按g 填充
;2019-08-07 Photoshop框架搭建
;
;
;已知Bug：归为0时如果是空对象 会导致报错 需要加个判断执行
;重命名大于3层 会莫名其妙新建个图层
Photoshop:
;定义注释
    vim.SetAction("<Photoshop_NormalMode>", "返回正常模式")
    vim.SetAction("<Photoshop_InsertMode>", "进入VIM模式")
    vim.SetWin("Photoshop","ahk_exe","photoshop.exe")

;normal模式
    vim.SetMode("normal", "Photoshop")
    vim.map("<insert>","<Photoshop_InsertMode>","Photoshop")
;insert模式
    ;载入自定义注释
    #Include %A_ScriptDir%\plugins\Photoshop\PhotoshopComment.ahk 
    vim.SetMode("insert", "Photoshop")
    vim.Map("<esc>", "<Photoshop_NormalMode>", "Photoshop")

    vim.Map("q", "<PS_Duplicate_画笔橡皮擦涂抹>", "Photoshop")
    vim.Map("w", "<PS_OneKeyDefault>", "Photoshop")
    vim.Map("e", "<PS_OneKeyDefaultSmudgePath>", "Photoshop")
    vim.Map("r", "<PS_Duplicate_旋转>", "Photoshop")
    

    vim.Map("m", "<PS_选区切换>", "Photoshop")
    vim.Map("l", "<PS_多边选区切换>", "Photoshop")
    vim.Map("b", "<PS_工笔>", "Photoshop")

    vim.Map("z", "<PS_Duplicate_放大镜>", "Photoshop")
    vim.Map("x", "<PS_Duplicate_关闭>", "Photoshop")
    vim.Map("d", "<PS_Duplicate_图层>", "Photoshop")
    vim.Map("h", "<PS_Duplicate_独立显示>", "Photoshop")
    vim.Map("o", "<PS_Duplicate_打开保存>", "Photoshop")


    vim.Map("c", "<PS_打开颜色面板>", "Photoshop")
    vim.Map("g", "<PS_填充颜色>", "Photoshop")
    

    vim.Map("0", "<PS_Duplicate_图层中心>", "Photoshop")
    vim.Map("<F2>", "<PS_切换标签>", "Photoshop")
    vim.Map("<F3>", "<PS_明颜色>", "Photoshop")
    vim.Map("<F4>", "<PS_暗颜色>", "Photoshop")

    vim.Map("<F8>1", "<PS_Remove_AllEmptyLayer>", "Photoshop")
    vim.Map("<F8>2", "<PS_Remove_AllInvisibleHiddenLayers>", "Photoshop")
    vim.Map("<F8>3", "<PS_Script_RotateMe>", "Photoshop")
    vim.Map("<F8>4", "<PS_Script_TransformEach>", "Photoshop") 

    vim.Map("vn", "<PS_创建新文档>", "Photoshop")
    vim.Map("vc", "<PS_创建新图层>", "Photoshop")
    vim.Map("vv", "<PS_发送V>", "Photoshop")
    vim.Map("<SP-n>", "<PS_Script_LayersRenamer>", "Photoshop")
    vim.Map("<SP-w>", "<PS_层上>", "Photoshop")
    vim.Map("<SP-s>", "<PS_层下>", "Photoshop")
    vim.Map("<SP-q>", "<PS_透明度加>", "Photoshop")
    vim.Map("<SP-e>", "<PS_透明度减>", "Photoshop")
    vim.Map("<SP-3>", "<PS_Brush_Big>", "Photoshop")
    vim.Map("<SP-2>", "<PS_Eraser>", "Photoshop")
    vim.Map("<SP-1>", "<PS_Brush_Small>", "Photoshop")
    vim.Map("<SP-i>", "<PS_Help>", "Photoshop")
    vim.map("?","<ShowHelp>","Photoshop")

    
    vim.Map("<LB-d>", "<PS_向下合并>", "Photoshop")

    vim.BeforeActionDo("Photoshop_CheckMode", "Photoshop") ; by Array
return
; 对符合条件的控件使用insert模式，而不是normal模式
Photoshop_CheckMode()
{
    ControlGetFocus, ctrl, A
    PixelGetColor, psinputt, 13, 473 ; By 天甜
    ;匹配颜色2019
    if ((psinputt = 0x1f1f1f) or (psinputt = 0x383838) or (psinputt = 0x808080) or (psinputt = 0xbfbfbf)) 	;
		{
		  ;setzh()			;中文0x8040804
		return true
		}
    if RegExMatch(ctrl, "i)Edit")  ; or WinExist("ahk_class #32770"))
    {
        return True
    }
    else
    {
        return False
    }
    return
}
PSCheckInput()
{
	ControlGetFocus, ctrl, A	;if (RegExMatch(ctrl, "Edit|Static88") or WinExist("ahk_class #32768"))
	PixelGetColor, psinputt, 16, 493
	;~ PixelGetColor, psinputj, 30, 38
    if (psinputt = 0x383838) ;&& (psinputj = 0x989898)) 	;Static88为输入文字时的ClassNN
		{
		setzh()			;中文0x8040804
		return true
		}
    if (A_CaretX) 	;Static88为输入文字时的ClassNN
		{
		setzh()			;中文0x8040804
		return true
		}
    if (RegExMatch(ctrl, "Edit|Static151|Static88")) ;|| (ConvMode = 1025) || A_CaretX	;Static88为输入文字时的ClassNN
		{
		setzh()			;中文0x8040804
		return true
		}
    if (RegExMatch(ctrl, "Static152"))
		{
		seten()			;英文0x4090409
		return false
		}
	else
	{
		seten()			;英文0x4090409
		return false
	}
}


;【全局运行PS】
<RunPS>:
    ExePath := ini.BOBOPath_Config.PSPath
    tClass := ini.ahk_class_Config.PSClass
    FunBoBO_RunActivation(ExePath,tClass)
 Return
<Photoshop_NormalMode>:
;   send,{esc}
    vim.SetMode("normal", "Photoshop")
    MsgBox, 0, 提示, 【正常模式】, 0.5
return

<Photoshop_InsertMode>:
;   send,{esc}
    vim.SetMode("insert", "Photoshop")
    MsgBox, 0, 提示, 【VIM模式s】, 0.5
return
;辅助帮助显示
<PS_Help>:
FunBoBO_ShowLayout("psHelp1.png")
KeyWait i
FunBoBO_HideLayout()
return

; ^#l::MouseClick,WheelDown,,,10,0,D,R
; ^#h::MouseClick,WheelUp,,,10,0,D,R
<PS_发送V>:
send {v}
return
<PS_切换标签>:
   DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, F2
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        
        return
    }
    ; Wait for 'd' to be pressed down again (o1ption "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, F2, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        send ^+{F6}
        return
    }
    else
    {
        send ^{Tab}
        return
    }
return

<PS_层上>:
send ^{]}
return

<PS_层下>:
send ^{[}
return
; Win + S, key
<PS_透明度加>:
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\透明度加.jsx
    )
    app.DoJavaScriptFile(alert)
return
<PS_透明度减>:
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\透明度减.jsx
    )
    app.DoJavaScriptFile(alert)
return
<ps_test>:
{
    ;//独立显示IsolateLayerSelection
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\IsolateLayerSelection.jsx
    )
    app.DoJavaScriptFile(alert)
return
}
<PS_明颜色>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\ColorLighten.jsx
    )
    app.DoJavaScriptFile(alert)
return
}
<PS_暗颜色>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\ColorDarken.jsx
    )
    app.DoJavaScriptFile(alert)
return
}
<PS_打开颜色面板>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, c
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        send {c}
        return
    }
    ; Wait for 'd' to be pressed down again (o1ption "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, c, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\打开颜色面板.jsx
        )
        app.DoJavaScriptFile(alert)
        return
    }
    else
    {
        send {h}
        return
    }

return
}
<PS_填充颜色>:
{
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, g
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        
        return
    }
    ; Wait for 'd' to be pressed down again (o1ption "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, g, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        send !{Delete}
        return
    }
    else
    {
        send {g}
        return
    }

return
}
<ps_test2>:
{
    if var=3 ; 总共几次 
    var=0
    var+=1
    ; msgbox %var%

    if (var=1)
    {
        msgbox 1
    }
    if (var=2)
    {
        msgbox 2
    }
    if (var=3)
    {
        msgbox 3
    }
    return
}

<PS_选区切换>:
    send +{m}
return

<PS_多边选区切换>:
    send +{l}
return

<PS_工笔>:
    send +{b}
return

<PS_创建新文档>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\NewFile.jsx
    )
    app.DoJavaScriptFile(alert)
    return
}

<PS_创建新图层>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\NewLayer.jsx
    )
    app.DoJavaScriptFile(alert)
    return
}

<PS_复制图层>:
{

    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\CopyToANewLayer.jsx
    )
    app.DoJavaScriptFile(alert)
    return
}
;

<PS_Duplicate_画笔橡皮擦涂抹>:
        ; 单按切换画笔和橡皮檫|双按涂抹|长按未指定
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, q
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        msgbox,未绑定
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
   ;  KeyWait, q, % "d T"DoubleClickTime/3000
     KeyWait, q, % "d T"DoubleClickTime/2000
    If ! Errorlevel
    {
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\smudgeTools.jsx
        )
        app.DoJavaScriptFile(alert)
        return
    }
    else
    {
        if B_var=2 ; 总
        B_var=0
        B_var+=1
        bo_var=0
        if (B_var=1 )
        {    
            send b
            return
        }
        if (B_var=2)
        {
            send e
            return
        }
    }
return
<PS_Duplicate_独立显示>:
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, h
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        msgbox,未绑定
        return
    }
    ; Wait for 'd' to be pressed down again (o1ption "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, h, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\IsolateLayerSelection.jsx
        )
        app.DoJavaScriptFile(alert)
        return
    }
    else
    {
        send {h}
        return
    }

return


<PS_Duplicate_放大镜>:
    ; 单按发送Z|双按画布100%%
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, z
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send, ^0
        return
    }
    ; Wait for 'd' to be pressed down again (o1ption "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, z, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\zoom100.jsx
        )
        app.DoJavaScriptFile(alert)
        return
    }
    else
    {
        send {z}
        return
    }

return

<PS_Duplicate_旋转>:
    ; 单按R|双水平翻转|当前图层水平翻转
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, r
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
            app:=ComObjCreate("Photoshop.Application")
            alert=
            (
            %A_ScriptDir%\custom\ps_script\画布旋转左右.jsx
            )
            app.DoJavaScriptFile(alert)
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, r, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            app:=ComObjCreate("Photoshop.Application")
            alert=
            (
            %A_ScriptDir%\custom\ps_script\水平翻转.jsx
            )
            app.DoJavaScriptFile(alert)
        }
    else
        {
            send {r}
            return
        }
    return

return


<PS_Duplicate_关闭>:
    ; 单按新建图层|双按复制图层|长按删除
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, x
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        msgbox,未绑定
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, x, % "d T"DoubleClickTime/1000
    If ! Errorlevel
    {
        send ^{w}
        return
    }
    else
    {
        send {x}
        return
    }

return


<PS_Duplicate_图层>:
{
    ; 单按新建图层|双按复制图层|长按删除
    DoubleClickTime := DllCall("GetDoubleClickTime") ; in milliseconds
    ; Wait for 'd' to be released
    KeyWait, d
    if (A_TimeSinceThisHotkey > DoubleClickTime) {
        Send,{Delete}
        return
    }
    ; Wait for 'd' to be pressed down again (option "d")
    ; But timeout after T0.5 seconds (If DoubleClickTime is 500)
    KeyWait, d, % "d T"DoubleClickTime/1000
    If ! Errorlevel
        {
            app:=ComObjCreate("Photoshop.Application")
            alert=
            (
            %A_ScriptDir%\custom\ps_script\CopyToANewLayer.jsx
            )
            app.DoJavaScriptFile(alert)
            return
        }
    else
        {
            app:=ComObjCreate("Photoshop.Application")
            alert=
            (
            %A_ScriptDir%\custom\ps_script\NewLayer.jsx
            )
            app.DoJavaScriptFile(alert)
            return
        }
    return

return
}

<PS_Duplicate_打开保存>:
    ; 单按新建图层|双按复制图层|长按删除
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

return

<PS_Duplicate_图层中心>:
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, PS_tappedkey_0, %t%
    if (t == "off")
    goto PS_double_0
    return

    PS_tappedkey_0:

    return

    PS_double_0:
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\CenterLayer.jsx
        )
        app.DoJavaScriptFile(alert)
    return
return

<PS_OneKeyDefault>:
{
    if O_var=4 ; 总共几次 
    O_var=0
    O_var+=1

    if (O_var=1)
    {
        send v
        return
    }
    if (O_var=2)
    {
        send m
        return
    }
    if (O_var=3)
    {
        send l
        return
    }
    if (O_var=4)
    {
        send w
        return
    }
    return
}

<PS_OneKeyDefaultSmudgePath>:
{
    if var=3 ; 总共几次 
    var=0
    var+=1
    ; msgbox %var%

    if (var=1)
    {
        app:=ComObjCreate("Photoshop.Application")
        alert=
        (
            %A_ScriptDir%\custom\ps_script\smudgeTools.jsx
        )
        app.DoJavaScriptFile(alert)
    }
    if (var=2)
    {
        send o
        return
    }
    if (var=3)
    {
        send p
        return
    }
    return
}

<PS_Remove_AllEmptyLayer>:
    ;删除所有空文件
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\RemoveAllEmptyLayerGroups.jsx
    )
    app.DoJavaScriptFile(alert)
    return
return

<PS_Remove_AllInvisibleHiddenLayers>:
    ;删除隐藏图层
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\RemoveAllInvisibleHiddenLayers.jsx
    )
    app.DoJavaScriptFile(alert)
    return
return

<PS_转为_RBG>:
return

<PS_Script_RotateMe>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\RotateMe.jsx
    )
    app.DoJavaScriptFile(alert)
    return
}
<PS_Script_TransformEach>:
{
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\TransformEach.jsx
    )
    app.DoJavaScriptFile(alert)
    return
    
}

<PS_Script_LayersRenamer>:
{
    ; 重命名
    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\LayersRenamer.jsx
    )
    app.DoJavaScriptFile(alert)
return
}

; ; 笔刷小 *********************************
<PS_Brush_Small>:
Loop
	{
		sleep, 14
		GetKeyState, state, 1, p
		if state = u
		break
		if state = d
		send {[}
	}
return

; ; 笔刷大 *************************************
<PS_Brush_Big>:
Loop
	{
	    sleep, 14
		GetKeyState, state, 3, p
		if state = u
		break
		if state = d
		send {]}
	}
return
; ; 橡皮檫 >>>> *************************************
<PS_Eraser>:
    send {e}
return

; ;按左鍵再按d | 向下合并



; ---长按鼠标左键后操作-----------------------------------------------------------------------

; ;按左鍵再按d | 向下合并
<PS_向下合并>:
    WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
    tool_pathandname = "%activePath%"
    KeyWait, LButton

    app:=ComObjCreate("Photoshop.Application")
    alert=
    (
        %A_ScriptDir%\custom\ps_script\向下合并.jsx
    )
    app.DoJavaScriptFile(alert)
return
; ~LButton & d:: 
; WinGet, activePath, ProcessPath, % "ahk_id" winActive("A")
; tool_pathandname = "%activePath%"
; KeyWait, LButton

; app:=ComObjCreate("Photoshop.Application")
; alert=
; (
;     %A_ScriptDir%\custom\ps_script\向下合并.jsx
; )
; app.DoJavaScriptFile(alert)

; return

