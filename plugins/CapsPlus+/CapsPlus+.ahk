CapsPlus+:
; 鼠标加速度微分对称模型，每秒误差 2.5ms 以内
Global ta := 0, td := 0, tw := 0, ts := 0, mvx := 0, mvy := 0
; 滚轮加速度微分对称模型（不要在意名字hhhh
Global tr := 0, tf := 0, tz := 0, tc := 0, svx := 0, svy := 0

#If GetKeyState(N2.keys,"p") ;## 语境约束:意思是当keys被实际按下时,以下内容就生效
; https://github.com/shines77/AutoHotKey_Vim/blob/master/AutoHotKey_Vim_For_VS.ahk
; Controller控制
; 模拟鼠标移到
; 鼠标运动处理
    mm:
        tNow := QPC()
        ; 计算用户操作时间
        tda := dt(ta, tNow),           tdd := dt(td, tNow)
        tdw := dt(tw, tNow),           tds := dt(ts, tNow)

        ; 计算加速度
        max := ma(tdd - tda),          may := ma(tds - tdw)

        ; 摩擦力不阻碍用户意志
        mvx := MoCaLi(mvx + max, max), mvy := MoCaLi(mvy + may, may)

        If(mvx Or mvy){
            MouseMove, %mvx%, %mvy%, 0, R
        }Else{
            SetTimer, mm, Off
        }
        Return

    ; 时间处理
    mTick(){
        SetTimer, mm, 1
    }
    return

    a:: 
    N2.ST() 
    ta := (ta ? ta : QPC()), mTick()
    return

    d:: 
    N2.ST() 
    td := (td ? td : QPC()), mTick()
    return

    w:: 
    N2.ST()
    tw := (tw ? tw : QPC()), mTick()
    return

    s:: 
    N2.ST()
    ts := (ts ? ts : QPC()), mTick()
    return


    a Up:: 
    N2.ST()
    ta := 0, mTick()
    return

    d Up:: 
    N2.ST()
    td := 0, mTick()
    return

    w Up:: 
    N2.ST()
    tw := 0, mTick()
    return

    s Up:: 
    N2.ST()
    ts := 0, mTick()
    return

    q:: 
    N2.ST()
    send,{RButton}
    return

    Pos2Long(x, y){
        Return x | (y << 16)
    }

    ; 滚轮运动处理
    msx:
        tNow := QPC()
        ; 计算用户操作时间
        tdz := dt(tz, tNow), tdc := dt(tc, tNow)
        ; 计算加速度
        sax := ma(tdc - tdz)
        svx := MoCaLi(svx + sax, sax)

        If(svx){
            MouseGetPos, mouseX, mouseY, wid, fcontrol
            wParam := svx << 16 ;zDelta
            lParam := Pos2Long(mouseX, mouseY)
            PostMessage, 0x20E, %wParam%, %lParam%, %fcontrol%, ahk_id %wid%
        }Else{
            SetTimer, msx, Off
        }
        Return
    
    msy:
        tNow := QPC()
        ; 计算用户操作时间
        tdr := dt(tr, tNow), tdf := dt(tf, tNow)
        ; 计算加速度
        say := ma(tdr - tdf)
        svy := MoCaLi(svy + say, say)

        If(svy){
            MouseGetPos, mouseX, mouseY, id, fcontrol
            wParam := svy << 16 ;zDelta
            lParam := Pos2Long(mouseX, mouseY)
            PostMessage, 0x20A, %wParam%, %lParam%, %fcontrol%, ahk_id %id%
        }Else{
            SetTimer, msy, Off
        }
        Return

    ; 时间处理
    sTickx(){
        SetTimer, msx, 1
    }
    sTicky(){
        SetTimer, msy, 1
    }
    return

    r:: 
    N2.ST()
    tr := (tr ? tr : QPC()), sTicky()
    return

    f:: 
    N2.ST()
    tf := (tf ? tf : QPC()), sTicky()
    return

    z:: 
    N2.ST()
    tz := (tz ? tz : QPC()), sTickx()
    return

    c:: 
    N2.ST()
    tc := (tc ? tc : QPC()), sTickx()
    return

    r Up:: 
    N2.ST()
    tr := 0, sTicky()
    return

    f Up:: 
    N2.ST()
    tf := 0, sTicky()
    return

    z Up:: 
    N2.ST()
    tz := 0, sTickx()
    return

    c Up:: 
    N2.ST()
    tc := 0, sTickx()
    return

; Close Window/关闭窗口  Q = {Alt + F4}
; q::
; 	N2.ST() 
;     Send, !{F4}
; return

; ; Switch Tag/切换标签    S = {Ctr + Tab}
; s::
; 	N2.ST() 
;     Send, ^{Tab}
; return

; ; Close Tag/关闭标签     W = {Ctr + W}
; w::
; 	N2.ST() 
;     Send, ^w 
; return

; ; Editor/编辑类
; ; Z = Cancel
; z::
;     N2.ST()
;     Send, ^z
; return

; ; X = Cut
; x::
;     N2.ST() 
;     Send, ^x 
; return

