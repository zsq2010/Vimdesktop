GoogleChrome:
;操作方面请使用Surfingkeys，只做功能补充
;定义注释
    vim.SetAction("<Google_NormalMode>", "返回正常模式")
    vim.SetAction("<Google_InsertMode>", "进入VIM模式")
    vim.SetWin("GoogleChrome", "","chrome.exe")

;normal模式（必需）
    vim.SetMode("normal", "GoogleChrome")
    vim.map("<insert>","<Google_InsertMode>","GoogleChrome")
;vim.comment("<Phantom_切换到【VIM模式】>","按下Esc键可以切换为VIM模式")

;insert模式
    vim.SetMode("insert", "GoogleChrome")
    vim.Map("<esc>", "<Google_NormalMode>", "GoogleChrome")
    ;vim.Map("", "<GoogleChrome_关闭标签>", "GoogleChrome")
    ;vim.Map("d", "<GoogleChrome_下载>", "GoogleChrome")
    ;vim.Map("f", "<Google_搜索>", "GoogleChrome")
    ;vim.Map("Z", "<GoogleChrome_撤销>", "GoogleChrome")
    ;vim.Map("X", "<GoogleChrome_全部关闭>", "GoogleChrome")
    vim.Map("<f9>", "<Google_Double_OpenGoogle>", "GoogleChrome")
    vim.Map("<Delete>", "<GoogleChrome_清除浏览数据>", "GoogleChrome")
    vim.Map("<f1>", "<GoogleChrome_无痕>", "GoogleChrome")
    vim.Map("<f5>", "<Google_刷新>", "GoogleChrome")
    vim.Map("<f8>", "<GoogleChrome_无痕>", "GoogleChrome")
    vim.Map("-", "<Google_最小化>", "GoogleChrome")
    vim.Map("<SP-1>1", "<Google_访问_仙谕服务端>", "GoogleChrome")
    vim.Map("<SP-1>2", "<Google_访问_仙谕本地端>", "GoogleChrome")
    vim.Map("<SP-1>3", "<Google_本地游戏打包>", "GoogleChrome")
    vim.Map("<Space>", "<Google_空格_Space>", "GoogleChrome")
    vim.BeforeActionDo("GoogleChrome_BeforeActionDo", "GoogleChrome") 
return
; 对符合条件的控件使用insert模式，而不是normal模式
GoogleChrome_BeforeActionDo()
{
    ControlGetFocus, ctrl, AHK_CLASS Chrome_WidgetWin_1
	If RegExMatch(ctrl,"Chrome_RenderWidgetHostHWND1") ; || RegExMatch(ctrl,"i)qwidget")
        return true
    return false
}
;【全局运行AE】
<RunGoogleChrome>:
    ExePath := ini.BOBOPath_Config.ChromePath
    tClass := ini.ahk_class_Config.GoogleChrome_Class
    FunBoBO_RunActivation(ExePath,tClass)
 Return

GoogleChrome_CheckMode()
{
    ControlGetFocus, ctrl, AHK_CLASS GoogleChrome_Class
    ; msgbox, ctrl
    if RegExMatch(ctrl, "Edit2")
        return true
    return false
}

<GoogleChrome_关闭标签>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_x, %t%
    if (t == "off")
    goto Google_double_x
    return

    Google_tappedkey_x:
    Send {x}
    return

    Google_double_x:
    send, ^w
    return
}
return

<GoogleChrome_全部关闭>:
send, !{F4}
return

<GoogleChrome_下载>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_d, %t%
    if (t == "off")
    goto Google_double_d
    return

    Google_tappedkey_d:
    Send {d}
    return

    Google_double_d:
    send, ^j
    return
}

return

<GoogleChrome_清除浏览数据>:
    send,^{t}
    send ^+{Del}
    sleep 1000
    send,{Enter}
    sleep 1000
    send,^w
    sleep 500
    send,^{f5}
return

<GoogleChrome_新建标签>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_n, %t%
    if (t == "off")
    goto Google_double_n
    return

    Google_tappedkey_n:
    Send {n}
    return

    Google_double_n:
    send, ^t
    return
}
return

<GoogleChrome_撤销>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_z, %t%
    if (t == "off")
    goto Google_double_z
    return

    Google_tappedkey_z:
    Send {z}
    return

    Google_double_z:
    send, ^z
    return
}

<GoogleChrome_无痕>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_f, %t%
    if (t == "off")
    goto Google_double_f
    return

    Google_tappedkey_f:
        send, ^t
    return

    Google_double_f:
        Send ^+{n}
    return
}

<Google_Double_OpenGoogle>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_g, %t%
    if (t == "off")
    goto Google_double_g
    return

    Google_tappedkey_g:
        url=www.google.com ; <-- place url here.
        run % "chrome.exe" ( winExist("ahk_class Chrome_WidgetWin_1") ? " --new-window " : " " ) url
    return

    Google_double_g:
        Send ^+{n}
        sleep 300
        Clipboard := "www.google.com"
        sleep 200
        send ^v
        send {Enter}
    return
}

<Google_搜索>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_f1, %t%
    if (t == "off")
    goto Google_double_f1
    return

    Google_tappedkey_f1:
    Send,f
    return

    Google_double_f1:
    send,^f
    return
}

<Google_刷新>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_f5, %t%
    if (t == "off")
    goto Google_double_f5
    return

    Google_tappedkey_f5:
    Send,{f5}
    return

    Google_double_f5:
    send,^{f5}
    return
}
<Google_最小化>:
{
    t := A_PriorHotkey == A_ThisHotkey && A_TimeSincePriorHotkey < 200 ? "off" : -200
    settimer, Google_tappedkey_Down, %t%
    if (t == "off")
    goto Google_double_Down
    return

    Google_tappedkey_Down:
        send,{-}
    return

    Google_double_Down:
        send,!{Space}
        Sleep,100
        send,x
        return
}

<Google_访问_仙谕服务端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://192.168.1.5:8000/month/index.html?host=192.168.1.5:10001&debug=true&uid=BoBO
    send,^v
    sleep 100
    send,{Enter}
    return
}
<Google_访问_仙谕本地端>:
{
    send,^t
    sleep,100
    ; send,{F6}
    ; sleep,100
    ; send,^a
    Clipboard=http://192.168.1.89/asset/index.html?host=192.168.1.5:10001&debug=true&uid=BoBO
    send,^v
    sleep,100
    send,{Enter}
    return
}

<Google_本地游戏打包>:
{
    Run,e:\project\xm4\asset\bldData.bat
    return
}
<Google_空格_Space>:
{
    send,{Space}
    return
}
<Google_InsertMode>:
    vim.SetMode("insert","GoogleChrome")
    MsgBox, 0, 提示, 【VIM模式】, 0.5
return

<Google_NormalMode>:
    vim.SetMode("normal","GoogleChrome")
    MsgBox, 0, 提示, 【正常模式】, 0.5
return