; ; C = Copy
; c::
;     N2.ST() 
;     Send, ^c
; return

; ; V = Paste
; v::
;     N2.ST()
;     Send, ^v
; return

; ; A = Select All
; a::
;     N2.ST() 
;     Send, ^a 
; return

; ; Y = Redo
; y::
;     N2.ST()
;     Send, ^y
; return

#If ;## 语境约束结束

#If GetKeyState(N1.keys,"p")


;选择文字Google搜索！！
g::
    N2.ST()
    search(copySelected())
    
    search(q)
        {
            Run, https://www.google.com/search?q=%q%
        }
    copySelected()
    {   
        clipboard = ; 清空剪贴板
        Send ^c
        ClipWait
        Return Clipboard
    }
return

; e::
;     N1.ST() ;
;     send {RButton}
; return

;保存
q::
    N1.ST() ;
    Send ^s
return

;全选
Tab::
    N1.ST()
    Send ^{a}
return

; ;复制
; c::
;     N1.ST()
;     Send ^{c}
; return

; ;粘贴
; v::
;     N1.ST()
;     Send ^{v}
; return
;----------------方向操作adws:上下左右---------------------------------
a:: 
    N1.ST()
    Send {Left}
return

;右
d:: 
    N1.ST()
    Send {Right}
return

;下
s:: 
    N1.ST()
    Send {Down}
return

;上
w::
    N1.ST()
    Send {Up}
return

;上页
1::
    N1.ST()
    send {PgUp} 
return

;上页
2::
    N1.ST()
    send {PgDn} 
return
;起始
3::
    N1.ST()
    Send {Home}
return
;结束
4::
    N1.ST()
    Send {End}
return
;-----------------------------------------------------------------------

; r:: 
;     N1.ST()
;     Send {BackSpace} 
; return

; t::
;     N1.ST()
;     Send {Delete}
; return

; f::
;     N1.ST()
;     send {enter} 
; return

#If
;-----------------------------------------------------------------------
QPF()
{
    DllCall("QueryPerformanceFrequency", "Int64*", QuadPart)
    Return QuadPart
}

QPC()
{
    DllCall("QueryPerformanceCounter", "Int64*", Counter)
    Return Counter
}

ma(t){
    ; Return ma2(t) ; 二次函数运动模型
    ; Return ma3(t) ; 三次函数运动模型
    Return maPower(t) ; 指数函数运动模型
}
ma2(t){
    ; x-t 二次曲线加速运动模型
    ; 跟现实世界的运动一个感觉
    If(0 == t)
        Return 0
    If(t > 0)
        Return  6
    Else
        Return -6
}

ma3(t){
    ; x-t 三次曲线函数运动模型
    ; 与现实世界不同，
    ; 这个模型会让人感觉鼠标比较“重”
    ;
    If(0 == t)
        Return 0
    If(t > 0)
        Return t * 12
    Else
        Return t * 12
}

maPower(t){
    ; x-t 指数曲线运动的简化模型
    ; 这个模型可以满足精确定位需求，也不会感到鼠标“重”
    ; 但是因为跟现实世界的运动曲线不一样，凭直觉比较难判断落点，需要一定练习才能掌握。
    ;
    ; 速度时间图像参见这个链接
    ; http://m.wolframalpha.com/input/?i=Plot+%7BInt%28+%28+Exp%28+t%29+-+1+%29+*+16%29%2C+80%7D&x=0&y=0
    If(0 == t)
        Return 0
    If(t > 0)
        Return  ( Exp( t) - 0.95 ) * 16
    Else
        Return -( Exp(-t) - 0.95 ) * 16
}

; 时间计算
dt(t, tNow){
    Return t ? (tNow - t) / QPF() : 0
}

MoCaLi(v, a){ ; 摩擦力
    ; 限制最大速度
    ; maxSpeed := 80
    ; If(v   < -maxSpeed)
    ;     v := -maxSpeed
    ; If(v   >  maxSpeed)
    ;     v :=  maxSpeed
    ; 摩擦力不阻碍用户意志
    If((a > 0 And v > 0) Or (a < 0 And v < 0))
        Return v
    ; 简单粗暴倍数降速
    v *= 0.8
    If(v > 0)
        v -= 1
    If(v < 0)
        v += 1
    v //= 1
    Return v
}

;大写按键移动窗口
~MButton & LButton::
CapsLock & LButton::
CoordMode, Mouse  ; 切换到屏幕/绝对坐标.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; 仅在窗口不处于最大化状态时
    SetTimer, EWD_WatchMouse, 10 ; 在用户拖动时跟踪鼠标.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; 按钮已经释放, 所以拖动结束.
{
    SetTimer, EWD_WatchMouse, Off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; 按下了 Escape, 所以取消拖动.
{
    SetTimer, EWD_WatchMouse, Off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; 否则, 改变窗口的位置以匹配
; 用户拖动鼠标引起的鼠标坐标变化:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; 让下面的移动更快速/平滑.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; 为下一次调用此子程序进行更新.
EWD_MouseStartY := EWD_MouseY
return